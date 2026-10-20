set.seed(530304)

n <- 1200

Sex <- sample(c("female", "male"), n, TRUE, c(0.36, 0.64))

Pclass <- sample(1:3, n, TRUE, c(0.25, 0.22, 0.53))

Age <- pmax(1, rnorm(n, 30, 14))

SibSp <- rpois(n, 0.5)

Parch <- rpois(n, 0.4)

Fare <- round(exp(rnorm(n, 4 - 0.4 * Pclass, 0.5)), 2)

Embarked <- sample(c("C", "Q", "S"), n, TRUE, c(0.2, 0.1, 0.7))

prob <- plogis(0.5 + 1.7 * (Sex == "female") - 0.65 * (Pclass - 1) - 0.025 * Age - 0.15 * 
    SibSp)

Survived <- rbinom(n, 1, prob)

Age[sample(n, 80)] <- NA

write.csv(data.frame(Survived, Sex, Pclass, Age, SibSp, Parch, Fare, Embarked), "data/synthetic_titanic.csv", 
    row.names = FALSE)

