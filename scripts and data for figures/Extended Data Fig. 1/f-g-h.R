library(ggplot2)  
library(patchwork)  

df1=read.table('F1_recall_precision_change_with_score.tsv',head=TRUE,sep='\t')

p1<- ggplot()+ 
  geom_line(df1,mapping=aes(x=attB_score,y=F1_score),color='grey',linewidth=1)+
  geom_point(df1,mapping=aes(x=attB_score,y=F1_score),shape=21,fill='#E2E9EE',size=2)+
  geom_line(df1,mapping=aes(x=attB_score,y=recall),color='grey',linewidth=1)+
  geom_point(df1,mapping=aes(x=attB_score,y=recall),shape=21,fill='#89B17C',size=2)+
  geom_line(df1,mapping=aes(x=attB_score,y=precision),color='grey',linewidth=1)+
  geom_point(df1,mapping=aes(x=attB_score,y=precision),shape=21,fill='#6E99BD',size=2)+
  scale_x_continuous(limits = c(0, 100), breaks = seq(0, 100, 20))+
  scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, 20))+
  ylab(NULL)+
  theme_bw()+theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank())
p1

p2<- ggplot()+ 
  geom_line(df1,mapping=aes(x=attB_score,y=F1_score),color='grey',linewidth=1)+
  geom_point(df1,mapping=aes(x=attB_score,y=F1_score),shape=21,fill='#E2E9EE',size=2)+
  geom_line(df1,mapping=aes(x=attB_score,y=recall),color='grey',linewidth=1)+
  geom_point(df1,mapping=aes(x=attB_score,y=recall),shape=21,fill='#89B17C',size=2)+
  geom_line(df1,mapping=aes(x=attB_score,y=precision),color='grey',linewidth=1)+
  geom_point(df1,mapping=aes(x=attB_score,y=precision),shape=21,fill='#6E99BD',size=2)+
  scale_x_continuous(limits = c(7, 60), breaks = seq(10, 60, 10))+
  scale_y_continuous(limits = c(88, 95), breaks = seq(88, 95, 1))+
  ylab(NULL)+
  theme_bw()+theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank())
p2


df2=read.table('3_db_F1score_recall_precision.tsv',head=TRUE,sep='\t')

df2$DB <- factor(df2$DB,levels = c('RefSeq_full','RefSeq_genus','NT'))
df2$type <- factor(df2$type,levels = c('F1_score','recall','precision'))
p3<-ggplot(df2,aes(x=type,y=num,fill=DB))+
  geom_col(width = 0.7,colour='black',linewidth=0.2, position = position_dodge(width = 0.8))+
  geom_text(
    aes(label = num),
    position = position_dodge(width = 0.8),
    vjust = -0.5, 
    size = 3.5,   
  ) +
  scale_fill_manual(values=c('#3E86B6','#82BDDE','#DFC27D'))+
  theme_bw()+theme(panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank(),legend.position=c(0.5,0.5))+
  scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, 20))+
  ylab('Percentage (%)')+xlab('DB')
p3

df3=read.table('time_consum_against_refseq_genus.tsv',head=TRUE,sep='\t')

df3$label <- with(df3, paste0("(", cpus, ", ", time, ")"))
p4<- ggplot()+ 
  geom_line(df3,mapping=aes(x=cpus,y=time),color='grey',linewidth=1)+
  geom_point(df3,mapping=aes(x=cpus,y=time),shape=21,fill='#E2E9EE',size=2)+
  geom_text(data = df3, 
            aes(x = cpus, y = time, label = label),
            hjust = -0.1,  # 向右偏移
            vjust = 0.5,  # 垂直居中
            size = 3,     # 字体大小
            color = "black") +
  scale_x_continuous(limits = c(0, 80), breaks = seq(0, 80, 20))+
  scale_y_continuous(limits = c(0, 200), breaks = seq(0, 200, 50))+
  ylab('Time (s)')+xlab('CPUs')+
  theme_bw()+theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank())
p4

p=p1+p2+p3+p4
p
