# toymodel1

A minimal, dependency-free **toy prediction model** for the
[ModelsCloud](https://github.com/resplab/modelscloud) platform. It predicts a
risk from three predictors using a fixed-coefficient logistic score —
illustrative only, not a real risk model.

**Predictors**

- `sex` — patient sex, coded `0` = female, `1` = male.
- `age` — age in years.
- `marker_value` — a generic numeric biomarker; higher values raise the
  predicted risk.

It implements the standard prediction-model API:

| Function | Role |
|---|---|
| `model_run(model_input)` | Predict for a table of patients (synchronous) |
| `get_sample_input()` | Return an example input dataset |

`model_run()` also draws a **barplot of the predicted risks** as a side effect.
On the server OpenCPU captures this plot automatically, so it can be retrieved
with `modelscloud::get_plots()`.

## Via modelscloud

```r
library(modelscloud)

# Public testing key — fine to use for trying out the examples collection
connect_to_model("examples/toymodel1",
                 access_key = "23b7bab3-118e-4516-b53c-91bca8e0082d")

sample <- get_sample_input()
result <- model_run(sample)

# Retrieve the barplot the model produced
get_plots(result)            # list available plots
img <- get_plots(result, id = 1)   # retrieve the barplot
plot(img)                          # display it
```

Prediction models are always called synchronously.

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
