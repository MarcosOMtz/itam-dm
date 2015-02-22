---
title: "EDA_algas"
author: "nosomos muchos pero somos machos"
date: "18 de noviembre de 2014"
output: html_document
---

# Exploración


```r
source("0-load.r")
source("2-eda.r")
```

## Exploración general de 5 variables


```r
algas.data  <- load()

eda1(algas.data,c(3,9,5,11,16))
```

```
## Loading required package: dplyr
## 
## Attaching package: 'dplyr'
## 
## The following object is masked from 'package:stats':
## 
##     filter
## 
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
## 
## Loading required package: scales
## Loading required package: ggplot2
## Loading required package: gridExtra
## Loading required package: grid
## Loading required package: ggthemes
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-21.png) 

```
## stat_bin: binwidth defaulted to range/30. Use 'binwidth = x' to adjust this.
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-22.png) 

```
## stat_bin: binwidth defaulted to range/30. Use 'binwidth = x' to adjust this.
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-23.png) 

```
## stat_bin: binwidth defaulted to range/30. Use 'binwidth = x' to adjust this.
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-24.png) 

```
## stat_bin: binwidth defaulted to range/30. Use 'binwidth = x' to adjust this.
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-25.png) 

## Exploración gernal, tomando como base a comparar good.loan


```r
eda2(algas.data,2,c(1,6,11,9,6))
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-31.png) ![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-32.png) ![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-33.png) ![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-34.png) ![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-35.png) 

