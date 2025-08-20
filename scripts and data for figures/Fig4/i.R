
df1=read.table('genus_1_HSC-median.tsv',head=TRUE,sep='\t',fileEncoding = 'GBK')

library(ggplot2)  
library(patchwork)  
library(grid)
library(RColorBrewer)
library(ggpmisc)
library(dplyr)
color_palette <- colorRampPalette(c("#bad6f3", "white", "#f3baba"))(100)
gradient_matrix_horizontal <- matrix(scales::alpha(color_palette, 0.5), nrow = 1)
# 创建渐变背景
gradient_grob <- rasterGrob(gradient_matrix_horizontal, 
                            width = unit(1, "npc"), 
                            height = unit(1, "npc"))


p1 <- ggplot(df1, aes(x = num, y = cov)) +  
  annotation_custom(gradient_grob, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
  geom_point(aes(fill = type), shape = 21, size = 3) +
  scale_fill_manual(values = c('#4682B4', '#EDEDD9')) +
  geom_line(aes(group = type), color = "grey", linewidth = 1) +
  geom_smooth(aes(color = type, group = type),
              method = "lm", formula = y ~ x, se = TRUE,
              linetype = 2, fill = NA, linewidth = 0.8) +
  stat_poly_eq(aes(color = type, group = type,
                   label = paste(after_stat(eq.label),
                                 after_stat(rr.label),
                                 after_stat(p.value.label),
                                 sep = "*\", \"*")),
               formula = y ~ x,
               parse = TRUE,
               size = 3,
               label.x = 40, 
               label.y = c(80, 60)) + 
  ylim(0, 100) +
  xlab('Subject-HSC') +
  ylab('Query-HSC') +
  theme_bw() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position = 'none',
        axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))

p1

