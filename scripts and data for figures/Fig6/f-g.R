library(ggplot2)
library(dplyr)
options(scipen = 999)
df1 <- read.delim("NZ_FVKI01000004.1__310000-325000-310821-322280.tsv", header=FALSE, col.names=c("position", "coverage"))
df2 <- read.delim("NZ_JAZHCX010000002.1__1145000-1155000-1141828-1159871.tsv", header=FALSE, col.names=c("position", "coverage"))

p1 <- ggplot(df1, aes(x = position, y = coverage)) + 
  geom_line(color='#4682B4',linewidth=1)+
  geom_vline(xintercept = c(310821,322280),color = c("red", "red"),linetype = "dashed",linewidth = 0.8) +
  scale_x_continuous(breaks = seq(0, max(data$position), by = 2000),labels = scales::comma) +
  labs( x = "Genomic Position", y = "Read depth") +
  theme_bw() +
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())
p1
p2 <- ggplot(df2, aes(x = position, y = coverage)) + 
  geom_line(color='#4682B4',linewidth=1)+
  geom_vline(xintercept = c(1141828,1159871),color = c("red", "red"),linetype = "dashed",linewidth = 0.8) +
  scale_x_continuous(breaks = seq(0, max(data$position), by = 2000),labels = scales::comma) +
  labs( x = "Genomic Position", y = "Read depth") +
  theme_bw() +
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())
p2
