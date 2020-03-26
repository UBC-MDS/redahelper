#' Create Pearson correlation matrix for columns in dataframe
#'
#' The function takes in a dataframe/tibble and a vector of column names
#' and creates a Pearson correlation matrix.
#' The correlation matrix can only include numeric columns
#'
#' @param df The data that will be plotted
#' @param selected_columns The vector of column names to be included in Pearson correlation matrix
#'
#' @return ggplot object
#' @export
#' @examples
#' fast_corr(iris, c('Sepal.Length','Sepal.Width', 'Petal.Length','Petal.Width', 'Species'))
#' fast_corr(iris, c(1,2,3,4,5))

fast_corr <- function(df, selected_columns) {
  
  # assert test
  if(!tibble::is_tibble(df) & !is.data.frame(df)){
    stop("The type of the input data must be tibble or dataframe")
  }
  
  if(!is.vector(selected_columns) | is.list(selected_columns)){
    stop("The selected_columns must be a vector")
  }
  
  if(length(selected_columns) < 2){
    stop("At least two columns must be selected for correlation analysis")
  }
  
  if (typeof(selected_columns)=='character' & sum(selected_columns %in% colnames(df)==TRUE)!=length(selected_columns)){
    stop('The column names were not found')
  }
  
  if (typeof(selected_columns)!='character' & max(selected_columns) > ncol(df)){
    stop('The column indexes were out of range')
  }
  
  # only use numeric columns
  data <- dplyr::select_if(df[,selected_columns], is.numeric)
  if (ncol(data)!=length(selected_columns)){
    n = length(selected_columns) - ncol(data)
    print(paste("Removed", n, "non-numberical columns from your selected columns"))
  }
  
  # calculate correlation
  corr <- round(cor(data), 1)
  # calculate p-value for correlation
  p.mat <- ggcorrplot::cor_pmat(data)
  # make plot
  ggcorrplot::ggcorrplot(corr, p.mat = p.mat,type = "lower", hc.order = TRUE, outline.col = "white") + ggplot2::ggtitle("Correlation Matrix") +
    ggplot2::theme(plot.title = ggplot2::element_text(size=22), axis.text.x = ggplot2::element_text(size=18),axis.text.y = ggplot2::element_text(size=18), panel.grid=ggplot2::element_blank(),legend.title= ggplot2::element_text(size=18), legend.text=ggplot2::element_text(size=15))
  
}
