#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
# vim: ts=4 sts=4 sw=4 tw=100 sta et

__author__ = 'Patrick Butler'
__email__ = 'pbutler@killertux.org'


import argparse
import fcntl
import logging
import os
from pathlib import Path
import shutil
import subprocess as sp
import sys

logging.basicConfig(level=logging.INFO)


class BootItException(Exception):
    pass


class BootItState:
    state = []

    @classmethod
    def push_state(cls, bootit):
        cls.state += [bootit]

    @classmethod
    def pop_state(cls):
        cls.state.pop()

    @classmethod
    def cur_state(cls):
        if cls.state:
            return cls.state[-1]
        else:
            return None


class BootIt:
    def __init__(self, args=None):
        if args is None:
            args = sys.argv

        self.argparse(args)

        self.selfdir = Path(__file__).absolute().parent

        if (self.selfdir / ".git").exists():
            logging.debug("Detected git mode")
        else:
            logging.debug("Detected untracked mode, forcing no update")
            self.options.update = False

        if self.options.update:
            logging.info("Gitting")
            Cmd("git", "pull", state=self)

    def argparse(self, argv=None):
        parser = argparse.ArgumentParser(description=__doc__)
        parser.add_argument("-G", "--no-git",
                            action="store_false", dest="update", default=True,
                            help="don't run git pull")
        parser.add_argument("--conf_file", default="bootstrap.py")
        parser.add_argument("--dry-run", action="store_true", default=False,
                            help="don't perform any real tasks")
        parser.add_argument("--working-dir", default=Path.cwd(), type=Path)
        self.options = parser.parse_args()

    @property
    def dry_run(self):
        return self.options.dry_run

    def __enter__(self):
        BootItState.push_state(self)
        self.orig_dir = Path.cwd()
        self.curdir = self.options.working_dir
        os.chdir(str(self.curdir))

    def __exit__(self, exc_type, exc_value, traceback):
        os.chdir(str(self.orig_dir))


class Command(object):
    def __init__(self, *args, state=None, **kwargs):
        if state is None:
            self.state = BootItState.cur_state()
        else:
            self.state = state
        self.do(*args, **kwargs)


class Cmd(Command):
    def do(self, *args, quiet=False, exception=True):
        if len(args) == 1:
            shell = True
        else:
            shell = False

        self.stdout = ""
        self.stderr = ""
        logging.info("Running cmd {} shell={}".format(args, shell))

        if self.state.dry_run:
            return

        p = sp.Popen(args, stdout=sp.PIPE, stderr=sp.PIPE, shell=shell)
        while p.returncode is None:
            s = self.non_block_read(p.stdout)
            if s:
                if not quiet:
                    sys.stdout.write(s)
                self.stdout += s

            s = self.non_block_read(p.stderr)
            if s:
                sys.stderr.write(s)
                self.stderr += s
            p.poll()

        logging.debug("ret={} stdout={} stderr={}".format(p.returncode,
                                                          self.stdout,
                                                          self.stderr))
        self.okay = (p.returncode == 0)
        if exception and not self.okay:
            raise BootItException("Cmd {} failed".format(" ".join(args)))

    def non_block_read(self, output):
        fd = output.fileno()
        fl = fcntl.fcntl(fd, fcntl.F_GETFL)
        fcntl.fcntl(fd, fcntl.F_SETFL, fl | os.O_NONBLOCK)
        try:
            return output.read().decode("utf8")
        except Exception:
            return ""


class Copy(Command):
    def do(self, src, dest):
        src = Path(src).expanduser()
        dest = Path(dest).expanduser()

        destdir = dest.parent
        if not destdir.exists():
            logging.info("making dir {}". format(destdir))
            if not self.state.dry_run:
                destdir.mkdir(parents=True)

        if dest.exists():
            logging.info("removing existing file {}". format(dest))
            if not self.state.dry_run:
                dest.unlink()
        shutil.copy2(str(src), str(dest))


class Link(Command):
    def do(self, src, dest):
        src = Path(src).expanduser()
        if not src.exists():
            raise BootItException("{} does not exist for linking".format(src))

        src = src.resolve()
        dest = Path(dest).expanduser()

        try:
            logging.info("%s %s", src, dest.resolve())
            rel_src = os.path.relpath(src, dest.resolve().parent)
        except ValueError:
            logging.info("Couldn't calculate relative path using absolute {}".format(src))
            rel_src = src.resolve()

        destdir = dest.parent
        if not destdir.exists():
            destdir.mkdir(parents=True)

        if dest.exists() and not dest.is_symlink():
            raise BootItException("Real file exists at %s" % dest)
        elif dest.is_symlink() and not dest.exists():
            logging.warn("Removing dangling link %s->%s" % (dest, rel_src))
            if not self.state.dry_run:
                os.unlink(str(dest))
        elif dest.exists() and not src.samefile(dest):
            logging.warn("Changing link from %s to %s" % (os.path.realpath(str(dest)), rel_src))
            if not self.state.dry_run:
                os.unlink(str(dest))

        if not dest.exists():
            logging.info("Linking from %s to %s" % (rel_src, dest))
            dest.symlink_to(rel_src)


