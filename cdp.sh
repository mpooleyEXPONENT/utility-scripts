#!/bin/bash
#
# cdp.sh helps to easily navigate to project folders.
# Default behavior assumes that a $projectFolder variable exists that contains the path to a directory in which all project folders are contained.
#   NOTE: this script needs to be sourced (i.e. called as . cpd.sh) - for convinience, consider using an alias e.g. alias cdp=". cdp.sh"
#
# USAGE: . cdp.sh [search_string [search_directory]]
#   search_string is a string that identifies the directory name within $projectFolder to which navigation is desired,
#       search_string does not need to be an exact match, it can be a sub-string of a project folder name.
#   search_directory is the directory in which to seek for search_string
#       default for search_directory is $projectFolder

if [ $# = 0 ]; then
    cd "$projectFolder"

elif [ $# = 1 ]; then   
	cd "$projectFolder/$(ls $projectFolder | grep "$1")"
elif [ $# = 2 ]; then
    cd ""$2"/$(ls "$2" | grep "$1")"
else
    echo "Usage: . cdp [search_string [search_directory]]"
    echo "        search_string is a substring within the desired folder's name"
    echo "        search_directory is the directory in which to search (default is $projectFolder)"
    echo "        call without any arguments to navigate to $projectFolder)"
fi



