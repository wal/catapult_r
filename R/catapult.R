library(tidyverse)
library(data.table)
library(ggmap)

raw_data <- fread('data/catapult_raw.csv', skip = 7)
str(raw_data)
sort(names(raw_data))

lat_long_data <- raw_data %>% select(Time, Latitude, Longitude)
dim(lat_long_data)

game_data <- lat_long_data %>% filter(Time > '40:00:00')
dim(game_data)

ggplot(game_data, aes(Longitude, Latitude)) + geom_point()

# Calculate the center of the map from the mean lat/long
center <- c(lon = mean(game_data$Longitude),  lat = mean(game_data$Latitude))

png("Rplot.png")

# Get the map using the midpoint as location
map <-  get_map(
  location=center, 
  zoom=18,
  source='google',
  maptype='satellite')

ggmap(map) + 
  # Plot the sampled points onto the map
  geom_point(data=game_data, aes(x=Longitude, y=Latitude), size=0.5) +
  scale_color_brewer(palette="Dark2")

dev.off()


