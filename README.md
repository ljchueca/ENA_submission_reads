# ENA_submission_reads

Code to submit individual raw data to the [European Nucleotide Archive (ENA)](https://www.ebi.ac.uk/ena/browser/home) from a population genomic study.
It is necessary an ENA account and credentials.

Disclaimer: These scripts work for us on our cluster, but there may be unforeseen idiosyncratic errors!

Neccesary tools
* Webin command line submission interface (Webin-CLI): (https://github.com/enasequence/webin-cli). Last version tested webin-cli-6.5.0.jar.
* Java 1.8 or a newer version (https://java.com/en/download/).
* Using Aspera Instead of FTP to Upload Files. In my case the FTP didn't work but with Aspera the submission was pretty good (https://www.ibm.com/products/aspera/downloads IBM Aspera Command Line Interface: ibm-aspera-cli-3.9.6.1467.159c5b1-linux-64-release.sh).

## STEP 1) Register data in ENA

* 1.1) Register a [Study](https://ena-docs.readthedocs.io/en/latest/submit/study/interactive.html)
* 1.2) Register [Samples](https://ena-docs.readthedocs.io/en/latest/submit/samples.html)
* 1.3) After samples registration, save the *SAMPLE* accession numbers and your *ALIAS* sample IDs in a plain text.
  <details><summary>EXAMPLE</summary>
  <p>
    
  ```
  C18_102_3 ERS15590137
  C18_102_4 ERS15590138
  C18_103_1 ERS15590139
  C18_103_5 ERS15590140
  C18_108_3 ERS15590141
  C18_108_4 ERS15590142
  C18_133_1 ERS15590143
  C18_133_2 ERS15590144
  C18_133_3 ERS15590145
  C18_019_3 ERS15590146  
  ```

## STEP 2) Create manifest files

* 2.1) `ENA_manifest_files.sh` Create the necessary manifest file for each sample in the directory where the reads are present.
* 2.2) Validate manifest files and reads. I usually only validate the submission of one sample. Be sure to include your username and password correctly within quotes.
  <details><summary>EXAMPLE</summary>
  <p>

  ```
  #!/bin/bash
  #SBATCH --job-name=ENA_validate
  #SBATCH --error %x-%j.err
  #SBATCH --output %x-%j.out

  #SBATCH --partition=tbg
  #SBATCH --mem=5G
  #SBATCH --cpus-per-task=1

  module load java/1.8.0_221

  java -Xms4G -jar /cluster/home/s_lchueca/programs/webin-cli-6.5.0.jar \
   -context=reads \
   -manifest=C18_133_1_manifest.txt \
   -username="Webin-USER-number" \
   -password="PASSWORD" \
   -inputdir=/home/user/documents/projects/raw_data/C18_133_1 \
   -outputdir=/home/user/documents/projects/raw_data/C18_133_1 \
   -validate

## STEP 3) Submit data to ENA

* 3.1) `ENA_submission_list.sh` Create a command list with the parameters for each submission (basically is the same than validation step but replacing -validate by -submit flag and including aspera option -ascp flag.
* 3.2) Submit all data in parallel
  <details><summary>EXAMPLE</summary>
  <p>

  ```
  #!/bin/bash

  #SBATCH --job-name=ENA_data_submission
  #SBATCH --error %x-%j.err
  #SBATCH --output %x-%j.out

  #SBATCH --partition=tbg
  #SBATCH --mem=4G
  #SBATCH --cpus-per-task=1
  #SBATCH --array=1-26%26

  module load java/1.8.0_221

  # Submit the files to ENA in parallel
  FILE=$(cat ENA_submission.list | sed -n ${SLURM_ARRAY_TASK_ID}p)
  bash -c "$FILE"
  ```
  
* 3.3) `ENA_save_accession_numbers.sh` Extract and save the *EXPERIMENT* and *RUN* accession numbers assigned after submission, together with their corresponding sample names.
 <details><summary>EXAMPLE</summary>
  <p>
    
  ```
  Alias           Experiment              Run
  C18_019_3       ERX10957573             ERR11553340
  C18_019_4       ERX10957565             ERR11553332
  C18_079_3       ERX10957545             ERR11553312
  C18_080_1       ERX10957562             ERR11553329
  C18_093_3       ERX10957548             ERR11553315
  C18_093_4       ERX10957570             ERR11553337
  C18_095_5       ERX10957553             ERR11553320
  C18_102_3       ERX10957557             ERR11553324
  C18_102_4       ERX10957556             ERR11553323
  C18_103_1       ERX10957566             ERR11553333 
  ```
