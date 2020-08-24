# File : spark_kernel_basic_local.R
#
# This example performs below functionality: 
#    - loads Spark kernels 
#    - connect with local Spark
#    - load small dataset and create spark data frame
#    - query spark dataframe
#    - disconnect from Spark kernel
#
############################################################################

# load spark R packages
library(sparklyr)

# connect to Spark kernel
sc <- spark_connect(master = 'local')

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