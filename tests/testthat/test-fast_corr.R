#tests for input
test_that('The type of the input data must be tibble or dataframe', {
  test_df <- as.list(iris)
  expect_error(fast_corr(test_df,selected_columns))
})

test_that('The selected_columns must be a vector', {
  expect_error(fast_corr(test_df,list(1,2,3)))
})

test_that('At least two columns must be selected for correlation analysis', {
  expect_error(fast_corr(test_df,c(1)))
})

test_that('The column names were not found', {
  expect_error(fast_corr(test_df,c('Sepal.Length','Sepal.Width', 'fun')))
})

test_that('The column indexes were out of range', {
  expect_error(fast_corr(test_df,c(1,2,6)))
})


# test for selecting only the numeric columns
test_that('1 non-numerical column should be droppd', {
  expect_true((length(selected_columns) - ncol(dplyr::select_if(test_df[,selected_columns], is.numeric)))==1)
})

# tests for the plot object
test_that('Plot should use GeomTile and GeomRect to generate matrix.', {
  test_df <- iris
  selected_columns <- c('Sepal.Length','Sepal.Width', 'Petal.Length','Petal.Width', 'Species')
  p <- fast_corr(test_df,selected_columns)
  expect_true("GeomTile" %in% c(class(p$layers[[1]]$geom)))
  expect_true("GeomRect" %in% c(class(p$layers[[1]]$geom)))
})

test_that('The number of squares in the correlation matrix should be 6', {
  test_df <- iris
  selected_columns <- c('Sepal.Length','Sepal.Width', 'Petal.Length','Petal.Width', 'Species')
  p <- fast_corr(test_df,selected_columns)
  expect_true(nrow(p$data)==6)
})

test_that('One of squares in the correlation matrix should be labeled as non-significant', {
  test_df <- iris
  selected_columns <- c('Sepal.Length','Sepal.Width', 'Petal.Length','Petal.Width', 'Species')
  p <- fast_corr(test_df,selected_columns)
  expect_true(sum(p$data$signif[1]==0)==1)
})

test_that('The title of the plot should be "Correlation Matrix" with text size of 22', {
  test_df <- iris
  selected_columns <- c('Sepal.Length','Sepal.Width', 'Petal.Length','Petal.Width', 'Species')
  p <- fast_corr(test_df,selected_columns)
  expect_true(p$labels$title=='Correlation Matrix')
  expect_true(p$theme$plot.title$size==22)
})

test_that('The size of the x and y axis text should be 18', {
  test_df <- iris
  selected_columns <- c('Sepal.Length','Sepal.Width', 'Petal.Length','Petal.Width', 'Species')
  p <- fast_corr(test_df,selected_columns)
  expect_true(p$theme$axis.text.y$size==18)
  expect_true(p$theme$axis.text.x$size==18)
})

test_that('The panel should not have grid', {
  test_df <- iris
  selected_columns <- c('Sepal.Length','Sepal.Width', 'Petal.Length','Petal.Width', 'Species')
  p <- fast_corr(test_df,selected_columns)
  expect_true("element_blank" %in% c(class(p$theme$panel.grid)))
})
