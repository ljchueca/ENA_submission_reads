#!/bin/bash
#
# Script to extract and save experiment and run accession numbers after ENA data submission
# Author: Luis J. Chueca
#
# Find a common pattern for all reads directories (at the beginning, if not check the first part of the loop). Should be the same used in ENA_submission_list.sh
#
# usage:    ./ENA_save_accession_numbers.sh  pattern
# e.g.:     ./ENA_save_accession_numbers.sh  C18

echo -e "Alias\tExperiment\tRun" > accession_numbers_ENA.txt

for i in $(find -maxdepth 1 -name "$1*" | sed 's/.\///'); do
  echo -n "$i"   # Print the value of i without a newline
  cd "$i"

  # Extract the first number using grep and store it in a variable
  first=$(grep -oP '(?<=experiment accession was assigned to the submission: )[^ ]*' webin-cli.report | tr '\n' '\t')

  # Extract the second number using grep and store it in a variable
  second=$(grep -oP '(?<=run accession was assigned to the submission: )[^ ]*' webin-cli.report | tr '\n' '\t')

  # Print the values of the variables with a tab separator
  echo -e "\t$first\t$second"

  cd ..
done >> accession_numbers_ENA.txt