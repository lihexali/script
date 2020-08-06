#!/bin/env python
import sys
import os.path
import Image

def convert2Jpeg(path):
    filePath = path
    (dirname, filename) = os.path.split(filePath)
    (fileBaseName, fileExtension) = os.path.splitext(filename)
    outputImage = Image.open(filename)
    outputImage.save(fileBaseName+'.jpg', format="jpeg")
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
