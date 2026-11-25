# Statistical learning assignment — Tasks 1 & 2

R Markdown report for **classification** (Task 1) and **regression** (Task 2) on the provided CSV datasets, with reproducible splits and model comparison.

## Repository contents

| Path | Description |
|------|-------------|
| `Assignment_Tasks1_2.Rmd` | Main submission source — knit to Word or PDF |
| `my_dataQ1.csv` | Classification: 100 rows, 501 columns (`Y`, `X1`–`X500`) |
| `my_dataQ2.csv` | Regression: 50 rows, 29 columns (`x1`–`x28`, `y`) |
| `validate_run.R` | Smoke test: data dimensions, splits, and model fits |
| `docs/ubuntu-cloud-testing.md` | **Ubuntu cloud VM** setup and end-to-end test |
| `docs/verification-checklist.md` | Pre-submission checklist |

## Requirements (summary)

- Single R Markdown file with Introduction; Task 1 (A/B/C); Task 2 (A/B/C)
- `set.seed(20261)` for both train/test splits (70/30 and 80/20)
- Task 1: Bayesian LDA, SVM, classification tree
- Task 2: stepwise regression, ridge, lasso

## Quick start (local or VM)

### 1. Install R and packages

```r
install.packages(c("MASS", "e1071", "rpart", "caret", "glmnet", "ggplot2", "knitr", "rmarkdown"))
```

### 2. Run the smoke test

From the repository root:

```bash
Rscript validate_run.R
```

You should see `=== ALL VALIDATION CHECKS PASSED ===`.

### 3. Knit the report

In RStudio: open `Assignment_Tasks1_2.Rmd`, set working directory to this folder, update **Your Name** in the YAML header, then **Knit → Knit to Word**.

Or in R:

```r
setwd("/path/to/Assignement")
rmarkdown::render("Assignment_Tasks1_2.Rmd", output_format = "word_document")
```

## Testing on Ubuntu in the cloud

For a clean functional test on **Ubuntu 22.04/24.04** (AWS, Azure, GCP, etc.), follow the step-by-step guide:

**[docs/ubuntu-cloud-testing.md](docs/ubuntu-cloud-testing.md)**

That document covers `apt` dependencies, package installation, `validate_run.R`, and optional knitting on Linux.

## Pre-submission

Use **[docs/verification-checklist.md](docs/verification-checklist.md)** before you submit.

## Notes for markers

- **LDA:** With \(p = 500\) and \(n_{\mathrm{train}} = 70\), the report uses scaled predictors and PCA (50 components) before `MASS::lda()`.
- **Metrics:** Classification — accuracy, Cohen’s κ, sensitivity, specificity. Regression — RMSE, MAE, \(R^2\) on train and test.