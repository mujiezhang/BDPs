library(ggplot2)  
library(patchwork)  

df1=read.table('in_range.tsv',head=TRUE,sep='\t')
df2=read.table('out_range.tsv',head=TRUE,sep='\t')

df1$taxon <- factor(df1$taxon,levels = c('species','genus','family','order','class','phylum'))
df2$taxon <- factor(df2$taxon,levels = c('species','genus','family','order','class','phylum'))
p1<-ggplot(df1,aes(x=taxon,y=ratio,fill=taxon))+
  geom_col(width = 0.7,colour='black',linewidth=0.2)+
  scale_fill_manual(values=c('#DCDCFE','#FECF99','#999999','#CCCCCC','#C99BCC','#E6CCE7'))+
  geom_text(aes(label= sprintf("%.2f", ratio),y=ratio-4))+
  ylim(0,100)+
  theme_bw()+theme(panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank(),legend.position= 'none')+

  ylab('attB from same taxon (%)')+xlab(NULL)
p1

p2<-ggplot(df2,aes(x=taxon,y=ratio,fill=taxon))+
  geom_col(width = 0.7,colour='black',linewidth=0.2)+
  scale_fill_manual(values=c('#DCDCFE','#FECF99','#999999','#CCCCCC','#C99BCC','#E6CCE7'))+
  geom_text(aes(label= sprintf("%.2f", ratio),y=ratio-4))+
  ylim(0,100)+
  theme_bw()+theme(panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank(),legend.position= 'none')+
  
  ylab('attB from other taxon (%)')+xlab(NULL)
p2
p=p1/p2
p

