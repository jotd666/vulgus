import re,pathlib

gamename = "vulgus"

# game_specific: replace or remove I/O addresses
# if not done it will write in ROM here!!
input_dict = {

"soundlatch_c800":"sound_start",
"palette_bank_w_c805":"set_palette_bank",
"background_scroll_y_msb_c902":"",
"background_scroll_y_lsb_c802":"",
"background_scroll_x_lsb_c803":"",
"background_scroll_x_msb_c903":"",
"dma_trigger_c806":"",
}

single_line_to_cc_protect = set()
remove_error_in_next_line = {0x001a,0x0022,0x6AE,0X06b1,0x1255,0x091b,0x2392,0x428f,0x43c2,0x1282,0x233c}
remove_error_in_prev_line = {0x1}
line_to_push_cc_protect = {0x6AA,0x6AF,0x06b4} | single_line_to_cc_protect
line_to_pull_cc_protect = {0x6AE,0x6B0,0x06b8} | single_line_to_cc_protect

store_to_video = re.compile("GET_ADDRESS\s+(0xd\w\w\w|video_ram_d)",flags=re.I)   # game_specific


# post-conversion automatic patches, allowing not to change the asm file by hand
tablere = re.compile("move.w\t#(\w*table_....),d(.)")
jmpre = re.compile("(j..)\s+\[a,(.)\]")
dreg_dict = {'a':'d0','b':'d1'}
areg_dict = {'x':'a2','y':'a3','u':'a4'}



def remove_continuing_lines(lines,i):
    for j in range(i+1,i+4):
        if "[...]" in lines[j]:
            lines[j] = ""
        else:
            break


def get_line_address(line):
    try:
        toks = line.split("|")
        address = toks[1].strip(" [$").split(":")[0]
        return int(address,16)
    except (ValueError,IndexError):
        return None

def remove_continuing_lines(lines,i):
    for j in range(i+1,i+4):
        if "[...]" in lines[j]:
            lines[j] = ""
        else:
            break


def change_instruction(code,lines,i,continuing_lines=True):
    line = lines[i]
    toks = line.split("|")
    if len(toks)==2:
        toks[0] = f"\t{code}"
        if continuing_lines:
            remove_continuing_lines(lines,i)
        return " | ".join(toks)
    return line

def remove_error(line,ignore=False):
    if "ERROR" in line:
        return ""
    elif not ignore:
        raise Exception(f"No ERROR to remove in {line}")
    else:
        return line
def remove_instruction(lines,i,continuing_lines=True):
    return change_instruction("",lines,i,continuing_lines=continuing_lines)

def remove_continuing_lines(lines,i):
    for j in range(i+1,i+6):
        if "[...]" in lines[j]:
            lines[j] = ""
        else:
            break



def process_jump_table(line):

    m = re.search("\[nb_entries=(\d+)",line)
    if m:
        nb_entries = m.group(1)
        line = f"""\t.ifndef\tRELEASE
\tmove.w\t#{nb_entries},d7
\t.endif
"""+line

    return line

def get_original_instruction(line):
    toks = line.split("| [")
    if len(toks)==1:
        return ""
    inst = toks[1][7:].split("]")[0]
    return inst


def remove_code(pattern,lines,i):
    if pattern in lines[i]:
        lines[i] = remove_instruction(lines,i)
        remove_continuing_lines(lines,i)
    return lines[i]

def rebuild_lines(lines):
    return "".join(lines).splitlines(True)

def swap_lines(lines,i,j):
    lines[i],lines[j] = lines[j].rstrip()+ "| swapped\n",lines[i].rstrip()+ "| swapped\n"
    return lines[i]

def kill_code(lines,start_line,end_address):
    while True:
        address = get_line_address(lines[start_line])
        lines[start_line] = remove_instruction(lines,start_line)
        if "|" not in lines[start_line]:
            lines[start_line] = ""
        if address == end_address:
            break
        start_line+=1

def subt(m):
    tn = m.group(1)
    rn = m.group(2)
    offset = tn.split("_")[-1]
    rval = f"""
\t.ifndef\tRELEASE
\tmove.w\t#0x{offset},d{rn}
\t.endif
\tlea\t{tn},a{rn}"""
    return rval

