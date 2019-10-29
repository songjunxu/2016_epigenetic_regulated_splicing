#!/usr/bin/perl

use warnings;
use strict;
use config;

my $work_dir = $PEAKDIR;

my $o_file = "$SCRIPTDIR/summary_peak_calling.txt";

open (OUT, ">$o_file");
print OUT "Sample\tPeaks(FDR<0.05)\n";
foreach my $k (sort(keys %SAMPLES_CTL)){
	print OUT "$k\t";
	print OUT `wc -l $work_dir/$k\_peaks.narrowPeak | awk '{print \$1}'`;
}
close OUT;



