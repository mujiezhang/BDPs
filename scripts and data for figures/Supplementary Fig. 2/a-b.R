library(ggplot2)
library(ggpubr)
library(dplyr)
library(patchwork)  

df1=read.table('top10_genus_len.tsv',head=TRUE,sep='\t')
df2=read.table('top10_family_len.tsv',head=TRUE,sep='\t')

df1$cluster <- factor(df1$cluster,levels = c('genus_1','genus_2','genus_3','genus_4','genus_5',
                                             'genus_6','genus_7','genus_8','genus_9','genus_10'))
df2$cluster <- factor(df2$cluster,levels = c('family_1','family_2','family_3','family_4','family_5',
                                             'family_6','family_7','family_8','family_9','family_10'))

p1 <- ggplot(df1, aes(x = cluster, y = genome_size/1000, fill = type)) +
  geom_boxplot(position = position_dodge(width = 0.8),outlier.shape = NA) +  # 并排箱线图
  scale_fill_manual(values=c('#AECCE8','#EAB579'))+
  labs(x = NULL, y = "Genome size (kb)") +ylim(0,100)+
  theme_bw()+
  theme(axis.text.x =element_text(angle = 45, hjust = 1, vjust = 1),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())
p1
p2 <- ggplot(df2, aes(x = cluster, y = genome_size/1000, fill = type)) +
  geom_boxplot(position = position_dodge(width = 0.8),outlier.shape = NA) +  # 并排箱线图
  labs(x = NULL, y = "Genome size (kb)") +ylim(0,100)+
  theme_bw()+
  scale_fill_manual(values=c('#AECCE8','#EAB579'))+
  theme(axis.text.x =element_text(angle = 45, hjust = 1, vjust = 1),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())
p2
p=p1/p2
p

