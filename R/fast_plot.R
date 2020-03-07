#' Creates either scatter plot, line plot or bar chart using two columns from dataframe
#'
#' The function takes in a dataframe, two column names for x and y axis and a plot type and
#' creates the plot using the ggplot2 library.
#' The plot types are restricted to either line plot, scatter plot or bar chart.
#' The function includes error handling to stop plots from being created for inappropriate
#' column types, such as a scatter plot will not be appropriate if both columns have categorical types

#' @param df The data that will be plotted
#' @param x The column name for the x variable
#' @param y The column name for the y variable
#' @param plot_type The type of plot from: {scatter, line, bar}

#' @return ggplot object
#' @export
#' @examples
#' fast_plot(iris, "Sepal.Length", "Sepal.Width", "scatter")
fast_plot <- function(df, x, y, plot_type) {
  
  # ASSERT TESTS
  
  # check that df is DataFrame or Tibble
  if (!tibble::is_tibble(df) & !is.data.frame(df)) {
    stop("Data must be in Data Frame or Tibble!")
  }
  
  # check that x and y are strings, and are valid columns
  
  if (!is.character(x) | length(x) != 1) {
    stop("x column name must be a string!")
  }
  
  if (!is.character(y) | length(y) != 1) {
    stop("y column name must be a string!")
  }
  
  if (!x %in% colnames(df)) {
    stop("x column name is not a column in data frame entered!")
  }
  
  if (!y %in% colnames(df)) {
    stop("y column name is not a column in data frame entered!")
  }
  
  # check that plot_type is one of the three allowed
  if (!tolower(plot_type) %in% c("scatter", "line", "bar")) {
    stop('plot_type must be either: "scatter", "line",  or "bar"')
  }
  
  # check that column is not all nulls
  
  if (sum(is.na(df[[x]])) == length(df[[x]])) {
    stop("x Column must not be all Null!")
  }
  
  if (sum(is.na(df[[y]])) == length(df[[y]])) {
    stop("y Column must not be all Null!")
  }
  
  
  x_type <- typeof(df[[x]])
  y_type <- typeof(df[[y]])
  
  # scatter plot
  
  # - if y is date - create error
  # - if x is date - make it factor
  if (tolower(plot_type) == "scatter") {
    if (lubridate::is.Date(df[[y]]) == TRUE) {
      stop("Y column cannot be a date type!")
    }
    
    if (lubridate::is.Date(df[[x]]) == TRUE) {
      df[x] <- factor(df[[x]])
    }
    p <- ggplot2::ggplot(df, ggplot2::aes_string(x = x, y = y)) +
      ggplot2::geom_point(na.rm = TRUE)
    
    # line plot
    # - if y is date - create error
  } else if (tolower(plot_type) == "line") {
    if (lubridate::is.Date(df[[y]]) == TRUE) {
      stop("Y column cannot be a date type!")
    } else {
      p <- ggplot2::ggplot(df, ggplot2::aes_string(x = x, y = y, group = 1)) +
        ggplot2::geom_point(stat = "summary", fun.y = sum, na.rm = TRUE) +
        ggplot2::stat_summary(fun.y = sum, geom = "line", na.rm = TRUE)
    }
    # bar chart
  } else {
    # if type of y is character
    # - stop if both columns are characters
    # - stop if x is a date
    # - else 
    #     - if factor and character - stop
    # if y is a factor
    # - if y is a character and x is either character or date - stop
    # - if x is also factor and not numeric - stop
    # if both x and y are dates - stop
    # if x is numeric or date
    # - if y is date - make y a factor
    # - else make x a factor
    if (y_type == "character") {
      if (y_type == x_type) {
        stop("Bar charts should have a numeric column, and both X and Y are non numeric!")
      } else if (lubridate::is.Date(df[[x]])) {
        stop("Bar charts should have a numeric column, and both X and Y are non numeric!")
      } else {
        if (is.factor(df[[x]])) {
          digit <- all(grepl("^[0-9]{1,}$", droplevels(df[[x]])))
          if (digit == FALSE) {
            stop("Bar charts should have a numeric column, and both X and Y are non numeric!")
          }
          p <- ggplot2::ggplot(df, ggplot2::aes_string(x = y, y = x)) +
            ggplot2::geom_bar(stat = "identity", na.rm = TRUE, fill = "steelblue") +
            ggplot2::coord_flip()
        } else {
          p <- ggplot2::ggplot(df, ggplot2::aes_string(x = y, y = x)) +
            ggplot2::geom_bar(stat = "identity", na.rm = TRUE, fill = "steelblue") +
            ggplot2::coord_flip()
        }
      }
    } else if (is.factor(df[[y]])) {
      digit <- all(grepl("^[0-9]{1,}$", droplevels(df[[y]])))
      if (digit == FALSE) {
        if (x_type == "character" | lubridate::is.Date(df[[x]])) {
          stop("Bar charts should have a numeric column, and both X and Y are non numeric!")
        } else if (is.factor(df[[x]])) {
          digit <- all(grepl("^[0-9]{1,}$", droplevels(df[[x]])))
          if (digit == FALSE) {
            stop("Bar charts should have a numeric column, and both X and Y are non numeric!")
          }
        }
        
        p <- ggplot2::ggplot(df, ggplot2::aes_string(x = y, y = x)) +
          ggplot2::geom_bar(stat = "identity", na.rm = TRUE, fill = "steelblue") +
          ggplot2::coord_flip()
      }
    } else if (lubridate::is.Date(df[[x]]) & lubridate::is.Date(df[[y]])) {
      stop("Bar charts should have a numeric column, and both X and Y are non numeric!")
    } else {
      if (is.numeric(df[[x]]) | lubridate::is.Date(df[[x]])) {
        if (lubridate::is.Date(df[[y]])) {
          df[y] <- factor(df[[y]])
          
          p <- ggplot2::ggplot(df, ggplot2::aes_string(x = y, y = x)) +
            ggplot2::geom_bar(stat = "identity", na.rm = TRUE, fill = "steelblue") +
            ggplot2::coord_flip()
        } else {
          df[x] <- factor(df[[x]])
          p <- ggplot2::ggplot(df, ggplot2::aes_string(x = x, y = y)) +
            ggplot2::geom_bar(stat = "identity", na.rm = TRUE, fill = "steelblue")
        }
      } else {
        df[x] <- factor(df[[x]])
        p <- ggplot2::ggplot(df, ggplot2::aes_string(x = x, y = y)) +
          ggplot2::geom_bar(stat = "identity", na.rm = TRUE, fill = "steelblue")
      }
    }
  }
  return(p)
}


