from PIL import Image,ImageOps
import os
import generate_tiles

this_dir = os.path.dirname(os.path.abspath(__file__))


with open(os.path.join(this_dir,"bg_tiles_amiga"),"rb") as f:
    contents = f.read()




def load_tileset(tiles_1,side,dump_prefix=""):
    nb_rows = tiles_1.size[1] // side
    nb_cols = tiles_1.size[0] // side

    dumpdir = "dumps"

    tileset_1 = []
    k=0
    for j in range(nb_rows):
        for i in range(nb_cols):
            img = Image.new("RGBA",(side,side))
            img.paste(tiles_1,(-i*side,-j*side))
            img = ImageOps.flip(img)
            img = ImageOps.mirror(img)
            tileset_1.append(img)
            k += 1

    return tileset_1

images = generate_tiles.doit_tiles_16x16()
ts_title_list = [load_tileset(img,16) for img in images[0:0x20]]
layer = Image.new("RGB",(512,512))

m_bgvideoram = contents


# we should know which bank it is
for address in range(0x400):

    x = ((address+5) & 0x1F)
    x *= 16

    y = (0x1F - (address // 0x20))*16

    attr = m_bgvideoram[address + 0x400]
    tile_code = m_bgvideoram[address] + ((attr & 0x80) << 1)
    tile_color = attr & 0x1F


    sheet = ts_title_list[tile_color]
    img = sheet[tile_code]
    if attr & 0x20:
        img = ImageOps.flip(img)
    if attr & 0x40:
        img = ImageOps.mirror(img)


    layer.paste(img,box=(x,y))

for i in range(0,layer.size[1]):
    layer.putpixel((96,i),(255,255,255))
    #layer.putpixel((197,i),(255,0,255))

layer.save("bg2.png")








