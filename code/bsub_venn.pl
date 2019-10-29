#!/usr/bin/perl

use warnings;
use strict;
use config;

my $work_dir = $PEAKMDIR;
my $job_name = "venn";
my $log_dir = "$work_dir/log";
my $batchFile = "$log_dir/$job_name.batch";
my $logOutFile = "$log_dir/$job_name.out";
my $logErrFile = "$log_dir/$job_name.error";

my $batch_cmd="
#!/bin/bash
#BSUB -P $Project_Name
#BSUB -J $job_name
#BSUB -o $logOutFile
#BSUB -e $logErrFile
#BSUB -q normal

source /etc/profile.d/modules.sh
module load $MODULES

cd $work_dir;
mergePeaks \*.narrowPeak -venn $work_dir/venn.txt
sed -i \"s|_peaks.narrowPeak||g\" venn.txt

cp venn.txt $SCRIPTDIR
";

open(OUT, ">$batchFile");
print OUT $batch_cmd;
close OUT;

print("bsub  < $batchFile\n");
system("bsub < $batchFile");	

