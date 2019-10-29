data <- read.table('peak_intersect.txt',sep="\t",header=T,stringsAsFactors=F)

# subset of histone modifications to plot
data <- subset(data, select=c('DMSO.H3K4me3','Nutlin.H3K4me3','DMSO.H4K16ac','Nutlin.H4K16ac'))

pdf("peak_intersect.pdf")

par(mfrow=c(1,2))

# peaks that intersect with H3K4me3
idx <- (data$Nutlin.H3K4me3 > 0)
x <- colSums(data[idx,] != 0)/sum(idx)
x <- matrix(x,nrow=2) #reshape to two rows DMSO/Nutlin
rownames(x) <- c('DMSO','Nutlin')
colnames(x) <- c('H3K4me3','H4K16ac')

# plot H3K4me3+
barplot(x, beside=T, col="darkgreen", space=c(0,0), ylim=c(0,1), ylab="% of TP53 peaks with overlap (H3K4me3)", main="H3K4me3+")
barplot(x, beside=T, density=c(0,10), col="black", space=c(0,0), ylim=c(0,1), add=T)
par(new=F,xpd=T)
legend("top",legend=rownames(x),horiz=T,inset=c(0,-0.08),bty="n",fill="darkgreen")
legend("top",legend=rownames(x),horiz=T,inset=c(0,-0.08),bty="n",density=c(0,10))

# peaks not intersect with H3K4me3
idx <- (data$Nutlin.H3K4me3 == 0)
x <- colSums(data[idx,] != 0)/sum(idx)
x <- matrix(x,nrow=2) #reshape to two rows DMSO/Nutlin
rownames(x) <- c('DMSO','Nutlin')
colnames(x) <- c('H3K4me3','H4K16ac')

# plot H3K4me3-
barplot(x, beside=T, col="darkgreen", space=c(0,0), ylim=c(0,1), ylab="% of TP53 peaks with overlap (H3K4me3)", main="H3K4me3-")
barplot(x, beside=T, density=c(0,10), col="black", space=c(0,0), ylim=c(0,1), add=T)
par(new=F,xpd=T)
legend("top",legend=rownames(x),horiz=T,inset=c(0,-0.08),bty="n",fill="darkgreen")
legend("top",legend=rownames(x),horiz=T,inset=c(0,-0.08),bty="n",density=c(0,10))

dev.off()

