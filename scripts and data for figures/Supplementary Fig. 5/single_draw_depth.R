library(ggplot2)
library(dplyr)
library(tidyr)
library(patchwork)  # 用于组合多个图形

# 读取测序深度数据
depth_data <- read.table("DRR107304.depth", 
                         header = FALSE, 
                         col.names = c("Contig", "Position", "Depth"))

# 读取contig起始区域信息
phage_data <- read.table("DRR107304_pos.txt", 
                         header = FALSE, sep = "\t", 
                         col.names = c("SRR", "Contig", "Regions", "Phage"))

# 同时对 Regions 和 Phage 进行拆分，保持一一对应关系
phage_regions <- phage_data %>%
  separate_rows(Regions, Phage, sep = ",") %>%
  separate(Regions, into = c("Start", "End"), sep = "-", convert = TRUE)

# 过滤出与测序深度文件中 Contig 匹配的部分
filtered_regions <- phage_regions %>%
  filter(Contig %in% unique(depth_data$Contig))

# 主图：绘制测序深度图
p_main <- ggplot(depth_data, aes(x = Position, y = Depth)) +
  geom_line(color = "blue") +
  facet_wrap(~ Contig, scales = "free_x") +  # 按Contig分面绘制
  geom_rect(data = filtered_regions, aes(xmin = Start, xmax = End, ymin = -Inf, ymax = Inf),
            fill = "red", alpha = 0.2, inherit.aes = FALSE) +  # 突出背景区域
  theme_minimal() +
  labs(title = "DRR107304 Depth Plot with Phage Regions",
       x = "Genomic Position",
       y = "Depth Coverage")

# 细节图：为每一组起始位点生成细节图，标题中使用对应的Phage名称
detail_plots <- lapply(1:nrow(filtered_regions), function(i) {
  region <- filtered_regions[i, ]
  contig <- region$Contig
  start <- region$Start
  end <- region$End
  phage_name <- region$Phage  # 获取对应的phage名称
  
  # 提取细节区域的数据（横坐标范围扩展5000个单位）
  detail_data <- depth_data %>%
    filter(Contig == contig, Position >= (start - 50000), Position <= (end + 5000))
  
  # 绘制细节图，标题中显示对应的Phage信息
  ggplot(detail_data, aes(x = Position, y = Depth)) +
    geom_line(color = "blue") +
    geom_vline(xintercept = c(start, end), color = "red", linetype = "dashed") +  # 标记起始和结束位置
    theme_minimal() +
    labs(title = paste("Detail:", phage_name, "Region", start, "-", end),
         x = "Genomic Position",
         y = "Depth Coverage")
})

# 使用 patchwork 组合主图和细节图（主图在上，细节图在下）
combined_plot <- p_main / wrap_plots(detail_plots, ncol = 1)

# 显示组合图形
#print(combined_plot)

# 保存组合图到指定位置
ggsave("./DRR107304_plot.png", plot = combined_plot, width = 10, height = 12, dpi = 300)

