Sys.setlocale(category = "LC_ALL", locale = "UTF-8")

library(rDEA)
library(knitr)
library(sfa)
library(Benchmarking)

data <- read.csv('./Data/Russian_Universities.csv', header=TRUE, sep=",", dec=".")
#data <- na.omit(data)
head(data)

uni <- data[1]
input <- data[, c(9:55)]
output <- data[, c(56:62)]

model1 <- dea(XREF = input, YREF = output, X = input[,], Y = output[,], model = "output", RTS = "variable")
scores1 <- round(model1$thetaOpt, 4)
result1 <- cbind(uni, scores1)
result1

model2 <- sfa(E1 + E2 ~ X1 + X2, data = data)
scores2 <- te.eff.sfa(model2)
result2 <- cbind(uni, scores2)
result2

print(cor(result1$scores1, result2$scores2, method = 'spearman'))
