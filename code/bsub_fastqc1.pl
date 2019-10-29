#!/usr/bin/perl

use warnings;
use strict;
use config;

foreach my $k (keys %SAMPLES){
        fastqc($k);
}

sub fastqc{
        my ($f) = @_;
        my $data_id = $f;
        my $work_dir = $QCDIR1;
        my $log_dir = "$work_dir/log";
        my $job_name = "$data_id.fastqc1";

        #input/output
        my $in_file = $SAMPLES{$data_id};

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

source /etc/profile.d/modules.sh
module load $MODULES

fastqc -o $work_dir --extract $in_file
";

	open(OUT, ">$batchFile");
        print OUT $batch_cmd;
        close OUT;

        print("bsub  < $batchFile\n");
	system("bsub < $batchFile");

        sleep(1);

}

