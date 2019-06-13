#!/bin/bash
#
#
# smb2win.sh converts a smb path into a windows path
# USAGE:
# smb2win <smb path>:
#		returns <windows path>
# 	e.g.: 
#		smb2win.sh smb://path/directory/file.txt returns \\path\directory\file.txt

input=$1
# remove "smb:" if it is included in the input path
if [ "${input:0:3}" = "smb" ]; then
	output="${input:4}"
fi
output=${output//\//\\} # replace all backslashes with forwardslashes

# output to terminal
echo 
echo "$output"
echo 