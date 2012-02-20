#!/usr/bin/env python
# -*- coding: UTF-8 -*-
# vim: ts=4 sts=4 sw=4 tw=79 sta et
"""%prog [options]
Python source code - replace this with a description of the code and write the code below this text.
"""

__author__ = 'Patrick Butler'
__email__  = 'pbutler@killertux.org'

import os
import sys
import optparse
import subprocess as sp
import fcntl




class Cmd(object):
    def __init__(self, *args):
        p = sp.Popen(*args, stdout=sp.PIPE, stderr=sp.PIPE, shell=True)
        self.stdout = ""
        self.stderr = ""
        while p.returncode is None:
            s = self.non_block_read(p.stdout)
            if s:
                sys.stdout.write(s)
                self.stdout += s
            s = self.non_block_read(p.stderr)
            if s:
                sys.stderr.write(s)
                self.stderr += s
            p.poll()

    def non_block_read(self, output):
        fd = output.fileno()
        fl = fcntl.fcntl(fd, fcntl.F_GETFL)
        fcntl.fcntl(fd, fcntl.F_SETFL, fl | os.O_NONBLOCK)
        try:
            return output.read()
        except:
            return ""

def copy(src, dest):
    os.link(src, dest)

def main(args):
    import  optparse
    parser = optparse.OptionParser()
    parser.usage = __doc__
    parser.add_option("-q", "--quiet",
                      action="store_false", dest="verbose", default=True,
                      help="don't print status messages to stdout")

    parser.add_option("-n", "--no-update",
                      action="store_false", dest="update",
                      help="don't run git pull or svnupdate")
    (options, args) = parser.parse_args()
    if len(args) < 0:
        parser.error("Not enough arguments given")

    selfdir = os.path.dirname(__file__)
    curdir = os.getcwd()
    os.chdir(selfdir)

    if os.path.exists(".svn"):
        print "Detected SVN mode"
        mode = "svn"
    elif os.path.exists(".git"):
        print "Detected git mode"
        mode = "git"
    else:
        print "Detected untracked mode"
        mode = "none"
        options.update = False

    if options.update:
        if mode == "svn":
            pass
        elif mode == "git":
            pass


    os.chdir(curdir)
    return 0



if __name__ == "__main__":
    import sys
    sys.exit( main( sys.argv ) )


