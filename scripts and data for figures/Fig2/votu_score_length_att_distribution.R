
df1=read.table('votu_score_length_att_infor.tsv',head=TRUE,sep='\t')
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
p1<- ggplot(df1,aes(x=score))+  
  annotation_custom(gradient_grob, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
  geom_histogram(binwidth=1,fill='steelblue',color="black",linewidth=0.1) +
  xlab('att score (total score = 100)')+ylab('viral genomes')+
  scale_y_continuous(limits=c(0,60000),breaks=seq(0,60000,10000))+
  theme_bw()+theme(axis.text.x =element_text(size=14),
                   axis.text.y =element_text(size=14),
                   axis.title.x =element_text(size=16),
                   axis.title.y =element_text(size=16),
                   panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank(),
                   legend.position = 'none')
p1

p3<- ggplot(df1,aes(x=genome_length/1000))+  
  annotation_custom(gradient_grob, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
  geom_histogram(binwidth=2,fill='steelblue',color="black",linewidth=0.1) +
  xlab('Genome size (kb)')+ylab('viral genomes')+
  scale_x_continuous(limits=c(0,101),breaks=seq(0,101,10))+
  theme_bw()+theme(axis.text.x =element_text(size=14),
                   axis.text.y =element_text(size=14),
                   axis.title.x =element_text(size=16),
                   axis.title.y =element_text(size=16),
                   panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank(),
                   legend.position = 'none')
p3
p4<- ggplot(df1,aes(x=genome_length/1000))+  
  annotation_custom(gradient_grob, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
  geom_histogram(binwidth=10,fill='steelblue',color="black",linewidth=0.1) +
  xlab(NULL)+ylab('viral genomes')+
  scale_x_continuous(limits=c(100,260),breaks=seq(100,260,30))+
  theme_bw()+theme(axis.text.x =element_text(size=12),
                   axis.text.y =element_text(size=12),
                   axis.title.x =element_text(size=12),
                   axis.title.y =element_text(size=12),
                   panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank(),
                   legend.position = 'none',
                   plot.background = element_rect(fill = "transparent", color = NA),
                   rect = element_rect(fill='transparent'))
p4

p5<- ggplot(df1,aes(x=att_length))+  
  annotation_custom(gradient_grob, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
  geom_histogram(binwidth=2,fill='steelblue',color="black",linewidth=0.1) +
  xlab('att length (bp)')+ylab('viral genomes')+
  scale_x_continuous(limits=c(4,225),breaks=seq(5,225,20))+
  scale_y_continuous(limits=c(0,8000),breaks=seq(0,8000,2000))+
  theme_bw()+theme(axis.text.x =element_text(size=14),
                   axis.text.y =element_text(size=14),
                   axis.title.x =element_text(size=16),
                   axis.title.y =element_text(size=16),
                   panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank(),
                   legend.position = 'none')
p5
p6<- ggplot(df1,aes(x=att_length))+  
  annotation_custom(gradient_grob, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
  geom_histogram(binwidth=40,fill='steelblue',color="black",linewidth=0.1) +
  xlab(NULL)+ylab('viral genomes')+
  scale_x_continuous(limits=c(225,3600),breaks=seq(200,3600,400))+
  scale_y_continuous(limits=c(0,150),breaks=seq(0,150,50))+
  theme_bw()+theme(axis.text.x =element_text(size=12),
                   axis.text.y =element_text(size=12),
                   axis.title.x =element_text(size=12),
                   axis.title.y =element_text(size=12),
                   panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank(),
                   legend.position = 'none',
                   plot.background = element_rect(fill = "transparent", color = NA),
                   rect = element_rect(fill='transparent'))
p6

p33=p3 + inset_element(p4, 0.5, 0.3, 0.99, 0.9, on_top = TRUE)
p33
p55=p5 + inset_element(p6, 0.2, 0.3, 0.99, 0.9, on_top = TRUE)
p55
p=p1/p33/p55
p

