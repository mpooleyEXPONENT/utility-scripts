#!/bin/bash
#
#
# smb2win.sh converts a smb path into a windows path
# USAGE: smb2win [-c] smb_path
#		default behaviour prints the windows version of smb_path and copies this to clipboad
# 	e.g.: smb2win.sh "smb://path/directory/file.txt" prints "\\path\directory\file.txt" and copies this path to clipboard
#	optional flag -c suppresses output to clipboard

source utility_styles.sh
us_header "smb2win"
# define string transform operation
path_transform () {
	# path_transform() converts a smb path to a windows path
	# USAGE: path_transform input
	#		sets a variable "output" such that $output is the windows version of $input
	#	input must be a string
	#	output is a string
	input="$1"
	# remove "smb:" if it is included in the input path
	if [ "${input:0:3}" = "smb" ]; then
		input="${input:4}"
	fi
	output="${input//\//\\}" # replace all backslashes with forwardslashes
}

if [ $# = 2 ] && [ $1 = "-c" ]; then # if optional flag [-c] is supplied the output path is not copied to clipboard
	path_transform "$2"
	echo "$output"
elif [ $# = 1 ]; then # if optional flag is not supplied then the output path is copied to clipboard
	path_transform "$1"
	tput setaf 38; echo -n "$output" | tee >(pbcopy); tput sgr0 # -n flag needed to prevent linebreak being added to clipboard
	echo # echo to get newline in terminal
else # if input is not correct a usage message is displayed along with an appropriate error message
	us_note "Usage: smb2win [-c] smb_path"
	if [ $# = 2 ] && [ $1 != "-c" ]; then
		us_error "Incorrect optional flag or option flag passed in incorrect position: [-c] is the only available option flag, and is passed after the input path to suppress copying output to clipboard" 
	elif [ $# -gt 2 ]; then
		us_error "Too many input arguments detected, see correct usage above" 
	elif [ $# = 0 ]; then
		us_error "No arguments detected, see correct usage above" 
	fi
fi
us_end "smb2win"