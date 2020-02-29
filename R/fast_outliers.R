#' Analyzes the values of a given column list in a given dataframe, identifies outliers using either the Z-Score algorithm or interquantile range algorithm.
#' The return is a dataframe containing the following columns: column name, list containing the outlier's index position, percentaje of total counts considered outliers.
#' Modifies an existing dataframe, with missing values
#' imputed based on the chosen method.
#'
#' @param data dataframe - Dataframe to be analyzed
#' @param columns list -  List containing the columns to be analyzed.
#' @param method string - string indicating which method to be used to identify outliers (methods available are: "Z score" or "Interquantile Range")
#'
#' @return dataframe
#' @export
#' @examples
#' fast_outliers_identifier(data = iris, method = "Z score", cols =  c("Sepal.Length", "Sepal.Width"))
fast_outliers_id <- function(data, columns, method) {
}