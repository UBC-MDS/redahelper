## redahelper 

An R package that simplifies up the main EDA procedures such as: outlier identification, data visualization, correlation, missing data imputation.

### Authors

| [Ofer Mansour](https://github.com/ofer-m) | [Suvarna Moharir](https://github.com/suvarna-m) | [Subing Cao ](https://github.com/scao1)| [Manuel Maldonado](https://github.com/manu2856)|
|:------------:|:--------------:|:--------------:|:--------------:|

### Project Overview

We are aware that data understanding and cleaning represents 60% of data scientist's time given to any project. 
Our goal with this package is to simplify this process , and make a more efficient use of time while working on some of the main procedures done in EDA (outlier identification, data visualization, correlation, missing data imputation).


### Installation:

```
Work in progress. 
```

### Functions


| Function Name | Input | Output | Description |
|---------|------------|------|-----------|
|fast_outliers_id|3 parameters:  A dataframe , a list of columns to be included in analysis,method to be used to identify outliers ("Z-score algorithm" or "Interquantile Range")| dataframe with included columns and outlier values identified, and % of counts considered as outliers for each anlyzed column| Given a dataframe, a list of given columns are analyzed in search for outlier values and return a dataframe summarizing the outliers values found and indicating which % of the counts are affected by this outlier(s)|
|fast_plot|4 parameters:  dataframe, name of X column, name of y column, plot name  | Plot object | Given a dataframe ,the columns to be considered X an Y respectively, and the desired plot; the function computes and returns the specified plot|
|fast_corr| 2 parameters: dataframe, list of columns to be analyzed, |correlation plot object| Calculates the correlation of all specified columns and generates a plot visualizing the correlation coefficients.|
|fast_missing_impute|3 parameters: dataframe, a string specifying the missing data treatment method,list of columns to be treated| new dataframe without missing values in the specified columns|Given a dataframe and a list of columns in that dataframe, missing values are identified and treated as specified in the missing data treatment method |


## Alignment with Python / R Ecosystems

At this time, there are multiple packages that are used during EDA with a similar functionality in both R and Python. Nevertheless most of these existing packages require multiple steps or provide results that could be simplified.

In our REDAHELPR package, our focus is to minimize the code an user uses to generate significant conclusions in relation to: outliers, missing data treatment, data visualization, correlation computing and visualization.

In the following table we have summarized existing packages that are related to the procedures that are simplified in our redahelper package.



|EDA Procedure related|Language|Existing Packages/Functions|
|---------|------------|---------------------------|
|Outlier identification| R| [Test for Outliers](https://cran.r-project.org/web/packages/outliers/index.html)|
|Outlier identification| R| [Outlier Detection](https://cran.r-project.org/web/packages/OutlierDetection/index.html)|
|Missing Value Treatment | R | [Mice Package](https://cran.r-project.org/web/packages/mice/index.html)|
|Data Visualization|R|[ggplot](https://ggplot2.tidyverse.org/)|
|Correlation Visualization|R|[corplot](https://cran.r-project.org/web/packages/corrplot/index.html)|


### Documentation
The official documentation is hosted on Read the Docs: <https://redahelper.readthedocs.io/en/latest/>

### Credits
This package was created with Cookiecutter and the UBC-MDS/cookiecutter-ubc-mds project template, modified from the [pyOpenSci/cookiecutter-pyopensci](https://github.com/pyOpenSci/cookiecutter-pyopensci) project template and the [audreyr/cookiecutter-pypackage](https://github.com/audreyr/cookiecutter-pypackage).
