library(ggplot2)
library(patchwork)
setwd('E:/课题/5.att/github/analysis-and-figure/fig1')
df1=read.table('recall-and-precision-f1score.tsv',head=TRUE,sep='\t')
df2=read.table('error_bar_before_and_after.tsv',head=TRUE,sep='\t')


df1$tools <- factor(df1$tools,levels = c('ProBord','TIGER','PHASTEST'))
df1$type<- factor(df1$type,levels = c('F1 score','Recall','Precision'))

df2$state <- factor(df2$state,levels = c('before','after'))

p1<-ggplot(df1,aes(x=type,y=Percentage,fill=tools))+
  geom_col(position = position_dodge(width = 0.7),width = 0.7,colour='black',linewidth=0.2)+
  scale_fill_manual(values=c('#ABD6B0','#3EB9E4','#E3E3D2'))+
  theme_bw()+theme(panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank(), legend.position = "top")+
  scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, 20))+
  ylab('Percentage (%)')+xlab(NULL)
p1

p2<-ggplot(df2,aes(x=state,y=err,fill=state,label=err))+
  geom_col(width = 0.7,colour='black',linewidth=0.2)+
  scale_fill_manual(values=c('#dfc27d','#82bdde'))+#ylim(0,100)+
  geom_text( vjust = -0.5,           
             color = "black"                    
  ) +
  theme_bw()+theme(panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank(),legend.position= 'none')+
  ylab('Error prediction length (bp)')+xlab(NULL)
p2

