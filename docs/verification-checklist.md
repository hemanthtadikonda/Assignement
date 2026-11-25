# Pre-submission verification checklist

Use before knitting and submitting the report.

## Repository layout (after cleanup)

| File | Role |
|------|------|
| `my_dataQ1.csv` | Task 1 classification data |
| `my_dataQ2.csv` | Task 2 regression data |
| `Assignment_Tasks1_2.Rmd` | Main report source (knit to Word/PDF) |
| `validate_run.R` | Non-interactive smoke test (no knit) |
| `docs/ubuntu-cloud-testing.md` | Ubuntu VM test procedure |
| `README.md` | Project overview |

Duplicate downloads (`* (1).csv`, extra `.docx` briefs) are **not** part of the repo and are ignored via `.gitignore`.

## Data checks

| Check | Expected |
|-------|----------|
| `my_dataQ1.csv` rows | 100 |
| `my_dataQ1.csv` columns | 501 (`Y`, `X1`…`X500`) |
| `my_dataQ2.csv` rows | 50 |
| `my_dataQ2.csv` columns | 29 (`x1`…`x28`, `y`) |

## Assignment rules (in `Assignment_Tasks1_2.Rmd`)

| Requirement | Implementation |
|-------------|----------------|
| Seed | `set.seed(20261)` before each split |
| Task 1 split | 70 train / 30 test |
| Task 2 split | 40 train / 10 test (80% / 20%) |
| Task 1 methods | LDA (PCA + `MASS::lda`), SVM, `rpart` tree |
| Task 2 methods | `step()` both ways, ridge and lasso (`glmnet`) |
| Structure | Task 1A/B/C and Task 2A/B/C with clear headings |
| Deliverable | Knit to **Word** (recommended) or PDF |

## Automated smoke test

From the repository root:

```bash
Rscript validate_run.R
```

Expected final line: `ALL VALIDATION CHECKS PASSED`.

Install packages first if prompted (see `README.md` or `docs/ubuntu-cloud-testing.md`).

## Knit test

1. Open `Assignment_Tasks1_2.Rmd` in RStudio, **or** render from the CLI on Ubuntu (see cloud testing doc).
2. Set working directory to the repository root (CSV paths are relative).
3. Knit to Word (or PDF if LaTeX is installed).
4. Confirm: no errors in the knit log; metric tables appear in sections 1A, 1B, 2A, 2B; 1C and 2C show fitted numeric results.

## Design notes (for markers / viva)

- **LDA + PCA:** With 500 predictors and 70 training observations, full-rank LDA is not viable; PCA before LDA is standard for \(p \gg n\).
- **Metrics:** Classification — accuracy, κ, sensitivity, specificity (`caret::confusionMatrix`). Regression — RMSE, MAE, \(R^2\) on train and test.