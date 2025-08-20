library(ggplot2)
library(patchwork)
library(dplyr)
library(grid)
library(RColorBrewer)
library(ggpmisc)


level_vec_family <- c('10-20','20-30','30-40','40-50','50-60','60-70','70-80','80-90','90-100')
level_vec_genus <- c('20-30','30-40','40-50','50-60','60-70','70-80','80-90','90-100')
point_size <- 2.5
line_size <- 0.7
base_theme <- function() {
  theme_bw() +
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      legend.position = 'none',
      axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size = 8),
      axis.title = element_text(size = 9),
      plot.title = element_text(size = 10, hjust = 0.5, face = "bold")
    )
}
color_palette <- colorRampPalette(c("#bad6f3", "white", "#f3baba"))(100)
gradient_matrix_horizontal <- matrix(scales::alpha(color_palette, 0.5), nrow = 1)
# 创建渐变背景
gradient_grob <- rasterGrob(gradient_matrix_horizontal, 
                            width = unit(1, "npc"), 
                            height = unit(1, "npc"))
# ==================== 绘制Family 2-10子图 ====================
family_data <- read.table('family_2-10-median.tsv', header = TRUE, sep = '\t')
family_data$num <- factor(family_data$num, levels = level_vec_family)

family_plots <- list()
families <- unique(family_data$family)

for (fam in families) {
  df_sub <- family_data %>% filter(family == fam)
  
  p <- ggplot(df_sub, aes(x = num, y = cov, group = type)) +
    annotation_custom(gradient_grob, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
    geom_line(color = "grey50", size = line_size) +
    geom_point(aes(fill = type), shape = 21, size = point_size) +
    scale_fill_manual(values = c('#4682B4', '#EDEDD9')) +
    scale_y_continuous(limits = c(0, 100), expand = c(0, 0)) +
    labs(
      x = 'coverage (%)',
      y = 'coverage (%)',
      title = fam
    ) +
    base_theme()
  
  family_plots[[fam]] <- p
}


combined_family <- wrap_plots(family_plots, ncol = 3)
combined_family
# ==================== 绘制Genus 2-10子图 ====================
genus_data <- read.table('genus_2-10-median.tsv', header = TRUE, sep = '\t')
genus_data$num <- factor(genus_data$num, levels = level_vec_genus)

genus_plots <- list()
genera <- unique(genus_data$genus)

for (gen in genera) {
  df_sub <- genus_data %>% filter(genus == gen)
  
  p <- ggplot(df_sub, aes(x = num, y = cov, group = type)) +
    annotation_custom(gradient_grob, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
    geom_line(color = "grey50", size = line_size) +
    geom_point(aes(fill = type), shape = 21, size = point_size) +
    scale_fill_manual(values = c('#4682B4', '#EDEDD9')) +
    scale_y_continuous(limits = c(0, 100), expand = c(0, 0)) +
    labs(
      x = 'coverage (%)',
      y = 'coverage (%)',
      title = gen
    ) +
    base_theme()
  
  genus_plots[[gen]] <- p
}


combined_genus <- wrap_plots(genus_plots, ncol = 3) 
combined_genus

p=combined_genus /combined_family
p
