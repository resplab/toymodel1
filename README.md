# toymodel1

A minimal, dependency-free **example prediction model** for the
[ModelsCloud](https://github.com/resplab/modelscloud) platform. A dot-free copy
of `toy.pred.model` (Pexa currently has trouble routing model names that
contain dots).

It implements the standard prediction-model API:

| Function | Role |
|---|---|
| `model_run(model_input)` | Predict for a table of patients (synchronous) |
| `get_sample_input()` | Return an example input dataset |

The "model" is a fixed-coefficient logistic risk score over `sex`
(0 = female, 1 = male), `age` (years), and `marker_value` (a numeric
biomarker) — illustrative only, not a real risk model.

## Local use

```r
# devtools::load_all() or install, then:
sample <- get_sample_input()
result <- model_run(sample)
result[, c("sex", "age", "marker_value", "risk")]
#>   sex age marker_value    risk
#> 1   0  55          1.2 0.05787
#> 2   1  62          2.4 0.27289
#> 3   1  48          0.7 0.04565
```

## Via modelscloud

```r
library(modelscloud)
connect_to_model("example/toymodel1", access_key = "YOUR_API_KEY")

sample <- get_sample_input()
result <- model_run(sample)
```

Prediction models are always called synchronously.
