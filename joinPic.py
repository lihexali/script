#!/usr/bin/env python
# Usage: joinPic.py <*.jpg|png>
# OutPut: joined_withxheight.jpg

import sys
import os.path
import plistlib
import Image

def main():
    argvs = sys.argv
    if len(argvs) < 2:
        print 'Usage: joinPic.py <*.png>'
        return

    files = argvs[1:]
    size = [0, 0]

    for pic in files:
        if os.path.exists(pic) == False:
            print 'File ' + pic + ' is not exists!'
            return
        print 'Joining pic: ' + pic
        img = Image.open(pic)
        imgSize = img.getbbox()
        print imgSize
        if size[0] < imgSize[2]:
            size[0] = imgSize[2]
        size = [size[0], size[1] + int(imgSize[3])]
        print size

    left_corner = [0, 0]
    right_corner = [0, 0]
    texture = Image.new('RGBA', size) 
    for pic in files:
        img = Image.open(pic)
        imgSize = img.getbbox()
        print '--'
        print left_corner
        print '++'
        right_corner = [left_corner[0] + imgSize[2], left_corner[1] + imgSize[3]]
        texture.paste(img, (left_corner[0], left_corner[1], right_corner[0] , right_corner[1]))
        left_corner = [left_corner[0], right_corner[1]]
        print left_corner

    savename = "joined_" + str(size[0]) + 'x' + str(size[1]) + '.jpg'
    print savename
    texture.save(savename)

if __name__ == "__main__":
    main()