class Mkdir(Command):
    def do(self, name, mode):
        name = Path(name).expanduser()
        if not name.exists():
            logging.info("Making dir {}".format(name))
            if not self.state.dry_run:
                name.mkdir(int(mode, 8), parents=True)
        Chmod(name, mode)


class Chmod(Command):
    def do(self, name, mode):
        name = Path(name).expanduser()
        if name.exists():
            logging.info("Chmodding dir {}".format(name))
            if not self.state.dry_run:
                name.chmod(int(mode, 8))
        else:
            raise BootItException("No file to chmod {}".format(name))


class Sync(Command):
    """clean is ignored at the moment"""
    def do(self, src, dest, clean=True, patterns=None):
        src = Path(src).expanduser()
        dest = Path(dest).expanduser()

        if patterns is None:
            patterns = [".git"]

        if not dest.exists():
            logging.info("Creating dir to sync to {}".format(dest))
            if not self.state.dry_run:
                dest.mkdir(parents=True)

        sunk = []
        for syncable in src.rglob("*"):
            if syncable == src:
                continue

            skip = False
            for pat in patterns:
                cur = syncable
                while cur != src:
                    if cur.match(pat):
                        logging.debug("Skipping sync of {}".format(syncable))
                        skip = True
                        break
                    cur = cur.parent
                if skip:
                    break
            if skip:
                continue
            partial = syncable.relative_to(src)

            sunk += [(syncable, dest / partial)]

        for fsrc, fdest in sunk:  # type: Path, Path
            fsrc = src.resolve().parent / fsrc
            if fsrc.is_dir():
                logging.info("Make Sync dir {} in  {}".format(fsrc, fdest))
                Mkdir(fdest)
                # TODO: copy chmod settings
            else:
                logging.info("Syncing {} to {}".format(fsrc, fdest))
                Copy(src=fsrc, dest=fdest)


class Echo(Command):
    """echos the given arguments to the command line"""

    def do(self, *args):
        """
        :param *args: arguments to be echoed

        """
        logging.info(" ".join(str(a) for a in args))


class Touch(Command):
    """Creates an empty file"""

    def do(self, fname):
        """@todo: to be defined

        :param fname: @todo

        """
        fname = Path(fname).expanduser()
        logging.info("Touching {}".format(fname))
        if not self.state.dry_run:
            fname.touch()


class Pip(Command):
    def do(self, pkgs=[], user=True, upgrade=True):
        opts = []
        if user:
            opts += ["--user"]

        if upgrade:
            opts += ["--upgrade"]

        cmd = "python3 -mpip install {} {}".format(
            " ".join(opts),
            " ".join(pkgs))

        Cmd(cmd)


class Brew(Command):
    """ upgrade is currently ignored"""
    def do(self, pkgs=[], cask=False, upgrade=True, tap=False):
        assert sum([tap, cask]) < 2, "Choose either cask or tap or neither"
        prefix = ["brew"]
        if cask:
            prefix += ["cask"]
            cmd = "list"
        elif tap:
            prefix += ["tap"]
            cmd = ""
        else:
            cmd = "list"

        prefix = " " .join(prefix)
        logging.info("Checking for installed {} pkgs".format(prefix))
        ret = Cmd("{} {}".format(prefix, cmd), quiet=True)
        installed = {p.split("@")[0] for p in ret.stdout.split("\n")}
        needed = set(pkgs) - installed
        if needed:
            logging.info("Installing from {}: {}".format(prefix, ", ".join(needed)))
            if tap:
                Cmd("{} {}".format(prefix, " ".join(needed)))
            else:
                Cmd("{} install {}".format(prefix, " ".join(needed)))
        else:
            logging.info("No pkgs from {} needed".format(prefix))


# def main(args):
#     commands = {}
#     for name, var in globals().items():
#         if name == "Command":
#             continue
#         if isinstance(var, type) and issubclass(var, Command):
#             commands[name.lower()] = var
#
#     evaluator = Evaluator(commands, options.dry_run)
#     evaluator.start(options.conf_file)
#
#     os.chdir(curdir)
#     return 0
#
#
# if __name__ == "__main__":
#     sys.exit(main(sys.argv))
