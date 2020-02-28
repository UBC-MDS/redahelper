#' Modifies missing data by removing or imputing with mean, median, mode, or multiple.
#'
#' The function takes in a dataframe, a list of column names to modify, and
#' a method of imputation.
#' The choices of imputation method are either remove (removes all rows with
#' missing data), mean, median, mode, or multiple imputation.
#'
#' @param df The dataframe of interest
#' @param method The method of imputation from: {remove, mean, median, mode, multiple}
#' @param cols The column names with missing data to be modified
#'
#' @return df
#' @export
#' @examples
#' fast_missing_impute(data = iris, method = "mean", cols = c("Sepal.Length", "Sepal.Width"))
#' fast_missing_impute(mtcars, "median", c("hp", "gear", "carb"))
fast_missing_impute <- function(df, method, cols) {
}
