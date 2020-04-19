Sys.setlocale(category = "LC_ALL", locale = "UTF-8")

library(knitr)
library(Benchmarking)

data <- read.csv('~/Google Drive/Университет/Магистратура/Research/Programs/Data/Russian_Universities.csv', header=TRUE, sep=",", dec=".")
data <- na.omit(data)
head(data)

data['X40_41_42'] <- data[, c('X40_41_42')] / 10000

uni <- data[1]
input_cols <- c('X1.1', 'X1', 'X9', 'X2.7', 'X2.16', 'X13', 'X14', 
                'X3.8', 'X3.9', 'X35', 'X4.1', 'X4.3', 'X48', 'X5.1', 'X5.6', 'X46', 'X6.4', 'X28',
                'X2.1_2_3', 'X2.4_5_6', 'X3.1_2', 'X6.1_2', 'X13_14', 'X40_41_42')
output_cols <- c('E.1', 'E.2', 'E.3', 'E.4', 'E.5')

input <- as.matrix(data[, input_cols])
output <- as.matrix(data[, output_cols])

input_t <- t(t(input)/colSums(input))
output_t <- t(t(output)/colSums(output))

# DEA MODEL
dea_model <- Benchmarking::dea(input[, 7:10], output_t, RTS = "vrs", ORIENTATION = "IN")
summary(dea_model)
dea_scores <- eff(dea_model)
dea_uni <- cbind(uni, dea_scores)
dea_uni

dea.plot.frontier(input[, 'X1'], output[, 'E.1'])
dea.plot.frontier(input[, 'X1'], output[, 'E.2'])
dea.plot.frontier(input[, 'X1'], output[, 'E.3'])
dea.plot.frontier(input[, 'X1'], output[, 'E.4'])


# PCA
pca_model <- prcomp(input)
summary(pca_model)

# SFA
input_sfa <- input_t
input_sfa[input_sfa == 0] <- 0.00001
#mat[mat < 0.1] <- NA

sfa_model <- Benchmarking::sfa(log(input_sfa), log(output[, 1]))
summary(sfa_model)
sfa_scores <- eff(sfa_model)
sfa_uni <- cbind(uni, sfa_scores)
sfa_uni


print(cor(dea_scores, sfa_scores, method = 'spearman'))
