Sys.setlocale(category = "LC_ALL", locale = "UTF-8")

library(knitr)
library(Benchmarking)

data <- read.csv('~/Google Drive/Университет/Магистратура/Research/Programs/Data/Russian_Universities_PCA.csv', header=TRUE, sep=",", dec=".")
data <- na.omit(data)
head(data)

uni <- c(data[, 'University'])
input_cols_dea <- c('X1.1', 'X1', 'X9', 'X2.7', 'X2.16', 'X3.8', 'X3.9', 'X35', 'X4.1', 'X4.3', 'X48', 'X5.1', 'X5.6', 'X46', 'X6.4', 'X28', 'X2.1_2_3', 'X2.4_5_6', 'X3.1_2', 'X6.1_2', 'X13_14', 'X40_41_42')
input_cols_sfa <- c('X1.1', 'X2.16', 'X3.1_2', 'X4.1', 'X13_14', 'X46', 'PC1', 'PC2', 'PC3')
output_cols <- c('E.1', 'E.2', 'E.3', 'E.4', 'E.5')

input_cols <- c('X1.1', 'X2.16', 'X3.1_2', 'X4.1', 'X13_14', 'X46', 'INPUT1', 'INPUT2', 'INPUT3')
output_cols <- c('E.3', 'OUTPUT1')
input_cols_dea <- c('X1.1', 'X2.16', 'X3.1_2', 'X4.1', 'X13_14', 'X46', 'INPUT1', 'INPUT2', 'INPUT3')
input_cols_sfa <- c('X1.1', 'X2.16', 'X3.1_2', 'X4.1', 'X13_14', 'X46', 'INPUT1', 'INPUT2', 'INPUT3')

input_dea <- as.matrix(data[, input_cols_dea])
input_sfa <- as.matrix(data[, input_cols_sfa])
output <- as.matrix(data[, output_cols])


# DEA MODEL
dea_model <- dea(input_dea[, 1:5], output, RTS = "DRS", ORIENTATION = "IN")
summary(dea_model)
dea_scores <- eff(dea_model)
dea_uni <- cbind(uni, dea_scores)
dea_uni

#dea.plot.frontier(input[, 'X1.1'], output[, 'E.1'])
#dea.plot.frontier(input[, 'X1.1'], output[, 'E.2'])
#dea.plot.frontier(input[, 'X1.1'], output[, 'E.3'])
#dea.plot.frontier(input[, 'X1.1'], output[, 'E.4'])



# SFA
X <- with(d,cbind(x2=x2/x1,x3=x3/x1,x4=x4/x1,x5=x5/x1,
                  x6=x6/x1,y2,y4))
Y <- matrix(d$x1,ncol=1)
dist <- sfa(log(X), -log(Y))
te <- te.sfa(dist)

input_sfa_merge <- cbind(input_sfa[, -c(1)], output)
output_sfa <- input_sfa[, 1]

last_col <- input_sfa[, ncol(input_sfa)]
input_sfa[, ncol(input_sfa)] = (last_col - min(last_col))/(max(last_col) - min(last_col))

input_sfa_merge[input_sfa_merge == 0] <- 0.0001


sfa_model <- sfa(log(input_sfa_merge), -log(output_sfa))
summary(sfa_model)
sfa_scores <- eff(sfa_model)
sfa_uni <- cbind(data$University, sfa_scores)
sfa_uni

plot(sort(sfa_scores))
plot(x = uni, y = sfa_scores)
