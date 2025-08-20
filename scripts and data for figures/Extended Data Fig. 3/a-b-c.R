
library(ggplot2)

df1 = read.table('cds.txt', head=TRUE, sep='\t')
df1$gene <- factor(df1$gene, levels = rev(unique(df1$gene)))
p1 <- ggplot(df1, aes(x=gene, y=counts)) +
  geom_col(width = 0.7, colour='black', linewidth=0.2, aes(fill=counts)) +
  scale_fill_gradient(low="#c6dbf0", high="#6baed8") +  
  scale_y_continuous(limits=c(0,10100),breaks=seq(0,10000,2000))+ 
  theme_bw() + 
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position = 'none') +
  ylab('Counts') + coord_flip()+
  xlab(NULL)
p1

df2 = read.table('tRNA.txt', head=TRUE, sep='\t')

df2$tRNA <- factor(df2$tRNA, levels = unique(df2$tRNA))

p2 <- ggplot(df2, aes(x=tRNA, y=Count)) +
  geom_col(width = 0.7, colour='black', linewidth=0.2, aes(fill=Count)) + 
  geom_text(aes(label=Count), vjust=-0.5, size=3) +
  scale_fill_gradient(low="#c6dbf0", high="#6baed8") +ylim(0,32000)+ 
  theme_bw() + 
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position = 'none',
        axis.text.x = element_text(angle = 45, hjust = 1)) +
  ylab('tRNAs') + 
  xlab(NULL)

p2

library(pheatmap)
heatmap_data <- read.csv("arc-bac-integration_region_for-heatmap.tsv", row.names = 1,sep='\t',header=TRUE)
bk2 <- c(seq(0,6,by=0.001))
t1 <- pheatmap(heatmap_data,
               cellwidth = 20, cellheight = 10,
               cluster_rows = F,
               cluster_cols =F,
               fontsize=10,
               breaks=bk2,
               color = c(colorRampPalette(colors = c("#1d91c0","white"))(length(bk2)*5/60),
                         colorRampPalette(colors = c("white","#ffbb25"))(length(bk2)*5/60),
                         colorRampPalette(colors = c("#ffbb25","#990000"))(length(bk2)*50/60)),
               show_rownames = T,
               show_colnames = T
)
t1




