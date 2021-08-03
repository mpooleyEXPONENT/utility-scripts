#!/bin/bash
# 
# gsum.sh generates a list of cryptographic hash values for all files within the current directory.
# A time stamp is prepended to the output file based on the current system time.
# Default behavior is to create hash values using SHA256 for all files within the current directory, saving the output to a timestamped .txt file within the same directory
#
# Usage: gsum.sh [-s source_directory] [-d destination_directory] [-a algorithm] [-f filename_label] [-v] [-t|c]
#   -v verbose flag for printing checksum output
#   -t generates a tab delimited version of the checksum file output
#   -c generates a comma delimited version of the checksum file output
#       if both -t and -c are passed, only the first of these inputs is parsed

source utility_styles.sh

us_header "gsum"
timeStamp=$(date "+%y%m%d_%H%M%S_%Z") # generate a single timestamp for use throughout entire script
commandStr=$(printf 'find . -type f -exec openssl sha256 '{}' + > %s_checksums.txt' "$timeStamp")
# modify commandStr with supplied optional parameters
tabulatedFLAG=false # indicates whether or not a tabulatedFLAG has been set
while getopts "s:a:d:f:vtc" opt; do
	case $opt in
		s ) # specify source directory
		commandStr=${commandStr/./"$OPTARG"}	
			;;
        a ) # specify algorithm
        commandStr=${commandStr/ openssl sha256 / openssl "$OPTARG" }
            ;;
        d ) # specify distination directory
        commandStr=${commandStr/> $timeStamp/> "$OPTARG"/$timeStamp}
            ;;
        f ) # specify filename for output
        commandStr=${commandStr/$timeStamp_checksums.txt/$timeStamp_"$OPTARG"}
            ;;
        v ) # specify verbose output
        verboseFLAG=true 
            ;;
        t ) # tabulated output desired (tab delimited)
        if [ $tabulatedFLAG = false ]; then # if a tabulateFLAG isn't already set
            tabulatedTabFLAG=true # set flag to control subsequent logic
            tabulatedFLAG=true # set tabulatedFLAG
        else
            us_warning "-t argument has been ignored"
        fi
            ;;
        c ) # tabulated output desired (comma delimited)
        if [ $tabulatedFLAG = false ]; then    
            tabulatedCommaFLAG=true # set flag to control subsequent logic
            tabulatedFLAG=true # set tabulatedFLAG
        else
            us_warning "-c argument has been ignored"
        fi
            ;;
	esac
done

eval $commandStr
us_success "executed: $commandStr"

if [ $verboseFLAG ] && [ $tabulatedFLAG = false ]; then
    tput setaf 38; column -t -s "= " "${commandStr##*> }"; tput sgr0
fi

if [ $tabulatedTabFLAG ]; then # if tab delimited table requested
    fileToTabulate=${commandStr##*> } # select only the output filename from commandStr by removing everything before and including "> "
    gsum_tabulate "$fileToTabulate"
    us_success "executed: gsum_tabulate '$fileToTabulate'"
    if [ $verboseFLAG ]; then
        tput setaf 38; column -t "tabulated_""${commandStr##*> }"; tput sgr0
    fi
fi
if [ $tabulatedCommaFLAG ]; then # if comma delimited table requested
    fileToTabulate=${commandStr##*> } # select only the output filename from commandStr by removing everything before and including "> "
    gsum_tabulate "$fileToTabulate" ","
    us_success "executed: gsum_tabulate '$fileToTabulate' ','"
    if [ $verboseFLAG ]; then
        tput setaf 38; column -t -s "," "tabulated_""${commandStr##*> }"; tput sgr0
    fi
fi
us_end "gsum"