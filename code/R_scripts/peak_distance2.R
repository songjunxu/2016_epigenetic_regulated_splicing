library(ggplot2)
library(grid)
library(gridExtra)
library(pheatmap)
library(RColorBrewer)

setwd("/project/ibilab/user/shared/chipseq_example/large_data/peak_distance_H3K27ac");

color <- brewer.pal(9,"Blues")

#ELYS-1
pdf("ELYS-1.heatmap.pdf")
data <- read.table('ELYS-1.heatmap.txt',sep="\t",header=T)
rownames(data) <- data[,1]
data <- data[,-1]
pheatmap(log10(data+1),color=color,show_rownames=F,show_colnames=F,cluster_rows=F,cluster_cols=F,legend=F,main="ELYS-1")
dev.off()

#ELYS-2
pdf("ELYS-2.heatmap.pdf")
data <- read.table('ELYS-2.heatmap.txt',sep="\t",header=T)
rownames(data) <- data[,1]
data <- data[,-1]
pheatmap(log10(data+1),color=color,show_rownames=F,show_colnames=F,cluster_rows=F,cluster_cols=F,legend=F,main="ELYS-2")
dev.off()

#H3K27ac
pdf("H3K27ac.heatmap.pdf")
data <- read.table('H3K27ac.heatmap.txt',sep="\t",header=T)
rownames(data) <- data[,1]
data <- data[,-1]
pheatmap(log10(data+1),color=color,show_rownames=F,show_colnames=F,cluster_rows=F,cluster_cols=F,legend=F,main="H3K27ac")
dev.off()

#Input
pdf("Input.heatmap.pdf")
data <- read.table('Input.heatmap.txt',sep="\t",header=T)
rownames(data) <- data[,1]
data <- data[,-1]
pheatmap(log10(data+1),color=color,show_rownames=F,show_colnames=F,cluster_rows=F,cluster_cols=F,legend=F,main="Input")
dev.off()
