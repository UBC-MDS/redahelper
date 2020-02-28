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
#' check_route(tibble(lat = -3, long = 3), tibble(lat = -seq(0, 10, 2), long = seq(0, 10, 2)))
#' fast_plot(iris, "Sepal.Length", "Sepal.Width", "scatter")
fast_plot  <- function(df, x, y, plot_type){   
}