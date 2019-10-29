#!/usr/bin/perl

use warnings;
use strict;
use config;

my $trimdir = $DATADIR;

foreach my $k (keys %SAMPLES){
	run($k);
}

sub run{
	my ($f) = @_;	
	my $data_id = $f;
	my $work_dir = $ALIGNDIR;
	my $job_name = "$data_id.align";

	my $in_file = "$trimdir/$data_id.fastq.gz";

	my $output_prefix = "$work_dir/$data_id";	
	my $output_sam = $output_prefix.".sam";

	my $output_bam = $output_prefix.".bam";
	my $output_bam_bai = $output_prefix.".bam.bai";
	my $output_bam_stat1 = $output_prefix.".flagstat.txt";
	my $output_bam_stat2 = $output_prefix.".idxstat.txt";

	my $output_bam_qc = $output_prefix.".qc.sort.bam";
	my $output_bam_qc_bai = $output_prefix.".qc.sort.bam.bai";
	
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
#BSUB -n 8,32
#BSUB -M 64400

source /etc/profile.d/modules.sh
module load $MODULES

#align using Bowtie2 (output sam file), which by default returns the best MAPQ alignment when there are multiple alignments
/project/ibilab/tools/bowtie2-2.2.9/bowtie2 -p \$LSB_DJOB_NUMPROC -N 1 --$PHRED -x $GNM_IDX -U $in_file -S $output_sam 

#convert sam files to bam files, sort and index
samtools view -h -bS $output_sam > $output_bam
samtools sort $output_bam $output_prefix.sort
mv $output_prefix.sort.bam $output_bam
samtools index $output_bam $output_bam_bai

#get alignment stats
samtools flagstat $output_bam > $output_bam_stat1
samtools idxstats $output_bam > $output_bam_stat2

#filtering on unmapped and QMap<=10 reads
samtools view -h -F 4 -q 10 -b $output_bam > $output_bam_qc
samtools index $output_bam_qc $output_bam_qc_bai
";		

	open(OUT, ">$batchFile");
	print OUT $batch_cmd;
	close OUT;

	print("bsub  < $batchFile\n");
	system("bsub < $batchFile");	

	sleep(1);
}

