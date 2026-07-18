from PIL import Image
import pathlib,bitplanelib

magenta = (254,0,254)
out = Image.new("RGB",(224,256+48),magenta)

y = 0
y_offset = 0

for i,pic in enumerate(sorted(pathlib.Path(".").glob("sprites_*.png"))):
    img = Image.open(pic)
    bitplanelib.replace_color(img,{(67,67,98)},magenta)  # magenta
    for x in range(img.size[0]):
        for y in range(img.size[1]):
            p = img.getpixel((x,y))
            if p!=magenta:
                out.putpixel((x,y+y_offset),p)
    if i==6:
        y_offset = 0x100

out.save("all.png")
