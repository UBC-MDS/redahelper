#' Modifies missing data by removing or imputing with mean, median, mode, or multiple.
#'
#' The function takes in a dataframe, a list of column names to modify, and
#' a method of imputation.
#' The choices of imputation method are either remove (removes all rows with
#' missing data), mean, median, mode, or multiple imputation.
#'
#' @param df The dataframe of interest
#' @param method The method of imputation from: {remove, mean, median, mode}
#' @param cols The column names with missing data to be modified
#'
#' @return df
#' @export
#' @examples
#' fast_missing_impute(df = iris, method = "mean", cols = c("Sepal.Length", "Sepal.Width"))
#' fast_missing_impute(df = mtcars, method = "median", cols = c("hp", "gear", "carb"))
fast_missing_impute <- function(df, method, cols) {
  #making sure data is a data frame
  if (!is.data.frame(df) & !tibble::is_tibble(df)){
    stop("Data must be a data frame or tibble!")
  }

  #making sure method is a character
  `%not_in%` <- purrr::negate(`%in%`)
  if(typeof(method) != 'character'){
    stop("Method must be a string!")
  }

  #making sure there is only one method
  if(length(method) != 1){
    stop("Must include one and only one method!")

  }

  #making sure method a valid method
  if(method %not_in% c("remove", "mean", "median", "mode")){
    stop("Not a valid method!")
  }

  #making sure cols is a character vector
  if(typeof(cols) != 'character'){
    stop("cols must be a character vector!")
  }

  #making sure the columns are in the data frame and user is not using numeric functions on non-numeric functions
  for(col in cols){
    if(col %not_in% names(df)){
      stop("One or more of the column names are not in the data frame or tibble!")
    }
    if(class(df[[col]]) %in% c('character', 'date', 'factor') & method %not_in% c('remove', 'mode')){
      stop("With non-numeric columns, can only use method = 'remove' or 'mode'!")}
  }

  if(method == 'remove'){ #removes all rows with missing data in specified columns
    df <- tidyr::drop_na(df, cols)
  } else if(method == 'mean'){ #for specified columns, imputes missing data with mean of column
    for(col in cols){
      df[[col]][is.na(df[[col]])] = mean(df[[col]], na.rm=TRUE)}
  } else if(method == 'median'){ #for specified columns, imputes missing data with median of column
    for(col in cols){
      df[[col]][is.na(df[[col]])] = stats::median(df[[col]], na.rm=TRUE)}
  } else if(method == 'mode'){ #for specified columns, imputes missing data with mode of column
    for(col in cols){
      mode <- function(x) {
        uniq <- unique(x)
        uniq[which.max(tabulate(match(x, uniq)))]}
      df[[col]][is.na(df[[col]])] = mode(df[[col]])}
  }
  return(df)
}
