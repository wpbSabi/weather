# Author: Sabi Horvat, July 2021
# github: www.github.com/wpbsabi
# twitter: @tourofdata 
# topic: record-breaking pacific northwest heat wave 

library(tidyverse)
library(lubridate)
library(ggthemes)
library(ggtext)

### Data Exploration and Visualization

csv_data <- read_csv('min_temp.csv')
str(csv_data)

# Check for the number of weather stations
unique(csv_data$NAME)

# Check the date range for the station
csv_data %>% 
  filter(NAME == 'PORTLAND INTERNATIONAL AIRPORT, OR US') %>%
  select(NAME, DATE) %>%
  group_by(NAME) %>%
  summarise('min_date' = min(DATE), 'max_date' = max(DATE))

# Filter on the "summer" months 
summer_data <- csv_data %>%
  filter(month(DATE) > 5 & month(DATE) < 10) %>%
  mutate(month = month(DATE)) %>%
  mutate(year = year(DATE))

# Plot highest nighttime temperatures in the summer by year
max_min_by_year <- summer_data %>%
  group_by(year) %>%
  summarise(max_min = max(TMIN))

max_min_2021_forecast <- data.frame('year' = 2021, 'max_min' = 81)

ggplot() +
  geom_line(data=max_min_by_year, mapping=aes(x=year, y=max_min)) +
  geom_point(data=max_min_by_year, mapping=aes(x=year, y=max_min)) +
  geom_point(data=max_min_2021_forecast, mapping=aes(x=year, y=max_min),
             fill='red', shape=21, size=4, color='black') +
  geom_label(aes(x=2010, y=83, label='June 27, 2021 Forecast: 81')) + 
  theme_economist_white() + 
  theme(plot.title.position = "panel"
         ,plot.title = element_textbox_simple(
           size = 13,
           lineheight = 1,
           padding = margin(5.5, 5.5, 5.5, 5.5),
           margin = margin(0, 0, 5.5, 0))
         ,panel.grid.minor = element_blank()
         ,legend.title = element_blank()) +
  coord_cartesian(xlim=c(1940, 2021), ylim=c(60, 85)) + 
  ggtitle("<b>Summer Maximum Lowest Nighttime Temperature by Year</b><br><span style = 'font-size:14pt'>") +
  labs(caption = "Data: National Centers for Environmental Information") +
  xlab('') +
  ylab('Fahrenheit\n')

