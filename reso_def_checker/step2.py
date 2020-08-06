#!/usr/bin/env python
# Usage: paser.py <*.jpg|png>
# OutPut: joined_withxheight.jpg

import re
import sys

LOGS=[]
LOGTAG='d'

# comment
def Log(msg='', arg=''):
    global LOGTAG
    log = str(msg) + str(arg)
    if 'v' == LOGTAG:
        print log
    pass
    global LOGS
    LOGS.append(log)

# comment
def verify(arglist):
    passed = False
    Log('arglist contains: ',arglist)
    argcount = len(arglist)
    Log('argcount: ',argcount)
    if argcount == 5:
        scendarg = arglist[1]
        thirdarg = arglist[2]
        fortharg = arglist[3]
        fivtharg = arglist[4]
        if scendarg == thirdarg:
            Log('2 = 3')
            passed = True
        if fortharg == (2 * thirdarg):
            Log('4 = 2x3')
            passed = passed and True
        if fortharg == fivtharg:
            Log('4 == 5')
            passed = passed and True
    if passed:
        print 'Passed'
        print
        print
        return

    pass

    passed = False
    if argcount == 10:
        Log('10 argcount')
        scendarg = [arglist[2], arglist[3]]
        thirdarg = [arglist[4], arglist[5]]
        fortharg = [arglist[6], arglist[7]]
        fivtharg = [arglist[8], arglist[9]]
        if scendarg[0] == thirdarg[0] and scendarg[1] == thirdarg[1]:
            Log('2 = 3')
            passed = True
        if fortharg[0] == (2 * thirdarg[0]) and fortharg[1] == (2 *thirdarg[1]):
            Log('4 = 2x3')
            passed = passed and True
        if fortharg[0] == fivtharg[0] and fortharg[1] == fivtharg[1]:
            Log('4 == 5')
            passed = passed and True
    if passed:
        print 'Passed'
    else:
        print 'Faild'
        global LOGS
        global LOGTAG
        if not (LOGTAG == 'v'):
            print '\n'.join(LOGS)
    print
    print
    pass

def main():
    f = sys.stdin
    argvs = sys.argv
    if len(argvs) > 1:
        global LOGTAG
        LOGTAG=argvs[1]
        #print 'LOGTAG',argvs[1]

    while True:
        line = f.readline()
        if len(line) == 0:
            break
        filelist = re.findall('.*.cpp:\d+|.*.h:\d+', line)
        #print file name
        if (len(filelist))> 0:
                print line.strip()
        else:
            Log('raw: ',line.strip())
            aList = re.findall('([+-]?\d+(\.\d*)?|\.\d+)([eE][+-]?\d+)?',line) 
            #print aList 
            arglist=[]
            for ss in aList:
                #print (ss[0] + ss[2])
                aNum = float((ss[0] + ss[2]))
                #print (aNum)
                arglist.append(aNum)
            # verify argument
            verify(arglist)
        global LOGS
        LOGS=[]
    f.close()
    pass

if __name__ == "__main__":
    main()

