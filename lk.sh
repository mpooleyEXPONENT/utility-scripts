#!/bin/bash
#
#
# lk.sh helps navigate to remote network locations, and interact with files at these locations.
# A Windows format link is assumed, but MacOS links may resolve correctly if "smb:" is omited from the beginning (untested).
# USAGE:
# lk.sh -<OPTION (-l, -o, or -c)> <ARG1(required)> <ARG2(only applicable to -c option)>:
#
#		Option -l navigates to a link:
#		lk.sh -l $PATH. E.G.: lk.sh -l "//<networkPath>/<directory>" navigates <directory> at <networkPath>.
#			$PATH is the path, in Windows format, to either a directory or a file on a server. If a file is used, lk.sh opens the directory that holds the file.	
#
#		Option -o opens a file:
#		lk.sh -o $PATH. E.G.: lk.sh -o "//<server>/<sharedFolder>/<exampleFile>" opens <exampleFile> in <sharedFolder> on network storage <server>
#			$PATH is the path, in Windows format, to a file on a server. If only a directory is supplied, this is opened in finder.
#		
#		Option -c copies a file to a local location
#		lk.sh -c $PATH $DESINATION. E.G.: lk.sh -c "//<server>/<sharedFolder>/<exampleFile>" "<localFolder>" copies <exampleFile> to the local machine at <localFolder>
#			$PATH is the path, in Windows format, to a file on a server. If only a directory is supplied this will cause problems.
#			$DESTINATION is the local directory into which the copy should be placed. If no $DESTINATION is supplied, the default "~/Downloads" is used.
#
while getopts "o:l:c:" opt; do
	case $opt in
		l ) # Navigate Finder to a target network directory
			input=$OPTARG
			output=${input//\\//} # replace all backslashes with forwardslashes
			while [ ${output:0:1} == "/" ]; do # remove any '/' from the start of the input string
				output=${output:1}
			done

			mntPath=/Volumes/${output##*/} # construct path to file via mountpoint in /Volumnes/
			if [ -d "$mntPath" ] # prevent multiple mountpoint to identical locations
			then
				echo Location already mounted, performing umount prior to following link:
				echo $ umount $mntPath
				umount "$mntPath"
			fi
				echo Navigating to: $output # display target location in terminal
				open smb://$USER:$(security find-generic-password -a ${USER} -w)@"$output" # "follow" the link!
				echo Mounted $output as $mntPath
			;;
		o ) # Open target file
			input=$OPTARG
			output=${input//\\//} # replace all backslashes with forwardslashes
			while [ ${output:0:1} == "/" ]; do # remove any '/' from the start of the input string
				output=${output:1}
			done

			mntPath=/Volumes/${output##*/} # construct path to file via mountpoint in /Volumnes/
			if [ -d "$mntPath" ] # prevent multiple mountpoint to identical locations
			then
				echo Location already mounted, performing umount prior to following link:
				echo $ umount $mntPath
				umount "$mntPath"
			fi
				echo Opening: $output # display target location in terminal
				open smb://$USER:$(security find-generic-password -a ${USER} -w)@"$output" # "follow" the link!
				while [ ! -d "$mntPath" ]; do # wait for mount to complete
    				sleep 10
				done
				filePath=$mntPath/${output##*/} # construct path to file beyond mountpoint
				open "$filePath" # open file on local machine using default program for filetype
				echo Mounted $output as $mntPath
			;;
		c ) # copy file to local machine
			input=$OPTARG
			output=${input//\\//} # replace all backslashes with forwardslashes
			while [ ${output:0:1} == "/" ]; do # remove any '/' from the start of the input string
				output=${output:1}
			done

			mntPath=/Volumes/${output##*/} # construct path to file via mountpoint in /Volumnes/
			if [ -d "$mntPath" ] # prevent multiple mountpoint to identical locations
			then
				echo Location already mounted, performing umount prior to following link:
				echo $ umount $mntPath
				umount "$mntPath"
			fi
				open smb://$USER:$(security find-generic-password -a ${USER} -w)@"$output" # "follow" the link!
				while [ ! -d "$mntPath" ]; do # wait for mount to complete
    				sleep 10
				done
				filePath=$mntPath/${output##*/} # construct path to file beyond mountpoint
				
				if [ $# == 2 ] # check for number of arguments to see if a destination path is provided
				then
					destination=/Users/$USER/Downloads #default if no destination is provided
				elif [ $# == 3 ]
				then
					destination=$3
				fi
				cp "$filePath" "$destination" # copy file to destination
				echo Copying: $output to $destination: # display target location in terminal
				echo Mounted $output as $mntPath
				echo $ cp $filePath $destination
			;;
	esac
done