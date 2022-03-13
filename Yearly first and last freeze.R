# Author: Sabi Horvat, November 2020
# github: www.github.com/wpbsabi
# twitter: @tourofdata - mobile.twitter.com/tourofdata
# Credit: Visual idea adapted from "Freeze History Bishop" 
#           by Ian Bell @ian_bellio, October 2020

library(tidyverse)
library(lubridate)
library(ggtext)
#library(rnoaa)
#library(weatherData)
#library(cowplot) # for multiple graphs (zoom in on years)

# GET DATA from https://www.climate.gov/maps-data/dataset/past-weather-zip-code-data-table
# via online search https://www.ncdc.noaa.gov/cdo-web/search
csv_data <- read_csv('Yearly first and last freeze data.csv') # 1941 January to 2020 November

# for appending new data (added 2021-full year and 2020-December data)
# sort_data <- csv_data %>%
#   arrange(DATE)
# write_csv(sort_data, 'Yearly first and last freeze data.csv')

# extract year, month, day from the date
extract_dates <- csv_data %>%
  mutate(year = year(DATE)
         ,month = month(DATE)
         ,yday = yday(DATE))

freeze_days <- extract_dates %>%
  select(year,TMIN,yday) %>%
  group_by(year) %>%
  filter(TMIN <= 32) 

first_freeze <- extract_dates %>%
  group_by(year) %>%
  filter(TMIN <= 32, month > 7) %>%
  summarise(min = min(DATE))

last_freeze <- extract_dates %>%
  group_by(year) %>%
  filter(TMIN <= 32, month < 7) %>%
  summarise(max = max(DATE))

first_freeze_yday <- first_freeze %>% mutate(yday = yday(min))
last_freeze_yday <- last_freeze %>% mutate(yday = yday(max))                                          

# Note that the origin date doesn't matter, need date format for the x-axis scale to work
freeze <- ggplot() +
  geom_point(data=freeze_days, aes(y=year, x=as.Date(yday,origin='2020-01-01'))
             , color = "gray", size = 0.8)+
  geom_point(data=first_freeze_yday, aes(y=year, x=as.Date(yday,origin='2020-01-01'))
             ,fill = "purple",shape = 21, size = 3, color = 'black') +
  geom_point(data=last_freeze_yday, aes(y=year, x=as.Date(yday,origin='2020-01-01')) 
             ,fill = "blue",shape = 21, size = 3, color = 'black') +
  scale_y_reverse(breaks= seq(1950, 2020, 10), minor_breaks = seq(1944, 2020, 2)) +
  scale_x_date(date_labels = "%b", breaks = "month") +
  theme_minimal() +
  theme( plot.title.position = "panel"
          ,plot.title = element_textbox_simple(
            size = 13,
            lineheight = 1,
            padding = margin(5.5, 5.5, 5.5, 5.5),
            margin = margin(0, 0, 5.5, 0))) +
  ggtitle("<b>Yearly First and Last Freeze Dates for US Zipcode 97218 </b>   <br><span style = 'font-size:14pt'>
           <br><span style = 'color:blue;'>Blue dots indicate the last freeze of winter/spring</span> 
           <br><span style = 'color:purple;'> Purple dots indicate the first freeze of fall/winter.</span> 
           <br><span style = 'color:gray;'> Gray dots indicate days with a min temp at or below 32 degrees Fahrenheit.</span>") +
  labs(caption = "Data: National Centers for Environmental Information") +
  xlab('') +
  ylab('')
  

freeze

ggsave("Yearly first and last freeze for US zipcode 97218.png", height= 6.5, width = 8, dpi = 300)
