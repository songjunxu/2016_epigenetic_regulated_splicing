#!/usr/bin/perl

use warnings;
use strict;
use config;
use List::MoreUtils qw(uniq);

my $work_dir = $MOTIFDIR;
my %mapping = %SAMPLES_ANT;

foreach my $k (uniq(sort(values %mapping))){
	run($k);
}

sub run{
	my ($f) = @_;	
	my $data_id = $f;
	my $job_name = "$data_id.motif";

	my $in_file = "$PEAKMDIR/$data_id"."_peaks.narrowPeak";
	my $o_file = "$work_dir/$data_id";

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

source /etc/profile.d/modules.sh
module load $MODULES

findMotifsGenome.pl $in_file $SPECIES $o_file
";

	open(OUT, ">$batchFile");
	print OUT $batch_cmd;
	close OUT;

	print("bsub  < $batchFile\n");
	system("bsub < $batchFile");	

	sleep(1);
}

