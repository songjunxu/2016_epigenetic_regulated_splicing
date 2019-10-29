## General ChIP-seq Analysis

**1. Setup**
  - if data is from NGSC, refer to [NGSC_data_retrieval.md](Bioinfo_Resources/NGSC_data_retrieval.md)
  - save raw data to large_data/raw_data/SampleID.fastq.gz
  - make large_data/sample_list.txt (tab-deliminated file as in the example: `/project/ibilab/user/shared/chipseq_example/large_data/sample_list.txt`) 
  - copy all pipeline codes here to your project's code directory
  - revise the config.pm file as commented in the file

**2. FASTQC of raw reads, generate summary**
  - input: raw read files (large_data/raw_data)
  - output: sequencing quality assessment (large_data/fastqc1), QC summary (data/summary_fastqc1.txt)

     ```
     perl bsub_fastqc1.pl
     perl summary_fastqc1.pl
     ```

**3. (skipped) Quality Trim**
  - input: raw read files (large_data/raw_data)
  - output: trimmed read files (large_data/trim)
  - parameter: trim adapters, filter phred<3 leading/trailing bases, filter by a phred 3/3 sliding window, minimum length 30bp.

     ``` 
     perl bsub_trim.pl
     ```

**4. (skipped) FASTQC of trimmed reads, generate summary**
  - input: trimmed read files (large_data/trim)
  - output: sequencing quality assessment (large_data/fastqc1), QC summary (data/summary_fastqc2.txt), QC summary plot (data/summary_plot_fastqc.pdf)

     ```
     perl bsub_fastqc2.pl
     perl summary_fastqc2.pl
     perl summary_plot_fastqc.pl
     ```

**5. Read mapping using Bowtie2**
  - input: non-trimmed read files (large_data/raw_data)
  - output: alignment files (large_data/bowtie2), alignment summary (data/summary_alignment.txt)
  - parameter: optimally mapped reads (up to 1 mismatch), MAPQ >= 10

     ```
     perl bsub_bowtie2.pl
     perl summary_bowtie2.pl
     ```

**6. Modify the alignment using bedtools**
  - input: alignment files (large_data/bowtie2)
  - output: modified alignment files (large_data/bed)
  - parameter (optional): remove duplicate reads, remove ChrM reads, remove reads from blacklist

     ```
     perl bsub_bedtools.pl
     ```

**7. Peak calling from alignment using MACS2**
  - input: modified alignment files (large_data/bed)
  - output: peak files (large_data/peak_calling, data/summary_peak_calling.txt)
  - parameter: FDR < 0.05

     ```
     perl bsub_peak_calling.pl
     perl summary_peak_calling.pl
     ```

**8. Peak calling comparison using DiffBind**
  - input: peak files (large_data/peak_calling)
  - output: peak calling comparison plot (data/summary_peak_diffbind.pdf)

     ```
     perl summary_peak_diffbind.pl
     ```

**9. Peak annotation using HOMER**
  - input: peak files (large_data/peak_calling)
  - output: peak annotation files (large_data/peak_annotation, data/peak_annotation)

     ```
     perl bsub_peak_annotation.pl
     perl summary_peak_annotation.pl
     ```

**10. Peak merge from replicates**
  - input: peak files (large_data/peak_calling)
  - output: merged peak files (large_data/peak_merge)

     ```
     perl bsub_peak_merge.pl
     ```

**11. Peak annotation using HOMER for merged peaks**
  - input: merged peak files (large_data/peak_merge)
  - output: merged peak annotation files (large_data/peak_merge_annotation)

     ```
     perl bsub_peak_merge_annotation.pl
     perl summary_peak_merge_annotation.pl
     ```

**12. Make tag directory from alignment, for each replicate separately**
  - input: modified alignment files (large_data/bed)
  - output: tag directories (large_data/tracks)

     ```
     perl bsub_tagdir.pl
     ```

**13. Make UCSC Tracks from tag directory, for each replicate separately**
  - input: tag directories (large_data/tracks)
  - output: track files, separate (large_data/tracks) or overlay (large_data/tracks/overlay_tracks)
  - parameter: normalized to 10 million tags per sample
  - use web server bsc.ibi.upenn.edu to host track files, manually create a text file to indicate the url (data/hub_url.txt)

     ```
     perl bsub_track.pl
     perl bsub_track_overlay.pl
     ```
  
## Project Specific Analysis

**14. Tag enrichment near H3K27ac peaks (histogram)**
  - input: H3K27ac peak file, tag directory of each sample (large_data/peak_merge/H3K27ac_peaks.narrowPeak, large_data/tracks)
  - output: tag enrichment data file (large_data/peak_distance_H3K27ac)
  - parameter: 1500bp flanking H3K27ac peaks, input subtracted
  - note: run for other IP instead of H3K27ac by changing the variable "$PEAK_CENTER" in config.pm

     ```
     perl bsub_peak_distance1.pl
     Rscript --no-save < R_scripts/peak_distance1.R (the .R file need to be modified for different project)
     ```

**15. Tag enrichment near H3K27ac peaks (heatmap)**
  - input: H3K27ac peak file, tag directory of each sample (large_data/peak_merge/H3K27ac_peaks.narrowPeak, large_data/tracks) 
  - output: tag enrichment data files (large_data/peak_distance_H3K27ac)
  - parameter: 5000bp flanking H3K27ac peaks
  - note: run for other IP instead of H3K27ac by changing the variable "$PEAK_CENTER" in config.pm

     ```
     perl bsub_peak_distance2.pl
     Rscript --no-save < R_scripts/peak_distance2.R (the .R file need to be modified for different project)
     ```

**16. Remember to copy peak_distance R plots to "data/peak_distance"**
  - e.g. ` cp large_data/peak_distance_H3K27ac/*.pdf data/peak_distance_H3K27ac`

**17. Peak intersect**
  - input: all peak files (large_data/peak_merge)
  - output: a venn table showing the intersection between all peaks (large_data/peak_intersect)

     ```
     perl bsub_venn.pl
     ```

**18. Motif analysis using HOMER**
  - input: peak files (large_data/peak_merge)
  - output: motif analysis reports (large_data/motif)

     ```
     findMotifsGenome.pl <peak_file> dm3 <output_directory>
     (e.g.) findMotifsGenome.pl peak_merge/ELYS_peaks.narrowPeak dm3 motif/ELYS/
     ```
