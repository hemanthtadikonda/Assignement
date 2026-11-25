# Pre-submission verification checklist

Use this list before you knit and submit.

## Data files

| Check | Expected | Status |
|-------|----------|--------|
| `my_dataQ1.csv` rows | 100 | Verify locally |
| `my_dataQ1.csv` columns | 501 (`Y` + `X1`…`X500`) | Verify locally |
| `my_dataQ2.csv` rows | 50 | Verify locally |
| `my_dataQ2.csv` columns | 29 (`x1`…`x28` + `y`) | Verify locally |

## Assignment rules (in `Assignment_Tasks1_2.Rmd`)

| Requirement | Implementation |
|-------------|----------------|
| Seed | `set.seed(20261)` before each split |
| Task 1 split | `sample(100, 70)` → 70 train, 30 test |
| Task 2 split | `sample(50, 40)` → 80% / 20% |
| Task 1 methods | LDA (PCA + `MASS::lda`), SVM (`e1071`), tree (`rpart`) |
| Task 2 methods | `step()` both directions, `glmnet` ridge (α=0), lasso (α=1) |
| Sections | Task 1A, 1B, 1C; Task 2A, 2B, 2C with clear headings |
| Output format | Knit to **Word** (recommended) or PDF |

## Run automated smoke test (requires R)

From the `Assign` folder in a terminal:

```text
Rscript validate_run.R
```

You should see `ALL VALIDATION CHECKS PASSED`. If packages are missing, install them first (see `README.md`).

## Knit test (required before submit)

1. Open `Assignment_Tasks1_2.Rmd` in RStudio.
2. **Session → Set Working Directory → To Source File Location** (so CSV paths resolve).
3. **Knit → Knit to Word**.
4. Confirm: no red error in the knit log; tables for 1A/1B/2A/2B appear; 1C/2C show numeric results (not `` `r ...` `` literals).

## Known design choices (defensible in report)

- **LDA + PCA:** With 500 predictors and only 70 training rows, plain LDA on all `X` variables fails (singular covariance). The report documents PCA + LDA—standard for \(p \gg n\).
- **PDF:** Needs a LaTeX install (TinyTeX or MiKTeX). Word only needs R + `rmarkdown` + Pandoc (bundled with RStudio).

## Cursor environment note

R was **not** available on the machine used to author this project, so **full knit was not executed here**. Your successful **Knit to Word** on your PC is the final confirmation.