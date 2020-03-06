#' Analyzes the values of a given column list in a given dataframe, identifies outliers using either the Z-Score algorithm or interquantile range algorithm.
#' The return is a dataframe containing the following columns: column name, list containing the outlier's index position, percentaje of total counts considered outliers.
#' Modifies an existing dataframe, with missing values
#' imputed based on the chosen method.
#'
#' @param data dataframe - Dataframe to be analyzed
#' @param cols list -  List containing the columns to be analyzed.
#' @param method string - string indicating which method to be used to identify outliers (methods available are: "Z score" or "Interquantile Range")
#' @param threshold_low_fre double - Indicates the threshold for evaluating outliers in categorical columns.
#'
#' @return dataframe
#' @export
#' @examples
#' fast_outlier_id(data = iris, cols =  c("Sepal.Length", "Sepal.Width"), method = "z-score")

fast_outlier_id <- function(data,cols="All",method = "z-score",threshold_low_freq = 0.05) {
    
    #Assert tests
    # check that df is DataFrame or Tibble
    if (!tibble::is_tibble(data) & !is.data.frame(data)) {
        stop("Data must be in Data Frame or Tibble!")
        }
    
    ##Check columns exist
    if (!tolower(cols) == "all"){
        for (i in cols){
            if(!i %in% colnames(data)){
                stop("Column name is not a column in data frame entered!")
            }
        }
    }
    
    ##Check method selected is allowed
    if (!tolower(method) %in% c("z-score","interquartile")){
        stop("The only permitted values are z-score or interquantile")
    }
 
    if (tolower(cols) == 'all'){
        cols = colnames(data)        
    }
    no_nans_list = list()
    col_type_list = list()
    perc_nans_list = list()
    outlier_values_list = list()
    outlier_count_list = list()
    outlier_perc_list = list()
    method_list = list()

    subset_data = data[cols]

    for (i in cols) {
        no_nans = sum(is.na(subset_data[[i]]))
        no_nans_list = append(no_nans_list,no_nans)
        col_type_list = append(col_type_list,class(subset_data[[i]]))
        perc_nans_list = append(perc_nans_list,round(no_nans/length(subset_data[[i]]),2))
        data_no_nans = na.omit(subset_data[[i]])
        if (class(data_no_nans) %in% c('numeric','integer','double')){
            if (tolower(method) == "z-score"){
                score = abs(scale(data_no_nans))
                outlier_values = list(data_no_nans[which(score>2)])
                outlier_count_list = append(outlier_count_list,length(outlier_values[[1]]))
                outlier_perc_list = append(outlier_perc_list,round(length(outlier_values[[1]])/length(subset_data[[i]]),2))
                outlier_values_list = append(outlier_values_list,outlier_values)
                method_list = append(method_list,"Z-Score")
                } else if (tolower(method) == "interquantile") {
                quantiles = quantile(data_no_nans,probs = c(0.25,0.75))
                Q1 = quantiles[1]
                Q3 = quantiles[2]
                IQR = Q3 - Q1
                score = (data_no_nans < (Q1 - 1.5 * IQR)) | (data_no_nans > (Q3 + 1.5 * IQR))
                outlier_values = list(data_no_nans[which(score>0)])
                outlier_count_list = append(outlier_count_list,length(outlier_values[[1]]))
                outlier_perc_list = append(outlier_perc_list,round(length(outlier_values[[1]])/length(subset_data[[i]]),2))
                outlier_values_list = append(outlier_values_list,outlier_values)
                method_list = append(method_list,"Interquantile")
                }
            } else if (class(data_no_nans) %in% c('character','factor')){
            score = (table(data_no_nans)/sum(table(data_no_nans)))
            outlier_values = list(labels(which(score<threshold_low_freq)))
            outlier_count_list = append(outlier_count_list,sum(table(data_no_nans[which(score<threshold_low_freq)])))
            outlier_perc_list = append(outlier_perc_list,round(sum(table(data_no_nans[which(score<threshold_low_freq)]))/length(subset_data[[i]]),2))
            outlier_values_list = append(outlier_values_list,outlier_values)
            method_list = append(method_list,"low-freq")
            } else {
            stop("Columns must be of the following types ('numeric','integer','double','character','factor')")
        }
    }
    
    summary = tibble::tibble(
        column_name = cols,
        type = as.character(col_type_list),
        no_nans = as.integer(no_nans_list),
        perc_nans = as.double(perc_nans_list),
        outlier_method = method_list,
        no_outliers = as.integer(outlier_count_list),
        perc_outliers = outlier_perc_list,
        outlier_values = outlier_values_list
    )
    
    ##Validating produced summarry contains the same number of requested columns

    if (!(count(summary)[[1]]) == length(cols)){
        stop("Summary does not contain expected number of columns")
    }       
    return(summary)
}
