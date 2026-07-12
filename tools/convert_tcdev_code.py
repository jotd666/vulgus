import re

label_re = re.compile("\w+:([0-9A-F]{4}).{13}(\w+):")
start_add_re = re.compile("\w+:([0-9A-F]{4}) (.{12})\s{24}",flags=re.MULTILINE)

labels_offsets = {}
with open("vulgus_z80_tcdev.asm") as fr:
    contents = fr.read()

# identify labels and offsets
for line in contents.splitlines():
    m = label_re.search(line)
    if m:
        offset,label = m.groups()
        prefix = label

        if label.endswith(offset):
            # already with offset: just convert to lower
            labels_offsets[label] = label.lower()
        else:
            toks = label.split("_")
            if len(toks)>1:
                last_part = toks[-1]
                try:
                    orig_offset = int(last_part,16)
                    if orig_offset == int(offset,16):
                        # remove original offset
                        prefix = "_".join(toks[:-1])
                except ValueError:
                    pass
            prefix = prefix.rstrip("_")
            labels_offsets[label] = f"{prefix}_{offset}".lower()

def ixy_offset_sub(m):
    offset,reg = m.groups()
    offset = int(offset)
    return f"({reg}+${offset:02x})"

contents = start_add_re.sub(r"\1: \2",contents)
contents = re.sub(r"(\w+)",lambda m:labels_offsets.get(m.group(1),m.group(1)),contents)
contents = re.sub(r"^\w{3}:\w{4}\s+(;.*)",r"\1",contents,flags=re.MULTILINE)
contents = re.sub(r"^\w{3}:\w{4} .{12}(.*:.*)",r"\1",contents,flags=re.MULTILINE)
contents = re.sub(r"^\w{3}:\w{4}$","",contents,flags=re.MULTILINE)
contents = re.sub(r",\s+",",",contents)
contents = re.sub(r"(\d+)\((i[xy])\)",ixy_offset_sub,contents)
contents = contents.replace("#0x","#$")
contents = re.sub("^.*\.dw","\t.word",contents,flags=re.MULTILINE)
contents = re.sub(r"([\s,])#",r"\1",contents)  # immediate mode is implicitly default

with open("../src/vulgus_z80.asm","w") as fw:
    for line in contents.splitlines(True):
        if not re.search("\.d[bs]",line):
            fw.write(line)