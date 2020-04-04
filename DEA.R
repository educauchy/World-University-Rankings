Sys.setlocale(category = "LC_ALL", locale = "UTF-8")

library(rDEA)
library(knitr)
library(sfa)

data <- read.csv('./Data/Processed.csv', header=TRUE, sep=",", dec=".")
data <- na.omit(data)

uni <- data[1]
#input <- data[, 12:28]
input <- data[, c(12:17, 19:28)]
output <- data[, 2:5]

model1 <- dea(XREF = input, YREF = output, X = input[,], Y = output[,], model = "input", RTS = "constant")
scores1 <- round(model1$thetaOpt, 4)
result1 <- cbind(uni, scores1)


model2 <- sfa(QS + THE ~ Score_Result + Industry_Income, data = data)
scores2 <- te.eff.sfa(model2)
result2 <- cbind(uni, scores2)

print(cor(result1$scores1, result2$scores2, method = 'spearman'))
