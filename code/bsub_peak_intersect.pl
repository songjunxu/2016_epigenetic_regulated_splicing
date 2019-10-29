#!/usr/bin/perl

use warnings;
use strict;
use config;
use List::MoreUtils qw(uniq);

my %mapping = %SAMPLES_ANT;
my $work_dir = $PEAKINTERSECTDIR;
my $template = "$PEAKMDIR/$PEAK_CENTER\_peaks.narrowPeak";

#run intersect for each sample except the template sample itself
foreach my $k (uniq(values %mapping)){
	if($k ne $template){
		run($k);
	}
}

sub run{
	my ($f) = @_;	
	my $data_id = $f;
	my $result_dir = "$SCRIPTDIR/peak_intersect";
	my $job_name = "$data_id.peak_intersect.$PEAK_CENTER";	

	my $in_file = "$PEAKMDIR/$data_id\_peaks.narrowPeak";

	my $o_file = "$work_dir/$data_id.peak_intersect.$PEAK_CENTER.txt";

	my $log_dir = "$work_dir/log";	
	my $logOutFile = "$log_dir/$data_id.$PEAK_CENTER.out";
	my $logErrFile = "$log_dir/$data_id.$PEAK_CENTER.error";
	my $batchFile = "$log_dir/$data_id.$PEAK_CENTER.batch";

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

bedtools intersect -c -a $in_file -b $template | sort -k4,4 > $o_file
";		

	open(OUT, ">$batchFile");
	print OUT $batch_cmd;
	close OUT;

	print("bsub  < $batchFile\n");
	system("bsub < $batchFile");	

	sleep(1);
}

