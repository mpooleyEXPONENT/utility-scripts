#!/bin/bash
#
# code_clipper.sh prints selected lines from source code files to PDF
# < WIP - currently the line numbers always start at 1, so when selecting the nth-mth line the line numbering is incorrect in the pdf unless n=1. >

# Define some defaults
NUM_LINES_PER_PAGE='70'
FROM_LINE='1'
TO_LINE='end'

#Parse inputs:
#
#   TODO - make input more robust, e.g., check required inputs are supplied and sensible
#
#   c = filename of code to parse
#   f = FROM_LINE
#   t = TO_LINE
#   n = NUM_LINES_PER_PAGE
while getopts "c:f:t:n:" opt; do
	case $opt in
		c ) # extract FILENAME
		FILENAME="$OPTARG"	
			;;
        f ) # extract FROM_LINE
        FROM_LINE="$OPTARG"
            ;;
        t ) # extract TO_LINE
        TO_LINE="$OPTARG"
            ;;
        n ) # extract NUM_LINES_PER_PAGE
        NUM_LINES_PER_PAGE="$OPTARG"
            ;;
	esac
done

#automatically detect pretty-print style sheet
STYLE_SHEET=$(a2ps --guess "$FILENAME" | sed -E -n 's/.*\((.*)\).*$/\1/p')

# clip and print the code!
#   awk is used to selet lines from FROM_LINE to TO_LINE, inclusive
#   a2ps is used to print the selected lines to postscript
#   ps2pdf converts the ps to pdf
awk "FNR==${FROM_LINE},FNR==${TO_LINE}" "$FILENAME" | a2ps -1 -gB -M letter --lines-per-page="$NUM_LINES_PER_PAGE" --left-title='' --right-title='' --center-title="$FILENAME" --pro='color' --pretty-print="$STYLE_SHEET" --line-numbers=1 -o- | ps2pdf - "${FILENAME%.*}.pdf"