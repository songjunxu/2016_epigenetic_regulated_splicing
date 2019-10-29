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
	my $work_dir = $PEAKDIR;
	my $job_name = "$data_id.peak_calling";	

	my $in_file1 = "$BEDDIR/$data_id.bed";

	my $in_file2 = ""; #pool together all controls if applicable
	my @t = split('\s+', $mapping{$data_id});
	foreach (@t){
		$in_file2 .= "$BEDDIR/".$_.".bed ";
	};

	my $output_prefix = "$work_dir/$data_id";
	my $output_rfile = "$output_prefix"."_model.r";

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

#peak calling using MACS (v2.1.0)
macs-2.1.0 callpeak -t $in_file1 -c $in_file2 -f BED -g $genome_size_for_macs --outdir $work_dir -n $data_id --qvalue 0.05

cd $work_dir
R --no-save < $output_rfile
";		

	open(OUT, ">$batchFile");
	print OUT $batch_cmd;
	close OUT;

	print("bsub  < $batchFile\n");
	system("bsub < $batchFile");	

	sleep(1);
}

