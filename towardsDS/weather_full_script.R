# Author: Sabi Horvat, February 2021
# github: www.github.com/wpbsabi
# twitter: @tourofdata 
# topic: democratizing historical weather data analysis
# purpose: medium / towards data science tutorial

# weather1: setup
library(tidyverse)
library(lubridate)
library(ggthemes)
library(ggtext)

csv_data <- read_csv('weather_towardsds.csv')
str(csv_data)

# weather2: date range for station
csv_data %>% 
  filter(NAME == 'PORTLAND INTERNATIONAL AIRPORT, OR US') %>%
  select(NAME, DATE) %>%
  group_by(NAME) %>%
  summarise('min_date' = min(DATE), 'max_date' = max(DATE))

# weather3: What one day had the most rainfall/snowfall? 
# And how many inches of rain/snow were measured that day?
weather_data <- csv_data %>%
  filter(DATE > '1940-12-31' & DATE < '2021-01-01')

max_daily_rainfall <- max(weather_data$PRCP, na.rm = TRUE)
max_daily_snowfall <- max(weather_data$SNOW, na.rm = TRUE)
weather_data %>% filter(PRCP == max_daily_rainfall | 
                        SNOW == max_daily_snowfall)

# weather4: rainfall monthly box-and-whisker plot
rain_monthly <- weather_data %>%
  filter(is.na(PRCP) == FALSE) %>%
  mutate(YEAR = year(DATE), MONTH = month(DATE), MONTH_ABB = month.abb[MONTH]) %>%
  select(YEAR,MONTH,MONTH_ABB,RAINFALL=PRCP) %>%
  group_by(YEAR,MONTH,MONTH_ABB) %>%
  summarise(sum(RAINFALL))

ggplot() +
  geom_boxplot(data=rain_monthly
               , mapping = aes(x=reorder(MONTH_ABB,MONTH), 
                               y=`sum(RAINFALL)`, group=MONTH_ABB)) +
  theme_economist_white() + 
  theme( plot.title.position = "panel"
         ,plot.title = element_textbox_simple(
           size = 13,
           lineheight = 1,
           padding = margin(5.5, 5.5, 5.5, 5.5),
           margin = margin(0, 0, 5.5, 0))
         ,panel.grid.major = element_blank()
         ,panel.grid.minor = element_blank()
         ,legend.title = element_blank() ) +
  ggtitle("<b>Rainfall by Month at PDX Airport (since 1941) </b>") +
  labs(caption = "Data: National Centers for Environmental Information") +
  xlab('') +
  ylab('Monthly Rainfall (inches)\n')

# weather5: snowfall by year
snowfall <- weather_data %>%
  filter(is.na(SNOW) == FALSE) %>%
  mutate(YEAR = year(DATE)) %>%
  select(YEAR,SNOW) %>%
  group_by(YEAR) %>%
  tally(sum(SNOW))

ggplot() +
  geom_point(data=snowfall, mapping = aes(x=YEAR, y=n)) +
  theme_economist_white() + 
  theme( plot.title.position = "panel"
         ,plot.title = element_textbox_simple(
           size = 13,
           lineheight = 1,
           padding = margin(5.5, 5.5, 5.5, 5.5),
           margin = margin(0, 0, 5.5, 0))
         ,panel.grid.minor = element_blank()
         ,legend.title = element_blank()) +
  ggtitle("<b>Yearly Inches of Snowfall for PDX Airport</b>   <br><span style = 'font-size:14pt'>") +
  labs(caption = "Data: National Centers for Environmental Information") +
  xlab('') +
  ylab('Snowfall (inches)\n')

# weather6: first and last freeze
# plot adapted from: https://twitter.com/tourofdata/status/1333586341481783296
extract_dates <- weather_data %>%
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

ggplot() +
  geom_point(data=freeze_days, aes(y=year, x=as.Date(yday,origin='2020-01-01'))
             , color = "gray", size = 0.8)+
  geom_point(data=first_freeze_yday, aes(y=year, x=as.Date(yday,origin='2020-01-01'))
             ,fill = "purple",shape = 21, size = 3, color = 'black') +
  geom_point(data=last_freeze_yday, aes(y=year, x=as.Date(yday,origin='2020-01-01')) 
             ,fill = "blue",shape = 21, size = 3, color = 'black') +
  scale_y_reverse(breaks= seq(1950, 2020, 10), minor_breaks = seq(1944, 2020, 2)) +
  scale_x_date(date_labels = "%b", breaks = "month") +
  theme_economist_white() + 
  theme( plot.title.position = "panel"
         ,plot.title = element_textbox_simple(
           size = 13,
           lineheight = 1,
           padding = margin(5.5, 5.5, 5.5, 5.5),
           margin = margin(0, 0, 5.5, 0))) +
  ggtitle("<b>Yearly Last Freeze (Spring) and First Freeze (Fall) Dates for US ZIP code 97218 </b>   <br><span style = 'font-size:14pt'>
          <br><span style = 'color:blue;'>Blue dots indicate the last freeze of winter/spring</span> 
          <br><span style = 'color:purple;'> Purple dots indicate the first freeze of fall/winter.</span> 
          <br><span style = 'color:gray;'> Gray dots indicate days with a min temp at or below 32 degrees Fahrenheit.</span>"
  ) +
  labs(caption = "Data: National Centers for Environmental Information") +
  xlab('') +
  ylab('')


# weather7: cold hardiness 
hardiness_current_usda_map <- freeze_days %>%
  filter(year > 1975 & year < 2006) %>%
  group_by(year) %>%
  summarise(annual_extreme_low = min(TMIN))
summary(hardiness_current_usda_map)

hardiness_newer_data <- freeze_days %>%
  filter(year > 1990 & year < 2021) %>%
  group_by(year) %>%
  summarise(annual_extreme_low = min(TMIN))
summary(hardiness_newer_data)
  
