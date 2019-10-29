#!/usr/bin/perl

use warnings;
use strict;
use config;
use List::MoreUtils qw(uniq);

my $work_dir = $PEAKINTERSECTDIR;

my $o_file = "$work_dir/peak_intersect.txt";
my $result_dir = "$SCRIPTDIR/peak_intersect";

my $template = $PEAK_CENTER;

open (OUT, ">header");
print OUT "$template.peaks";
foreach my $k (uniq(values %SAMPLES_ANT)){
        if($k ne $template){
		print OUT "\t$k";
		if (! -f $o_file){
                        system("awk '{print \$4 \"\\t\" \$NF}' $work_dir/$k.peak_intersect.txt > $o_file");
	        } else {
                        system("awk '{print \$NF}' $work_dir/$k.peak_intersect.txt > tmp1; paste $o_file tmp1 > tmp2; mv tmp2 $o_file; rm tmp1");
		}
	}
}
print OUT "\n";
close OUT;

system("cat header $o_file > tmp3; mv tmp3 $o_file; rm header");

if (! -d $result_dir){
	system("mkdir $result_dir");
}

system("cp $o_file $result_dir");


