#!/bin/env python
# Usage: unpacker.py <*.plist>

import sys
import os.path
import plistlib
#import Image
from PIL import Image
import re


AssetsDir = r'assets_'
TexutreFileName = ''
Texutre = ''
Format = 2

def boxFromString(box_str):
    res = re.sub('{|}','',box_str)
    out_box = res.split(',')
    out_tuple =  tuple(out_box)
    out_tuple = (int(out_tuple[0]),int(out_tuple[1]),int(out_tuple[2]),int(out_tuple[3]))
    return out_tuple

def sizFromString(size_str):
    res = re.sub('{|}','',size_str)
    out_size = res.split(',')
    out_tuple =  tuple(out_size)
    out_tuple = (int(out_tuple[0]),int(out_tuple[1]))
    return out_tuple


def parseOnePicFormat3(pic_info):
    one_pic_frame= boxFromString(pic_info['textureRect'])
    print one_pic_frame

    one_pic_source_Size = sizFromString(pic_info['spriteSourceSize'])
    print one_pic_source_Size

    sourceColorRect = boxFromString(pic_info['spriteColorRect'])
    print sourceColorRect


    outputImage = Image.new('RGBA',one_pic_source_Size)

    if pic_info['textureRotated'] == True:
        print "rotated"
        crop_box = (one_pic_frame[0],one_pic_frame[1],one_pic_frame[0]+one_pic_frame[2],one_pic_frame[1]+one_pic_frame[3])
        xim = Texutre.crop(crop_box)
        xim = xim.transpose(Image.ROTATE_90)
        outputImage.paste(xim,(sourceColorRect[0],sourceColorRect[1]))
        pass
    else:
        crop_box = (one_pic_frame[0],one_pic_frame[1],one_pic_frame[0]+one_pic_frame[2],one_pic_frame[1]+one_pic_frame[3])
        xim = Texutre.crop(crop_box)
        outputImage.paste(xim,(sourceColorRect[0],sourceColorRect[1]))
        pass

    #outputImage.save('crop.png')
    #xim.save('crop.png')
    return outputImage

def parseOnePicFormat1or2(pic_info):
    one_pic_frame= boxFromString(pic_info['frame'])
    print one_pic_frame

    one_pic_source_Size = sizFromString(pic_info['sourceSize'])
    print one_pic_source_Size

    sourceColorRect = boxFromString(pic_info['sourceColorRect'])
    print sourceColorRect


    outputImage = Image.new('RGBA',one_pic_source_Size)

    if pic_info['rotated'] == True:
        crop_box = (one_pic_frame[0],one_pic_frame[1],one_pic_frame[0]+one_pic_frame[3],one_pic_frame[1]+one_pic_frame[2])
        xim = Texutre.crop(crop_box)
        xim = xim.transpose(Image.ROTATE_90)
        outputImage.paste(xim,(sourceColorRect[0],sourceColorRect[1]))
        pass
    else:
        crop_box = (one_pic_frame[0],one_pic_frame[1],one_pic_frame[0]+one_pic_frame[2],one_pic_frame[1]+one_pic_frame[3])
        xim = Texutre.crop(crop_box)
        outputImage.paste(xim,(sourceColorRect[0],sourceColorRect[1]))
        pass

    #outputImage.save('crop.png')
    #xim.save('crop.png')
    return outputImage



def parsePlist(path):
    plistPath = path
    (dirname, filename) = os.path.split(plistPath)
    (fileBaseName, fileExtension) = os.path.splitext(filename)

    if fileExtension != '.plist':
        print 'Usage: unpacker.py <*.plist>'
        return

    global AssetsDir
    AssetsDir = r'assets_'
    AssetsDir = AssetsDir + fileBaseName + '/'

    if os.path.isdir(AssetsDir) == False:
        os.mkdir(AssetsDir)

    if os.path.exists(AssetsDir) == False:
        pass
        return

    plist = plistlib.readPlist(filename)
    frames = plist['frames']

    metadata = plist['metadata']

    format = int(metadata['format'])

    global TexutreFileName
    if  format == 3:
        target = metadata['target']
        textureFileExtension = target['textureFileExtension']
        TexutreFileName = target['textureFileName'] + textureFileExtension
    else:
        TexutreFileName = metadata['textureFileName']

    print TexutreFileName

    global Texutre
    Texutre = Image.open(TexutreFileName)

    pic_names = frames.keys()
    for name in pic_names:
        output_dir = AssetsDir
        (dirname, filename) = os.path.split(name)
        output_dir = os.path.join(output_dir, dirname)
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)
        frame = frames[name]
        if format == 3:
            img = parseOnePicFormat3(frame)
            img.save(os.path.join(output_dir, filename))
        else:
            img = parseOnePicFormat1or2(frame)
            img.save(os.path.join(output_dir, filename))
        print 'Saved in ' + os.path.join(output_dir, filename)

    return


def main():
    argvs = sys.argv
    if len(argvs) < 2:
        print 'Usage: unpacker.py <*.plist>'
        return

    files = argvs[1:]
    for plist_file in files:
        if os.path.exists(plist_file) == False:
            print 'File ' + plist_file + ' is not exists!'
            return
        print 'Parsing: ' + plist_file
        parsePlist(plist_file)

if __name__ == "__main__":
    main()




