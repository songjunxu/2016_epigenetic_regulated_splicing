#!/usr/bin/perl

use warnings;
use strict;
use config;
use List::MoreUtils qw(uniq);

my $work_dir = $PEAKMDIR;
my %mapping = %SAMPLES_ANT;

foreach my $k (uniq(sort(values %mapping))){
	run($k);
}

sub run{
	my ($f) = @_;	
	my $data_id = $f;
	my $job_name = "$data_id.merge";

	my $in_files = ""; #pool together all replicates
	my @t = grep { $mapping{$_} eq $data_id } keys %mapping;
	foreach (@t){
		$in_files .= "$PEAKDIR/".$_."_peaks.narrowPeak ";
	};
	
	my $o_file = "$work_dir/$data_id"."_peaks.narrowPeak";

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
	
	my $batch_cmd="";
	if(scalar(@t)==1){
		$batch_cmd="
#!/bin/bash
#BSUB -P $Project_Name
#BSUB -J $job_name
#BSUB -o $logOutFile
#BSUB -e $logErrFile
#BSUB -q normal

source /etc/profile.d/modules.sh
module load $MODULES

cut -f1,2,3,4,5,6 $in_files > $o_file
";
	} else {
		$batch_cmd="
#!/bin/bash
#BSUB -P $Project_Name
#BSUB -J $job_name
#BSUB -o $logOutFile
#BSUB -e $logErrFile
#BSUB -q normal

source /etc/profile.d/modules.sh
module load $MODULES

mergePeaks $in_files | tail -n +2 > $o_file

#(optional) discard peaks in the merged file that are not showing up in more than one replicate
awk -F \"\\t\" \'{if(\$8>1)print \$0}\' $o_file > $o_file.tmp
mv $o_file.tmp $o_file

#change output column orders to be bed/narrowPeak
awk \'BEGIN {FS=\"\t\";OFS=\"\t\"} {print \$2,\$3,\$4,\$1,\$6,\$5}\' $o_file > $o_file.tmp
mv $o_file.tmp $o_file
";
	}

	open(OUT, ">$batchFile");
	print OUT $batch_cmd;
	close OUT;

	print("bsub  < $batchFile\n");
	system("bsub < $batchFile");	

	sleep(1);
}

