#!/bin/env python
import sys
import os.path
import Image

def convert2Jpeg(path):
    filePath = path
    (dirname, filename) = os.path.split(filePath)
    (fileBaseName, fileExtension) = os.path.splitext(filename)
    outputImage = Image.open(filename)
    outputImage = outputImage.transpose(Image.ROTATE_180)
    outputImage = outputImage.transpose(Image.FLIP_LEFT_RIGHT)
    outputImage.save(fileBaseName+'_rotaed.png')
    print "--->"
    print "Saved " + fileBaseName + '.jpg'

def main():
    argvs = sys.argv
    if len(argvs) < 2:
        print 'Usage: p2j.py <*.png>'
        return

    files = argvs[1:]
    for png_file in files:
        if os.path.exists(png_file) == False:
            print 'File ' + png_file + ' is not exists!'
            return
        print 'Parsing: ' + png_file
        convert2Jpeg(png_file)

if __name__ == "__main__":
    main()
