# Ubuntu cloud VM — setup and functional testing

Use this guide on a fresh **Ubuntu 22.04 or 24.04** instance (AWS EC2, Azure, GCP, university lab VM, etc.) to confirm the repository runs end-to-end before you submit or knit the report.

## What you are verifying

| Step | Success criterion |
|------|-------------------|
| Data | `my_dataQ1.csv` is 100×501; `my_dataQ2.csv` is 50×29 |
| Splits | `set.seed(20261)` → 70/30 (Task 1) and 40/10 (Task 2) |
| Models | LDA (PCA), SVM, classification tree; stepwise, ridge, lasso |
| Smoke test | `Rscript validate_run.R` prints `ALL VALIDATION CHECKS PASSED` |
| Report | `rmarkdown::render(...)` completes without errors (optional Word/PDF) |

## 1. Instance sizing

| Resource | Minimum | Recommended |
|----------|---------|-------------|
| vCPU | 1 | 2 |
| RAM | 2 GiB | 4 GiB |
| Disk | 10 GiB free | 20 GiB |

Task 1 uses 500 predictors; full tree and `glmnet` need a modest amount of memory.

## 2. System packages (run on the VM)

```bash
sudo apt-get update
sudo apt-get install -y \
  git \
  r-base \
  r-base-dev \
  libcurl4-openssl-dev \
  libssl-dev \
  libxml2-dev \
  pandoc \
  pandoc-citeproc
```

For **PDF** output only (optional; skip if you only need Word/HTML):

```bash
sudo apt-get install -y texlive-base texlive-latex-extra texlive-fonts-recommended
```

Or install TinyTeX from R (see section 5).

## 3. Clone and enter the repository

```bash
git clone https://github.com/hemanthtadikonda/Assignement.git
cd Assignement
```

If you use a private fork, use your clone URL and ensure the VM has SSH keys or a credential helper configured.

## 4. R packages

Start R as your normal user (not root):

```bash
R -q -e 'install.packages(c("MASS","e1071","rpart","caret","glmnet","ggplot2","knitr","rmarkdown"), repos="https://cloud.r-project.org")'
```

`glmnet` and `caret` may take a few minutes to compile on first install.

**One-line check** that required packages load:

```bash
R -q -e 'lapply(c("MASS","e1071","rpart","caret","glmnet","ggplot2"), require, character.only=TRUE)'
```

You should see no `Error` and a series of `TRUE` values.

## 5. Automated smoke test (required)

From the repository root:

```bash
Rscript validate_run.R
```

Expected output (abbreviated):

```text
Working directory: .../Assignement
OK: Q1 100x501, Q2 50x29
OK: Task 1 split 70/30
OK: Task 2 split 40/10 (80/20)
...
=== ALL VALIDATION CHECKS PASSED ===
```

If you see `Install packages: ...`, run the `install.packages` command from section 4 and retry.

## 6. Knit the assignment (optional on Linux)

Edit the YAML in `Assignment_Tasks1_2.Rmd` and set `author` to your name before knitting.

**Word** (only needs Pandoc, already installed above):

```bash
R -q -e 'setwd("'"$(pwd)"'"); rmarkdown::render("Assignment_Tasks1_2.Rmd", output_format = "word_document")'
```

This creates `Assignment_Tasks1_2.docx` in the repo root. Copy it off the VM with `scp` or your cloud console file download.

**PDF** (needs LaTeX):

```bash
R -q -e 'install.packages("tinytex", repos="https://cloud.r-project.org"); tinytex::install_tinytex()'
R -q -e 'setwd("'"$(pwd)"'"); rmarkdown::render("Assignment_Tasks1_2.Rmd", output_format = "pdf_document")'
```

## 7. Troubleshooting

| Symptom | Likely cause | Fix |
|---------|----------------|-----|
| `cannot open file 'my_dataQ1.csv'` | Wrong working directory | `cd` to repo root; in R use `setwd()` to that path |
| `Install packages: glmnet` | Missing dev libraries | Re-run `apt-get install` lines in section 2, then reinstall `glmnet` |
| LDA / matrix errors in knit | Corrupt or wrong CSV | Confirm dimensions with `Rscript validate_run.R` |
| Pandoc not found | `pandoc` not installed | `sudo apt-get install pandoc` |
| Knit very slow on 1 vCPU | Large tree + 500 predictors | Use a larger instance or wait; smoke test is enough for “functionality” |
| `git push` HTTP 403 on corporate network | Proxy blocks `git-receive-pack` | Test on the cloud VM (often works) or use SSH remote |

## 8. Quick validation checklist

Printable list: [verification-checklist.md](verification-checklist.md).

After a successful run on Ubuntu, you can treat the environment as validated for the same commit you tested (`git rev-parse HEAD`).