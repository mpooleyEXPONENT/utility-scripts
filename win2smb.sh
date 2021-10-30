#!/bin/bash
#
#
# win2smb.sh converts a windows path into a smb path
# USAGE: win2smb [-c] win_path
#		default behaviour prints the smb version of win_path and copies this to clipboad
# 	e.g.: win2smb.sh "\\path\directory\file.txt" prints "smb://path/directory/file.txt" and copies this path to clipboard
#	optional flag -c suppresses output to clipboard
source utility_styles.sh
us_header "win2smb"
# define string transform operation
path_transform () {
	# path_transform() converts a windows path to a smb path
	# USAGE: path_transform input
	#		sets a variable "output" such that $output is the smb version of $input
	#	input must be a string
	#	output is a string
	input="$1"
	# add "smb:" to the input path
	if [ "${input:0:3}" != "smb" ]; then
		input="smb:${input}"
	fi
	output="${input//\\//}" # replace all forwardslashes with backslashes
}

if [ $# = 2 ] && [ $1 = "-c" ]; then # if optional flag [-c] is supplied the output path is not copied to clipboard
	path_transform "$2"
	tput setaf 38; echo "$output"; tput sgr0 
elif [ $# = 1 ]; then # if optional flag is not supplied then the output path is copied to clipboard
	path_transform "$1"
	tput setaf 38; echo -n "$output" | tee >(pbcopy); tput sgr0 # -n flag needed to prevent linebreak being added to clipboard
	echo # echo to get newline in terminal
else # if input is not correct a usage message is displayed along with an appropriate error message
	us_note "Usage: win2smb [-c] win_path"
	if [ $# = 2 ] && [ $1 != "-c" ]; then
		us_error "Incorrect optional flag or option flag passed in incorrect position: [-c] is the only available option flag, and is passed after the input path to suppress copying output to clipboard" 
	elif [ $# -gt 2 ]; then
		us_error "Too many input arguments detected, see correct usage above" 
	elif [ $# = 0 ]; then
		us_error "No arguments detected, see correct usage above" 
	fi
fi
us_end "win2smb"