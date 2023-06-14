#!/bin/bash
#
# Script to create the manifest file for multiple individuals
# Author: Luis J. Chueca
#
# Modify reads information accordingly to your data
# FILE.txt has to be a two column file with sample alias in column 1 and ENA accession number in column 2
#
# usage:    ./ENA_manifest_files.sh FILE.txt STUDY_NUMBER
# e.g.:     ./ENA_manifest_files.sh sample_name_ids.txt PRJEB43841
#


while read i b; do
  echo "i is $i, b is $b"

 # Provide necessary information on how reads were obtained (see https://ena-docs.readthedocs.io/en/latest/submit/reads/webin-cli.html)
 #INSTRUMENT
 INS="Illumina NovaSeq 6000"
 #INSERT_SIZE
 ISZ="300"
 #LIBRARY_SOURCE
 LSC="GENOMIC"
 #LIBRARY_SELECTION
 LST="RANDOM"
 #LIBRARY_STRATEGY
 LSG="WGS"

 echo "STUDY $2" > "${i}_manifest.txt"
 echo "SAMPLE ${b}" >> "${i}_manifest.txt"
 echo "NAME ${i}" >> "${i}_manifest.txt"
 echo "INSTRUMENT ${INS}" >> "${i}_manifest.txt"
 echo "INSERT_SIZE ${ISZ}" >> "${i}_manifest.txt"
 echo "LIBRARY_SOURCE ${LSC}" >> "${i}_manifest.txt"
 echo "LIBRARY_SELECTION ${LST}" >> "${i}_manifest.txt"
 echo "LIBRARY_STRATEGY ${LSG}" >> "${i}_manifest.txt"

  # Go into directory and loop over files ending with fq.gz
  cd "$i"
  for file in *fq.gz; do
    echo "FASTQ $(basename "$file")" >> "../${i}_manifest.txt"
  done
  cd ..

  # Move the generated manifest file to the respective directory
  mv "${i}_manifest.txt" "${i}/"

done < $1 > "$2"_stdout.log 2> "$2"_stderr.log