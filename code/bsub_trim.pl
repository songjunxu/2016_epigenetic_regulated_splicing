#!/usr/bin/perl

use warnings;
use strict;
use config;

foreach my $k (keys %SAMPLES){
        trim($k);
}

sub trim{
        my ($f) = @_;
        my $data_id = $f;
        my $work_dir = $TRIMDIR;
        my $log_dir = "$work_dir/log";
        my $job_name = "$data_id.trim";

        #input/output
        my $in_file = $SAMPLES{$data_id};
	my $o_file = "$work_dir/$data_id.fastq.gz";

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
#BSUB -n 8,32
#BSUB -M 64400

source /etc/profile.d/modules.sh
module load $MODULES

#Trimmomatic-0.32
java -jar /opt/software/Trimmomatic/0.32/trimmomatic-0.32.jar SE -threads \$LSB_DJOB_NUMPROC -phred33 $in_file $o_file ILLUMINACLIP:/opt/software/Trimmomatic/0.32/adapters/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:3:3 MINLEN:30
";

	open(OUT, ">$batchFile");
        print OUT $batch_cmd;
        close OUT;

        print("bsub  < $batchFile\n");
	system("bsub < $batchFile");

        sleep(1);

}