equates = []
global_symbols = []
equates_re = re.compile("(\w+)\s*=\s*(\$?\w+)")
this_dir = pathlib.Path(__file__).absolute().parent

source_dir = this_dir / "../src"

add_a_to_hl = """\tMAKE_HL_NO_AR
\tand.w #0xFF,d0
\tadd.w\td0,d6
\tmove.b\td6,d0   | so routine is equivalent to original
\tMAKE_H
"""
eqd={}
# various dirty but at least automatic patches applying on the converted code
with open(source_dir / "conv.s") as f:
    lines = list(f)
    # force equates in RAM, also the ones references by LOAD_xx
    for i,line in enumerate(lines):
        m = re.search("LOAD_\w\w\s+(\w+)_([0-9a-f]{4})",line)
        if m:
            radix,offset = m.groups()
            eqd[f"{radix}_{offset}"] = f"0x{offset}"
        m = re.search("(\w+)_([de][0-9a-f]{3})",line)
        if m:
            radix,offset = m.groups()
            eqd[f"{radix}_{offset}"] = f"0x{offset}"

    for i,line in enumerate(lines):
        m = equates_re.match(line)
        if m:
            eqd[m.group(1)] = m.group(2)
            line = ""


##        elif "review stray daa" in line:
##            line = """\tCLR_XC_FLAGS
##\tmove.b\t(a0),d6
##\tabcd\td6,d0
##"""
        address = get_line_address(line)

        if "[return]" in line:
            if "MAKE_" in line:
                line = ""
            else:
                line = change_instruction("rts",lines,i)

        elif "[nop]" in line:
            line = remove_instruction(lines,i)

        elif "[breakpoint]" in line and address:
            line = f'\tBREAKPOINT "{address:04x}"\n{line}'

        elif "[cc_ok]" in line:
            if "rts" in line and "ret]" not in line: # conditional return
                lines[i-1] = remove_error(lines[i-1],True)
            else:
                lines[i+1] = remove_error(lines[i+1],True)


        line = process_jump_table(line)


        if "[push_function]" in line:
            toks = line.split()
            pa = toks[1].strip("#")
            # remove from equates else equates overrides label in push!
            eqd.pop(pa,None)
            line = remove_instruction(lines,i)
            lines[i+1] = change_instruction(f"pea\t{pa}",lines,i+1)

        # pre-add video_address tag if we find a store instruction to an explicit 3000-3FFF address
        m = store_to_video.search(line)
        if m:
            g = m.group(1)
            okay = True
            if g.startswith("0x"):
                address = int(g,16)
                line = line.rstrip() + " [video_address]\n"

        if "[video_address" in line or "[unchecked_address" in line:
            # give me the original instruction
            line = line.replace("_ADDRESS","_UNCHECKED_ADDRESS")
            if "MAKE" in line:
                line = re.sub(r"(MAKE_AR)",r"\1_UNCHECKED",line)
                line = re.sub(r"(MAKE_[HDB]\w)",r"\1_UNCHECKED",line)
            elif "MAKE" in lines[i-1] and "UNCHECKED" not in lines[i-1]:
                lines[i-1] = re.sub(r"(MAKE_AR)",r"\1_UNCHECKED",lines[i-1])
                lines[i-1] = re.sub(r"(MAKE_[HDB]\w)",r"\1_UNCHECKED",lines[i-1])
            elif "ldir" in line:
                line = line.replace("ldir","ldir_video" if "[video_address" in line else "ldir_unchecked")
            if "[video_address" in line:
                if ",(a0)" in line or ("(a0)" in line and "clr.b" in line):
                    line += "\tVIDEO_BYTE_DIRTY | [...]\n"
                elif (",(a0)" in lines[i+1] or ("(a0)" in  lines[i+1]  and "clr.b" in lines[i+1] )):
                    lines[i+1]  += "\tVIDEO_BYTE_DIRTY | [...]\n"

        if "[pop_stack]" in line:
            line = change_instruction("addq\t#4,sp",lines,i)

        ###############################################
        # game_specific

        if "replace by EXG_A_A_PRIME" in line:
            # no need to swap F with F', ever in this game
            lines[i-1] = "* just swap A/A'\n"+change_instruction("EXG_A_A_PRIME",lines,i-1)
            line = remove_error(line)
        elif "abcd/sbcd/subx/addx" in line:
            # those have been analyzed, no risk (worse case: score not working properly, easy to debug)
            line = remove_error(line)
        if address == 1:
            line = remove_instruction(lines,i)
