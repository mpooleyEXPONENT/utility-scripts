#!/bin/bash
# Creates a new project folder with standard subfolders and places these in $projectFolder.
# NOTE: $projectFolder must be defined as an environmental variable, or line 10 should be edited to your choice of path.
#
# Usage: mkpdir.sh project_folder_name
#	e.g: mkpdir.sh "1234567.000 - project name" -> creates folder "1234567.000 - project name" in $projectFolder, within this newly created folder will be the standard subfolders


# USER CONFIGURABLE VARIABLES
path=$projectFolder # define target directory in which project folders will be placed (recomment setting this as an environmental variable, e.g. projectFolder)
# -----------------------------

s="$1" # grab user argument supplied with function call - this is the project folder name
dir=$(pwd) # grab initial directory
if [ $# = 1 ]; then	
	if [ -d "$path" ] # check if target root directory exists
	then
		if [ -d "$path/$s" ] #check if directory already exists
		then
			echo 'Project folder already exists'
		else
			cd $path # cd to projects folder (mkdir -p syntex is simpler from target directory)
			echo 'New project directory created:' $(pwd)'/'$s
			eval "mkdir -p '$s'/{'Work Product','Non-work Product','Contractual'}"
			cd "$dir" # return to initial directory
		fi
	else
		echo "Project directory" $path "does not exist"
	fi
else
	echo "~~~~~~~~ mkpdir: INPUT ERROR ~~~~~~~~"
	echo "Usage: mkpdir.sh project_folder_name"
	if [ $# = 0 ]; then
		echo "      Too few arguments: project_folder_name must be supplied"
	else
		echo "      Too many arguments: see usage message above"
	fi
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
fi