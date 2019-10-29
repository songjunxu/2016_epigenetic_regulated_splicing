#!/usr/bin/perl

use warnings;
use strict;
use config;

my $gnm_sizes = $GNM_SIZES;

foreach my $k (sort(keys %RNA_SAMPLES)){
        run($k);
}

sub run{
	my ($f) = @_;	
	my $data_id = $f;
	my $work_dir = $TRACKDIR;
	my $job_name = "$data_id.track";	

	my $in_dir = "$TRACKDIR/$data_id";

	my $o_file1 = "$work_dir/$data_id.norm.bedGraph";	
	my $o_file2 = "$work_dir/$data_id.norm.bigWig";

	my $log_dir = "$work_dir/log";	
	my $logOutFile = "$log_dir/$data_id.out";
	my $logErrFile = "$log_dir/$data_id.error";
	my $batchFile = "$log_dir/$data_id.batch";

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

makeUCSCfile $in_dir -norm 1e7 > $o_file1
bedGraphToBigWig $o_file1 $gnm_sizes $o_file2
";		

	open(OUT, ">$batchFile");
	print OUT $batch_cmd;
	close OUT;

	print("bsub  < $batchFile\n");
	system("bsub < $batchFile");	

	sleep(1);
}

