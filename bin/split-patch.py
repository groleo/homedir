#! /usr/bin/python3

import sys
import getopt
import os
import re


class Splitter:
    __fname = ""

    def __init__(self, fname):
        self.__fname = fname


    def isValid(self):
        return os.path.isfile(self.__fname) and  os.access(self.__fname, os.R_OK)


    def splitByFile(self):
        outfile = None
        fileId = 0

        stream = open(self.__fname, "r")
        while 1:
            line = stream.readline()
            if not line: break

            m = re.match('diff --git a/(.+) b/(.*)$', line)
            if m:
                fileId += 1
                filename = m.group(1).replace('/','_')
                filename = "%04d_%s.patch" % (fileId,filename)
                print("filename:%s. line:%s" % (filename, line))

                dirname = os.path.dirname(filename)
                if dirname and not os.path.exists(dirname):
                    os.makedirs( os.path.dirname(filename) )

                if outfile: outfile.close()
                outfile = open(filename, "w")
                outfile.write(line)
            elif outfile:
                outfile.write(line)


    def splitByHunk(self):
        print("Stub")


def main():
    s = Splitter(sys.argv[-1])
    if (s.isValid()):
        if sys.argv[0] == "--hunks":
            s.splitByHunk()
        else:
            s.splitByFile()
    else:
        print("File does not exist or is not readable")
        print(s.__fname)

if __name__ == "__main__":
        main()