##        if address == 0x0018:
##            # replace routine altogether
##            line = add_a_to_hl+"\trts"
##            kill_code(lines,i+1,0x1D)
##        elif address == 0x0020:
##            # replace routine altogether
##            line = add_a_to_hl
##            kill_code(lines,i+1,0x24)
        elif address in {0x0018,0x0020}:
            line = change_instruction("add.b\td0,d6",lines,i)
            lines[i+1] = remove_instruction(lines,i+1)
        elif address == 0x0030:
            # jump table
            line = """\tmove.l\t(a7)+,a0   | get table address (just after rst instruction)
\t.ifndef\tRELEASE
\tcmp.b\td7,d0
\tjcs\t0f
\tmove.b\td0,d1
\tmove.b\td7,d6
\tjbsr\tosd_get_last_known_pc
\tBREAKPOINT\t"too many cases for jump table (D1 vs D6, rst called from D7)"
0:
\t.endif
\tadd.w\td0,d0
\tadd.w\td0,d0       | times 4
\tmove.l\t(a0,d0.w),a0
\tjmp\t(a0)
"""
            kill_code(lines,i+1,0x33)
        elif address == 0x0282:
            line += "\tMAKE_AR_FROM_HL\ta0\nmove.b\t(a0),d0\n\tjbsr\tosd_sound_start\n"+line
        elif address in {0x0917,0x91a}:
            line = remove_instruction(lines,i)
        elif address == 0x918:
            line = change_instruction("sub.b\t#0x20,d6",lines,i)
        elif address in {0x238e,0x2338}:
            line = swap_lines(lines,i,i-1)
        elif address == 0x127f:
            line += "\ttst.b\td0\n"
        elif address in [0x0f18,0x447f,0x4597,0x45f8,0x4703]:
            line = "\ttst.b\tinvincible_flag\n\tjne\t0f\n"+line
        elif address in [0x0f1b,0x4482,0x459a,0x45fb,0x4706]:
            line = "0:\n"+line

        # end game_specific
        ###############################################
        if address in line_to_pull_cc_protect:
            # protect the sub instructions
            line += "\tPOP_SR\n"
        if address in line_to_push_cc_protect:
            # protect the sub instructions
            line = "\tPUSH_SR\n"+line
        if address in remove_error_in_prev_line:
            lines[i-1] = remove_error(lines[i-1].strip()+f" ({address:04x})")
        if address in remove_error_in_next_line:
            lines[i+1] = remove_error(lines[i+1].strip()+f" ({address:04x})")
        if "GET_ADDRESS" in line:
            val = line.split()[1].split(",")[0]
            osd_call = input_dict.get(val)
            if osd_call is not None:

                if osd_call:
                    line = change_instruction(f"jbsr\tosd_{osd_call}",lines,i)
                else:
                    line = remove_instruction(lines,i)
                lines[i+1] = remove_instruction(lines,i+1)

        if "[global]" in line:
            label = line.split(":")[0]
            global_symbols.append(label)

        lines[i] = line

    # remove duplicate VIDEO_BYTE_DIRTY
    lines = rebuild_lines(lines)
    new_lines = []
    prev_line = ""
    for line in lines:
        if "VIDEO_BYTE_DIRTY" in line and "VIDEO_BYTE_DIRTY" in prev_line:
            pass
        else:
            new_lines.append(line)
        prev_line = line


with open(source_dir / "data.inc","w") as fw:
    for k,v in sorted(eqd.items()):
        fw.write(f"{k} = {v}\n")

with open(source_dir / f"{gamename}.68k","w") as fw:

    fw.write(f"""\t.include "data.inc"
""")
    for g in global_symbols:
        fw.write(f"\t.global\t{g}\n")

    fw.writelines(new_lines)
