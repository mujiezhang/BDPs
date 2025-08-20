
library(ggplot2)
library(ggalluvial)
library(gghalves)
library(patchwork)

df1<- read.table("e.tsv",header = T)
df1$class <- factor(df1$class, levels = c( "multi",'single'))
df1$type <- factor(df1$type, levels = c("votu", "genus",'family'))
p1=ggplot(df1, aes( x = type,y=percent,fill = class,
                   stratum = class, alluvium =class))+
  geom_stratum(width = 0.5)+
  geom_alluvium(alpha = 0.5,
                width = 0.5,color='grey')+
  scale_fill_manual(values=c('#B9D2E7','#F0A298'))+
  scale_y_continuous(labels = scales::percent) +
  labs(x=NULL,
       y = "Percentage") +
  theme_bw()+theme(panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank(),legend.position = 'none')
p1


df2<- read.table("f.tsv",header = T)

df2$type <- factor(df2$type, levels = c("votu", "genus",'family'))
p2<- ggplot(df2,aes(x=type,y=cv))+
  geom_violin(aes(fill = type),trim=FALSE,alpha=0.5)+
  stat_summary(fun = mean, geom = "point",color = "red",size = 3, shape = 19 ) +
  stat_summary(fun = mean,geom = "text",aes(label = round(after_stat(y), 2)),color = "black",size = 4,vjust = -1.5,fontface = "bold" ) +
  xlab(NULL)+ylab('att clusters')+
  theme_bw()+theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank(),
                   legend.position = 'none')
p2

df3<- read.table("g.tsv",header = T)#读取文件
df4<- read.table("h.tsv",header = T)
df3$class <- factor(df3$class, levels = c( "multi",'single'))
df3$type <- factor(df3$type, levels = c("votu", "genus",'family'))
df4$type <- factor(df4$type, levels = c("votu", "genus",'family'))
p3=ggplot(df3, aes( x = type,y=percent,fill = class,
                    stratum = class, alluvium =class))+
  geom_stratum(width = 0.5)+
  geom_alluvium(alpha = 0.5,
                width = 0.5,color='grey')+
  scale_fill_manual(values=c('#B9D2E7','#F0A298'))+
  scale_y_continuous(labels = scales::percent) +
  labs(x=NULL,
       y = "Percentage") +
  theme_bw()+theme(panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank(),legend.position = 'none')
p3
p4<- ggplot(df4,aes(x=type,y=cv))+
  geom_violin(aes(fill = type),trim=FALSE,alpha=0.5)+
  stat_summary(fun = mean, geom = "point",color = "red",size = 3, shape = 19 ) +
  stat_summary(fun = mean,geom = "text",aes(label = round(after_stat(y), 2)),color = "black",size = 4,vjust = -1.5,fontface = "bold" ) +
  xlab(NULL)+ylab('Coefficient of Variation')+
  theme_bw()+theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank(),
                   legend.position = 'none')
p4

p=p1/p2/p3/p4

p
