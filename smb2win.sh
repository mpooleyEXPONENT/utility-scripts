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
	input="${input:4}"
fi
output="${input//\//\\}" # replace all backslashes with forwardslashes

# output to terminal and copy to clipboard
echo -n "$output" | tee >(pbcopy) # -n flag needed to prevent linebreak being added to clipboard
echo # echo to get newline in terminal
