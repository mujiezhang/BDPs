library(pheatmap)
library(ggplot2)
library(patchwork)
library(forcats) 

heatmap_data <- read.csv("vfg-arg-amp-defense.tsv", row.names = 1,sep='\t',header=TRUE)

bk2 <- c(seq(0,15.5,by=0.01))

t <- pheatmap(heatmap_data,
               cellwidth = 7, cellheight = 7,
               cluster_rows = F,
               cluster_cols =F,
               fontsize=6,
               breaks=bk2,
               legend_breaks =  c(0,3,6,9,12,15),
               color = c(colorRampPalette(colors = c("white","#1d91c0"))(length(bk2)*2/31),
                         colorRampPalette(colors = c("#1d91c0","#ffbb25"))(length(bk2)*14/31),
                         colorRampPalette(colors = c("#ffbb25","#990000"))(length(bk2)*15/31)),
)
t

df2=read.table('bar-plot.txt',head=TRUE,sep='\t')

df2$type <- fct_inorder(df2$type)

p1<-ggplot(df2,aes(x=type,y=number))+
  geom_col(width = 0.5,colour='black',linewidth=0.2)+
  scale_y_continuous(limits=c(0,16),breaks=seq(0,15,5))+
  theme_bw()+theme(axis.text.x = element_text(angle = 90,vjust=0.5),
                   panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank(),legend.position= 'none')+
  ylab('Counts (log2(n+1))')+xlab(NULL)
p1