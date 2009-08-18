#!/bin/bash

if [ -z "$1" ];
then
	print "Specify a file name"
	exit
fi

cat >$1 <<EOT
#!/usr/bin/env python
# -*- coding: UTF-8 -*-
# vim: tabstop=4 shiftwidth=4 softtabstop=4
"""
Python source code - replace this with a description of the code and write the code below this text.
"""

__author__ = 'Patrick Butler'
__email__  = 'pbutler@killertux.org'

if __name__ == "__main__":
        import sys
        sys.exit(0)
EOT

chmod 0700 $1
