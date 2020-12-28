pacman::p_load(dplyr, readxl, ggplot2, scales, ggpubr, fpc, doParallel, reticulate)
memory.limit()

#rna는 정상 세포와 암세포 각각의 RNA 발현량을 담고 있음 -> 원발암 유전자를 찾아라

#단순 proportion으로만 했음

rna <- read_excel("Data/rna.xlsx")
colnames(rna) <- c("gene", "normal", "cancer")
rna <- rna[rna$normal >= 1e-08 & rna$cancer >= 1e-08,]

ggplot(data=rna, aes(x=log10(normal), y=log10(cancer))) + #log scale
  geom_point() +
  geom_abline(slope=1, intercept=0)

rna$pro <- log10(rna$cancer/rna$normal)

ggplot(data=rna, aes(x=pro)) +
  geom_density(color="darkblue", fill="lightblue")

ggboxplot(data=rna, y="pro")
qqnorm(rna$pro)

cancer_gene_proportion <- c(arrange(rna, pro)[1:15,]$gene, arrange(rna, desc(pro))[1:15,]$gene)

median(rna$pro)

#DBSCAN, python으로 했음

rna_plot <- bind_cols(rna, py$predict)
rna_plot$predict <- rna_plot$predict + 2
rna_plot$predict <- as.factor(rna_plot$predict)
ggplot(rna_plot, aes(x=log10(normal), y=log10(cancer), group=predict, color=predict)) +
  geom_point() +
  scale_color_manual(values=c("grey", "#E69F00", "#56B4E9", "skyblue", "green", "red", "yellow")) +
  geom_abline(slope=1, intercept=0)

cancer_gene_DBSCAN <- py$cancer_gene_DBSCAN

intersect(cancer_gene_DBSCAN, cancer_gene_proportion)
rna[rna$gene %in% intersect(cancer_gene_DBSCAN, cancer_gene_proportion),] #여기서 proportion은 극단치를 잡아냈을 뿐임을 알 수 있다.
