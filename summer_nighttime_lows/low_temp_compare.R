# Author: Sabi Horvat, July 2021
# github: www.github.com/wpbsabi
# twitter: @tourofdata 
# topic: Comparison of summer nightly low temperatures across cities in the US

library(tidyverse)
library(lubridate)
library(ggthemes)
library(ggtext)
library(cowplot)

### Data Exploration and Visualization for each data set to combine

combined <- read_csv('combined.csv')
sfo.csv <- read_csv('sfo.csv')

# Check for the number of weather stations
test_data <- sfo.csv
unique(test_data$NAME)

# # Filter stations as needed
# test_data <- test_data %>%
#   filter(NAME == 'FARMINGTON, UT US')

# Check for the data of importance
tmin_data <- test_data %>% drop_na(TMIN)

# Check the date range for stations
tmin_data %>%
  select(NAME, DATE) %>%
  group_by(NAME) %>%
  summarise('min_date' = min(DATE), 'max_date' = max(DATE)) 

# Finalize data
tmin_data <- tmin_data %>%
  select(DATE, TMIN) %>%
  mutate(CITY = 'SAN FRANCISCO')

# Add to the combined data set
combined <- rbind(tmin_data, combined)
write_csv(combined, 'combined.csv')


### Prepare data for plots and plot two cities at a time

plot_lows <- function(city1, city2) {
  # Filter on the "summer" months: June, July, August
  summer_data1 <- combined %>%
    filter(CITY==city1) %>%
    filter(month(DATE) > 5 & month(DATE) < 9) %>%
    filter(year(DATE)>2010) %>%
    mutate(year = year(DATE)
           ,month = month(DATE)
           ,yday = yday(DATE))
  summer_data_avg1 <- summer_data1 %>%
    filter(CITY==city1) %>%
    group_by(yday, CITY) %>%
    tally(mean(TMIN))
  
  summer_data2 <- combined %>%
    filter(CITY==city2) %>%
    filter(month(DATE) > 5 & month(DATE) < 9) %>%
    filter(year(DATE)>2010) %>%
    mutate(year = year(DATE)
           ,month = month(DATE)
           ,yday = yday(DATE))
  summer_data_avg2 <- summer_data2 %>%
    filter(CITY==city2) %>%
    group_by(yday, CITY) %>%
    tally(mean(TMIN))
  
  plot1 <- ggplot() +
    geom_line(data=summer_data1, aes(y=TMIN, x=yday, group=year, color=year),
              show.legend = FALSE) +
    geom_line(data=summer_data_avg1, aes(y=n, x=yday), color='orange', size=2) + 
    coord_cartesian(ylim=c(30, 95)) + 
    theme_economist_white() + 
    theme(axis.text.x=element_blank(), axis.ticks=element_blank()) + 
    ggtitle(paste0('\n', city1, ' (2010-2020)\n')) + 
    xlab('\nSummer (June, July, August)') +
    ylab('Nightly Low Temperature (F)\n') 
  
  plot2 <- ggplot() +
    geom_line(data=summer_data2, aes(y=TMIN, x=yday, group=year, color=year),
              show.legend = FALSE) +
    geom_line(data=summer_data_avg2, aes(y=n, x=yday), color='orange', size=2) + 
    coord_cartesian(ylim=c(30, 95)) + 
    theme_economist_white() + 
    theme(axis.text.x=element_blank(), axis.ticks=element_blank()) + 
    ggtitle(paste0('\n', city2, ' (2010-2020)\n')) + 
    xlab('\nSummer (June, July, August)') +
    ylab('Nightly Low Temperature (F)\n') 
  
  plot_grid(plot1, plot2)
}

plot_lows('PORTLAND', 'SEATTLE')
plot_lows('SAN FRANCISCO', 'LOS ANGELES')
plot_lows('LAS VEGAS', 'PHOENIX')
plot_lows('BOISE', 'SALT LAKE CITY')
plot_lows('DENVER', 'KANSAS CITY')
plot_lows('DALLAS', 'HOUSTON')
plot_lows('MINNEAPOLIS', 'CHICAGO')
plot_lows('MEMPHIS', 'NEW ORLEANS')
plot_lows('MIAMI', 'ATLANTA')
plot_lows('CLEVELAND', 'DETROIT')
plot_lows('BOSTON', 'NEW YORK')
plot_lows('WASHINGTON DC', 'CHARLOTTE')


