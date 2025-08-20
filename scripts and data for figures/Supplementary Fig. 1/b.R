
df1=read.table('vOTU_accumulate_data.txt',head=TRUE,sep='\t')
df2=read.table('genus_accumulate_data.txt',head=TRUE,sep='\t')
df3=read.table('family_accumulate_data.txt',head=TRUE,sep='\t')

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
p1<- ggplot() +
  annotation_custom(gradient_grob, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
  geom_smooth(df1,mapping=aes(x = sample_size/1000, y = vcs),se= FALSE,color='#4b80aa',linewidth=1)+
  geom_point(df1,mapping=aes(x = sample_size/1000, y = vcs),fill='#4b80aa',color='#4b80aa',size=1.5,shape=21,alpha=0.7) +
  geom_hline(yintercept = 102018, color = "grey", linetype = "dashed") +
  geom_vline(xintercept = 430.134, color = "grey", linetype = "dashed") +
  geom_hline(yintercept = 7962, color = "grey", linetype = "dashed") +
  geom_hline(yintercept = 1248, color = "grey", linetype = "dashed") +
  geom_smooth(df2,mapping=aes(x = sample_size/1000, y = vcs),se= FALSE,color='#9cc6df',linewidth=1)+
  geom_point(df2,mapping=aes(x = sample_size/1000, y = vcs),fill='#9cc6df',color='#9cc6df',size=1.5,shape=21,alpha=0.7) +
  geom_smooth(df3,mapping=aes(x = sample_size/1000, y = vcs),se= FALSE,color='#c8dde8',linewidth=1)+
  geom_point(df3,mapping=aes(x = sample_size/1000, y = vcs),fill='#c8dde8',color='#c8dde8',size=1.5,shape=21,alpha=0.7) +
  scale_x_continuous(limits=c(0,450),breaks=seq(0,450,80))+
  theme_bw() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  ylab('Viral clusters') +
  xlab("Viruses (×103)")
p1

