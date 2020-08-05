#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
# vim: ts=4 sts=4 sw=4 tw=88 sta et
"""%prog [options]
Python source code - @todo
"""

__author__ = "Patrick Butler"
__email__ = "pbutler@killertux.org"
__version__ = "0.0.1"

import os
from pathlib import Path
import pendulum
import filetype


class FilteredDir:
    def __init__(self, src_dir, filters):
        self.src_dir = src_dir
        self.filters = filters

    def __rshift__(self, destdir):
        destdir = Path(destdir).expanduser()
        src = self.src_dir.src

        for file in src.glob("*"):  # type: Path
            if file == src:
                continue

            if file.is_dir():
                continue

            # rel_file = file.relative_to(src)
            if self.filters.eval(file):
                file_arch_dir = file.parent / destdir

                orders = {
                    ".jpg": "Images",
                    ".gif": "Images",
                    ".png": "Images",
                    ".svg": "Images",
                    ".gif": "Images",

                    ".doc": "Documents",
                    ".docx": "Documents",
                    ".ppt": "Documents",
                    ".pptx": "Documents",
                    ".xls": "Documents",
                    ".xlsx": "Documents",
                    ".txt": "Documents",
                    ".html": "Documents",
                    ".htm": "Documents",

                    ".pdf": "PDFs",

                    ".stl": "3D Printer",
                    ".gcode": "3D Printer",
                    ".dxf": "3D Printer",
                    ".scad": "3D Printer",

                    ".zip": "Archivees",
                    ".gz": "Archives",
                    ".rar": "Archives",
                    ".pkg": "Archives",
                    ".dmg": "Archives",
                    ".bz2": "Archives",
                    ".tgz": "Archives",

                    ".csv": "Data",
                    ".tsv": "Data",
                    ".json": "Data",


                    ".py": "Source Code",
                    ".ipynb": "Data",
                }

                try:
                    typedir = orders[file.suffix.lower()]
                except:
                    typedir = "Other"

                if typedir is None:
                    print(">>>", file)
                    continue

                typedir = file_arch_dir / typedir
                if not typedir.exists():
                    typedir.mkdir(parents=True)

                file_arch = typedir / file.name
                os.link(file, file_arch)
                file_arch.chmod(file.stat().st_mode)
                file.unlink()

                print(file, file_arch)


class SourceDir:
    def __init__(self, src):
        self.src = Path(src).expanduser()

    def __rshift__(self, filters):
        return FilteredDir(self, filters)


class Filter:
    def __init__(self, *args, **kwargs):
        self.args = args
        self.kwargs = kwargs

    def __and__(self, other):
        return And(self, other)

    def __or__(self, other):
        return Or(self, other)

    def eval(self, file: Path):
        raise NotImplementedError()


class And(Filter):
    def eval(self, file):
        return all(self.args)


class Or(Filter):
    def eval(self, file):
        return any(self.args)


class MTime(Filter):
    def eval(self, file: Path):
        amt = int(self.args[0])
        units = self.args[1]

        now = pendulum.now()
        cutoff = now.subtract(**{units: amt})
        mtime = file.stat().st_mtime
        mtime = pendulum.from_timestamp(mtime)
        return mtime < cutoff


SourceDir("~/Downloads") >> MTime(6, "months") >> "Archives"
