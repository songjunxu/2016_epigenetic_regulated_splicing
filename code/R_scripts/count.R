library(ggplot2)
library(RColorBrewer)
library(reshape2)
library(grid)

setEPS()
postscript("exon.eps",width=12,height=6)

#cluster8
data <- read.table('cluster8.tag_count.txt',sep="\t",header=T,fill=T,quote=NULL,comment.char="")
data$type <- sub(".*_", "", data$PeakID)
#statistics
labs <- c("promoter","variant","altDonor","canonical","altAcceptor","polyA")
for (i in 1:6){
  data3 <- data[data$type==labs[i],]
  t <- wilcox.test(data3$H3K36me3_coc,data3$H3K36me3_sal,exact=F)$p.value
  if (t<0.01){labs[i]<-paste("**",labs[i],sep="")} else if (t<0.1){labs[i]<-paste("*",labs[i],sep="")}
}
#melt
data2 <- subset(data,select=c("PeakID","type","H3K36me3_coc","H3K36me3_sal"))
data2 <- melt(data2,id=c("PeakID","type"))
colnames(data2) <- c("PeakID","type","treatment","intensity")
data2$type <- factor(data2$type,c("promoter","variant","altDonor","canonical","altAcceptor","polyA"))
#plot
p1 <- ggplot(data2,aes(x=type,y=intensity,fill=treatment,color="gray")) + geom_boxplot(show.legend=F,outlier.color="gray") + theme_bw(base_size=22) + 
  xlab("") + ylab("H3K36me3") + ggtitle("cluster8") +
  theme(panel.grid = element_blank()) + scale_x_discrete(labels=labs) +
  theme(axis.text.x = element_text(angle=90, hjust=1, vjust=0.5)) +
  scale_fill_manual(values=c("red","black")) + scale_color_manual(values="gray")

#cluster14
data <- read.table('cluster14.tag_count.txt',sep="\t",header=T,fill=T,quote=NULL,comment.char="")
data$type <- sub(".*_", "", data$PeakID)
#statistics
labs <- c("promoter","variant","altDonor","canonical","altAcceptor","polyA")
for (i in 1:6){
  data3 <- data[data$type==labs[i],]
  t <- wilcox.test(data3$H3K36me3_coc,data3$H3K36me3_sal,exact=F)$p.value
  if (t<0.01){labs[i]<-paste("**",labs[i],sep="")} else if (t<0.1){labs[i]<-paste("*",labs[i],sep="")}
}
#melt
data2 <- subset(data,select=c("PeakID","type","H3K36me3_coc","H3K36me3_sal"))
data2 <- melt(data2,id=c("PeakID","type"))
colnames(data2) <- c("PeakID","type","treatment","intensity")
data2$type <- factor(data2$type,c("promoter","variant","altDonor","canonical","altAcceptor","polyA"))
#plot
p2 <- ggplot(data2,aes(x=type,y=intensity,fill=treatment,color="gray")) + geom_boxplot(show.legend=F,outlier.color="gray") + theme_bw(base_size=22) + 
  xlab("") + ylab("H3K36me3") + ggtitle("cluster14") +
  theme(panel.grid = element_blank()) + scale_x_discrete(labels=labs) +
  theme(axis.text.x = element_text(angle=90, hjust=1, vjust=0.5)) +
  scale_fill_manual(values=c("red","black")) + scale_color_manual(values="gray")

#cluster19
data <- read.table('cluster19.tag_count.txt',sep="\t",header=T,fill=T,quote=NULL,comment.char="")
data$type <- sub(".*_", "", data$PeakID)
#statistics
labs <- c("promoter","variant","altDonor","canonical","altAcceptor","polyA")
for (i in 1:6){
  data3 <- data[data$type==labs[i],]
  t <- wilcox.test(data3$H3K36me3_coc,data3$H3K36me3_sal,exact=F)$p.value
  if (t<0.01){labs[i]<-paste("**",labs[i],sep="")} else if (t<0.1){labs[i]<-paste("*",labs[i],sep="")}
}
#melt
data2 <- subset(data,select=c("PeakID","type","H3K36me3_coc","H3K36me3_sal"))
data2 <- melt(data2,id=c("PeakID","type"))
colnames(data2) <- c("PeakID","type","treatment","intensity")
data2$type <- factor(data2$type,c("promoter","variant","altDonor","canonical","altAcceptor","polyA"))
#plot
p3 <- ggplot(data2,aes(x=type,y=intensity,fill=treatment,color="gray")) + geom_boxplot(show.legend=F,outlier.color="gray") + theme_bw(base_size=22) + 
  xlab("") + ylab("H3K36me3") + ggtitle("cluster19") +
  theme(panel.grid = element_blank()) + scale_x_discrete(labels=labs) +
  theme(axis.text.x = element_text(angle=90, hjust=1, vjust=0.5)) +
  scale_fill_manual(values=c("red","black")) + scale_color_manual(values="gray")

vplayout <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
grid.newpage()
pushViewport(viewport(layout = grid.layout(1, 3)))
print(p1, vp = vplayout(1, 1))
print(p2, vp = vplayout(1, 2))
print(p3, vp = vplayout(1, 3))

dev.off()

