
df1=read.table('DPs_infor.tsv',head=TRUE,sep='\t')
library(ggplot2)  
library(patchwork)  
library(grid)
library(RColorBrewer)
library(ggpmisc)
# 创建渐变色的矩形对象
color_palette <- colorRampPalette(c("#bad6f3", "white", "#f3baba"))(100)
gradient_matrix_horizontal <- matrix(scales::alpha(color_palette, 0.5), nrow = 1)
# 创建渐变背景
gradient_grob <- rasterGrob(gradient_matrix_horizontal, 
                            width = unit(1, "npc"), 
                            height = unit(1, "npc"))


df2=read.table('host.tsv',head=TRUE,sep='\t')
df2$host <- factor(df2$host, levels = unique(df2$host)) 
p3<- ggplot(df2,aes(x=host,y=num))+  
  annotation_custom(gradient_grob, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
  geom_col(width = 0.7,colour='black',fill='#4682B4',linewidth=0.2)+
  xlab(NULL)+ylab('viral genomes')+
  theme_bw()+theme(axis.text.x =element_text(angle = 45, hjust = 1, vjust = 1),

                   panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank(),
                   legend.position = 'none')
p3

df3=read.table('BDP-vs-DPs-unannotation-rate.tsv',head=TRUE,sep='\t')

p4<- ggplot(df3,aes(x=type,y=rate))+  
  annotation_custom(gradient_grob, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
  geom_col(width = 0.7,colour='black',fill='#4682B4',linewidth=0.2)+
  xlab(NULL)+ylab(NULL)+
  theme_bw()+theme(
                   panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank(),
                   legend.position = 'none')
p4

p2 <- ggplot(df1, aes(x =genome_len/1000)) +
  annotation_custom(gradient_grob, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
  geom_density(alpha=0.8,fill='#4682B4')+
  xlab('Genome size (kb)')+
  scale_x_continuous(limits=c(0,125),breaks=seq(0,125,20))+
  theme_bw()+theme(panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank(),legend.position = 'none')

p2

p5 <- ggplot(df1, aes(x=1,y=ptoh)) +
  annotation_custom(gradient_grob, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
  geom_violin(fill ='#4682B4',trim=FALSE)+
  geom_boxplot(width = 0.20,outlier.shape = NA)+
  geom_hline(aes(yintercept=1.5), colour="#FA7F6F", linetype="dashed") +
  xlab('PtoH')+
  theme_bw()+theme(axis.text.x =element_blank(),
    panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank(),legend.position = 'none')

p5
p=p2+p3+p4+p5
p

