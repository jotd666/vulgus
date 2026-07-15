# we're trying to work cleanly this time: instead of generating pics and storing them, we generate them
# and return the list, it takes 1 or 2 seconds

import glob,shutil,os,re,pathlib
from PIL import Image
from shared import *
import bitplanelib
import gen_cluts



ref_clut_index = 1
pal_8x8_file = sheets_path / f"tiles_8x8_color_{ref_clut_index:02x}.png"  # reference sheet with all colors represented
ref_clut_index = 0
pal_16x16_file = sheets_path / f"tiles_16x16_color_{ref_clut_index:02x}.png"  # reference sheet with all colors represented


# theoritically: could generate 64 tilemaps (like in RallyX) but only 25 maps are non black (0->0x19)


def doit(pal4_file,nb_colors,offset,nb_cluts,kind,dump_it=False):
    cluts = gen_cluts.doit(nb_colors)
    tilegen = dump_dir / "tilegen" / kind

    cluts = cluts[offset:]

    rval = []
    if dump_it:
        tilegen.mkdir(exist_ok=True)

    source = Image.open(pal4_file)

    # this reference clut has all 4 colors different. We can use that to generate
    # the other cluts (mame gfx save only saves up to 32 cluts, we need 64)
    ref_clut = cluts[ref_clut_index]

    for i in range(0,nb_cluts):
        this_clut = cluts[i]
        dest = Image.new("RGB",source.size)
        if len(set(this_clut))>1:  # avoid all black
            rep_dict = {k:v for k,v in zip(ref_clut,this_clut)}

            dest_file = tilegen / f"pal_{i:02x}.png"
            if i==ref_clut_index:
                shutil.copy(pal4_file,dest_file)
            else:
                for x in range(source.size[0]):
                    for y in range(source.size[1]):
                        pix = source.getpixel((x,y))
                        newpix = rep_dict[pix]

                        dest.putpixel((x,y),newpix)
                if dump_it:
                    dest.save(dest_file)

        rval.append(dest)
    return rval

def doit_8x8(dump_it=False):
    return doit(pal_8x8_file,4,0,64,"8x8",dump_it)
def doit_16x16(dump_it=False):
    return doit(pal_16x16_file,8,512//8,64,"16x16",dump_it)

if __name__ == "__main__":
    #doit_8x8(False)
    doit_16x16(True)