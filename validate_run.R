# Cross-check: source all assignment logic (no knit). Run from Assign folder:
#   Rscript validate_run.R

options(warn = 1)
args <- commandArgs(trailingOnly = FALSE)
file_arg <- sub("^--file=", "", args[grep("^--file=", args)])
if (length(file_arg)) setwd(dirname(normalizePath(file_arg[1])))

cat("Working directory:", getwd(), "\n\n")

required <- c("MASS", "e1071", "rpart", "caret", "glmnet", "ggplot2")
missing <- setdiff(required, rownames(installed.packages()))
if (length(missing)) stop("Install packages: ", paste(missing, collapse = ", "))

suppressPackageStartupMessages({
  library(MASS)
  library(e1071)
  library(rpart)
  library(caret)
  library(glmnet)
})

# --- Data checks ---
q1 <- read.csv("my_dataQ1.csv", check.names = FALSE)
q2 <- read.csv("my_dataQ2.csv", check.names = FALSE)
stopifnot(nrow(q1) == 100L, ncol(q1) == 501L)
stopifnot(nrow(q2) == 50L, ncol(q2) == 29L)
stopifnot(names(q1)[1] == "Y", names(q2)[ncol(q2)] == "y")
cat("OK: Q1 100x501, Q2 50x29\n")

# --- Task 1 split ---
set.seed(20261)
idx1_tr <- sample(100L, 70L)
stopifnot(length(idx1_tr) == 70L, length(setdiff(1:100, idx1_tr)) == 30L)
cat("OK: Task 1 split 70/30\n")

# --- Task 2 split ---
set.seed(20261)
idx2_tr <- sample(50L, floor(0.8 * 50L))
stopifnot(length(idx2_tr) == 40L, length(setdiff(1:50, idx2_tr)) == 10L)
cat("OK: Task 2 split 40/10 (80/20)\n")

# --- Minimal model fit smoke test (Task 1) ---
source_lines <- TRUE
data_q1 <- q1
data_q1$Y <- factor(data_q1$Y, levels = c(0, 1), labels = c("Class0", "Class1"))
train_q1 <- data_q1[idx1_tr, ]
test_q1 <- data_q1[-idx1_tr, ]
pred_cols_q1 <- setdiff(names(data_q1), "Y")

x_tr <- scale(train_q1[, pred_cols_q1])
pca <- prcomp(x_tr, center = FALSE, scale. = FALSE)
k <- 50L
fit_lda <- lda(pca$x[, seq_len(k)], grouping = train_q1$Y)
fit_svm <- svm(Y ~ ., data = train_q1[, c("Y", pred_cols_q1)], kernel = "radial", scale = TRUE)
form_tree <- as.formula(paste("Y ~", paste(pred_cols_q1[1:20], collapse = " + "))) # subset smoke
fit_tree <- rpart(form_tree, data = train_q1, method = "class")
cat("OK: Task 1 LDA, SVM, rpart (20-var tree smoke) fit\n")

# Full tree with 500 vars
form_full <- as.formula(paste("Y ~", paste(pred_cols_q1, collapse = " + ")))
fit_tree_full <- rpart(form_full, data = train_q1, method = "class",
                       control = rpart.control(cp = 0.01))
cat("OK: Task 1 full classification tree (500 predictors)\n")

# --- Task 2 models ---
train_q2 <- q2[idx2_tr, ]
test_q2 <- q2[-idx2_tr, ]
pred_cols_q2 <- setdiff(names(q2), "y")
form <- as.formula(paste("y ~", paste(pred_cols_q2, collapse = " + ")))
full_lm <- lm(form, data = train_q2)
fit_step <- step(full_lm, direction = "both", trace = 0)
x_tr <- as.matrix(train_q2[, pred_cols_q2])
cv_ridge <- cv.glmnet(x_tr, train_q2$y, alpha = 0, nfolds = 10)
cv_lasso <- cv.glmnet(x_tr, train_q2$y, alpha = 1, nfolds = 10)
cat("OK: Task 2 stepwise, ridge CV, lasso CV\n")

cat("\n=== ALL VALIDATION CHECKS PASSED ===\n")