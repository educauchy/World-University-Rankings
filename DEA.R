Sys.setlocale(category = "LC_ALL", locale = "UTF-8")

#library(rDEA)
library(knitr)
library(sfa)
library(Benchmarking)

input_cols <- c('X1.1', 'X1', 'X9', 'X2.7', 'X2.16', 'X3.8', 'X3.9', 'X35', 'X4.1', 'X4.3', 'X48', 'X5.1', 'X5.6', 'X46', 'X6.4', 'X28',
                'X2.1_2_3', 'X2.4_5_6', 'X3.1_2', 'X6.1_2', 'X13_14', 'X40_41_42')
output_cols <- c('E.1', 'E.2', 'E.3', 'E.4', 'E.5')

data <- read.csv('./Data/Russian_Universities.csv', header=TRUE, sep=",", dec=".")
data <- na.omit(data)
rownames(data) <- NULL

uni <- data$University
inputs <- as.matrix(sapply(data[, input_cols], as.numeric))  
outputs <- as.matrix(sapply(data[, output_cols], as.numeric))  

model1 <- dea.robust(X = inputs, Y = outputs, model = "input", RTS = "variable")
print(model1)
print(eff(model1))
#scores1 <- round(model1$thetaOpt, 4)
#result1 <- cbind(uni, scores1)
#result1

i <- inputs[, 1]
o <- outputs[, 1]
m <- dea.robust(X = inputs, Y = outputs, model = "output", bw = 'cv')
m <- dea.robust(X = i, Y = o, model = "output", bw = 'cv')
print(m)

dea.plot.frontier(inputs, outputs, txt=TRUE)
dea.plot.frontier(i, o, txt=TRUE)





model2 <- sfa(outputs ~ inputs)
print(model2)
#scores2 <- te.eff.sfa(model2)
#result2 <- cbind(uni, scores2)
#result2

print(cor(result1$scores1, result2$scores2, method = 'spearman'))
