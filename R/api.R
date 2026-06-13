# toymodel1 — a minimal example PREDICTION model for ModelsCloud.
#
# Demonstrates the standard prediction-model API expected by modelscloud:
#   - model_run(model_input)  : synchronous; returns predictions for the input
#   - get_sample_input()       : an example input dataset
#
# The "model" is a fixed-coefficient logistic risk score over sex, age, and a
# generic marker_value. It has no external dependencies and is a template, not
# a real risk model — the coefficients are made up.

# Known input variables — single source of truth for validation.
.var_names <- c("sex", "age", "marker_value")

# Fixed (illustrative) logistic coefficients.
.coefs <- c(
  intercept    = -4.00,
  sex          =  0.50,   # extra log-odds for male (sex = 1)
  age          =  0.05,   # per year above 50
  marker_value =  0.80    # per unit of the marker
)

#' Run the toy prediction model
#'
#' Computes a predicted risk for each row of `model_input` from a fixed
#' logistic score. This is the synchronous prediction-model pattern: a single
#' `model_input` (a table of patients) in, the same table plus predictions out.
#'
#' @param model_input Named list or data frame with columns `sex`
#'   (0 = female, 1 = male), `age` (years), and `marker_value` (a numeric
#'   biomarker). Multiple rows are predicted at once.
#'
#' @return The input as a data frame with an added `risk` column (predicted
#'   probability in `[0, 1]`).
#' @export
model_run <- function(model_input = NULL) {
  if (is.null(model_input)) {
    stop("model_input is required.", call. = FALSE)
  }

  unknown <- setdiff(names(model_input), .var_names)
  if (length(unknown) > 0) {
    stop("Unknown input variable(s): ", paste(unknown, collapse = ", "),
         call. = FALSE)
  }

  df <- as.data.frame(model_input, stringsAsFactors = FALSE)

  missing <- setdiff(.var_names, names(df))
  if (length(missing) > 0) {
    stop("Missing required variable(s): ", paste(missing, collapse = ", "),
         call. = FALSE)
  }

  b <- .coefs
  lp <- b[["intercept"]] +
    b[["sex"]]          * df$sex +
    b[["age"]]          * (df$age - 50) +
    b[["marker_value"]] * df$marker_value

  df$risk <- 1 / (1 + exp(-lp))
  df
}

#' Sample input for the toy prediction model
#'
#' Returns a small data frame of example patients that can be passed verbatim
#' to [model_run()], i.e. `model_run(get_sample_input())` works directly.
#'
#' @return A data frame of 3 example patients with columns `sex`, `age`, and
#'   `marker_value`.
#' @export
get_sample_input <- function() {
  data.frame(
    sex          = c(0, 1, 1),
    age          = c(55, 62, 48),
    marker_value = c(1.2, 2.4, 0.7)
  )
}
