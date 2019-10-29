library(ggplot2)
library(grid)
library(gridExtra)
library(pheatmap)
library(RColorBrewer)
library(reshape2)
library(plyr)

#setwd("/project/ibilab/projects/Shelley_Berger_ChIPseq_Payel_2016_8/large_data/peak_distance_peak_diff.intergenic");

#setwd("~/Desktop/peak_distance_peak_diff.intergenic")
setwd("~/Desktop/peak_distance_peak_diff.intron")
#setwd("~/Desktop/peak_distance_peak_diff.intergenic_intron")


# read peaks
#P <- read.table('../peak_diff/peak_diff.intergenic.narrowPeak',sep="\t",header=F,fill=T,quote=NULL,comment.char="")
P <- read.table('../peak_diff/peak_diff.intron.narrowPeak',sep="\t",header=F,fill=T,quote=NULL,comment.char="")
#P <- read.table('../peak_diff/peak_diff.intergenic_intron.narrowPeak',sep="\t",header=F,fill=T,quote=NULL,comment.char="")

P <- P[1]
colnames(P) <- "Gene"
# already sorted by peak fold change, need to flip upside down for heatmap plotting
P$Gene <- rev(P$Gene)
P$Gene <- factor(P$Gene,P$Gene)

#
antibody = "H3K27ac"

#read tag counts
sample  <- paste('PD78',antibody,sep="-")
histone <- 'PD78-H3'
igg  <- 'PD78-IgG'
input <- 'PD78-input'
data_sample <- read.table(paste(sample,'.heatmap.txt',sep=""), sep="\t", header=T, comment.char="")
data_histone <- read.table(paste(histone,'.heatmap.txt',sep=""), sep="\t", header=T, comment.char="")
data_igg <- read.table(paste(igg,'.heatmap.txt',sep=""), sep="\t", header=T, comment.char="")
data_input <- read.table(paste(input,'.heatmap.txt',sep=""), sep="\t", header=T, comment.char="")
#match rows by peak, replace missing rows/peaks with rows of 0s
data_sample_sort <- join(P, data_sample, type="left", by="Gene")
data_sample_sort[is.na(data_sample_sort)] <- 0
data_histone_sort <- join(P, data_histone, type="left", by="Gene")
data_histone_sort[is.na(data_histone_sort)] <- 0
data_igg_sort <- join(P, data_igg, type="left", by="Gene")
data_igg_sort[is.na(data_igg_sort)] <- 0
data_input_sort <- join(P, data_input, type="left", by="Gene")
data_input_sort[is.na(data_input_sort)] <- 0
#subtract tag counts
data <- (data_sample_sort[,-1]-data_histone_sort[,-1])-(data_igg_sort[,-1]-data_input_sort[,-1])
data[data<0] <- 0
data$Gene <- P$Gene
data <- data[c(502,51:451)] #flanking 4kb instead of 5kb
#
dataS <- data
rm(list = ls()[!(ls() %in% c('P','antibody','dataS'))])

#read tag counts
sample  <- paste('PD36',antibody,sep="-")
histone <- 'PD36-H3'
igg  <- 'PD36-IgG'
input <- 'PD36-input'
data_sample <- read.table(paste(sample,'.heatmap.txt',sep=""), sep="\t", header=T, comment.char="")
data_histone <- read.table(paste(histone,'.heatmap.txt',sep=""), sep="\t", header=T, comment.char="")
data_igg <- read.table(paste(igg,'.heatmap.txt',sep=""), sep="\t", header=T, comment.char="")
data_input <- read.table(paste(input,'.heatmap.txt',sep=""), sep="\t", header=T, comment.char="")
#match rows by peak, replace missing rows/peaks with rows of 0s
data_sample_sort <- join(P, data_sample, type="left", by="Gene")
data_sample_sort[is.na(data_sample_sort)] <- 0
data_histone_sort <- join(P, data_histone, type="left", by="Gene")
data_histone_sort[is.na(data_histone_sort)] <- 0
data_igg_sort <- join(P, data_igg, type="left", by="Gene")
data_igg_sort[is.na(data_igg_sort)] <- 0
data_input_sort <- join(P, data_input, type="left", by="Gene")
data_input_sort[is.na(data_input_sort)] <- 0
#subtract tag counts
data <- (data_sample_sort[,-1]-data_histone_sort[,-1])-(data_igg_sort[,-1]-data_input_sort[,-1])
data[data<0] <- 0
data$Gene <- P$Gene
data <- data[c(502,51:451)] #flanking 4kb instead of 5kb
#
dataP <- data
rm(list = ls()[!(ls() %in% c('P','antibody','dataS','dataP'))])

if(FALSE){
#plot curve
png(paste(antibody,'.curve.png',sep=""),width=300,height=250)
#plot(colMeans(dataP[,-1]),lwd=3,type="l",main=antibody,xlab="",ylab="",xaxt="n",col="cyan",ylim=c(0,max(range(colMeans(dataS[,-1])),range(colMeans(dataP[,-1])))))
plot(colMeans(dataP[,-1]),lwd=3,type="l",main=antibody,xlab="",ylab="",xaxt="n",col="cyan",ylim=c(0,2))
lines(colMeans(dataS[,-1]),lwd=3,type="l",xlab="",ylab="",xaxt="n",col="red")
dev.off()
}

#if(FALSE){

#heatmap for each sample and curve for each sample vs. control
#plot heatmapS
datam <- melt(dataS, id.vars = "Gene")
datam$value <- log2(datam$value+1)
png(paste(antibody,'.heatmapS.png',sep=""),width=250,height=500)
ggplot(datam,aes(x=variable,y=Gene,fill=value)) + geom_tile() + scale_fill_gradient2(low="white",high="navy") +
  theme_classic() + theme(axis.text.x=element_blank(),axis.text.y=element_blank()) +
  theme(axis.line=element_blank(),axis.ticks=element_blank()) +
  theme(legend.position="none") + xlab("") + ylab("") + ggtitle("") +
  theme(panel.border = element_rect(colour = "black", fill=NA, size=1))
dev.off()
#plot heatmapP
datam <- melt(dataP, id.vars = "Gene")
datam$value <- log2(datam$value+1)
png(paste(antibody,'.heatmapP.png',sep=""),width=250,height=500)
ggplot(datam,aes(x=variable,y=Gene,fill=value)) + geom_tile() + scale_fill_gradient(low="white",high="navy") +
  theme_classic() + theme(axis.text.x=element_blank(),axis.text.y=element_blank()) +
  theme(axis.line=element_blank(),axis.ticks=element_blank()) +
  theme(legend.position="none") + xlab("") + ylab("") + ggtitle("") +
  theme(panel.border = element_rect(colour = "black", fill=NA, size=1))
dev.off()

#}

