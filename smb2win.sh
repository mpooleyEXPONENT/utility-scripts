#!/bin/bash
#
#
# smb2win.sh converts a smb path into a windows path
# USAGE:
# smb2win [-c] smb_path:
#		returns <windows path>
# 	e.g.: 
#		smb2win.sh smb://path/directory/file.txt returns \\path\directory\file.txt and copies this path to clipboard
#	optional flag -c suppresses output to clipboard

# define string transform operation
path_transform () {
	input=$1
	# remove "smb:" if it is included in the input path
	if [ "${input:0:3}" = "smb" ]; then
		input="${input:4}"
	fi
	output="${input//\//\\}" # replace all backslashes with forwardslashes
}

if [ $# = 2 ] && [ $1 = "-c" ]; then # if optional flag [-c] is supplied the output path is not copied to clipboard
	path_transform $2
	echo $output
elif [ $# = 1 ]; then # if optional flag is not supplied then the output path is copied to clipboard
	path_transform $1
	echo -n "$output" | tee >(pbcopy) # -n flag needed to prevent linebreak being added to clipboard
	echo # echo to get newline in terminal
else # if input is not correct a usage message is displayed along with an appropriate error message
	echo "usage: smb2win [-c] smb_path"
	if [ $# = 2 ] && [ $1 != "-c" ]; then
		printf "\tIncorrect optional flag: [-c] is the only available option flag, and is used to suppress copying output to clipboard" $warning
	elif [ $# -gt 2 ]; then
		printf "\tToo many input arguments detected, see correct usage above" $warning
	elif [ $# = 0 ]; then
		printf "\tNo arguments detected, see correct usage above" $warning
	fi
	printf "%s\n" $warning
fi