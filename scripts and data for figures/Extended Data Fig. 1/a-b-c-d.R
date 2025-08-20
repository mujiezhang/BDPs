library(ggplot2)
library(patchwork)

df1=read.table('host-type-and-att-distribution.tsv',head=TRUE,sep='\t')
df1$Type <- factor(df1$Type,levels = c('Bacteria','Archaea'))
df1$att_length <- as.numeric(as.character(df1$att_length))

p1<-ggplot(df1,aes(x=Type,fill=Type))+
  geom_bar(width = 0.7,colour='black',linewidth=0.2)+ylim(0,300)+
  geom_text(aes(label =after_stat(count)),stat = "count",vjust = -0.5,size = 3,color = "black") +
  scale_fill_manual(values=c('#dfc27d','#82bdde'))+
  theme_bw()+theme(panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank(),legend.position= 'none')+
  ylab('Virus')+xlab('Host domain')
p1
p2<-ggplot(df1,aes(x=att_length))+
  geom_histogram(binwidth=5,fill='steelblue',color="black",linewidth=0.1) +
  scale_x_continuous(breaks=seq(5,225,20))+
  theme_bw()+theme(panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank(),legend.position= 'none')+
  ylab('Virus')+xlab('att length (bp)')
p2
layout <- "
ABBB
"
p=p1 + p2  + plot_layout(design = layout)
p

library(ggbreak)
df2=read.table('viral_prediction_ave_error.tsv',head=TRUE,sep='\t')
df3=read.table('viral_prediction_error.tsv',head=TRUE,sep='\t')

df2$tools <- factor(df2$tools,levels = c('geNomad','DBSCAN-SWA','VIBRANT','Phigaro','PHASTEST','PhiSpy','VirSorter2'))
df3$tools <- factor(df3$tools,levels = c('geNomad','DBSCAN-SWA','VIBRANT','Phigaro','PHASTEST','PhiSpy','VirSorter2'))

p3<-ggplot(df2,aes(x=tools,y=ave_error/1000,fill=tools))+
  geom_col(width = 0.7,colour='black',linewidth=0.2)+
  scale_fill_manual(values=c('#284553','#29736f','#2d9c92','#89b17c','#e6c66d','#f0a564','#e47253'))+
  theme_bw()+theme(panel.grid.major = element_blank(),
                   axis.text.x = element_text(angle = 45,vjust = 0.5,hjust = 0.5),
                   panel.grid.minor = element_blank(),legend.position= 'none')+
  geom_text(aes(label=ave_error/1000, y=(ave_error/1000)+0.4), position=position_dodge(0.9), vjust=0)+
  ylab('Ave prediction error (kb)')+xlab(NULL)+scale_y_break(c(15,80),space = 0.3,scales = 0.6)+ylim(0,100)
p3
p4<-ggplot(df3,aes(x=tools,y=error,fill=tools))+
  geom_boxplot(outlier.shape = NA)+
  scale_fill_manual(values=c('#284553','#29736f','#2d9c92','#89b17c','#e6c66d','#f0a564','#e47253'))+
  ylim(-20000,100000)+
  theme_bw()+theme(panel.grid.major = element_blank(),
                   axis.text.x = element_text(angle = 45,vjust = 0.5,hjust = 0.5),
                   panel.grid.minor = element_blank(),legend.position= 'none')+
  ylab('Prediction error (bp)')+xlab(NULL)+
  geom_jitter(width=0.08,size=0.5,alpha=1,fill='black')
p4


pp=p3/p4
pp

