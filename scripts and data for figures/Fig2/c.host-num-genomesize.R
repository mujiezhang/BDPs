
df1=read.table('host_number100_att_length_genome_length.tsv',head=TRUE,sep='\t')
df2=read.table('annotation.tsv ',head=TRUE,sep='\t')
library(ggthemes)
library(ggplot2)
library(patchwork)
library(ggsci)
library(RColorBrewer)
library(ggpmisc)
library(grid)
library(ggridges)
color_palette <- colorRampPalette(c("#bad6f3", "white", "#f3baba"))(100)
gradient_matrix_horizontal <- matrix(scales::alpha(color_palette, 0.5), nrow = 1)
# 创建渐变背景
gradient_grob <- rasterGrob(gradient_matrix_horizontal, 
                            width = unit(1, "npc"), 
                            height = unit(1, "npc"))

df2$class <- factor(df2$class,levels = c('Gammaproteobacteria','Bacilli','Actinomycetes','Bacteroidia','Alphaproteobacteria',
                                         'Clostridia','Campylobacteria','Bacilli_A','Cyanobacteriia','Negativicutes','Coriobacteriia',
                                         'Spirochaetia','Leptospirae','Fusobacteriia','Verrucomicrobiae','Chlamydiia','Desulfovibrionia','Deinococci',
                                         'Brachyspirae','Planctomycetia','Rhodothermia','Myxococcia','Thermotogae','Synergistia',
                                         'Desulfuromonadia','Halobacteria','Methanobacteria','Thermoprotei_A','Methanosarcinia',
                                         'Methanomicrobia','Thermococci','Thermoplasmata'))
df1$class <- factor(df1$class,levels = c('Gammaproteobacteria','Bacilli','Actinomycetes','Bacteroidia','Alphaproteobacteria',
                                         'Clostridia','Campylobacteria','Bacilli_A','Cyanobacteriia','Negativicutes','Coriobacteriia',
                                         'Spirochaetia','Leptospirae','Fusobacteriia','Verrucomicrobiae','Chlamydiia','Desulfovibrionia','Deinococci',
                                         'Brachyspirae','Planctomycetia','Rhodothermia','Myxococcia','Thermotogae','Synergistia',
                                         'Desulfuromonadia','Halobacteria','Methanobacteria','Thermoprotei_A','Methanosarcinia',
                                         'Methanomicrobia','Thermococci','Thermoplasmata'))                                       
col5<-colorRampPalette(brewer.pal(8,'Dark2'))(36)
scales::show_col(col5)


p1<-ggplot(df2, aes(x=class,y = host2)) +
  annotation_custom(gradient_grob, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
  geom_col(width = 0.7,colour='black',linewidth=0.2,fill='#4682B4')+
  theme_bw()+  scale_y_continuous(limits=c(0,5.5),breaks=seq(0,5,1))+
  ylab(NULL)+xlab(NULL)+
  theme(axis.text.x = element_text(angle = 90,vjust=0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position = "none")
p1

p2<-ggplot(df2, aes(x=class,y = BDP_ratio/100)) +
  annotation_custom(gradient_grob, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
  geom_col(width = 0.7,colour='black',linewidth=0.2,fill='#4682B4')+
  theme_bw()+ 
  ylab(NULL)+xlab(NULL)+
  theme(axis.text.x = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position = "none")

p2
p3<-ggplot(df1, aes(x=genome_length/1000,y = class, fill = class)) +
  geom_density_ridges(alpha=0.7) +
  scale_fill_manual(values=rev(col5))+
  scale_x_continuous(limits=c(0,100),breaks=seq(0,100,20))+
  theme_bw() + 
  ylab(NULL)+xlab(NULL)+coord_flip()+
  theme(axis.text.x = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position = "none")
p3
layout <- "
A
A
B
C
"
p <- p3+p2 + p1+ plot_layout(design = layout)
p

