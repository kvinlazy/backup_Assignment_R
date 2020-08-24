#
# File : sparkaas_mtcars.R
#
# This example performs below functionality: 
#    - loads Spark kernels 
#    - connect with Spark based on selected kernel
#    - load mtcars dataset and create spark data frame
#    - create partitions
#    - fit a linear model to the training data set
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

library(dplyr)

#data set
View(mtcars)

# copy mtcars data set into Spark
mtcars_tbl <- copy_to(sc, mtcars, overwrite = TRUE, "cars")
colnames(mtcars_tbl)

# list all of the available tables
src_tbls(sc)

# build SQL and execute
library(DBI)
highgearcars <- dbGetQuery(sc, "SELECT * FROM cars WHERE gear >= 5")
highgearcars

# transform our data set, and then partition the data set into 'training', 'test'
partitions <- mtcars_tbl %>%
  filter(hp >= 100) %>%
  mutate(cyl8 = cyl == 8) %>%
  sdf_partition(training = 0.5, test = 0.5, seed = 1099)

partitions$training
partitions$test

# fit a linear model to the training data set
fit <- partitions$training %>%
  ml_linear_regression(response = "mpg", features = c("wt", "cyl"))
fit

summary(fit)

# disconnect
spark_disconnect(sc)
spark_disconnect_all()