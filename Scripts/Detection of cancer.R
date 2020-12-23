pacman::p_load(dplyr, readxl, ggplot2, scales)

#rna는 정상 세포와 암세포 각각의 RNA 발현량을 담고 있음 -> 원발암 유전자를 찾아라

rna <- read_excel("Data/rna.xlsx")
colnames(rna) <- c("gene", "normal", "cancer")

tmp <- log10(rna %>% select(-gene)) 
rownames(tmp) <- rna$gene

ggplot(data=rna, aes(x=normal, y=cancer)) + #log scale
  geom_point() +
  geom_abline(slope=1, intercept=0)
