# production function
A <- 1.1
L <- 1:100
K <- 4
alpha <- 0.8
beta <- 0.2
Q <- A * K^alpha * L^beta
plot(L, Q, type = "l", xlab = "L, quantity of employees", ylab = "Q, quantity of goods")


# production possibility curve
#Q1 <- 0:3
from <- 0
to <- 3.2142
Q1 <- seq(from = from, to = to, by = (to - from)/(100-1))
Q2 <- 1 / (Q1 - 7/2) + 7/2
plot(Q1, Q2, type = "l", xlab = expression("Q"[1]*", quantity of sales"), ylab = expression("Q"[2]*", quantity of clients"))


# isoquant
x1 <- seq(1, 10, by = 0.05)
x2 <- 1 / x1
plot(x1, x2, type = "l", xlab = expression("x"[1]*", quantity of labour"), ylab = expression("x"[2]*", quantity of capital"))


# isocost
x1 <- seq(0, 10, by = 1)
x2 <- -15/25 * x1 + 6
plot(x1, x2, type = "l", xlim = c(0, 11), ylim = c(0, 7), xlab = expression("x"[1]*", quantity of labour"), ylab = expression("x"[2]*", quantity of capital"))
