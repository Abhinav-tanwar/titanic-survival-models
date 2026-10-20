split_rows <- function(y, seed = 121, p = 0.7) {
    set.seed(seed)
    sort(unlist(lapply(split(seq_along(y), y), function(i) sample(i, floor(length(i) * p)))))
}

score <- function(actual, pred, prob = NULL) {
    levels_y <- levels(actual)
    cm <- table(actual = factor(actual, levels_y), predicted = factor(pred, levels_y))
    result <- list(accuracy = mean(actual == pred), confusion = unclass(cm))
    if (length(levels_y) == 2) {
        positive <- levels_y[2]
        tp <- sum(actual == positive & pred == positive)
        fp <- sum(actual != positive & pred == positive)
        fn <- sum(actual == positive & pred != positive)
        tn <- sum(actual != positive & pred != positive)
        result$recall <- tp/(tp + fn)
        result$precision <- if (tp + fp) 
            tp/(tp + fp)
        else 0
        result$balanced_accuracy <- (tp/(tp + fn) + tn/(tn + fp))/2
        if (!is.null(prob)) {
            y <- actual == positive
            result$roc_auc <- (sum(rank(prob)[y]) - sum(y) * (sum(y) + 1)/2)/(sum(y) * sum(!y))
        }
    }
    result
}

run_analysis <- function(root, out) {
    d <- read.csv(file.path(root, "data/synthetic_titanic.csv"))
    d$Survived <- factor(d$Survived, levels = c(0, 1))
    d$Sex <- factor(d$Sex)
    d$Pclass <- factor(d$Pclass)
    d$Embarked <- factor(d$Embarked)
    idx <- split_rows(d$Survived)
    train <- d[idx, ]
    test <- d[-idx, ]
    med <- median(train$Age, na.rm = TRUE)
    train$Age[is.na(train$Age)] <- med
    test$Age[is.na(test$Age)] <- med
    models <- list(LDA_simple = MASS::lda(Survived ~ Sex + Pclass, train), LDA_full = MASS::lda(Survived ~ 
        ., train), QDA_simple = MASS::qda(Survived ~ Sex + Pclass, train), Logistic = glm(Survived ~ 
        Sex + Pclass, train, family = binomial()))
    result <- list(data = "synthetic demonstration; not historical passengers", train_rows = nrow(train), 
        test_rows = nrow(test), positive_class = "1 = survived")
    for (name in names(models)) {
        if (name == "Logistic") {
            prob <- predict(models[[name]], test, type = "response")
            pred <- factor(ifelse(prob >= 0.5, 1, 0), levels = c(0, 1))
        }
        else {
            pr <- predict(models[[name]], test)
            prob <- pr$posterior[, "1"]
            pred <- pr$class
        }
        result[[name]] <- score(test$Survived, pred, prob)
    }
    result
}

