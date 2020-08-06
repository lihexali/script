#!/usr/bin/python
#coding UTF-8

import sys
import plist
import struct

class CCBReader:
    def __init__(self, ccbi):
        self.ccbi = ccbi
        self.currentByte = 0

    def readInt(self):
        magicBytes = struct.unpack('<I',self.fileData.read(4))
        self.offsetCurrentByte(4)
        return int(hex(magicBytes[0]), 0)

    
    def readIntStr(self):
        hexv = self.readInt()
        list_l = [hex(hexv >> i & 0xff) for i in (24,16,8,0)]
        # print list_l
        list_char = [(lambda i:chr(int(i,0)))(i) for i in list_l]
        # print list_char
        return ''.join(list_char)


    def offsetCurrentByte(self, offset):
        self.currentByte = self.currentByte + offset
        self.fileData.seek(self.currentByte)

        print 'offsetByte: ' , offset , 'currentByte: ' , self.currentByte


    def readHeader(self):
        print 'readHeader'
        self.fileData = open("./mainScene.ccbi", 'rb')
        ccbistr = self.readIntStr()
        print ccbistr

        # read version
        version = self.readIntStr()
        print version


        return cmp('ccbi', ccbistr)

        
    def readStringCache(self):
        print 'readStringCache'

    def readNodeGraph(self):
        print 'readNodeGraph'

reader = CCBReader('./mainScene.ccbi')
reader.readHeader()




