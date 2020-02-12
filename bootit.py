#!/usr/bin/env python
# -*- coding: UTF-8 -*-
# vim: ts=4 sts=4 sw=4 tw=100 sta et
"""%prog [options]
Python source code - replace this with a description of the code and write the code below this text.
"""

__author__ = 'Patrick Butler'
__email__ = 'pbutler@killertux.org'

import sys
try:
    import yaml
except ImportError:
    sys.path += ["yaml{}.zip".format(sys.version_info.major)]
    import yaml
import os
import optparse
import subprocess as sp
import fcntl
import shutil
import logging
import fnmatch
import io


class Command(object):
    def __init__(self, evaluator, *args, **kwargs):
        pass


class Cmd(Command):
    def __init__(self, evaluator, *args):
        if len(args) == 1:
            shell = True
        else:
            shell = False
        p = sp.Popen(args, stdout=sp.PIPE, stderr=sp.PIPE, shell=shell)
        self.stdout = b""
        self.stderr = b""
        while p.returncode is None:
            s = self.non_block_read(p.stdout)
            if s:
                sys.stdout.write(s.decode("utf8"))
                self.stdout += s
            s = self.non_block_read(p.stderr)
            if s:
                sys.stderr.write(s.decode("utf"))
                self.stderr += s
            p.poll()

    def non_block_read(self, output):
        fd = output.fileno()
        fl = fcntl.fcntl(fd, fcntl.F_GETFL)
        fcntl.fcntl(fd, fcntl.F_SETFL, fl | os.O_NONBLOCK)
        try:
            return output.read()
        except Exception:
            return ""


class File(Command):
    def __init__(self, evaluator, src, dest):
        src = os.path.expanduser(src)
        dest = os.path.expanduser(dest)

        destdir = os.path.dirname(dest)
        if destdir and not os.path.exists(destdir):
            os.makedirs(destdir)

        if os.path.exists(dest):
            os.unlink(dest)
        shutil.copy2(src, dest)


class Link(Command):
    def __init__(self, evaluator, src, dest):
        src = os.path.expanduser(src)
        dest = os.path.expanduser(dest)
        assert os.path.exists(src), "{} does not exist for linking".format(src)
        rel_src = os.path.relpath(src, os.path.dirname(dest))

        destdir = os.path.dirname(dest)
        if destdir and not os.path.exists(destdir):
            os.makedirs(destdir)

        if os.path.lexists(dest):  # something is here
            if not os.path.islink(dest):
                raise IOError("Real file exists at %s" % dest)
            elif not os.path.exists(dest):
                logging.warn("Removing dangling link")
                os.unlink(dest)
            elif not os.path.samefile(src, dest):
                logging.warn("Changed link from %s to %s" %
                             (os.path.realpath(dest), rel_src))
                os.unlink(dest)

        if not os.path.exists(dest):  # something is here
            os.symlink(rel_src, dest)


class MkDir(Command):
    def __init__(self, evaluator, name, mode):
        name = os.path.expanduser(name)
        if not os.path.exists(name):
            os.mkdir(name, int(mode, 8))
        os.chmod(name, int(mode, 8))


class Chmod(Command):
    def __init__(self, evaluator, name, mode):
        name = os.path.expanduser(name)
        if os.path.exists(name):
            os.chmod(name, int(mode, 8))


class Sync(Command):
    def __init__(self, evaluator, src, dest, clean=True, patterns=None):
        if patterns is None:
            patterns = []
        src = os.path.expanduser(src)
        dest = os.path.expanduser(dest)

        destdir = os.path.dirname(dest)
        if destdir and not os.path.exists(destdir):
            os.makedirs(destdir)

        if not patterns:
            patterns = [".git", ".svn"]

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
                if not os.path.exists(srcdir) and clean:
                    shutil.rmtree(destdir)

            for file in filenames:
                srcfile = os.path.join(srcpath, file)
                destfile = os.path.join(dirpath, file)
                if not os.path.exists(srcfile) and clean:
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
                for pat in patterns:
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
                for pat in patterns:
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


class Echo(Command):
    """echos the given arguments to the command line"""

    def __init__(self, evaluator, *args):
        """
        :param *args: arguments to be echoed

        """
        print(" ".join(str(a) for a in args))


class If(Command):
    """If statement might be better thought of a switch statement that takes a
    dictionary and runs the lines from the dictionary elements.  Since true and
    false are not valid key values in JSON these are mapped to their strings
    (True and False).
    """

    def __init__(self, evaluator, **kwargs):
        """
        :param condition: condition to check, a string of python code
        :param statements: statements, an array of stuff

        """

        condition = kwargs["expr"]
        result = str(eval(condition))
        if result in kwargs:
            evaluator.eval(kwargs[result])


class Touch(Command):
    """Creates an empty file"""

    def __init__(self, evaluator, fname):
        """@todo: to be defined

        :param fname: @todo

        """
        fname = os.path.expanduser(fname)
        io.open(fname, "wt").close()


class Evaluator(object):

    """Docstring for Evaluator. """

    def __init__(self, commands):
        """TODO: to be defined1.

        :param commands: TODO

        """
        self._commands = commands

    def start(self, fname):
        lines = yaml.safe_load(open(fname, "rt").read())
        self.eval(lines)

    def eval(self, lines):
        commands = self._commands
        try:
            for line in lines:
                cmd_name = list(line.keys())[0]
                cmd = commands[cmd_name]
                args = line[cmd_name]
                if isinstance(args, dict):
                    cmd(self, **args)
                elif isinstance(args, list):
                    cmd(self, *args)
                else:
                    cmd(self, args)
        except Exception as e:
            print("Error in '%s': '%s'" % (line, e))
            raise


def main(args):
    parser = optparse.OptionParser()
    parser.usage = __doc__
    parser.add_option("-q", "--quiet",
                      action="store_false", dest="verbose", default=True,
                      help="don't print status messages to stdout")

    parser.add_option("-n", "--no-update",
                      action="store_false", dest="update", default=True,
                      help="don't run git pull")
    parser.add_option("--conf_file", default="bootit.yaml")
    (options, args) = parser.parse_args()

    if len(args) < 0:
        parser.error("Not enough arguments given")
    selfdir = os.path.dirname(os.path.abspath(__file__))
    curdir = os.getcwd()
    os.chdir(selfdir)

    if os.path.exists(".git"):
        print("Detected git mode")
        mode = "git"
    else:
        print("Detected untracked mode")
        mode = "none"
        options.update = False

    if options.update:
        if mode == "git":
            print("Gitting")
            Cmd("", "git", "pull")

    # if mode == "git":
    #    Cmd("git submodule update --init --recursive")

    commands = {}
    for name, var in globals().items():
        if name == "Command":
            continue
        if isinstance(var, type) and issubclass(var, Command):
            commands[name.lower()] = var

    evaluator = Evaluator(commands)
    evaluator.start(options.conf_file)

    os.chdir(curdir)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
