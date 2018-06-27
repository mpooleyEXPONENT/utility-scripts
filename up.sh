#!/bin/bash
#
# Enables easy movement back "up" a directory tree
# 
# USAGE: 
#	This file must be SOURCED, i.e. use:
#		$ . up.sh
#	. up.sh -> moves up one directory level
#	. up.sh n -> moves up n directories
#	(NB: there is a ". " before the executable filename)
#	For convinience, consider placing a suitable alias in .bash_profile e.g.: alias up=". up.sh"
#
# EXAMPLES:
#	If $PWD=~/<Directory>/<subDirectory> then
#		. up.sh -> moves to ~/<Directory>
#		. up.sh 2 -> moves to ~/
cd .. # always move up at least one directory, even if no argument is passed
if [ $1 > 1 ] 
then
	for ((  i = 1 ;  i < $1;  i++  ))
	do
		cd ..
	done
fi
if [ $# -gt 1 ] # check for too many arguments and alert if appropriate (only the 1st argument is used)
then
	echo Warning: Too many arguments - $# arguments detected, those after 1st have been ignored
fi
