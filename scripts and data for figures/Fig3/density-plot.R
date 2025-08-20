
df1=read.table('att_length.tsv',head=TRUE,sep='\t')

library(ggthemes)
library(ggridges)
library(ggplot2)
library(patchwork)
library(ggsci)
library(RColorBrewer)
df1$class <- factor(df1$class,levels = c('Verrucomicrobiae','Chlamydiia','Planctomycetia','Rhodothermia',
'Bacteroidia','Leptospirae','Brachyspirae','Spirochaetia','Gammaproteobacteria','Alphaproteobacteria',
'Campylobacteria','Desulfuromonadia','Myxococcia','Desulfovibrionia','Negativicutes','Bacilli',
'Clostridia','Bacilli_A','Fusobacteriia','Cyanobacteriia','Coriobacteriia','Actinomycetes',
'Deinococci','Thermotogae','Synergistia','Thermococci','Thermoprotei_A','Methanobacteria','Thermoplasmata',
'Halobacteria','Methanomicrobia','Methanosarcinia'))

col5<-colorRampPalette(brewer.pal(8,'Dark2'))(36)
scales::show_col(col5)

p1<-ggplot(df1, aes(x=att_length,y = class, fill = class)) +
  geom_density_ridges(alpha=0.7) +
  scale_fill_manual(values=rev(col5))+
  scale_x_continuous(limits=c(0,160),breaks=seq(0,160,20))+
  theme_hc() + xlab(NULL)+
  theme(legend.position = "none")

p1


