library(ggplot2)
library(dplyr)

df1 <- read.table("Mu.tsv", header=TRUE,sep='\t')

p1=ggplot(df1, aes(x=position, y=richness)) + 
  geom_line(color = "steelblue")   + 
  scale_x_continuous(breaks = seq(0, max(df1$position), by = 5000))+
  labs(title="Escherichia phage Mu-CP118014.1-4474808-4511534", x="Position", y="Hits accumulation")+
  theme_bw() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank())
p1

