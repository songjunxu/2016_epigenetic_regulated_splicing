#!/usr/bin/perl

use warnings;
use strict;
use config;

my %raw_stat;
my %label = (
	1 => "raw reads",
	2 => "unpaired reads",
	3 => "aligned 0 times",
	4 => "aligned 1 time",
	5 => "aligned >1 times",
);
my $base_idx = 1; #the $base_idx of label is used to calculate ratio
my $label_base = 5;
my $label_total = 5; 

foreach my $k (sort(keys %SAMPLES)){
	run($k);
}

open (OUT, ">$SCRIPTDIR/summary_alignment.txt");
print OUT "Sample";
foreach my $k (sort(keys %SAMPLES)){
	print OUT "\t$k\t$k.ratio";
}
print OUT "\n";

for(my $i=1; $i<=$label_total; $i++){
	print OUT $label{$i};
	foreach my $k (sort(keys %SAMPLES)){
		print OUT "\t",$raw_stat{$i}{$k},"\t",int($raw_stat{$i}{$k}/$raw_stat{$base_idx}{$k}*1000)/1000*100,"%";
	}
	print OUT "\n";
}
close OUT;

sub run{
	my ($f) = @_;	
	my $data_id = $f;
        my $logfile = "$ALIGNDIR/log/$data_id.error";
	my $idxstatfile = "$ALIGNDIR/$data_id.idxstat.txt";

	my $idx = 1;

	open(IN, $logfile) or die "can not open file $logfile\n";
	while(defined(my $line = <IN>) && $idx<=$label_base){
		chomp $line;
		my @t = split('\s+',trim($line));
		$raw_stat{$idx}{$data_id} = $t[0];
		$idx++;
	}
	close IN;

	open(IN, $idxstatfile) or die "can not open file $idxstatfile\n";
        while(my $line = <IN>){
                chomp $line;
                my @t = split('\s+', $line);
                if(!$label{$idx}){
                        $label{$idx} = $t[0];
			$label_total = $idx;
                }
                $raw_stat{$idx}{$data_id} = $t[2];
		$idx++;
        }
        close IN;
}
# remove leading and trailing spaces
sub trim{
	my $s = shift;
	$s =~ s/^\s+|\s+$//g;
	return $s;
}
