#!/usr/bin/perl

use warnings;
use strict;
use config;

my $gnm_sizes = $GNM_SIZES;
my %mapping = %SAMPLES_TRKCTL;

my $in_files = "";
my $work_dir = $TRACKDIR;

foreach my $k (keys %mapping){
        $in_files .= "$work_dir/$k ";
}

my $job_name = "overlay_tracks";	

my $log_dir = "$work_dir/log";	
my $logOutFile = "$log_dir/$job_name.out";
my $logErrFile = "$log_dir/$job_name.error";
my $batchFile = "$log_dir/$job_name.batch";

if(! -d $work_dir){
	system("mkdir $work_dir");
}
if(! -d $log_dir){
	system("mkdir $log_dir");
}

my $batch_cmd="
#!/bin/bash
#BSUB -P $Project_Name
#BSUB -J $job_name
#BSUB -o $logOutFile
#BSUB -e $logErrFile
#BSUB -q normal
#BSUB -M 64400

source /etc/profile.d/modules.sh
module load $MODULES

cd $work_dir
makeMultiWigHub.pl overlay_tracks $SPECIES -url . -webdir . -norm 1e7 -d $in_files 
";		

open(OUT, ">$batchFile");
print OUT $batch_cmd;
close OUT;

print("bsub  < $batchFile\n");
system("bsub < $batchFile");	

