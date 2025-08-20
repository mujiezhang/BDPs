library(patchwork)
library(ggplot2)
options(scipen = 200)
df1=read.table('example-tools-prediction-for-r.tsv',head=TRUE,sep='\t')
df_contig1 <- df1[df1$phage == 'Lambda', ]
df_contig2 <- df1[df1$phage == 'B3', ]
df_contig3 <- df1[df1$phage == 'P22', ]
custom_colors <- c(
                  'True boundary'='red',
                  "geNomad" = "#284553", 
                   "VIBRANT" = "#29736f", 
                   "VirSorter2" = "#2d9c92", 
                   'PHASTEST'='#89b17c',
                   "PhiSpy" = "#e6c66d", 
                   "DBSCAN-SWA" = "#f0a564",
                   "Phigaro" = "#e47253")

df_contig1$tools <- factor(df_contig1$tools, levels =c("VirSorter2","PhiSpy",'PHASTEST',
                                         "Phigaro","VIBRANT","DBSCAN-SWA","geNomad",
                                         'True boundary'))
df_contig2$tools <- factor(df_contig2$tools, levels =c("VirSorter2","PhiSpy",'PHASTEST',
                                                       "Phigaro","VIBRANT","DBSCAN-SWA","geNomad",
                                                       'True boundary'))
df_contig3$tools <- factor(df_contig3$tools, levels =c("VirSorter2","PhiSpy",'PHASTEST',
                                                       "Phigaro","VIBRANT","DBSCAN-SWA","geNomad",
                                                       'True boundary'))
# Create the plot
p1 <- ggplot(df_contig1, aes(x = start, xend = end, y = tools, yend = tools, color = tools)) +
  geom_segment(linewidth = 4,color = "black") +
  geom_segment(linewidth = 3) + 
  geom_text(aes(x = start, label = start), hjust =1.2, vjust = 0.5, color = "black") +  
  geom_text(aes(x = end, label = end), hjust =-0.2, vjust = 0.3, color = "black") +  
  scale_y_discrete(expand = expansion(mult = c(0.05, 0.05)))+
  scale_x_continuous(name = "Position",position = "top", limits = c(min(df_contig1$start) - 3000, max(df_contig1$end) + 3000)) +  
  scale_color_manual(values = custom_colors) +  
  theme_bw() +  
  xlab('none')+ 
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title.x = element_blank(), axis.title.y = element_blank(),
        axis.line.y = element_blank(),
        legend.position = "none")

p1
p2 <- ggplot(df_contig2, aes(x = start, xend = end, y = tools, yend = tools, color = tools)) +
  geom_segment(linewidth = 4,color = "black") +
  geom_segment(linewidth = 3) +  
  geom_text(aes(x = start, label = start),hjust =1.2, vjust = 0.5, color = "black") +  
  geom_text(aes(x = end, label = end), hjust =-0.2, vjust = 0.3, color = "black") +  
  scale_y_discrete(expand = expansion(mult = c(0.05, 0.05)))+
  scale_x_continuous(name = "Position",position = "top", limits = c(min(df_contig2$start) - 3000, max(df_contig2$end) + 3000)) +
  scale_color_manual(values = custom_colors) + 
  theme_bw() + 
  xlab('none')+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title.x = element_blank(), axis.title.y = element_blank(),
        axis.line.y = element_blank(),
        legend.position = "none")

p2
p3 <- ggplot(df_contig3, aes(x = start, xend = end, y = tools, yend = tools, color = tools)) +
  geom_segment(linewidth = 4,color = "black") +
  geom_segment(linewidth = 3) +
  geom_text(aes(x = start, label = start), hjust =1.2, vjust = 0.5, color = "black") + 
  geom_text(aes(x = end, label = end), hjust =-0.2, vjust = 0.3, color = "black") + 
  scale_y_discrete(expand = expansion(mult = c(0.05, 0.05)))+
  scale_x_continuous(name = "Position",position = "top", limits = c(min(df_contig3$start) - 3000, max(df_contig3$end) + 3000)) +  
  scale_color_manual(values = custom_colors) +  
  theme_bw() +  
  xlab('none')+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title.x = element_blank(), axis.title.y = element_blank(),
        axis.line.y = element_blank(),
        legend.position = "none")

p3
p = p1/p2/p3
p


