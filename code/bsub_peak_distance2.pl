#!/usr/bin/perl

use warnings;
use strict;
use config;
use List::MoreUtils qw(uniq);

my $work_dir = $PEAKDISTDIR.".".$PEAK_CENTER;
my %mapping = %SAMPLES_TAG;

foreach my $k (uniq(values %mapping)){
	run($k);
}

sub run{
	my ($f) = @_;	
	my $data_id = $f;
	my $job_name = "$data_id.peak_distance";

	my $in_file1 = "$PEAKDIFFDIR/peak_diff.$PEAK_CENTER.txt";
	my $in_file2 = "$TRACKDIR/$data_id";

	my $o_file = "$work_dir/$data_id.heatmap.txt";

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

annotatePeaks.pl $in_file1 $SPECIES -size 4000 -d $in_file2 -hist 10 -ghist > $o_file
";		

	open(OUT, ">$batchFile");
	print OUT $batch_cmd;
	close OUT;

	print("bsub  < $batchFile\n");
	system("bsub < $batchFile");	

	sleep(1);
}
