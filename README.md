
## redahelper

[![codecov](https://codecov.io/gh/UBC-MDS/redahelper/branch/master/graph/badge.svg)](https://codecov.io/gh/UBC-MDS/redahelper)
[![R-CMD-check](https://github.com/UBC-MDS/redahelper/workflows/R-CMD-check/badge.svg)](https://github.com/UBC-MDS/redahelper/actions)

An R package that simplifies up the main EDA procedures such as: outlier
identification, data visualization, correlation, missing data
imputation.

### Authors

| [Ofer Mansour](https://github.com/ofer-m) | [Suvarna Moharir](https://github.com/suvarna-m) | [Subing Cao](https://github.com/scao1) | [Manuel Maldonado](https://github.com/manu2856) |
| :---------------------------------------: | :---------------------------------------------: | :------------------------------------: | :---------------------------------------------: |

### Project Overview

Data understanding and cleaning represents 60% of data scientist’s time
given to any project. The goal with this package is to simplify this
process , and make a more efficient use of time while working on some of
the main procedures done in EDA (outlier identification, data
visualization, correlation, missing data imputation).

### Installation:

To start using our package, please follow these instructions:

1.  Ensure `devtools` is installed on your computer. If not, you can
    open the console and input the following:

<!-- end list -->

    install.packages('devtools')

2.  Load `devtools` by inputting this command into the console:

<!-- end list -->

    library(devtools)

3.  Install the `redahelper` package by inputting this command into the
    console:

<!-- end list -->

    devtools::install_github("UBC-MDS/redahelper")

### Documentation

  - The package website can be found
    [here](https://ubc-mds.github.io/redahelper/index.html)

  - The vignette can be found
    [here](https://ubc-mds.github.io/redahelper/articles/redahelper-vignette.html)

### Functions

| Function Name         | Input                                                                                                                                                          | Output                                                                                                                        | Description                                                                                                                                                                                                            |
| --------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| fast\_outliers\_id    | 3 parameters: A dataframe , a list of columns to be included in analysis,method to be used to identify outliers (“Z-score algorithm” or “Interquantile Range”) | dataframe with included columns and outlier values identified, and % of counts considered as outliers for each anlyzed column | Given a dataframe, a list of given columns are analyzed in search for outlier values and return a dataframe summarizing the outliers values found and indicating which % of the counts are affected by this outlier(s) |
| fast\_plot            | 4 parameters: dataframe, name of X column, name of y column, plot name                                                                                         | Plot object                                                                                                                   | Given a dataframe ,the columns to be considered X an Y respectively, and the desired plot; the function computes and returns the specified plot                                                                        |
| fast\_corr            | 2 parameters: dataframe, list of columns to be analyzed,                                                                                                       | correlation plot object                                                                                                       | Calculates the correlation of all specified columns and generates a plot visualizing the correlation coefficients.                                                                                                     |
| fast\_missing\_impute | 3 parameters: dataframe, a string specifying the missing data treatment method,list of columns to be treated                                                   | new dataframe without missing values in the specified columns                                                                 | Given a dataframe and a list of columns in that dataframe, missing values are identified and treated as specified in the missing data treatment method                                                                 |

### Usage

The package can analyze the values of a given column list, and identify
outliers using either the ZScore algorithm or interquantile range
algorithm. Below is an example of a column to analyze.

``` r
sample_data = tibble::tibble("col_a" = c(5000, 50, 6, 8, NaN, 10, 5, 2, 3))
sample_data
```

    ## # A tibble: 9 x 1
    ##   col_a
    ##   <dbl>
    ## 1  5000
    ## 2    50
    ## 3     6
    ## 4     8
    ## 5   NaN
    ## 6    10
    ## 7     5
    ## 8     2
    ## 9     3

After using the `fast_outlier_id` function, it returns the following
summary:

``` r
library(redahelper)
fast_outlier_id(data=sample_data,cols="All",method = "z-score",threshold_low_freq = 0.05)
```

    ## # A tibble: 1 x 8
    ##   column_name type  no_nans perc_nans outlier_method no_outliers perc_outliers
    ##   <chr>       <chr>   <int>     <dbl> <list>               <int> <list>       
    ## 1 col_a       nume~       1      0.11 <chr [1]>                1 <dbl [1]>    
    ## # ... with 1 more variable: outlier_values <list>

`redahelper` can also quickly create scatter, line or bar plots from a
pandas data frame, using the ggplot2 library. As an example, using the
iris dataset:

``` r
library(redahelper)
fast_plot(df=iris, x="Sepal.Length", y="Sepal.Width", plot_type="scatter")
```

![](README_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

The package can also create correlation matrix easily, by inputting a
pandas data frame and desired columns. As an example, using the iris
dataset:

``` r
library(redahelper)
fast_corr(iris, c('Sepal.Length','Sepal.Width', 'Petal.Length','Petal.Width'))
```

![](README_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

Finally, `redahelper` can impute values to missing data, with method
choices of either remove (removes all rows with missing data), mean,
median, or mode imputation.

Below is a toy dataframe with missing values:

``` r
sample_data = tibble::tibble("col_1"= c(1L, NA, 3L, 3L, 5L, NaN),
                             "col_2"= c("a", NA, "d", "d", "f","e"))
sample_data
```

    ## # A tibble: 6 x 2
    ##   col_1 col_2
    ##   <dbl> <chr>
    ## 1     1 a    
    ## 2    NA <NA> 
    ## 3     3 d    
    ## 4     3 d    
    ## 5     5 f    
    ## 6   NaN e

Using the `fast_missing_impute` function, with the “mode” imputation
method, the function returns:

``` r
library(redahelper)
fast_missing_impute(df = sample_data, method = "mode", cols = c("col_1", "col_2"))
```

    ## # A tibble: 6 x 2
    ##   col_1 col_2
    ##   <dbl> <chr>
    ## 1     1 a    
    ## 2     3 d    
    ## 3     3 d    
    ## 4     3 d    
    ## 5     5 f    
    ## 6     3 e

## Alignment with Python / R Ecosystems

At this time, there are multiple packages that are used during EDA with
a similar functionality in both R and Python. Nevertheless most of these
existing packages require multiple steps or provide results that could
be simplified.

In the `redahelper` package, the focus is to minimize the code a user
uses to generate significant conclusions in relation to: outliers,
missing data treatment, data visualization, correlation computing and
visualization.

The following table summarizes existing packages that are related to the
procedures that are simplified in the `redahelper` package.

| EDA Procedure related     | Language | Existing Packages/Functions                                                              |
| ------------------------- | -------- | ---------------------------------------------------------------------------------------- |
| Outlier identification    | R        | [Test for Outliers](https://cran.r-project.org/web/packages/outliers/index.html)         |
| Outlier identification    | R        | [Outlier Detection](https://cran.r-project.org/web/packages/OutlierDetection/index.html) |
| Missing Value Treatment   | R        | [Mice Package](https://cran.r-project.org/web/packages/mice/index.html)                  |
| Missing Value Treatment   | R        | [Amelia Package](https://cran.r-project.org/web/packages/Amelia/index.html)              |
| Data Visualization        | R        | [ggplot](https://ggplot2.tidyverse.org/)                                                 |
| Correlation Visualization | R        | [corplot](https://cran.r-project.org/web/packages/corrplot/index.html)                   |

**How will the `redahelper` package compare to the previous existing
packages/functions?**

The `redahelper` package aims to provide an user friendly experience by
reducing the code needed to conduct an exploratory data analysis,
specifically for identifying outliers, imputing missing data, and
generating visualizations for relations and correlations.

The fast\_plot function leverages the ggplot package in R, however it
improves on it by giving the user the ease to change plot type by
changing an argument, and including error handling to ensure appropriate
column types for certain plots. While the R packages GGalley, ggplot2
and corrplot have similar functions in creating the correlation matrix,
the fast\_corr function provides a more user-friendly (less coding)
experience and makes it easier to select the columns (features) for the
analysis. It will filter out of the categorical columns and only perform
the analysis on the numeric columns. On ther hand, the R packages MICE,
Amelia, and Hmisc have a similar function to imputing missing data.
However, the fast\_missing\_impute function is likely more convenient
for the user as it involves less coding, requiring the user to simply
select the method of imputation and the columns with missing data.
Finally, in relation to outlier identification, the fast\_outliers\_id
function will serve as another options for users by creating an integral
solution by mixing current existing methods into a single function. It
will automatize the usage of Z-score and Interquantile methods to
identify outliers.

### Dependencies

  - purrr == 0.3.3
  - tidyr == 1.0.0
  - tibble == 2.1.3
  - testthat (\>= 2.1.0)
  - stats == 3.6.1
  - lubridate == 1.7.4
  - ggplot2 == 3.2.1
  - dplyr == 0.8.4
  - tidyselect == 0.2.5
  - ggcorrplot == 0.1.3
  - readr == 1.3.1

### Credits

This package was created with Cookiecutter and the
UBC-MDS/cookiecutter-ubc-mds project template, modified from the
[pyOpenSci/cookiecutter-pyopensci](https://github.com/pyOpenSci/cookiecutter-pyopensci)
project template and the
[audreyr/cookiecutter-pypackage](https://github.com/audreyr/cookiecutter-pypackage).
