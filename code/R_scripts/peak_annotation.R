library(ggplot2)

# set working directory
setwd(".")

# create a list from all txt files
list.filenames<-list.files(pattern=".txt$")

# create an empty list that will serve as a container to receive the incoming files
list.data<-list()

# create a loop to read in files
for (i in 1:length(list.filenames)) {
  list.data[[i]] <- read.table(file=list.filenames[i],sep="\t",header=T,fill=T,quote=NULL)
}
names(list.data)<-list.filenames

# plot annotation stackbars
pdf("Annotation.pdf")
list.table <- data.frame()
for (i in 1:length(list.filenames)) {
  tmp <- as.data.frame(sub(' \\(.*','',list.data[[i]]$Annotation))
  tmp$sample <- sub('\\..*','',list.filenames[i])
  list.table <- rbind(list.table,tmp)
}
colnames(list.table) <- c("region","sample")
ggplot(list.table,aes(x=sample,fill=region)) + geom_bar(position = 'fill') + 
  theme_classic() + theme(axis.text.x = element_text(angle = 60, hjust = 1)) + 
  scale_fill_brewer(palette="Set3") + ylab("% of peaks")
dev.off()

# plot distance to TSS stackbars
pdf("Distance.To.TSS.pdf")
list.table <- data.frame()
for (i in 1:length(list.filenames)) {
  tmp <- as.data.frame(abs(list.data[[i]]$Distance.to.TSS))
  tmp$sample <- sub('\\..*','',list.filenames[i])
  list.table <- rbind(list.table,tmp)
}
colnames(list.table) <- c("Distance.to.TSS","sample")
list.table$Distance.to.TSS <- cut(list.table$Distance.to.TSS, breaks=c(0,5000,50000,100000,Inf), labels=c("0-5kb", "5-50kb", "50-100kb",">100kb"))
ggplot(list.table,aes(x=sample,fill=Distance.to.TSS)) + geom_bar(position = 'fill') +
  theme_classic() + theme(axis.text.x = element_text(angle = 60, hjust = 1)) + 
  scale_fill_brewer(palette="Set3") + ylab("% of peaks")
dev.off()



