# MAME script that kills sprite update
# then create binary files and a script to load+snapshot the result
# that allows to dump all sprites with proper black border

# 1) run the script in MAME directory
# 2) run mame -debug vulgusa
# 3) insert coin
# 4) run "source sprite_dump_script" in MAME debugger
# 5) collect the pic in "snap"
# 6) post-process with another script


with open("tile_dump_script","w") as fs:
    fs.write("""# insert coin and source this
# neutral bg tiles background color 67,67,98
fill DC00,400,80
fill D800,400,1F
# no OSD
fill D000,800,0
# kill sprite refresh
bpset 0282,,{PC=$02A0;g}
# no sprites
fill CC00,80,0
""")
    buffer = [0]*0x800
    x = 0
    y = 0
    for code in range(0x200):
        offset = 0x40 + (0x1F-y) + x*0x20
        print(x,y,hex(offset))
        buffer[offset] = code & 0xFF
        buffer[offset+0x400] = ((code >> 8) <<7) + 0x10
        x += 1
        if x == 28:
            x = 0
            y += 1


    sd_name = f"fg_tiles"
    with open(sd_name,"wb") as f:
        f.write(bytes(buffer))
    fs.write(f"load {sd_name},$D000\n")
    fs.write(f"snap {sd_name}\n")


