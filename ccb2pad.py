#!/usr/bin/env python
#  iphone ccb convert to ipad ccb
#  How it works: contentSize, position, positionRelative coordinates x2
#  Usage: ccb2pad.py <*.ccb>

import sys
import os.path
import plistlib

def parseChild(plist, child):
    scaleNum = 0.5
    properties = child["properties"]
    (contentSize_x, contentSize_y) = properties["contentSize"]
    properties["contentSize"] = (contentSize_x * scaleNum, contentSize_y * scaleNum)

    (position_x, position_y) = properties["position"]
    properties["position"] = (position_x * scaleNum, position_y * scaleNum)

    (positionRelative_x, positionRelative_y) = properties["positionRelative"]
    properties["positionRelative"] = (positionRelative_x * scaleNum, positionRelative_y * scaleNum)

    child["properties"] = properties

    children = child["children"]
    for kid in children:
        parseChild(plist, kid)
    pass
    return child


def parseCCB(path):
    plistPath = path
    (dirname, filename) = os.path.split(plistPath)
    (fileBaseName, fileExtension) = os.path.splitext(filename)

    if fileExtension != '.ccb':
        print 'Usage: ccb2pad.py <*.ccb>'
        return

    if dirname == '':
        dirname='.'
    padCCBFileName = dirname + '/' + fileBaseName + '-pad' + '.ccb';

    print "Parsing file: " + plistPath
    plist = plistlib.readPlist(plistPath)
    nodeGraph  = plist['nodeGraph']
    newNodeGraph = parseChild(plist, nodeGraph)
    plist['nodeGraph'] = newNodeGraph 
    print 'Parse over! writed in: ' + padCCBFileName
    plistlib.writePlist(plist, padCCBFileName)


def main():
    argvs = sys.argv
    if len(argvs) < 2:
        print 'Usage: ccb2pad.py <*.ccb>'
        return

    files = argvs[1:]
    for ccb_file in files:
        if os.path.exists(ccb_file) == False:
            print 'File ' + ccb_file + ' is not exists!'
            return
        parseCCB(ccb_file)

if __name__ == "__main__":
    main()

