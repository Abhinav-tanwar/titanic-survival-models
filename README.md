# Titanic Survival Models

Reproducible classifier comparison using explicitly synthetic demonstration data.

## Run

Requires R 4.4+ and packages MASS and jsonlite.

```r
install.packages(c("MASS", "jsonlite"))
```

```sh
Rscript scripts/run.R
Rscript tests/checks.R
```

Generated metrics and figures are saved in `results/`. Read [input provenance](data/README.md) and [method changes](docs/provenance.md).

## Executed results

All models use the same held-out records. Positive class is explicitly defined in metrics.json. Confusion matrices contain actual classes as rows and predicted classes as columns, in order 0, 1. Classification threshold is 0.5 for logistic regression.

| Model | Accuracy | Positive recall | Precision | ROC AUC |
|---|---:|---:|---:|---:|
| LDA simple | 0.690 | 0.597 | 0.614 | 0.726 |
| LDA full | 0.706 | 0.597 | 0.642 | 0.734 |
| QDA simple | 0.662 | 0.757 | 0.556 | 0.726 |
| Logistic | 0.690 | 0.597 | 0.614 | 0.726 |

**All scores use synthetic data.** They demonstrate the pipeline only and must not be represented as findings about historical Titanic passengers or as a reproduction of the original report.

## Reproducibility and scope

Seeds are fixed in source. Validation uses numerical invariants or input/split checks. This is a maintained reconstruction of the supplied work; methodological corrections and newly generated data mean some results intentionally differ from the original reports. Original PDFs are omitted to avoid publishing student identifiers.

## Reports

`report.html` is a ready-to-open summary. To render the R Markdown version after running the analysis, install `rmarkdown` and `knitr`, install Pandoc, and run `rmarkdown::render("report.Rmd")` from the repository root. The optional R Markdown rendering was not executed in the local environment because Pandoc is unavailable.
