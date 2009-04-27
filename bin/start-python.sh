#!/bin/bash

if [ -z "$1" ];
then
	print "Specify a file name"
	exit
fi
 
cat >$1 <<EOT
#!/usr/bin/env python
# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4
"""
Python source code - replace this with a description of the code and write the code below this text.
"""

if __name__ == "__main__":
	import sys
	sys.exit(0)
EOT

