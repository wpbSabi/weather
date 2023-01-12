
# What is in the weather repository?

For a thorough explanation and tutorial of this project, please read my article on [Towards Data Science](https://towardsdatascience.com/democratizing-historical-weather-data-with-r-cc3c76dde7c5)

This repository contains data from the National Centers for Environmental Information (https://www.climate.gov/maps-data/dataset/past-weather-zip-code-data-table).

Using this data, weather visualizations for a zipcode answer the following questions:
* How often has it rained?  Which months receive more (or less) rain?
* How often has it snowed?
* When is the average first freeze in the fall?
* When is the average latest freeze in the spring?


## Why/History

These visualizations are helpful for gardeners and farmers that pay attention to precipitation and freezing temperatures.  The visualizations may also be helpful for real estate in that learning about weather patterns may be a consideration for migration.


## Visualizations for the Portland, Oregon Airport Zipcode (97218)

While temperature statistsics are likely the most sought after weather data, Rainfall data is also very interesting but less available to the public.  Although it is easy to find estimations of annual rainfall, the folllowing plot provides more information regarding the monthly averages and distribution of rainfall.

![Rainfall](https://github.com/wpbSabi/weather/blob/main/images/rainfall.png)

Winter weather analysis can vary greatly by region.  For Portland, it is interesting to plot measurable snowfall as a scatterplot, to show that measurable snowfall has been rare in the last 20 years.

![Snowfall](https://github.com/wpbSabi/weather/blob/main/images/snowfall.png)

Gardeners and growers will be particularly interested in the history of last freezes in the spring and first freezes in the fall.  And a greater audience may also be interested in the frequency of minimum temperatures at or below freezing.

![Freeze](https://github.com/wpbSabi/weather/blob/main/images/Yearly_first_and_last_freeze_for_Portland_OR.png)

## How do I run the code?

If you have cloned the repository:
* Run 'Yearly first and last freeze.R' with temperature data.
* Run 'Precipitation.Rmd' with RStudio on the precipidation data.
* If you prefer one R script to follow along with the [article](https://towardsdatascience.com/democratizing-historical-weather-data-with-r-cc3c76dde7c5), that R script can be found at './towardsDS/weather_full_script.R'
