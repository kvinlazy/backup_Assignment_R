# File : spark_kernel_basic_remote.R
#
# This example performs below functionality: 
#    - loads Spark kernels 
#    - connect with remote Spark based on selected kernel
#    - load small dataset and create spark data frame
#    - query spark dataframe
#    - disconnect from Spark kernel
#
############################################################################

# load spark R packages
library(ibmwsrspark)
library(sparklyr)

# load kernels
kernels <- load_spark_kernels()

# display kernels
display_spark_kernels()

# connect to Spark kernel
sc <- spark_connect(config = kernels[1])

# create local R data frame
library(dplyr)
localDF <- data.frame(name=c("John", "Smith", "Sarah", "Mike", "Bob"), age=c(19, 23, 18, 25, 30))

#create Spark kernel data frame and temporary table based on local R data frame
sampletbl <- copy_to(sc, localDF, "sampleTbl")

# list tables
src_tbls(sc)

#db query for sampleTbl table
library(DBI)
sampletbl_preview <- dbGetQuery(sc, "SELECT * FROM sampleTbl")
sampletbl_preview

# filter by age
filtered_sampletbl <- sampletbl %>% filter(age > 20)
filtered_sampletbl

# reading data
iris_tbl <- copy_to(sc, iris, "irisData")

# list tables
src_tbls(sc)

library(DBI)
iris_preview <- dbGetQuery(sc, "SELECT * FROM irisData")
iris_preview

# disconnect
spark_disconnect(sc)
spark_disconnect_all()