#!/usr/bin/env python
# -*- coding: UTF-8 -*-
# vim: ts=4 sts=4 sw=4 tw=79 sta et
"""%prog [options]
Python source code - replace this with a description of the code and write the code below this text.
"""

__author__ = 'Patrick Butler'
__email__ = 'pbutler@killertux.org'

import os
import sys
import optparse
import subprocess as sp
import fcntl
import json
import shutil
import logging
import fnmatch


class Cmd(object):
    def __init__(self, *args):
        if len(args) == 1:
            shell = True
        else:
            shell = False
        p = sp.Popen(args, stdout=sp.PIPE, stderr=sp.PIPE, shell=shell)
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
            logging.warn("Changed link from %s to %s" %
                         (os.path.realpath(dest), src))
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
                    shutil.copystat(os.path.join(dirpath, dir), destdir)
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


class Echo(object):
    """echos the given arguments to the command line"""

    def __init__(self, *args):
        """
        :param *args: arguments to be echoed

        """
        print " ".join( map(str, args))


class If(object):
    """If statement might be better thought of a switch statement that takes a
    dictionary and runs the lines from the dictionary elements.  Since true and
    false are not valid key values in JSON these are mapped to their strings
    (True and False).
    """

    def __init__(self, condition, statements):
        """
        :param condition: condition to check, a string of python code
        :param statements: statements, an array of stuff

        """

        result = eval(condition)
        if result is True:
            if "True" in statements:
                eval_conf(statements["True"])
        elif result is False:
            if "False" in statements:
                eval_conf(statements["False"])
        elif result in statements:
            eval_conf(statements[result])
        else:
            raise Exception("Unexpected result received")


class Touch(object):
    """Creates an empty file"""

    def __init__(self, fname):
        """@todo: to be defined

        :param fname: @todo

        """
        open(fname, "w")

conf_match = {
    "cmd":   Cmd,
    "file":  File,
    "link":  Link,
    "sync":  Sync,
    "mkdir": MkDir,
    "chmod": Chmod,
    "echo":  Echo,
    "if":    If,
    "touch": Touch
}


def eval_conf(lines):
    try:
        [conf_match[line[0]](*line[1:]) for line in lines]
    except Exception as e:
        print "Error in '%s'" % line
        raise e

def read_conf(fname="config.bootit"):
    lines = json.load(open(fname))
    eval_conf(lines)



def main(args):
    parser = optparse.OptionParser()
    parser.usage = __doc__
    parser.add_option("-q", "--quiet",
                      action="store_false", dest="verbose", default=True,
                      help="don't print status messages to stdout")

    parser.add_option("-n", "--no-update",
                      action="store_false", dest="update", default=True,
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
            print "Gitting"
            Cmd("git pull")

    if mode == "git":
        Cmd("git submodule update --init --recursive")

    read_conf()

    os.chdir(curdir)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
