

library(ggplot2)
library(dplyr)
library(ggforce)  # 新增依赖包，需要先安装

# 设置路径
input_dir <- "path_to/depth"
output_dir <- "path_to/plot"

# 创建输出目录（如果不存在）
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# 获取所有 .tsv 文件
files <- list.files(path = input_dir, pattern = "\\.tsv$", full.names = TRUE)
filenames <- list.files(path = input_dir, pattern = "\\.tsv$")

# 循环处理每个文件
for (i in seq_along(files)) {
  file_path <- files[i]
  file_name <- tools::file_path_sans_ext(filenames[i])
  
  # 从文件名提取竖线位置（保持原逻辑不变）
  split_name <- unlist(strsplit(file_name, "-"))
  if (length(split_name) < 2) {
    message("跳过文件（缺少分隔符）: ", file_name)
    next
  }
  
  vline1 <- as.numeric(split_name[length(split_name)-1])
  vline2 <- as.numeric(split_name[length(split_name)])
  
  # 检查数值有效性
  if (any(is.na(c(vline1, vline2)))) {
    message("无效坐标值在文件: ", file_name)
    next
  }
  
  # 读取数据
  data <- read.delim(file_path, header = FALSE, col.names = c("position", "coverage"))
  
  # 检查是否为空
  if (nrow(data) == 0) {
    message("警告：空数据文件 ", file_name)
    next
  }
  
  # 绘图（修改部分：将 geom_line 改为 geom_xspline）
  p <- ggplot(data, aes(x = position, y = coverage)) + 
    geom_line(color = "steelblue") +
    geom_vline(
      xintercept = c(vline1, vline2),
      color = c("red", "red"),
      linetype = "dashed",
      linewidth = 0.8
    ) +
    scale_x_continuous(
      breaks = seq(0, max(data$position), by = 5000),
      labels = scales::comma
    ) +
    labs(
      title = paste( file_name),
      x = "Genomic Position",
      y = "Coverage Depth"
    ) +
    theme_bw() +
    theme(
      plot.title = element_text(hjust = 0.5, face = "bold"),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank()
    )
  
  # 保存为PNG
  output_path <- file.path(output_dir, paste0(file_name, ".pdf"))
  ggsave(
    filename = output_path,
    plot = p,
    width = 5,
    height = 2
  )
  
  message("已保存: ", output_path)
}
