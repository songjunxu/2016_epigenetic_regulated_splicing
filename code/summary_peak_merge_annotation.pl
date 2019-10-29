#!/usr/bin/perl

use warnings;
use strict;
use config;

my $work_dir = $PEAKMANNODIR;
my $log_dir = "$work_dir/log";
my $result_dir = "$SCRIPTDIR/peak_merge_annotation";

my $job_name = "summary_peak_merge_annotation";

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

cd $work_dir
R --no-save < $CODEDIR/R_scripts/peak_annotation.R
cp $work_dir/*.pdf $result_dir
";		

open(OUT, ">$batchFile");
print OUT $batch_cmd;
close OUT;

print("bsub  < $batchFile\n");
system("bsub < $batchFile");	


