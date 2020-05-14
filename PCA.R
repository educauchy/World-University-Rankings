Sys.setlocale(category = "LC_ALL", locale = "UTF-8")

library(ggbiplot)
library(data.table)

thesis_url <- '~/Google Drive/Университет/Магистратура/Research/Programs/'
data <- read.csv( paste0(thesis_url, 'Data/Russian_Universities.csv'), header=TRUE, sep=",", dec=".")
data <- na.omit(data)
head(data)

uni <- data$University
input <- c('X1.1', 'X1', 'X9', 'X2.7', 'X2.16', 'X3.8', 'X3.9', 'X35', 'X4.1', 'X4.3', 'X48', 'X5.1', 'X5.6', 'X46', 'X6.4', 'X28', 'X2.1_2_3', 'X2.4_5_6', 'X3.1_2', 'X6.1_2', 'X13_14', 'X40_41_42')

input_positive_cor <- c('X2.7', 'X5.1', 'X6.1_2', 'X6.4', 'X35', 'X40_41_42', 'X48')
input_negative_cor <- c('X1', 'X2.1_2_3', 'X2.4_5_6', 'X3.8', 'X3.9', 'X4.3', 'X5.6', 'X9', 'X28')
output_cor <- c('E.1', 'E.2', 'E.4', 'E.5')
output_cor_all <- c('E.1', 'E.2', 'E.3', 'E.4', 'E.5')


# PCA Input Positive
pca_x_pos <- prcomp(data[, input_positive_cor])
summary(pca_x_pos)

png(paste0(thesis_url, 'Media/PCA/Input_Positive_Variances.png'), width = 500, height = 500)
screeplot(pca_x_pos,
          type = "l", 
          npcs = length(input_positive_cor),
          main = paste0("Screeplot of the PC variances") )
dev.off()

png(paste0(thesis_url, 'Media/PCA/Input_Positive_Biplot.png'), width = 500, height = 500)
ggbiplot(pca_x_pos, labels = uni)
dev.off()



# PCA Input Negative
pca_x_neg <- prcomp(data[, input_negative_cor])
summary(pca_x_neg)

png(paste0(thesis_url, 'Media/PCA/Input_Negative_Variances.png'), width = 500, height = 500)
screeplot(pca_x_neg,
          type = "l", 
          npcs = length(input_negative_cor),
          main = paste0("Screeplot of the PC variances") )
dev.off()

png(paste0(thesis_url, 'Media/PCA/Input_Negative_Biplot.png'), width = 500, height = 500)
ggbiplot(pca_x_neg, labels = uni)
dev.off()



# PCA Output
pca_out <- prcomp(data[, output_cor])
summary(pca_out)

png(paste0(thesis_url, 'Media/PCA/Output_Variances.png'), width = 500, height = 500)
screeplot(pca_out,
          type = "l", 
          npcs = length(output_cor),
          main = paste0("Screeplot of the PC variances") )
dev.off()

png(paste0(thesis_url, 'Media/PCA/Output_Biplot.png'), width = 500, height = 500)
ggbiplot(pca_out, labels = uni)
dev.off()


# PCA Output All
pca_out <- prcomp(data[, output_cor_all])
summary(pca_out)

png(paste0(thesis_url, 'Media/Benchmarking/Output_Variances.png'), width = 500, height = 500)
screeplot(pca_out,
          type = "l", 
          npcs = length(output_cor_all),
          main = paste0("Screeplot of the PC variances") )
dev.off()

png(paste0(thesis_url, 'Media/Benchmarking/Output_Biplot.png'), width = 500, height = 500)
ggbiplot(pca_out, labels = uni)
dev.off()