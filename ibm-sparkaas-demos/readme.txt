#############################################################################
# File : readme.txt
############################################################################
This file describes how RStudio interacts with the Spark service on Watson Studio by using the sparklyr package(http://spark.rstudio.com/index.html).

When an RStudio session starts, the sparklyr package is loaded and creates two files in a working directory:
   
   1) config.yml file :- Lists all Spark services available for this user along with the Spark kernel connection parameters. By using these connection parameters, the spark_connect API can connect with a remote Spark kernel gateway proxy. The list_spark_kernels() function lists all available Spark kernels.
   
   2) .Rprofile file  :- Sets up the Spark environment and loads the sparklyr package when an RStudio session starts.
   
The sparklyr package is pre-loaded to a RStudio session. 

To view a list of Spark instances, run this R function:
     > kernels <- list_spark_kernels()
     > kernels
    [1] "Apache-Spark-01" "Apache-Spark-02"
    
To connect to Spark, use this R function:
     > sc <- spark_connect(config = kernels[1])

This spark_connect function takes config parameter as one of the values generated using list_spark_kernels function and creates a SparkContext (sc) that references the SparkContext on a remote Spark-as-a-service kernel. After the SparkContext created all operations will be executed on remote spark kernel.
    
Three example R script files demonstrate how the Spark service works :
 
 1) spark_kernel_basic_local.R   :- Creates simple R data frames and generates local Spark data frames based on the local R data frames. It also runs some basic filters and DBI queries.
 
 2) spark_kernel_basic_remote.R   :- Creates simple R data frames and generates remote Spark data frames based on the local R data frames. It also runs some basic filters and DBI queries.
 
 3) sparkaas_mtcars.R :- Loads the popular mtcars R data frame and then generates a Spark data frame for the  mtcars data frame. It then does transformations to create a training data set and runs a linear model on the training data set.
 
 4) sparkaas_flights.R :- Loads some bigger data sets about flights and batting. This scenario is taken from http://spark.rstudio.com/index.html. The script creates a ggplot plot for delay and runs window functions.
