# Author: Sabi Horvat, November 2020 (Last Updated 2023)
# github: www.github.com/wpbsabi
# Credit: Visual idea for First Freeze adapted from "Freeze History Bishop" 
#           by Ian Bell @ian_bellio, October 2020

library(tidyverse)
library(lubridate)
library(ggtext)

# GET DATA from https://www.climate.gov/maps-data/dataset/past-weather-zip-code-data-table
# via online search https://www.ncdc.noaa.gov/cdo-web/search
# csv_data <- read_csv('data/97218_portland_1940_2022-11_temp_prec.csv') # 1941 January to 2022 November
csv_data <- read_csv('data/portland_1871_11_2022-12_temp_prec.csv') # 1871 January to 2022 November

# for appending new data (added 2021-full year and 2020-December data)
# sort_data <- csv_data %>%
#   arrange(DATE)
# write_csv(sort_data, 'Yearly first and last freeze data.csv')

# Freezing temperature to model (choose higher temperature to be more conservative)
FREEZE <- 32

# extract year, month, day from the date
extract_dates <- csv_data %>%
  mutate(year = year(DATE)
         ,month = month(DATE)
         ,yday = yday(DATE))

freeze_days <- extract_dates %>%
  select(year,TMIN,yday) %>%
  group_by(year) %>%
  filter(TMIN <= FREEZE) 

first_freeze <- extract_dates %>%
  group_by(year) %>%
  filter(TMIN <= FREEZE, month > 7) %>%
  summarise(min = min(DATE))

last_freeze <- extract_dates %>%
  group_by(year) %>%
  filter(TMIN <= FREEZE, month < 7) %>%
  summarise(max = max(DATE))

first_freeze_yday <- first_freeze %>% mutate(yday = yday(min))
last_freeze_yday <- last_freeze %>% mutate(yday = yday(max))                                          

# Note that the origin date doesn't matter, need date format for the x-axis scale to work
title_to_paste1 <- "<b>Annual First and Last Freeze for Portland, OR </b>
  <br><span style = 'color:black;font-size:10pt'>Weather Stations: Regional Forecast Center from 1871, PDX Airport from 1940</span> 
  <br><span style = 'color:blue;font-size:10pt'>Blue dots indicate the last freeze of winter/spring</span> 
  <br><span style = 'color:purple;font-size:10pt'> Purple dots indicate the first freeze of fall/winter.</span> 
  <br><span style = 'color:gray;font-size:10pt'> Gray dots indicate days with a min temp at or below "
title_to_paste2 <- " degrees Fahrenheit.</span>"

freeze <- ggplot() +
  geom_point(data=freeze_days, aes(y=year, x=as.Date(yday,origin='2020-01-01'))
             , color="gray", size=0.8)+
  geom_point(data=first_freeze_yday, aes(y=year, x=as.Date(yday,origin='2020-01-01'))
             ,fill="purple", shape=21, size=3, color='black') +
  geom_point(data=last_freeze_yday, aes(y=year, x=as.Date(yday,origin='2020-01-01')) 
             ,fill="blue", shape=21, size=3, color='black') +
  scale_y_reverse(breaks= seq(1870, 2020, 10), minor_breaks = seq(1870, 2020, 2)) +
  scale_x_date(date_labels="%b", breaks="month") +
  theme_minimal() +
  theme( plot.title.position = "panel"
          ,plot.title = element_textbox_simple(
            size = 13,
            lineheight = 1,
            padding = margin(5.5, 5.5, 5.5, 5.5),
            margin = margin(0, 0, 5.5, 0))) +
  ggtitle(paste(title_to_paste1, FREEZE, title_to_paste2)) + 
  xlab('') +
  ylab('')
  

freeze

filename1 <- "images/Yearly first and last freeze (" 
filename2 <- ") for Portland, OR.png"
ggsave(paste0(filename1, FREEZE, filename2), height= 6.5, width = 8, dpi = 300)
