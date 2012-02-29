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
import csv
import shutil
import logging
import fnmatch

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

class File(object):
    def __init__(self, src, dest):
        src = os.path.expanduser(src)
        dest = os.path.expanduser(dest)

        destdir = os.path.dirname(dest)
        if destdir and not os.path.exists(destdir):
            os.makedirs(destdir)

        if os.path.exists(dest):
            os.unlink(dest)
        shutil.copy2(src, dest)

class Link(object):
    def __init__(self, src, dest):
        src = os.path.expanduser(src)
        dest = os.path.expanduser(dest)
        src = os.path.relpath(src, os.path.dirname(dest))

        destdir = os.path.dirname(dest)
        if destdir and not os.path.exists(destdir):
            os.makedirs(destdir)

        if os.path.islink(dest) and os.path.samefile(src, dest):
            logging.warn("Changed link from %s to %s" %(os.path.realpath(dest),
                                                        src))
            os.unlink(dest)
        elif os.path.lexists(dest) and os.path.islink(dest):
            os.unlink(dest)
        os.symlink(src, dest)

class MkDir(object):
    def __init__(self, dir, perms):
        dir = os.path.expanduser(dir)
        if not os.path.exists(dir):
            os.mkdir(dir, int(perms, 8))
        os.chmod(dir, int(perms, 8))

class Chmod(object):
    def __init__(self, path, perms):
        path = os.path.expanduser(path)
        if os.path.exists(path):
            os.chmod(path, int(perms, 8))

class Sync(object):
    def __init__(self, src, dest, *pats):
        clean = True
        src = os.path.expanduser(src)
        dest = os.path.expanduser(dest)

        destdir = os.path.dirname(dest)
        if destdir and not os.path.exists(destdir):
            os.makedirs(destdir)

        if len(pats) > 0 and pats[0] == "noclean":
            pats = pats[1:]
            clean = False

        if not pats:
            pats = [ ".git", ".svn" ]

        if not os.path.exists(dest):
            os.makedirs(dest)

        for dirpath, dirnames, filenames in os.walk(dest):
            srcpath = dirpath[len(dest):]
            if srcpath and srcpath[0] == "/":
                srcpath = srcpath[1:]
            srcpath = os.path.join(src, srcpath)

            for dir in dirnames:
                srcdir = os.path.join(srcpath, dir)
                destdir = os.path.join(dirpath, dir)
                if not os.path.exists(srcdir):
                    shutil.rmtree(destdir)

            for file in filenames:
                srcfile = os.path.join(srcpath, file)
                destfile = os.path.join(dirpath, file)
                if not os.path.exists(srcfile):
                    os.unlink(destfile)

        for dirpath, dirnames, filenames in os.walk(src):
            destpath = dirpath[len(src):]
            if destpath and destpath[0] == "/":
                destpath = destpath[1:]
            destpath = os.path.join(dest, destpath)

            dnames = dirnames[:]
            for dir in dnames:
                destdir = os.path.join(destpath, dir)
                skip = False
                for pat in pats:
                    if fnmatch.fnmatch(dir, pat):
                        skip = True
                        break
                if skip:
                    dirnames.remove(dir)
                    continue

                if not os.path.exists(destdir):
                    os.mkdir(destdir)
                try:
                    shutil.copystat(os.path.join(dirpath,dir), destdir)
                except shutil.WindowsError:
                    pass


            for file in filenames:
                skip = False
                for pat in pats:
                    if fnmatch.fnmatch(file, pat):
                        skip = True
                        break
                if skip:
                    continue
                destfile = os.path.join(destpath, file)
                srcfile = os.path.join(dirpath, file)
                if os.path.exists(destfile):
                    os.unlink(destfile)

                if os.path.islink(srcfile):
                    linkto = os.readlink(srcfile)
                    os.symlink(linkto, destfile)
                else:
                    try:
                        shutil.copy2(srcfile, destfile)
                    except shutil.WindowsError:
                        pass


conf_match = {
    "cmd" : Cmd,
    "file" : File,
    "link" : Link,
    "sync" : Sync,
    "mkdir" : MkDir,
    "chmod" : Chmod,
}


def read_conf(fname="config.bootit"):
    lines = csv.reader(open(fname))
    for line in lines:
        for name, type in conf_match.iteritems():
            if line[0] == name:
                type(*line[1:])



def main(args):
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

    read_conf()

    os.chdir(curdir)
    return 0


if __name__ == "__main__":
    import sys
    sys.exit( main( sys.argv ) )


