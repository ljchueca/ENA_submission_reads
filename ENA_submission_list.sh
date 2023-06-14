#!/bin/bash
#
# Script to create a command list to submit reads in parallel
# Author: Luis J. Chueca
#
# Use your ENA's credentials
# Check the path to the webin-cli version you want to use
# Find a common pattern for all reads directories (at the beginning, if not check the first part of the loop)
#
# usage:    ./ENA_submission_list.sh username password pattern
# e.g.:     ./ENA_submission_list.sh Webin-43890 qwerty C18


#Path to webin-cli software
WEBIN=/cluster/home/s_lchueca/programs/webin-cli-6.5.0.jar

for i in $(find -maxdepth 1 -name "$3*" | sed 's/.\///'); do echo "cd ${i} && java -Xms4G -jar ${WEBIN} -context=reads -manifest=${i}_manifest.txt -username=\""$1"\" -password=\""$2"\" -inputdir=$(pwd)/${i} -outputdir=$(pwd)/${i} -submit -ascp  && cd .."; done > ENA_submission.list