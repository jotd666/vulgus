# MAME script that kills sprite update
# then create binary files and a script to load+snapshot the result
# that allows to dump all sprites with proper black border

# 1) run the script in MAME directory
# 2) run mame -debug vulgusa
# 3) insert coin
# 4) run "source sprite_dump_script" in MAME debugger
# 5) collect the pics in "snap"
# 6) post-process with another script


buffer = []
x = 0x10
y = 0xF0
buff_count = 0

with open("sprite_dump_script","w") as fs:
    fs.write("""# insert coin and source this
# neutral bg tiles background color 67,67,98
fill DC00,400,80
fill D800,400,1F
# no OSD
fill D000,800,0
# kill sprite refresh
bpset 0282,,{PC=$02A0;g}
""")

    for code in range(0x100):
        buffer.append(code)
        buffer.append(0)
        buffer.append(x)
        buffer.append(y)

        if len(buffer)==0x80:
            sd_name = f"sprites_{code:02x}"
            with open(sd_name,"wb") as f:
                f.write(bytes(buffer))
            print(sd_name)
            fs.write(f"load {sd_name},$CC00\n")
            fs.write(f"snap {sd_name}\n")
            buffer.clear()

        x += 0x10
        if x==0xF0:
            x = 0x10
            y -= 0x10
        if y<0:
            y = 0xf0

