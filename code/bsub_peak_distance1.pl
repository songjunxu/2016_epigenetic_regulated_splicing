#!/usr/bin/perl

use warnings;
use strict;
use config;
use List::MoreUtils qw(uniq);

my $work_dir = $PEAKDISTDIR."_".$PEAK_CENTER;

my $in_file = "$PEAKMDIR/$PEAK_CENTER\_peaks.narrowPeak";

my $in_files = "";
foreach my $k (uniq(values %SAMPLES_TAG)){
        $in_files .= "$TRACKDIR/$k ";
}

my $o_file = "$work_dir/peak_distance.txt";

my $job_name = "peak_distance";

my $log_dir = "$work_dir/log";	
my $logOutFile = "$log_dir/$job_name.out";
my $logErrFile = "$log_dir/$job_name.error";
my $batchFile = "$log_dir/$job_name.batch";

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

annotatePeaks.pl $in_file $SPECIES -size 1500 -d $in_files -hist 10 > $o_file

sed -i \"s|$TRACKDIR/||g\" $o_file
awk -F \"\t\" '{for(i=1;i<=NF;i++){if(i==1||i%3==2) printf \$i \"\t\"} print \"\"}' $o_file | sed \"s| Coverage||g\" > tmp
mv tmp $o_file
";		

open(OUT, ">$batchFile");
print OUT $batch_cmd;
close OUT;

print("bsub  < $batchFile\n");
system("bsub < $batchFile");	

