library(ggplot2)
library(grid)
library(gridExtra)

#setwd("/project/ibilab/user/shared/chipseq_example/large_data/peak_distance_H3K27ac");

vplayout <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)

data <- read.table("peak_distance.txt",sep="\t",header=T)
data <- data[,-dim(data)[2]]
colnames(data)[1] <- "Distance.from.Center"
#### devide by input
data$H3K27ac <- as.numeric(data$H3K27ac / data$Input)
data$ELYS.1 <- as.numeric(data$ELYS.1 / data$Input)
data$ELYS.2 <- as.numeric(data$ELYS.2 / data$Input)

#### plot replicates for each antibody
p1 <- ggplot(data) +
  geom_line(aes(x = Distance.from.Center, y = H3K27ac), colour = "blue") +
  xlab('') + ylab('') + ylim(0.5,2.5) +
  ggtitle("H3K27ac") + scale_x_continuous(breaks=c(-750,0,750)) + theme_classic()
p2 <- ggplot(data) +
  geom_line(aes(x = Distance.from.Center, y = ELYS.1), colour = "blue") +
  geom_line(aes(x = Distance.from.Center, y = ELYS.2), colour = "red") +
  xlab('') + ylab('') + ylim(0.5,3.5) +
  ggtitle("ELYS") + scale_x_continuous(breaks=c(-750,0,750)) + theme_classic()
pdf("peak_distance1_H3K27ac.pdf")
grid.arrange(p1, p2, ncol=2, nrow=1, respect=TRUE, bottom='Distance from H3K27ac peak center', left='ChIP/Input Enrichment')
dev.off()
