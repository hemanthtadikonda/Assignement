# Assignment — Task 1 & Task 2

## Files

| File | Purpose |
|------|---------|
| `my_dataQ1.csv` | Classification data (100 × 501) |
| `my_dataQ2.csv` | Regression data (50 × 29) |
| `Assignment_Tasks1_2.Rmd` | **Main submission**: code + solutions in one R Markdown document |

## Requirements checklist

- [x] Task 1 & Task 2 in a **single** R Markdown file
- [x] Clear headings: Introduction, Task 1 (A/B/C), Task 2 (A/B/C)
- [x] `set.seed(20261)` for both splits
- [x] Task 1: 70 train / 30 test from 100 cases
- [x] Task 2: 80% train / 20% test from 50 cases
- [x] Classification: Bayesian LDA, SVM, classification tree
- [x] Regression: stepwise, ridge, lasso

## How to knit (MS Word or PDF)

1. Install [R](https://cran.r-project.org/) and [RStudio](https://posit.co/download/rstudio-desktop/) (recommended).
2. Open `Assignment_Tasks1_2.Rmd` in RStudio.
3. Install packages (run once in the R console):

```r
install.packages(c("MASS", "e1071", "rpart", "caret", "glmnet", "ggplot2", "knitr"))
```

4. Set working directory to this folder (`Session` → `Set Working Directory` → `To Source File Location`).
5. **Word:** click **Knit** → **Knit to Word**, or:

```r
rmarkdown::render("Assignment_Tasks1_2.Rmd", output_format = "word_document")
```

6. **PDF:** requires a LaTeX distribution (e.g. TinyTeX). Then:

```r
rmarkdown::render("Assignment_Tasks1_2.Rmd", output_format = "pdf_document")
```

7. Replace **Your Name** in the YAML header before submitting.

## Notes for markers

- **Task 1 LDA:** With $p = 500$ and $n_{\mathrm{train}} = 70$, classical LDA is rank-deficient; the report uses scaled predictors and PCA (50 components) before `MASS::lda()`, which is standard in high-dimensional LDA.
- **Metrics:** Classification — accuracy, Cohen’s κ, sensitivity, specificity (via `caret::confusionMatrix`). Regression — RMSE, MAE, $R^2$ on train and test.

## Cross-check before submit

1. See **`VERIFICATION_CHECKLIST.md`** for the full list.
2. Run: `Rscript validate_run.R` (fits all models; must print `ALL VALIDATION CHECKS PASSED`).
3. Knit to Word once and open the `.docx` to confirm tables and plots.

**Verified in this project (data only, via PowerShell):** `my_dataQ1.csv` = 100×501 (`Y`, `X1`–`X500`); `my_dataQ2.csv` = 50×29 (`x1`–`x28`, `y`). Full R execution was not run in Cursor because R is not installed on that environment.