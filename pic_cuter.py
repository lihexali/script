#!/bin/env python
import sys
import os.path
import Image

def cutPic(pic):
    org_img = Image.open(pic)
    to_pate_img = org_img.crop((0, 0, 1920, 1080))
    to_pate_img.save('new_' + pic)

def main():
    argvs = sys.argv
    if len(argvs) < 2:
        print 'Usage: pic_cuter.py <*.png>'
        return

    files = argvs[1:]
    for pic_file in files:
        if os.path.exists(pic_file) == False:
            print 'File ' + pic_file + ' is not exists!'
            return
        print 'Parsing: ' + pic_file
        cutPic(pic_file)




if __name__ == "__main__":
    main()
