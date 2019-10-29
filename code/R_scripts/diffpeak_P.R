library(ggplot2)
library(grid)
library(gridExtra)
library(pheatmap)
library(RColorBrewer)
library(reshape2)
library(plyr)
library(stats)
library(data.table)

data <- read.table('tag_count.txt',sep="\t",header=T,fill=T,quote=NULL,comment.char="")

data2 <- data[,1:19]
data2$PD36 <- (data$PD36.H3K27ac-data$PD36.H3) - (data$PD36.IgG-data$PD36.input)
data2$PD36[data2$PD36<0] <- 0
data2$PD78 <- (data$PD78.H3K27ac-data$PD78.H3) - (data$PD78.IgG-data$PD78.input)
data2$PD78[data2$PD78<0] <- 0

data2$FC <- data2$PD36/data2$PD78
data2$FC[data2$FC>100] <- 100  #where PD36>0 & PD78=0
data2$FC[is.na(data2$FC)] <- 0 #where PD36=0 & PD78=0

tmp <- cbind(round(data2$PD36),data2$PD78)
data2$pvalue <- apply(tmp, 1, function(x) poisson.test(x[1], T=x[2], r=1, alternative="greater", conf.level=0.95)$p.value)

data2 <- data2[order(data2$PD36,decreasing=T),]
data2 <- data2[order(data2$pvalue,decreasing=F),]
data2 <- data2[order(data2$FC,decreasing=T),]

write.table(data2,sep="\t",file="peak_diff.all.txt",quote=F,col.names=T,row.names=F)

data2 <- data2[(data2$FC>=4) & (data2$pvalue<=0.0001),]
write.table(data2,sep="\t",file="peak_diff.filter.txt",quote=F,col.names=T,row.names=F)

data3 <- data2[data2$Annotation %like% "Intergenic",]
write.table(data3,sep="\t",file="peak_diff.intergenic.txt",quote=F,col.names=T,row.names=F)

data4 <- data2[data2$Annotation %like% "intron",]
write.table(data4,sep="\t",file="peak_diff.intron.txt",quote=F,col.names=T,row.names=F)

data5 <- rbind(data3,data4)
write.table(data5,sep="\t",file="peak_diff.intergenic_intron.txt",quote=F,col.names=T,row.names=F)


