#Creating helper data
test_df_1 = tibble("col_A"= c(1,2,1,2,3,3,1,2,4,5,1,2,1,2,3,3,1,2,4,5,1,2,1,2,3,3,1,2,4,5,1,2,1,2,3,3,1,2,4,5), 
                 "col_B"=c("A", "A", "A", "A","A","A","A","A","A","A","B", "B", "B", "B","B","B","B","B","B","B","C", "C", "C", "C","C","C","C","C","C","C","D", "D", "D", "D","D","D","D","D","D","D"),
                 "col_C"=c(8.1, 10.6, 8.9,7.9 ,9.9 ,12.1,10.1,9.5,8.7,8.5,8.1, 10.6, 8.9,7.9 ,9.9 ,12.1,10.1,9.5,8.7,8.5,8.1, 10.6, 8.9,7.9 ,9.9 ,12.1,10.1,9.5,8.7,8.5,8.1, 10.6, 8.9,7.9 ,9.9 ,12.1,10.1,9.5,8.7,8.5)
)

test_df_2 = tibble("col_A"= c(1000,1000,NaN,2,3,3,1,2,4,5,1,2,1,2,3,3,1,2,4,5,1,2,1,2,3,3,1,2,4,5,1,2,1,2,3,3,1,2,4,5), 
                 "col_B"=c("T", "X", "Y","Y","A","A","A","A","A","A","B", "B", "B", "B","B","B","B","B","B","B","C", "C", "C", "C","C","C","C","C","C","C","D", "D", "D", "D","D","D","D","D","D","D"),
                 "col_C"=c(1008.1, 1010.6, 1010.7,NaN ,9.9 ,12.1,10.1,9.5,8.7,8.5,8.1, 10.6, 8.9,7.9 ,9.9 ,12.1,10.1,9.5,8.7,8.5,8.1, 10.6, 8.9,7.9 ,9.9 ,12.1,10.1,9.5,8.7,8.5,8.1, 10.6, 8.9,7.9 ,9.9 ,12.1,10.1,9.5,8.7,8.5)
)
test_df_2[[4,2]] = NA

test_that("Data inputed must be a dataframe or tibble", {
  expect_error(fast_outlier_id(data = c(1,2,3)), "Data must be in Data Frame or Tibble!", ignore.case = TRUE)
})

test_that("Columns inputed must exist in the inputed dataframe/tibble", {
  expect_error(fast_outlier_id(test_df_2, cols = "T"), "Column name is not a column in data frame entered!", ignore.case = TRUE)
})

test_that("Method inputed must be z-score or interquantile", {
  expect_error(fast_outlier_id(test_df_2, method="x-score"), "The only permitted values are z-score or interquantile", ignore.case = TRUE)
})

test_that("NaNs are being identified as expected", {
  expect_true(sum(fast_outlier_id(test_df_1)$no_nans) == 0 && sum(fast_outlier_id(test_df_2)$no_nans) == 3)
})

test_that("Outliers are being identified as expected", {
  expect_true(sum(fast_outlier_id(test_df_1)$no_outliers) == 0 && sum(fast_outlier_id(test_df_2)$no_outliers) == 8)
})