#Tests for fast_missing_impute function
#making a sample tibble
sample_data = tibble::tibble("col_1"= c(1L, NA, 3L, 4L, 5L, NaN),
                             "col_2"=c("a", NA, "d", "d", "f","e"),
                             "col_3"=c(7, 10, 13, 4, 12, NaN),
                             "col_4"=c(7, 13, 13, NA, 12, 12),
                             "col_5"=as.factor(c("hello", "be", "as", NA, "she","hi")),
                             "col_6"= rep(NaN,6),
                             "col_7"= c(NA, 2016L, 2017L, 2017L, 2019L, 2020L),
                             "col_8"= as.Date(c("2018-02-04",NA,"2018-02-04","2018-02-07","2018-02-08","2018-02-09")))
#making a sample list
my_list = c(10, 11, 15)

#Edge Case Tests----------------------------------------------------------------------------------------------------------------------------
test_that("df input must be a dataframe or tibble", {
  expect_error(fast_missing_impute(df = my_list, method = "median", cols = c("col_8")), "Data must be a data frame or tibble!", ignore.case = TRUE)
})

test_that("method input must be a string", {
  expect_error(fast_missing_impute(df = sample_data, method = mean, cols = c("col_8")), "Method must be a string!", ignore.case = TRUE)
})

test_that("cannot use multiple methods at the same time", {
  expect_error(fast_missing_impute(df = sample_data, method = c("mean", "median"), cols = c("col_7", "col_8")), "Must include one and only one method!", ignore.case = TRUE)
})

test_that("method must be 'remove', 'mean', 'median', or 'mode'", {
  expect_error(fast_missing_impute(df = sample_data, method = c("average"), cols = c("col_7", "col_8")), "Not a valid method!", ignore.case = TRUE)
})

test_that("cols must be a character vector", {
  expect_error(fast_missing_impute(df = sample_data, method = "mean", cols = list("col_7", "col_8")), "cols must be a character vector!", ignore.case = TRUE)
})

test_that("cols must be columns in the dataframe or tibble", {
  expect_error(fast_missing_impute(df = sample_data, method = "mean", cols = c("col_7", "col_9")), "One or more of the column names are not in the data frame or tibble!", ignore.case = TRUE)
})

test_that("when cols has a non-numeric column, can only use methods 'remove' or 'mode'", {
  expect_error(fast_missing_impute(df = sample_data, method = "mean", cols = c("col_2", "col_5")), "With non-numeric columns, can only use method = 'remove' or 'mode'!", ignore.case = TRUE)
})

#Unit Tests--------------------------------------------------------------------------------------------------------------------------
test_that("mean should leave selected columns with no NAs and leave other columns the same", {
  sample_mean <- fast_missing_impute(df = sample_data, method = "mean", cols = c("col_1", "col_3"))
  expect_equal(sum(is.na(sample_mean$col_1)), 0)
  expect_equal(sum(is.na(sample_mean$col_3)), 0)
  expect_gt(sum(is.na(sample_mean$col_4)), 0) #should keep its NA because it's not in cols
  expect_equal(dim(sample_mean), dim(sample_data)) #dimensions should not change
})

test_that("mean should replace NAs and NaNs with the mean and leave other values the same", {
  sample_mean <- fast_missing_impute(df = sample_data, method = "mean", cols = c("col_1", "col_3"))
  expect_equal(sample_mean$col_1[2], mean(sample_data$col_1, na.rm = TRUE))
  expect_equal(sample_mean$col_1[6], mean(sample_data$col_1, na.rm = TRUE))
  expect_equal(sample_mean$col_3[6], mean(sample_data$col_3, na.rm = TRUE))
  expect_equal(sample_mean$col_1[1], sample_data$col_1[1]) #should stay unchanged because it wasn't an NA or NaN
})

test_that("median should leave selected columns with no NAs and leave other columns the same", {
  sample_median <- fast_missing_impute(df = sample_data, method = "median", cols = c("col_1", "col_7"))
  expect_equal(sum(is.na(sample_median$col_1)), 0)
  expect_equal(sum(is.na(sample_median$col_7)), 0)
  expect_gt(sum(is.na(sample_median$col_3)), 0) #should keep its NA because it's not in cols
  expect_equal(dim(sample_median), dim(sample_data)) #dimensions should not change
})

test_that("median should replace NAs and NaNs with the median and leave other values the same", {
  sample_median <- fast_missing_impute(df = sample_data, method = "median", cols = c("col_1", "col_7"))
  expect_equal(sample_median$col_1[2], stats::median(sample_data$col_1, na.rm = TRUE))
  expect_equal(sample_median$col_1[6], stats::median(sample_data$col_1, na.rm = TRUE))
  expect_equal(sample_median$col_7[1], stats::median(sample_data$col_7, na.rm = TRUE))
  expect_equal(sample_median$col_1[1], sample_data$col_1[1]) #should stay unchanged because it wasn't an NA or NaN
})

test_that("mode should leave selected columns with no NAs and leave other columns the same", {
  sample_mode <- fast_missing_impute(df = sample_data, method = "mode", cols = c("col_2", "col_3", "col_8"))
  expect_equal(sum(is.na(sample_mode$col_2)), 0)
  expect_equal(sum(is.na(sample_mode$col_3)), 0)
  expect_equal(sum(is.na(sample_mode$col_8)), 0)
  expect_gt(sum(is.na(sample_mode$col_1)), 0) #should keep its NA because it's not in cols
  expect_equal(dim(sample_mode), dim(sample_data)) #dimensions should not change
})

test_that("mode should replace NAs and NaNs with the mode and leave other values the same", {
  sample_mode <- fast_missing_impute(df = sample_data, method = "mode", cols = c("col_2", "col_3", "col_8"))
  expect_equal(sample_mode$col_2[2], "d")
  expect_equal(sample_mode$col_3[6], sample_data$col_3[1]) #should replace with first value of column since there is no mode
  expect_equal(sample_mode$col_8[2], as.Date("2018-02-04"))
  expect_equal(sample_mode$col_8[6], sample_data$col_8[6]) #should stay unchanged because it wasn't an NA or NaN
})

test_that("remove should leave selected columns with no NAs and leave other columns the same", {
  sample_drop <- fast_missing_impute(df = sample_data, method = "remove", cols = c("col_1"))
  expect_equal(sum(is.na(sample_drop$col_1)), 0)
  expect_equal(sum(is.na(sample_drop$col_3)), 0)
  expect_gt(sum(is.na(sample_drop$col_4)), 0) #should keep its NA because it's not in cols and NA row is not part of col_1's
  expect_less_than(dim(sample_drop)[1], dim(sample_data)[1]) #rows should be fewer
  expect_equal(dim(sample_drop)[2], dim(sample_data)[2]) #columns should be the same
})
