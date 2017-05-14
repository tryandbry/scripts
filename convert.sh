#!/bin/bash

# Syntax: ./convert.sh <folder>
# changes all files in a directory to m4a format

for i in `ls $1`
do
ffmpeg -i "$1"/$i -c:a aac "$1/"`echo $i | awk -F'.' '{print $1}' | awk -F'-' '{print "think_like_a_freak-"$2"-"$3}'`.m4a
#echo $i | awk -F'.' '{print $1}' | awk -F'-' '{print "think_like_a_freak-"$2"-"$3}'
done
