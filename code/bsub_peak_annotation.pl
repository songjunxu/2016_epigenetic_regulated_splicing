#!/usr/bin/perl

use warnings;
use strict;
use config;

my %mapping = %SAMPLES_CTL;
my $species = $SPECIES;

foreach my $k (keys %mapping){
	run($k);
}

sub run{
	my ($f) = @_;	
	my $data_id = $f;
	my $work_dir = $PEAKANNODIR;
	my $result_dir = "$SCRIPTDIR/peak_annotation";
	my $job_name = "$data_id.peak_annotation";	

	my $in_file = "$PEAKDIR/$data_id\_peaks.narrowPeak";

	my $o_file = "$work_dir/$data_id.peak_annotation.txt";

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
	if(! -d $result_dir){
                system("mkdir $result_dir");
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

annotatePeaks.pl $in_file $species > $o_file

cp $o_file $result_dir
";		

	open(OUT, ">$batchFile");
	print OUT $batch_cmd;
	close OUT;

	print("bsub  < $batchFile\n");
	system("bsub < $batchFile");	

	sleep(1);
}

