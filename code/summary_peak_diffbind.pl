#!/usr/bin/perl

use warnings;
use strict;
use config;

my $work_dir = $PEAKDIR;
my $log_dir = "$work_dir/log";
my $result_dir = $SCRIPTDIR;

my $job_name = "summary_peak_diffbind";

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
R --no-save < $CODEDIR/R_scripts/peak_diffbind.R
mv $work_dir/summary_peak_diffbind.pdf $result_dir
rm $work_dir/summary_peak_diffbind.txt
";		

open(OUT, ">$batchFile");
print OUT $batch_cmd;
close OUT;

print("bsub  < $batchFile\n");
system("bsub < $batchFile");	


