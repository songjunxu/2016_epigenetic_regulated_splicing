#!/usr/bin/perl

use warnings;
use strict;
use config;
use List::MoreUtils qw(uniq);

my %mapping = %SAMPLES_TAG;

foreach my $k (uniq(sort(values %mapping))){
	run($k);
}

sub run{
	my ($f) = @_;	
	my $data_id = $f;
	my $work_dir = $TRACKDIR;
	my $job_name = "$data_id.track";	

	my $in_files = ""; #pool together all replicates
	my @t = grep { $mapping{$_} eq $data_id } keys %mapping;
	foreach (@t){
		$in_files .= "$BEDDIR/".$_.".bed ";
	};

	my $o_dir = "$work_dir/$data_id";

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

makeTagDirectory $o_dir $in_files
";		

	open(OUT, ">$batchFile");
	print OUT $batch_cmd;
	close OUT;

	print("bsub  < $batchFile\n");
	system("bsub < $batchFile");	

	sleep(1);
}

