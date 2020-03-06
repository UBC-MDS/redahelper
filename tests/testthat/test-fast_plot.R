test_df = tibble("col_int"= c(1L, 2L, 3L, 4L, 5L, 6L), 
                 "col_chr"=c("a", "b", "d", "d", "f","e"),
                 "col_flt"=c(7, 10.6, 13, 4.2, 12, NaN),
                 "col_fct_chr"=as.factor(c("hello", "be", "as", "who", "she","hi")),
                 "col_nan"= rep(NaN,6),
                 "col_fct_flt"= as.factor(c(7, 10.6, 13, 4.2, 12, 11.5)),
                 "col_date"= as.Date(c("2018-02-04","2018-02-05","2018-02-06","2018-02-07","2018-02-08","2018-02-09"))
)


# input tests

test_that("df input must be a dataframe or tibble", {
  expect_error(fast_plot(df = c(1,2,3), x = "col_int", "col_flt", "scatter"), "Data must be in Data Frame or Tibble!", ignore.case = TRUE)
})

test_that("x input must be a string", {
  expect_error(fast_plot(df = test_df, x = c("col_int", "hi"), "col_flt", "scatter"), "x column name must be a string!", ignore.case = TRUE)
})

test_that("y input must be a column in data", {
  expect_error(fast_plot(df = test_df, x = "col_int", "abcd", "scatter"), "y column name is not a column in data frame entered!", ignore.case = TRUE)
})

test_that("plot type must be scatter/bar/line", {
  expect_error(fast_plot(df = test_df, x = "col_int", "col_flt", "jlsfsdf"), 'plot_type must be either: "scatter", "line",  or "bar"', ignore.case = TRUE)
})

test_that("column cannot be completely null", {
  expect_error(fast_plot(df = test_df, x = "col_nan", "col_flt", "bar"), "x Column must not be all Null!", ignore.case = TRUE)
})

# base cases for each plot type 

test_that('Scatter plot should use geom_point and have x and y labels be the 
column names.', {
  p <- fast_plot(df = test_df, x = "col_int", y="col_flt", plot_type ="scatter")
  expect_true("GeomPoint" %in% c(class(p$layers[[1]]$geom)))
  expect_true("col_int" %in% p$labels$x)
  expect_true("col_flt" %in% p$labels$y)
})

test_that('Line plot should use geom_point and geom_line, have x and y labels be the 
column names and data used in plot must be identical to input data.', {
  p <- fast_plot(df = test_df, x = "col_int", y="col_flt", plot_type ="line")
  expect_true("GeomPoint" %in% c(class(p$layers[[1]]$geom)))
  expect_true("GeomLine" %in% c(class(p$layers[[2]]$geom)))
  expect_true("col_int" %in% p$labels$x)
  expect_true("col_flt" %in% p$labels$y)
})

test_that('Bar plot should use geom_bar, have x and y labels be the 
column names.', {
  p <- fast_plot(df = test_df, x = "col_int", y="col_flt", plot_type ="bar")
  expect_true("GeomBar" %in% c(class(p$layers[[1]]$geom)))
  expect_true("col_int" %in% p$labels$x)
  expect_true("col_flt" %in% p$labels$y) 
})

# scatter plot if statement tests

test_that("Can't use column with date type as y for scatter plot", {
  expect_error(fast_plot(df = test_df, x = "col_int", y="col_date", plot_type ="scatter"), "Y column cannot be a date type!", ignore.case = TRUE)
})

test_that('Scatter plot with x as date: use geom_point and have x and y labels be the 
column names and x column should be transformed to factor. ', {
  p <- fast_plot(df = test_df, x = "col_date", y="col_flt", plot_type ="scatter")
  expect_true("GeomPoint" %in% c(class(p$layers[[1]]$geom)))
  expect_true("col_date" %in% p$labels$x)
  expect_true("col_flt" %in% p$labels$y)
  expect_true(is.factor(p$data[["col_date"]]))  
})

# line plot if statement tests
test_that("Can't use column with date type as y for line plot", {
  expect_error(fast_plot(df = test_df, x = "col_int", y="col_date", plot_type ="line"), "Y column cannot be a date type!", ignore.case = TRUE)
})

# bar plot if statement tests

test_that("x and y cannot both be of type character in bar chart", {
  expect_error(fast_plot(df = test_df, x = "col_chr", y="col_chr", plot_type ="bar"), 
               "Bar charts should have a numeric column, and both X and Y are non numeric!", ignore.case = TRUE)
})

test_that("x cannot be date and y cannot character in bar chart", {
  expect_error(fast_plot(df = test_df, x = "col_date", y="col_chr", plot_type ="bar"), 
               "Bar charts should have a numeric column, and both X and Y are non numeric!", ignore.case = TRUE)
})

test_that("x cannot be factor with non numeric elements and y cannot character in bar chart", {
  expect_error(fast_plot(df = test_df, x = "col_fct_chr", y="col_chr", plot_type ="bar"), 
               "Bar charts should have a numeric column, and both X and Y are non numeric!", ignore.case = TRUE)
})


test_that("x can't be character and y can't be factor with non numeric elements in bar chart", {
  expect_error(fast_plot(df = test_df, x = "col_chr", y="col_fct_chr", plot_type ="bar"), 
               "Bar charts should have a numeric column, and both X and Y are non numeric!", ignore.case = TRUE)
})

test_that("x can't be date and y can't be factor with non numeric elements in bar chart", {
  expect_error(fast_plot(df = test_df, x = "col_date", y="col_fct_chr", plot_type ="bar"), 
               "Bar charts should have a numeric column, and both X and Y are non numeric!", ignore.case = TRUE)
})

test_that("x and y cannot be factor with non numeric elements in bar chart", {
  expect_error(fast_plot(df = test_df, x = "col_fct_chr", y="col_fct_chr", plot_type ="bar"), 
               "Bar charts should have a numeric column, and both X and Y are non numeric!", ignore.case = TRUE)
})


test_that('Bar plot with numeric x and y as date: use geom_bar and have x and y labels be the 
column names and y column should be transformed to factor. ', {
  p <- fast_plot(df = test_df, x = "col_int", y ="col_date", plot_type ="bar")
  expect_true("GeomBar" %in% c(class(p$layers[[1]]$geom)))
  expect_true("col_date" %in% p$labels$x)
  expect_true("col_int" %in% p$labels$y)
  expect_true(is.factor(p$data[["col_date"]]))  
})

test_that('Bar plot with x and y both numeric: use geom_bar and have x and y labels be the 
column names and x column should be transformed to factor. ', {
  p <- fast_plot(df = test_df, x = "col_int", y ="col_flt", plot_type ="bar")
  expect_true("GeomBar" %in% c(class(p$layers[[1]]$geom)))
  expect_true("col_int" %in% p$labels$x)
  expect_true("col_flt" %in% p$labels$y)
  expect_true(is.factor(p$data[["col_int"]]))  
})


