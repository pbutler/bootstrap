#!/bin/bash

FILES=`find . -name \*.tex`
TERM=xterm-color
for file in $FILES; do
	echo $file
	aspell --local-data-dir=./ --home-dir=./ -t check $file
done
