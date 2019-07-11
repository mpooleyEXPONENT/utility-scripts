#!/bin/bash
#
# tf.sh -- copies files to a remove directory stored in an environmental veriable $transferFolder
#
# USAGE: tf.sh source_file [target_subdirectory]
#           source_file is the local file to be copied to $transferFolder
#           target_subdirectory is an optional argument that enables copying to a subdirectory within $transferFolder.
#
#               e.g.: tf.sh <filename> <subdirectory> -> copes file <filename> to $transferFolder/<subdirectory>

mntPath="/Volumes/${transferFolder##*/}" # define path to be mounted in /Volumnes/, this is the final directory of $transferFolder

# prevent multiple mountpoint to identical locations.
if [ -d "$mntPath" ] 
then
    echo $transferFolder already mounted as $mntPath, performing unmount prior to reopening tranfer drive as a network location:
    echo $ umount $mntPath
    umount "$mntPath"
fi

# mount $transferFolder in /Volumes/ for later reference by cp
open smb://$USER:$(security find-generic-password -a ${USER} -w)@"$transferFolder" # use security API to access keychain
echo Mounting $transferFolder as $mntPath

# check whether mounting is complete, and wait for mounting to finish if required
while [ ! -d "$mntPath" ] # wait while mounting is performed
do 
    sleep 10
done

# Parse inputs to construct source_file and target_directory for cp
if [ $# == 2 ]
then
    destination="$mntPath/$2" 
    transferFolderStr="$transferFolder/$2"  
    if [ ! -d "$destination" ] # make the desintation subdirectory if required
    then
        mkdir "$destination" 
    fi
elif [ $# == 1 ]
then
    destination="$mntPath" 
    transferFolderStr="$transferFolder"
fi

# Transfer the file if mounting of transfer folder was successful and $destination is available
if [ -d "$destination" ]
then
    echo copying $1 to $transferFolderStr
    cp "$1" "$destination" # copy file to destination
elif [ loopEscape == 20 ]
then
    echo Error: timeout during mounting $mntPath
else
    echo Error: file transfer unsuccessful
fi