#!/usr/bin/perl

use warnings;
use strict;
use config;

my $work_dir = $BEDDIR;
my $blacklist= $BLACKLIST;
my $gnm_sizes = $GNM_SIZES;

foreach my $k (sort(keys %SAMPLES)){
	run($k);
}

sub run{
	my ($f) = @_;	
	my $data_id = $f;
	my $job_name = "$data_id.bed";	
	my $bam_file = "$ALIGNDIR/$data_id.qc.sort.bam";

	my $bam_file_rmdup = "$work_dir/$data_id.rmdup.bam";
	my $bed_file = "$work_dir/$data_id.tmp.bed";
	my $bed_file_final = "$work_dir/$data_id.bed";

	my $bam_file_final = "$work_dir/$data_id.bam";
	my $bam_file_final_bai = "$work_dir/$data_id.bam.bai";

	my $bedGraph_file = "$work_dir/$data_id.bedGraph";
	my $bigWig_file = "$work_dir/$data_id.bigWig";

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

# (optional) remove duplicate reads
samtools rmdup $bam_file $bam_file_rmdup

# convert bam to bed file
bedtools bamtobed -i $bam_file_rmdup > $bed_file
mv $bed_file $bed_file_final

# (optional) remove mitochondria reads
grep -v chrM $bed_file_final > $bed_file
mv $bed_file $bed_file_final

# (optional) remove reads in blacklist regions
bedtools intersect -v -a $bed_file_final -b $blacklist > $bed_file
mv $bed_file $bed_file_final

# convert bed back to bam file
bedToBam -i $bed_file_final -g $gnm_sizes > $bam_file_final
samtools sort $bam_file_final $bam_file_final.tmp
mv $bam_file_final.tmp.bam $bam_file_final
samtools index $bam_file_final $bam_file_final_bai

# (optional) create bedGraph and bigWig file
x=\$(wc -l $bed_file_final | awk '{print 10000000/\$i}')
eval \"bedtools genomecov -bg -scale \$x -i $bed_file_final -g $gnm_sizes > $bedGraph_file\"
bedGraphToBigWig $bedGraph_file $gnm_sizes $bigWig_file
";

	open(OUT, ">$batchFile");
	print OUT $batch_cmd;
	close OUT;

	print("bsub  < $batchFile\n");
	system("bsub < $batchFile");	

	sleep(1);
}

