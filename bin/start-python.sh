#!/bin/bash

if [ -z "$1" ];
then
	print "Specify a file name"
	exit
fi

cp ~/.vim/templates/python.py $1
chmod 0700 $1
