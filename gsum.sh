#!/bin/bash
# 
#
# gsum.sh generates a list of cryptographic hash values for all files within the current directory.
# A time stamp is prepended to the output file based on the current system time.
# Default behavior is to create hash values using SHA256 for all files within the current directory, saving the output to a timestamped .txt file within the same directory
#
# USAGE: gsum.sh [-s source_directory] [-d destination_directory] [-a algorithm] [-f filename_label]
commandStr="find . -type f -exec openssl sha256 '{}' + > $(date "+%y%m%d_%H%M%S_%Z")_checksums.txt"
# modify commandStr with supplied optional parameters
while getopts "s:a:d:f:" opt; do
	case $opt in
		s ) # specify source directory
		commandStr=${commandStr/./"$OPTARG"}	
			;;
        a ) # specify algorithm
        commandStr=${commandStr/ openssl sha256 / openssl "$OPTARG" }
            ;;
        d ) # specify distination directory
        commandStr=${commandStr/> $(date "+%y%m%d_%H%M%S_%Z")/> "$OPTARG"/$(date "+%y%m%d_%H%M%S_%Z")}
            ;;
        f ) # specify filename for output
        commandStr=${commandStr/$(date "+%y%m%d_%H%M%S_%Z")_checksums.txt/$(date "+%y%m%d_%H%M%S_%Z")_"$OPTARG"}
            ;;
	esac
done
eval $commandStr
echo $commandStr