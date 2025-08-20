
df1=read.table('integrase_related_data.tsv',head=TRUE,sep='\t')

library(ggthemes)
library(ggridges)
library(ggplot2)
library(patchwork)
library(ggsci)
library(RColorBrewer)
df1$int_type <- factor(df1$int_type,levels = c('others','tnp','s_int','y_int'))
df1$int_loca2 <- as.numeric(as.character(df1$int_loca2))
p1<-ggplot(df1, aes(x=att_len,y = int_type, fill = int_type)) +
  geom_density_ridges(alpha=0.7) +
  scale_x_continuous(limits=c(0,100),breaks=seq(0,100,10))+
  theme_ridges() + xlab('att length (bp)')+ylab(NULL)+
  theme(legend.position = "none")

p1

p2<-ggplot(df1, aes(x=genome_len/1000,y = int_type, fill = int_type)) +
  geom_density_ridges(alpha=0.7) +
  scale_x_continuous(limits=c(0,80),breaks=seq(0,80,10))+
  theme_ridges() + 
  ylab(NULL)+ xlab('Genome length (kb)')+
  theme(legend.position = "none")

p2

p3<-ggplot(df1, aes(x=int_loca2,y = int_type, fill = int_type)) +
  geom_density_ridges(alpha=0.7) +
  scale_x_continuous(limits=c(0,1),breaks=seq(0,1,0.1))+
  theme_ridges() + 
  ylab(NULL)+ xlab('relative loci')+
  theme(legend.position = "none")

p3

library(ggalluvial)
df2<- read.table("j.tsv",header = T)#读取文件

df2$class <- factor(df2$class, levels = c("RNA", "cds", "none",'multi-gene','crispr'))
df2$type <- factor(df2$type, levels = c("all", "y_int", "s_int",'tnp','others'))
p4=ggplot(df2, aes( x = type,y=percent,fill = class,
                   stratum = class, alluvium =class))+
  geom_stratum(width = 0.5)+
  geom_alluvium(alpha = 0.5,
                width = 0.5,color='grey')+
  scale_fill_manual(values=c('#4FB47F','#A6D6B1','#61B5DF','#E3E4D4','#7E7F81'))+
  scale_y_continuous(labels = scales::percent) +
  labs(x=NULL,
       y = "Percentage") +
  theme_bw()+theme(panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank())
p4
layout <- "
AA
BB
CC
DD
"
pp =p1+p2 + p3+p4+ plot_layout(design = layout)
pp


