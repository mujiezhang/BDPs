setwd('E:/课题/5.att/github/analysis-and-figure/fig4')
df1=read.table('BDP-BUP-genome-szie-quality.tsv',head=TRUE,sep='\t')
library(ggplot2)
library(ggpointdensity)
library(ggsignif)
library(patchwork) 
library(grid)
library(RColorBrewer)
library(ggpmisc)

mycomparisons <- list(c("BDP",'BUP'))
p2 <- ggplot(df1, aes(x = contig_length / 1000,fill=type)) +
  geom_density(alpha=0.3)+
  scale_fill_manual(values=c('#E8BCBC','#B9D4E9'))+xlab('Genome size (kb)')+
  scale_x_continuous(limits = c(0, 100), breaks = seq(0, 100, 20))+
  theme_bw()+theme(panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank(),legend.position = c(.8, .8))
p2
p22 <- ggplot(df1, aes(x = completeness,fill=type)) +
  geom_density(alpha=0.3)+
  scale_fill_manual(values=c('#E8BCBC','#B9D4E9'))+xlab('Completeness (%)')+
  scale_x_continuous(limits = c(0, 100), breaks = seq(0, 100, 20))+
  theme_bw()+theme(panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank(),legend.position = c(.8, .8))
p22
p3 <- ggplot(df1, aes(x=type,y = completeness,fill=type)) +
  geom_boxplot(outlier.shape = NA,alpha=0.3)+
  geom_signif(
    comparisons = mycomparisons,
    map_signif_level = F,
  )+
  scale_fill_manual(values=c('#E8BCBC','#B9D4E9'))+xlab(NULL)+
  theme_bw()+theme(panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank(),legend.position='none')
p3
p33 <- ggplot(df1, aes(x=type,y = contig_length / 1000,fill=type)) +
  geom_boxplot(outlier.shape = NA,alpha=0.3)+
  scale_fill_manual(values=c('#E8BCBC','#B9D4E9'))+ylim(0,100)+xlab(NULL)+ylab('Genome size (kb)')+
  theme_bw()+theme(panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank(),legend.position='none')
p33

layout <- "
AAAABBBBCD
"
pp =p2+p22 + p33+ p3+plot_layout(design = layout)
pp

df2=read.table('protein_annotation_compare.tsv',head=TRUE,sep='\t')

# 创建渐变色的矩形对象
color_palette <- colorRampPalette(c("#bad6f3", "white", "#f3baba"))(100)
gradient_matrix_horizontal <- matrix(scales::alpha(color_palette, 0.5), nrow = 1)
# 创建渐变背景
gradient_grob <- rasterGrob(gradient_matrix_horizontal, 
                            width = unit(1, "npc"), 
                            height = unit(1, "npc"))
df2$category<- factor(df2$category,levels = c('integration and excision','transcription regulation','nucleotide metabolism',
                                              'head and packaging','connector','tail','lysis','moron'))


p4<- ggplot(df2) +
  annotation_custom(gradient_grob, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
  geom_segment(aes(x=category, xend=category, y=BDP*100, yend=BUP*100), color="black",linewidth=1) +#数据点之间的连线
  geom_point( aes(x=category, y=BDP*100), shape=21,fill='#4682B4',size=6 ,stroke=1) +#数据点1
  geom_point( aes(x=category, y=BUP*100),shape=21, fill='#EDEDD9' ,size=6,stroke=1) +
  scale_y_continuous(limits=c(30,100),breaks=seq(30,100,10))+
  theme_bw()+theme(axis.text.x =element_text(angle = 45, hjust = 1, vjust = 1),
                   panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank())+ylab('Percent (%)')+xlab(NULL)


p4

df3=read.table('BDP-vs-BUP-functional-gene.tsv',head=TRUE,sep='\t')
df3$func<- factor(df3$func,levels = c('VFG','DS','ADS','AMP','ARG'))
p5<- ggplot(df3, aes(x = func, y = ave, fill = type)) +
  annotation_custom(gradient_grob, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
  geom_bar(stat = "identity", position = position_dodge(),width=0.6)+
  scale_fill_manual(values=c('#E8BCBC','#B9D4E9'))+
  theme_bw()+theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),legend.position ='none')+ylab('Functional genes per viral genome')+xlab(NULL)

p5

pp2=p4+p5
pp2
