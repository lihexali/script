#!/usr/bin/env python
# Usage: paser.py <*.jpg|png>
# OutPut: joined_withxheight.jpg

import re
import sys

def verify(arglist):
    print 'arglist contains: ',arglist
    argcount = len(arglist)
    print 'argcount: ',argcount
    if argcount == 5:
        scendarg = arglist[1]
        thirdarg = arglist[2]
        fortharg = arglist[3]
        fivtharg = arglist[4]
        if scendarg == thirdarg:
            print '2 = 3'
        if fortharg == (2 * thirdarg):
            print '4 = 2x3'
        if fortharg == fivtharg:
            print '4 == 5'
    pass

    if argcount == 10:
        print '10 argcount'
        scendarg = [arglist[2], arglist[3]]
        thirdarg = [arglist[4], arglist[5]]
        fortharg = [arglist[6], arglist[7]]
        fivtharg = [arglist[8], arglist[9]]
        if scendarg[0] == thirdarg[0] and scendarg[1] == thirdarg[1]:
            print '2 = 3'
        if fortharg[0] == (2 * thirdarg[0]) and fortharg[1] == (2 *thirdarg[1]):
            print '4 = 2x3'
        if fortharg[0] == fivtharg[0] and fortharg[1] == fivtharg[1]:
            print '4 == 5'
    pass
    print 


    pass

def main():
    #f = file('./tmd.txt')
    f = sys.stdin
    while True:
        line = f.readline()
        if len(line) == 0:
            break
        #print 'raw: ',line,
        strlist=[]
        if "RESO_DEF" in line:
            #print line
            pos = line.find('RESO_DEF')
            filename = line[0:pos]
            print filename
            beginstr = line[pos:].strip('\n')
            strlist.append(beginstr)
            nextline = line
            while True:
                if "};" in nextline:
                    break
                nextline = f.readline()
                if len(nextline) == 0:
                    break
                nextline = nextline.strip('\n')
                strlist.append(nextline.strip())
            finalstr = ''.join(strlist)
            print finalstr.strip()
    f.close()
    pass

if __name__ == "__main__":
    main()

