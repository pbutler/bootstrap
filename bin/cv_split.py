#!/usr/bin/env python
# -*- coding: UTF-8 -*-
# vim: ts=4 sts=4 sw=4 tw=79 sta et
"""%prog [options]
Python source code - @todo
"""

__author__ = "Patrick Butler"
__email__ = "pbutler@killertux.org"
__version__ = "0.0.1"

import random


def main(args):
    import argparse

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("-q", "--quiet",
                        action="store_false", dest="verbose",
                        help="don't print status messages to stdout")
    parser.add_argument("--version", action="version", version="%(prog)s " + __version__)
    parser.add_argument("-r", "--ranomd-seed", type=int)
    parser.add_argument("-s", "--split", type=float, default=0.9)
    parser.add_argument("file")
    options = parser.parse_args()

    if options.random_seed:
        random.seed(options.random_seed)

    train = open(options.file + ".train", "w")
    test = open(options.file + ".test", "w")
    for line in open(options.file):
        if random.random() > options.split:
            test.write(line)
        else:
            train.write(line)
    test.close()
    train.close()
    return 0


if __name__ == "__main__":
    import sys

    sys.exit(main(sys.argv))
