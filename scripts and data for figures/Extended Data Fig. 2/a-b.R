library('UpSetR')
library(openxlsx)
library(RColorBrewer)
library(ggthemes)
library(ggridges)
library(ggplot2)

data<-read.xlsx("for-upset.xlsx",sep=',')
data2 = apply(data, 2, na.omit)

p1<- upset(fromList(data2),order.by = "freq",mb.ratio = c(0.7, 0.3),
          point.size = 3, mainbar.y.label = "proviral genomes",
          text.scale = c(1.3, 1.3, 1, 1, 1.2, 1),
          sets.x.label = "proviral genomes",matrix.color = "#033250",
          sets=c("Defense","Anti-defense","VFG",'AMP','ARG'),
          shade.color="#ADC5CF")
p1

df1=read.table('function-gene-location.tsv',head=TRUE,sep='\t')


df1$type <- factor(df1$type,levels = c('ARG','AMP','Anti-defense','Defense','VFG'))
df1$location <- as.numeric(as.character(df1$location ))
p2<-ggplot(df1, aes(x=location,y = type, fill = type)) +
  geom_density_ridges(alpha=0.7) +
  scale_x_continuous(limits=c(0,1),breaks=seq(0,1,0.2))+
  theme_ridges() + xlab('Relative location')+ylab(NULL)+
  theme(legend.position = "none")

p2
