#!/bin/bash
# 
#
# gsum.sh generates a list of cryptographic hash values for all files within the current directory.
# sha-256 sums are currently used. A time stamp is prepended to the output file based on the current system time.

# TODO: add command line arguments for path and algorithm
find . -type f -exec openssl sha256 "{}" + > $(date "+%y%m%d_%H%M%S_%Z")_checksums.txt

