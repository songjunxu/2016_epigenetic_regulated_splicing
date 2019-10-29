library(DiffBind)

Peaks <- list.files(pattern=".narrowPeak$")

SampleID <- sapply(strsplit(Peaks,"_"), "[", 1)
Treatment <- sapply(strsplit(SampleID,"-"), "[", 1)
data <- cbind(data.frame(SampleID),data.frame(Treatment),data.frame(Peaks))
data$PeakCaller <- "narrow"
write.table(data,sep=",",file="summary_peak_diffbind.txt",quote=F,row.names=F)

pdf("summary_peak_diffbind.pdf")
samples <- read.csv("summary_peak_diffbind.txt",sep=",")
sampleDBA <- dba(sampleSheet="summary_peak_diffbind.txt",)
dba.plotPCA(sampleDBA,DBA_TREATMENT,label=DBA_ID,dotSize=1)
dev.off()

