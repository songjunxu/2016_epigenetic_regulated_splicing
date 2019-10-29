library(ggplot2)
library(reshape2)
library(grid)
library(gridExtra)

d1 <- read.table('summary_fastqc1.txt',sep="\t",quote="",stringsAsFactors=T,header=T)
md1 <- melt(d1,id.var='Sample')
md1$description <- "raw reads"

d2 <- read.table('summary_fastqc2.txt',sep="\t",quote="",stringsAsFactors=T,header=T)
md2 <- melt(d2,id.var='Sample')
md2$description <- "trimmed reads"

data <- rbind(md1,md2)
colnames(data) <- c('QC','Sample','Stat','description')

p <- ggplot(data,aes(Sample,QC,fill=Stat)) + geom_tile(col='black') + facet_grid(.~description) +
  theme_classic() + theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
  theme(axis.line = element_blank(), axis.ticks = element_blank()) +
  scale_colour_manual(values = c("PASS" = "green","WARNING" = "yellow","FAIL" = "red"))

ggsave("summary_plot_fastqc.pdf",p,width=12,height=8)
