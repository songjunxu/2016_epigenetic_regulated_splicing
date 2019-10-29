#/usr/bin/perl

package config; 

use strict;
use warnings;

use Exporter;
our @ISA = 'Exporter';
our @EXPORT = qw(
	$Project_Name $SPECIES $ALIGNER $RNA $RNA_ALIGNER $PHRED $genome_size_for_macs $BLACKLIST $PEAK_CENTER $WORKDIR $CODEDIR $SCRIPTDIR $DATADIR
	$QCDIR1 $TRIMDIR $QCDIR2 $ALIGNDIR $BEDDIR $PEAKDIR $PEAKANNODIR $PEAKMDIR $PEAKMANNODIR $MOTIFDIR $PEAKDIFFDIR $PEAKDISTDIR $PEAKINTERSECTDIR $TRACKDIR
	$RNA_QCDIR1 $RNA_TRIMDIR $RNA_QCDIR2 $RNA_ALIGNDIR $RNA_HTSEQDIR
	$GNM_IDX $RNA_GNM_IDX $GNM_GTF $GNM_BED12 $GNM_SIZES
	$MODULES $TRIMMO_JAR $PICARD_DIR
	$RAW_DATA_SUFFIX %SAMPLES %SAMPLES_CTL %SAMPLES_ANT %SAMPLES_TAG %SAMPLES_TRKCTL);

##### change for each projet ########################################
our $Project_Name = "Elizabeth_Heller_ShenDataset_Qiwen_2016_8";
our $SPECIES = "mm9";
our $ALIGNER = "bowtie2"; #aligner for ChIP-seq data
our $RNA = 0; #boolean 0/1 flag to indicate if there is supplementary RNA-seq data 
our $RNA_ALIGNER = "star"; #aligner for RNA-seq data, choose from "star/tophat2"
our $PHRED = "phred33";
our $BLACKLIST = "/project/ibilab/library/blacklist/$SPECIES-blacklist.bed";

our $genome_size_for_macs = "hs"; #'hs' for human, 'mm' for mouse, 'ce' for C. elegans and 'dm' for fruitfly
our $PEAK_CENTER = "cluster8";        #one of the samples, the distance to its peak center will be computed for all samples 

##### set up work directory #########################################
our $WORKDIR = "/project/ibilab/projects/$Project_Name/large_data";
our $CODEDIR = "/project/ibilab/projects/$Project_Name/$Project_Name/code";
our $SCRIPTDIR = "/project/ibilab/projects/$Project_Name/$Project_Name/data";

our $DATADIR = $WORKDIR."/raw_data";
our $QCDIR1 = $WORKDIR."/fastqc1";
our $TRIMDIR = $WORKDIR."/trim";
our $QCDIR2 = $WORKDIR."/fastqc2";
our $ALIGNDIR = $WORKDIR."/alignment";
our $BEDDIR = $WORKDIR."/bed";
our $PEAKDIR = $WORKDIR."/peak_calling";
our $PEAKANNODIR = $WORKDIR."/peak_annotation";
our $PEAKMDIR = $WORKDIR."/peak_merge";
our $PEAKMANNODIR = $WORKDIR."/peak_merge_annotation";
our $MOTIFDIR = $WORKDIR."/motif";
our $PEAKDIFFDIR = $WORKDIR."/peak_diff";
our $PEAKDISTDIR = $WORKDIR."/peak_distance";
our $PEAKINTERSECTDIR = $WORKDIR."/peak_intersect";
our $TRACKDIR = $WORKDIR."/tracks";

##### set up reference genome #######################################
#ref genome for ChIP-seq, bowtie2
our $GNM_IDX = "/project/ibilab/library/bowtie2/$SPECIES/$SPECIES";
#ref genome for RNA-seq, star/tophat2
if ($RNA){
	if ($RNA_ALIGNER eq "star"){
		our $RNA_GNM_IDX = "/project/ibilab/library/STAR/$SPECIES"; #STAR
	} else {
		our $RNA_GNM_IDX = "/project/ibilab/library/bowtie2/$SPECIES/$SPECIES"; #tophat2
	}
}
our $GNM_GTF = "/project/ibilab/library/genes/$SPECIES/$SPECIES\_RefSeq\_Gene\_UCSC\_rev.gtf";
our $GNM_BED12 = "/project/ibilab/library/genes/$SPECIES/$SPECIES\_RefSeq.bed12";
our $GNM_SIZES = "/project/ibilab/library/bedtools/$SPECIES.genome";

##### modules to load ###############################################
our $MODULES = "samtools-0.1.19 FastQC-0.11.2 Trimmomatic-0.32 bowtie2-2.1.0 tophat-2.0.11 STAR-2.3.0e picard-1.96";
our $TRIMMO_JAR = "/opt/software/Trimmomatic/0.32/trimmomatic-0.32.jar";
our $PICARD_DIR = "/opt/software/picard/picard-tools-1.96";

##### read in sample files from sample_list.txt #####################
our $RAW_DATA_SUFFIX = "fastq.gz";
our %SAMPLES; #hash keys are sample names, hash values are *.fastq files
our %SAMPLES_CTL; #hash keys are sample names, hash values are the corresponding input control sample names
our %SAMPLES_ANT; #hash keys are sample names, hash values are the corresponding antibody
our %SAMPLES_TAG; #hash keys are sample names, hash values are the corresponding tag directory name
our %SAMPLES_TRKCTL; #hash keys are sample names, hash values are the corresponding track control tag directory name
open(IN,"$WORKDIR/sample_list.txt") or die "can not open sample list files\n";
my $line = <IN>; #skip header line
while(my $line = <IN>){
	chomp $line;
	my @t = split('\t', $line);
	$SAMPLES{$t[0]} = "$DATADIR/$t[0]".".$RAW_DATA_SUFFIX";
	if ($t[1] ne "-"){
		$SAMPLES_CTL{$t[0]} = $t[1];
	}
	if ($t[2] ne "-"){
                $SAMPLES_ANT{$t[0]} = $t[2];
        }
	if ($t[3] ne "-"){
                $SAMPLES_TAG{$t[0]} = $t[3];
        }
	if ($t[4] ne "-"){
                $SAMPLES_TRKCTL{$t[0]} = $t[4];
        }
}
close IN;
