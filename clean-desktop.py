#!/usr/bin/env python
# -*- coding: UTF-8 -*-
# vim: ts=4 sts=4 sw=4 tw=79 sta et
"""%prog [options]
Python source code - @todo
"""

__author__ = "Patrick Butler"
__email__ = "pbutler@killertux.org"
__version__ = "0.0.1"

import os
import fnmatch
import time

dirs = {
    "Images": ["*.jpg", "*.png", "*.gif", "*.dia", "*.fig", "*.svg", "*.eps"],
    "Data": ["*.csv", "*.dat", "*.json"],
    "Sound": ["*.wav", "*.mp3", "*.mp4"],
    "Archives": ["*.zip", "*.tar.*", "*.dmg", "*.tgz", "*.pkg"],
    "Docs": [
        "*.ppt*",
        "*.doc*",
        "*.xls*",
        "*.txt",
        "*.html",
        "*.pps",
        "*.odp",
        "*.rtf",
        "*.odt",
    ],
    "PDFs": ["*.pdf*", "*.ps*"],
    "CAD": ["*.scad", "*.dxf", "*.FCStd*", "*.stl", "*.dtx"],
    "Scripts": [
        "*.py*",
        "*.pl",
        "*.js",
        "*.java",
        "*.ipynb",
        "*.gs",
        "*.fs",
        "*.pkl",
        "*.mjson",
    ],
    "Apps": ["*.app", "*.exe"],
    "Misc": [],
    "Videos": ["*.avi", "*.asf"],
    "Torrents": ["*.torrent"],
    "Videos": ["*.avi", "*.asf"],
}


def safe_copy(src, target, dry=False):
    if not dry:
        dir = os.path.dirname(target)
        if not os.path.exists(dir):
            os.mkdir(dir)
        os.link(src, target)
        os.unlink(src)


def main(args):
    import argparse

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "-q",
        "--quiet",
        action="store_false",
        dest="verbose",
        help="don't print status messages to stdout",
    )
    parser.add_argument(
        "--version", action="version", version="%(prog)s " + __version__
    )
    parser.add_argument(
        "-d", "--dir", default=os.path.join(os.environ["HOME"], "Desktop")
    )
    parser.add_argument("-a", "--age", type=float, default=30)
    parser.add_argument("--dry-run", action="store_true")
    # parser.add_argument('args', metavar='args', type=str, nargs='*',
    #                    help='an integer for the accumulator')
    options = parser.parse_args()

    dpath = options.dir
    # options.dry_run = True
    filter_age = time.time() - options.age * 60 * 60 * 24

    managed = {}

    old_path = os.path.join(dpath, "Old")
    if not os.path.exists(old_path):
        os.mkdir(old_path)

    for dir in dirs:
        target = os.path.join(old_path, dir)
        print("{}:".format(target))
        files = sorted(
            {
                file
                for pat in dirs[dir]
                for file in fnmatch.filter(os.listdir(dpath), pat)
            }
        )
        managed[dir] = set(files)
        for file in files:
            src = os.path.join(dpath, file)
            target = os.path.join(old_path, dir, file)
            stat = os.stat(src)
            age = (time.time() - stat.st_atime) / (60 * 60 * 24)
            if stat.st_atime > filter_age:
                print("skipping {} for age: {:.2f}".format(src, age))
            else:
                print("copy {} to {}".format(src, target))
                if not options.dry_run:
                    safe_copy(src, target)
    print("Others:")
    ofiles = set(os.listdir(dpath))
    for files in managed.values():
        ofiles = ofiles - files
    print(sorted(ofiles))
    return 0


if __name__ == "__main__":
    import sys

    sys.exit(main(sys.argv))
