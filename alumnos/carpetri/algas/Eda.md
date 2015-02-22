    source('../utils.r')
    source('0_lectura.r')
    library(plyr)
    library(dplyr)

    ## 
    ## Attaching package: 'dplyr'
    ## 
    ## The following objects are masked from 'package:plyr':
    ## 
    ##     arrange, count, desc, failwith, id, mutate, rename, summarise,
    ##     summarize
    ## 
    ## The following object is masked from 'package:stats':
    ## 
    ##     filter
    ## 
    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

    library(ggplot2)
    library(corrgram)

    ## 
    ## Attaching package: 'corrgram'
    ## 
    ## The following object is masked from 'package:plyr':
    ## 
    ##     baseball

    ## [1] "V4"

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-1.png)

    ## [1] "V5"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-2.png)

    ## [1] "V6"

    ## Warning: Removed 10 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 10 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 10 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-3.png)

    ## [1] "V7"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-4.png)

    ## [1] "V8"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-5.png)

    ## [1] "V9"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-6.png)

    ## [1] "V10"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-7.png)

    ## [1] "V11"

    ## Warning: Removed 12 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 12 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 12 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-8.png)

    ## [1] "V12"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-9.png)

    ## [1] "V13"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-10.png)

    ## [1] "V14"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-11.png)

    ## [1] "V15"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-12.png)

    ## [1] "V16"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-13.png)

    ## [1] "V17"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-14.png)

    ## [1] "V18"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-15.png)

    ## [1] "V4"

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-16.png)

    ## [1] "V5"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-17.png)

    ## [1] "V6"

    ## Warning: Removed 10 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 10 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 10 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-18.png)

    ## [1] "V7"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-19.png)

    ## [1] "V8"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-20.png)

    ## [1] "V9"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-21.png)

    ## [1] "V10"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-22.png)

    ## [1] "V11"

    ## Warning: Removed 12 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 12 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 12 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-23.png)

    ## [1] "V12"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-24.png)

    ## [1] "V13"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-25.png)

    ## [1] "V14"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-26.png)

    ## [1] "V15"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-27.png)

    ## [1] "V16"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-28.png)

    ## [1] "V17"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-29.png)

    ## [1] "V18"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-30.png)

    ## [1] "V4"

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-31.png)

    ## [1] "V5"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-32.png)

    ## [1] "V6"

    ## Warning: Removed 10 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 10 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 10 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-33.png)

    ## [1] "V7"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-34.png)

    ## [1] "V8"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-35.png)

    ## [1] "V9"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-36.png)

    ## [1] "V10"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-37.png)

    ## [1] "V11"

    ## Warning: Removed 12 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 12 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 12 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-38.png)

    ## [1] "V12"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-39.png)

    ## [1] "V13"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-40.png)

    ## [1] "V14"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-41.png)

    ## [1] "V15"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-42.png)

    ## [1] "V16"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-43.png)

    ## [1] "V17"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-44.png)

    ## [1] "V18"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-45.png)

    ## [1] "V4"

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-46.png)

    ## [1] "V5"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-47.png)

    ## [1] "V6"

    ## Warning: Removed 10 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 10 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 10 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-48.png)

    ## [1] "V7"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-49.png)

    ## [1] "V8"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-50.png)

    ## [1] "V9"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-51.png)

    ## [1] "V10"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-52.png)

    ## [1] "V11"

    ## Warning: Removed 12 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 12 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 12 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-53.png)

    ## [1] "V12"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-54.png)

    ## [1] "V13"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-55.png)

    ## [1] "V14"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-56.png)

    ## [1] "V15"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-57.png)

    ## [1] "V16"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-58.png)

    ## [1] "V17"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-59.png)

    ## [1] "V18"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-60.png)

    ## [1] "V4"

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-61.png)

    ## [1] "V5"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-62.png)

    ## [1] "V6"

    ## Warning: Removed 10 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 10 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 10 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-63.png)

    ## [1] "V7"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-64.png)

    ## [1] "V8"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-65.png)

    ## [1] "V9"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-66.png)

    ## [1] "V10"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-67.png)

    ## [1] "V11"

    ## Warning: Removed 12 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 12 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 12 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-68.png)

    ## [1] "V12"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-69.png)

    ## [1] "V13"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-70.png)

    ## [1] "V14"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-71.png)

    ## [1] "V15"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-72.png)

    ## [1] "V16"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-73.png)

    ## [1] "V17"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-74.png)

    ## [1] "V18"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-75.png)

    ## [1] "V4"

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-76.png)

    ## [1] "V5"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-77.png)

    ## [1] "V6"

    ## Warning: Removed 10 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 10 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 10 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-78.png)

    ## [1] "V7"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-79.png)

    ## [1] "V8"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-80.png)

    ## [1] "V9"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-81.png)

    ## [1] "V10"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-82.png)

    ## [1] "V11"

    ## Warning: Removed 12 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 12 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 12 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-83.png)

    ## [1] "V12"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-84.png)

    ## [1] "V13"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-85.png)

    ## [1] "V14"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-86.png)

    ## [1] "V15"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-87.png)

    ## [1] "V16"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-88.png)

    ## [1] "V17"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-89.png)

    ## [1] "V18"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-90.png)

    ## [1] "V4"

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-91.png)

    ## [1] "V5"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-92.png)

    ## [1] "V6"

    ## Warning: Removed 10 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 10 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 10 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-93.png)

    ## [1] "V7"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-94.png)

    ## [1] "V8"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-95.png)

    ## [1] "V9"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-96.png)

    ## [1] "V10"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-97.png)

    ## [1] "V11"

    ## Warning: Removed 12 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 12 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 12 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-98.png)

    ## [1] "V12"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-99.png)

    ## [1] "V13"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-100.png)

    ## [1] "V14"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-101.png)

    ## [1] "V15"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-102.png)

    ## [1] "V16"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-103.png)

    ## [1] "V17"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-104.png)

    ## [1] "V18"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-105.png)

    ## [1] "V4"

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-106.png)

    ## [1] "V5"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-107.png)

    ## [1] "V6"

    ## Warning: Removed 10 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 10 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 10 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-108.png)

    ## [1] "V7"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-109.png)

    ## [1] "V8"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-110.png)

    ## [1] "V9"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-111.png)

    ## [1] "V10"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-112.png)

    ## [1] "V11"

    ## Warning: Removed 12 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 12 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 12 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-113.png)

    ## [1] "V12"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-114.png)

    ## [1] "V13"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-115.png)

    ## [1] "V14"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-116.png)

    ## [1] "V15"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-117.png)

    ## [1] "V16"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-118.png)

    ## [1] "V17"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-119.png)

    ## [1] "V18"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-120.png)

    ## [1] "V4"

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-121.png)

    ## [1] "V5"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-122.png)

    ## [1] "V6"

    ## Warning: Removed 10 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 10 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 10 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-123.png)

    ## [1] "V7"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-124.png)

    ## [1] "V8"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-125.png)

    ## [1] "V9"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-126.png)

    ## [1] "V10"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-127.png)

    ## [1] "V11"

    ## Warning: Removed 12 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 12 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 12 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-128.png)

    ## [1] "V12"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-129.png)

    ## [1] "V13"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-130.png)

    ## [1] "V14"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-131.png)

    ## [1] "V15"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-132.png)

    ## [1] "V16"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-133.png)

    ## [1] "V17"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-134.png)

    ## [1] "V18"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-135.png)

    ## [1] "V4"

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-136.png)

    ## [1] "V5"

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing missing values (geom_point).

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-137.png)

    ## [1] "V6"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 4 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 4 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

    ## Warning: Removed 4 rows containing missing values (geom_point).

    ## Warning: Removed 2 rows containing missing values (geom_point).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-138.png)

    ## [1] "V7"

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing missing values (geom_point).

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-139.png)

    ## [1] "V8"

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing missing values (geom_point).

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-140.png)

    ## [1] "V9"

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing missing values (geom_point).

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-141.png)

    ## [1] "V10"

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing missing values (geom_point).

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-142.png)

    ## [1] "V11"

    ## Warning: Removed 3 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 3 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 4 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 3 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 3 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 4 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 3 rows containing missing values (geom_point).

    ## Warning: Removed 3 rows containing missing values (geom_point).

    ## Warning: Removed 2 rows containing missing values (geom_point).

    ## Warning: Removed 4 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-143.png)

    ## [1] "V12"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-144.png)

    ## [1] "V13"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-145.png)

    ## [1] "V14"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-146.png)

    ## [1] "V15"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-147.png)

    ## [1] "V16"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-148.png)

    ## [1] "V17"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-149.png)

    ## [1] "V18"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-150.png)

    ## [1] "V4"

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-151.png)

    ## [1] "V5"

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing missing values (geom_point).

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-152.png)

    ## [1] "V6"

    ## Warning: Removed 3 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 6 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 3 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 6 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 3 rows containing missing values (geom_point).

    ## Warning: Removed 1 rows containing missing values (geom_point).

    ## Warning: Removed 6 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-153.png)

    ## [1] "V7"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-154.png)

    ## [1] "V8"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-155.png)

    ## [1] "V9"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-156.png)

    ## [1] "V10"

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing missing values (geom_point).

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-157.png)

    ## [1] "V11"

    ## Warning: Removed 6 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 6 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 6 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 6 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 6 rows containing missing values (geom_point).

    ## Warning: Removed 6 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-158.png)

    ## [1] "V12"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-159.png)

    ## [1] "V13"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-160.png)

    ## [1] "V14"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-161.png)

    ## [1] "V15"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-162.png)

    ## [1] "V16"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-163.png)

    ## [1] "V17"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-164.png)

    ## [1] "V18"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-165.png)

    ## [1] "V4"

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-166.png)

    ## [1] "V5"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-167.png)

    ## [1] "V6"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 8 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

    ## Warning: Removed 8 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-168.png)

    ## [1] "V7"

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing missing values (geom_point).

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-169.png)

    ## [1] "V8"

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing missing values (geom_point).

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-170.png)

    ## [1] "V9"

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing missing values (geom_point).

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-171.png)

    ## [1] "V10"

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing missing values (geom_point).

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-172.png)

    ## [1] "V11"

    ## Warning: Removed 2 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 1 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 9 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 2 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 1 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 9 rows containing non-finite values (stat_ydensity).

    ## Warning: Removed 2 rows containing missing values (geom_point).

    ## Warning: Removed 1 rows containing missing values (geom_point).

    ## Warning: Removed 9 rows containing missing values (geom_point).

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-173.png)

    ## [1] "V12"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-174.png)

    ## [1] "V13"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-175.png)

    ## [1] "V14"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-176.png)

    ## [1] "V15"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-177.png)

    ## [1] "V16"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-178.png)

    ## [1] "V17"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-179.png)

    ## [1] "V18"

![](./Eda_files/figure-markdown_strict/unnamed-chunk-2-180.png)
