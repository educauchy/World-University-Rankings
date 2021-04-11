Sys.setlocale(category = "LC_ALL", locale = "UTF-8")

library(knitr)
library(Benchmarking)
library(ggplot2)
library(dplyr)

thesis_url <- '~/Google Drive/Университет/Магистратура/Research/Programs/'
data <- read.csv('~/Google Drive/Университет/Магистратура/Research/Programs/Data/Russian_Universities.csv',
                 header=TRUE, sep=",", dec=".") %>% na.omit()
uni <- data %>% select(University)


# INPUT / OUTPUT COLUMNS
input_cols <- c('X1.1', 'X1', 'X9', 'X2.7', 'X2.16', 'X3.8', 'X3.9', 'X35', 'X4.1', 'X4.3',
                    'X48', 'X5.1', 'X5.6', 'X46', 'X6.4', 'X28', 'X2.1_2_3', 'X2.4_5_6', 'X3.1_2',
                    'X6.1_2', 'X13_14', 'X40_41_42')
input_cols_PCA <- c('X1.1', 'X2.16', 'X3.1_2', 'X4.1', 'X13_14', 'X46', 'INPUT1', 'INPUT2', 'INPUT3')
output_cols <- c('E.1', 'E.2', 'E.3', 'E.4', 'E.5')
output_cols_PCA_shrink <- c('E.3', 'OUTPUT_SHRINK')
output_cols_PCA_full <- c('OUTPUT_FULL')



# INPUTS / OUTPUTS
input <- as.matrix(data[, input_cols])
input_PCA <- as.matrix(data[, input_cols_PCA])
output <- as.matrix(data[, output_cols])
output_PCA_shrink <- as.matrix(data[, output_cols_PCA_shrink])
output_PCA_full <- as.matrix(data[, output_cols_PCA_full], ncol = 1)



# FRONTIER PLOT
plot.new()
png(paste0(thesis_url, 'Media/Benchmarking/DEA_Frontier.png'), width = 600, height = 600)
dea.plot.frontier(input, output, txt = as.matrix(uni, col = 1), GRID = TRUE, xlab = "Summed Inputs", ylab = "Summed Outputs")
dea.plot.isoquant(input[7, ], input[8, ], txt = as.matrix(uni, col = 1), GRID = TRUE, xlab = "X1", ylab = "X2")
dea.plot.transform(output[3, ], output[5, ], txt = as.matrix(uni, col = 1), GRID = TRUE, xlab = "X1", ylab = "X2")
dev.off()



# DEA WITH SINGLE OUTPUT
dea_model_single <- dea(input, output_PCA_full, RTS = "VRS", ORIENTATION = "IN")
summary(dea_model_single)
dea_scores_single <- eff(dea_model_single)
dea_uni_single <- cbind(uni, dea_scores_single)
dea_uni_single
plot(sort(dea_scores_single))



# DEA WITH TWO OUTPUTS
dea_model_single <- dea(input, output_PCA_shrink, RTS = "VRS", ORIENTATION = "IN")
summary(dea_model_single)
dea_scores_single <- eff(dea_model_single)
dea_uni_single <- cbind(uni, dea_scores_single)
dea_uni_single
plot(sort(dea_scores_single))



# DEA WITH MULTIPLE OUTPUTS
dea_model_multiple <- dea(input, output, RTS = "VRS", ORIENTATION = "IN", digits = 9)
summary(dea_model_multiple)
dea_scores_multiple <- eff(dea_model_multiple)
dea_uni_multiple <- cbind(uni, dea_scores_multiple)
dea_uni_multiple
plot(sort(dea_scores_multiple))



# DEA WITH MULTIPLE OUTPUTS ADDITIVE
dea_mult_add <- dea.add(input, output)
summary(dea_mult_add)



# SFA WITH SINGLE OUTPUT | FINAL
sfa_model_multiple_full <- sfa(input_PCA, output_PCA_full)
summary(sfa_model_multiple_full)
sfa_scores_multiple_full <- eff(sfa_model_multiple_full)
sfa_uni_multiple_full <- data.frame(University = uni,
                                    Score = round(sfa_scores_multiple_full, 4) )
sfa_uni_multiple_full <- sfa_uni_multiple_full[order(sfa_uni_multiple_full$Score), ]
rownames(sfa_uni_multiple_full) <- NULL

png(paste0(thesis_url, 'Media/Benchmarking/SFA_scores.png'), width = 600, height = 600)
ggplot(sfa_uni_multiple_full, aes(reorder(University, Score), Score)) +
  geom_point() +
  labs(x = "University",
       y = "Efficiency Score")
dev.off()




# SFA WITH MULTIPLE OUTPUTS SHRINK
input_sfa <- input_PCA / input_PCA[, 'X1.1']
input_sfa <- input_sfa[, c(2:ncol(input_sfa))]
input_sfa <- cbind(input_sfa, output_PCA_shrink)
input_sfa[input_sfa <= 0] <- 0.01

output_sfa <- as.matrix( input_PCA[, 'X1.1'], ncol = 1 )

sfa_model_multiple_shrink <- sfa(log(input_sfa), -log(output_sfa))
summary(sfa_model_multiple_shrink)
sfa_scores_multiple_shrink <- eff(sfa_model_multiple_shrink)
sfa_uni_multiple_shrink <- cbind(uni, sfa_scores_multiple_shrink)
sfa_uni_multiple_shrink
plot(sort(sfa_scores_multiple_shrink))

# DIFF B/W SINGLE & MULTIPLE
cbind(sfa_scores_multiple_full, sfa_scores_multiple_shrink)
