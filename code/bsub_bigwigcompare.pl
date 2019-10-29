#!/usr/bin/perl

use warnings;
use strict;
use config;

my %mapping = %SAMPLES_CTL;

foreach my $k (keys %mapping){
	run($k);
}

sub run{
	my ($f) = @_;	
	my $data_id = $f;
	my $work_dir = $BEDDIR;
	my $job_name = "$data_id.bigwigcompare";	

	my $in_file1 = "$BEDDIR/$data_id.bigWig";
	my $in_file2 = "$BEDDIR/$mapping{$data_id}.bigWig";

	my $o_file = "$work_dir/$data_id"."-".$mapping{$data_id}.".bigWig";

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
#BSUB -n 4,32

source /etc/profile.d/modules.sh
module load $MODULES

bigwigCompare -b1 $in_file1 -b2 $in_file2 --ratio=subtract --binSize=1 --skipNonCoveredRegions -p \$LSB_DJOB_NUMPROC -o $o_file

";		

	open(OUT, ">$batchFile");
	print OUT $batch_cmd;
	close OUT;

	print("bsub  < $batchFile\n");
	system("bsub < $batchFile");	

	sleep(1);
}

