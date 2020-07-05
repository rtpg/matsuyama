#!/usr/bin/env python3
from PIL import Image

im = Image.open("sample_sprites.bmp").convert('RGB')
import os
os.getcwd()

w, h = im.size
assert w == 8
assert h % w == 0

def iter_tiles(im):
    w, h = im.size
    assert w == 8
    assert h % w == 0
    num_tiles = int(h / w)
    assert num_tiles > 0
    for i in range(num_tiles):
        yield eight_by_eight(im, i)

def eight_by_eight(im, i):
    # give the n'th tile in the image (as RGB tuples)
    return [
        [
            im.getpixel((x,y)) for y in range(8*i, 8*(i+1))
        ] for x in range(8)
    ]

def four_byte_tile(t):
    # go from 0-255 to 0-16
    return [
        [
            (r//16, g//16, b//16) for (r, g, b) in line
        ] for line in t
    ]

def build_palette(tiles):
    # build up a palette of up to 255 colors from the input tiles
    # also provide a reverse lookup
    reverse_lookup = {}
    palette = []
    for t in tiles:
        for line in t:
            for elt in line:
                if elt not in reverse_lookup:
                    palette.append(elt)
                    # index is palette - 1, as 0 is for transparency
                    reverse_lookup[elt] = len(palette)
    if len(palette) > 250:
        raise ValueError("Palette too big!")
    return palette, reverse_lookup


def compile_images(tiles, reverse_lookup):
    numbers = [
        [
            [
                reverse_lookup[elt]
                for elt in line
            ]
            for line in tile
        ] for tile in tiles
    ]

    return ["\n".join(
        " ".join(f'{elt:02x}' for elt in line)
        for line in tile
    ) for tile in numbers
    ]


def compile_palette(palette):
    # our palette is a 768 element array, _but_ each element in this array is 4 bits
    # so actually we're working off a 768/2 = 384 byte array
    res = [0] * 384
    print(palette)
    for idx, p in enumerate(palette):
        if idx % 2 == 0:
            # even number: lower bits
            res[idx] = p[0] # red
            res[idx + 128] = p[1] # green
            res[idx + 256] = p[2] # blue
        else:
            # odd number: higher bits
            res[idx] = 16 * p[0] # red
            res[idx + 128] = 16 * p[1] # green
            res[idx + 256] = 16 * p[2] # blue
    print(res)
    return " ".join(f'{r:02x}' for r in res)


def get_img_bins(im):
    # first, get tiles as RGB tuples
    tiles = list(iter_tiles(im))
    # downsample to 4-bit colors
    tiles = [four_byte_tile(t) for t in tiles]

    # now get the palette
    palette, reverse_lookup = build_palette(tiles)

    tiles_as_binaries = compile_images(tiles, reverse_lookup)
    palette_as_binary = compile_palette(palette)

    return tiles_as_binaries, palette_as_binary

def write_binaries(ts, p):
    for i, t in enumerate(ts):
        with open(f'img/{i+1}.mem', 'w') as f:
            f.write(t)
    with open('img/palette.mem', 'w') as f:
        f.write(p)

ts, p = get_img_bins(im)
write_binaries(ts, p)
