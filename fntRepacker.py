#!/usr/bin/env python
# Usage: fntRepacker.py <*.fnt>

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
    max_x = max_y = 0
    max_x_frame = None
    max_y_frame = None
    for frame_name in frames:
        frame = frames[frame_name]
        if frame['x'] > max_x:
            max_x = frame['x']
            max_x_frame = frame

        if frame['y'] > max_y:
            max_y = frame['y']
            max_y_frame = frame

    max_w = max_x_frame['x'] + max_y_frame['w'] + 1
    max_h = max_y_frame['y'] + max_y_frame['h'] + 1
    outputImage = Image.new('RGBA',(max_w, max_h))

    for frame_name in frames:
        frame = frames[frame_name]
        crop_box = ( 0, 0, frame['w'], frame['h'])
        texutre = Image.open(frame_name + '.png')
        xim = texutre.crop(crop_box)
        outputImage.paste(xim,(frame['x'] + frame['offX'], frame['y'] + frame['offY']))

    outputImage.save(os.path.join(dirname, png_file))

def main():
    argvs = sys.argv
    if len(argvs) < 2:
        print 'Usage: fntRepacker.py <*.fnt>'
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


