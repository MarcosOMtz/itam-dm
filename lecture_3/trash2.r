library('lubridate')

años <- seq(2003, 2014)

meses <- month.name


nombres <- as.vector(outer(años, meses, paste, sep="-"))

mass.download <- function(file.name) {
  base_url <- "http://lists.extropy.org/pipermail/extropy-chat/"
  full_file_name <- paste(file.name, '.txt.gz', sep='')
  url <- paste(base_url, full_file_name, sep='')
  download.file(url, destfile=paste('data',full_file_name, sep='/'), method='curl')
}

# Download all the files
lapply(nombres[10], mass.download)


