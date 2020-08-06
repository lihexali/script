#!/usr/bin/env python
# Usage: fntUnpacker.py <*.fnt>

import sys
import os.path
from PIL import Image
import re
import json


def parseFnt(path):
    fntPath = path
    (dirname, filename) = os.path.split(fntPath)
    (fileBaseName, fileExtension) = os.path.splitext(filename)

    if fileExtension != '.fnt':
        print 'Usage: unpacker.py <*.fnt>'
        return

    fnt_json = json.load(open(fntPath));
    png_file = fnt_json['file']
    frames = fnt_json['frames']
    texutre = Image.open(png_file)
    for frame_name in frames:
        frame = frames[frame_name]
        crop_box = (
                frame['x'] + frame['offX'],
                frame['y'] + frame['offY'],
                frame['x']+frame['w'],
                frame['y']+frame['h'])
        xim = texutre.crop(crop_box)
        outputImage = Image.new('RGBA',(frame['w'], frame['h']))
        outputImage.paste(xim,(0, 0))
        outputImage.save(os.path.join(dirname, frame_name+'.png'))


def main():
    argvs = sys.argv
    if len(argvs) < 2:
        print 'Usage: fntUnpacker.py <*.fnt>'
        return

    files = argvs[1:]
    for fnt_file in files:
        if os.path.exists(fnt_file) == False:
            print 'File ' + fnt_file + ' is not exists!'
            return
        print 'Parsing: ' + fnt_file
        parseFnt(fnt_file)

if __name__ == "__main__":
    main()


