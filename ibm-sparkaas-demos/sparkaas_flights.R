#
# File : sparkaas_flights.R
#
# This example performs below functionality: 
#    - loads Spark kernels 
#    - connect with Spark based on selected kernel
#    - load large dataset and create spark data frame
#    - create ggplot
#    - Call Window functions and grouped mutate and filter functions
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

# load nycflights13::flights data set
install.packages("nycflights13")
flights_tbl <- copy_to(sc, nycflights13::flights, "flights", overwrite = TRUE)

# load Lahman::Batting data set
install.packages("Lahman")
batting_tbl <- copy_to(sc, Lahman::Batting, "batting", overwrite = TRUE)


# filter by departure delay
flights_tbl %>% filter(dep_delay == 2)

# Using dplyr
delay <- flights_tbl %>%
  group_by(tailnum) %>%
  summarise(count = n(), dist = mean(distance), delay = mean(arr_delay)) %>%
  filter(count > 20, dist < 2000, !is.na(delay)) %>%
  collect()

# plot delays
install.packages("mgcv")
library(ggplot2)
ggplot(delay, aes(dist, delay)) +
  geom_point(aes(size = count), alpha = 1/2) +
  geom_smooth() +
  scale_size_area(max_size = 2)

# Window functions and grouped mutate and filter functions
batting_tbl %>%
  select(playerID, yearID, teamID, G, AB:H) %>%
  arrange(playerID, yearID, teamID) %>%
  group_by(playerID)

# disconnect
spark_disconnect(sc)
spark_disconnect_all()