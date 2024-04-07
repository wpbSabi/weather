# Weather visualizations

>**TIP**: For a thorough explanation and tutorial of this project,
please read my article on [Towards Data Science](https://towardsdatascience.com/democratizing-historical-weather-data-with-r-cc3c76dde7c5).

This repository uses data from the
[U.S. National Centers for Environmental Information](https://www.climate.gov/maps-data/dataset/past-weather-zip-code-data-table)
to create weather visualizations that answer the following questions:

* How often has it rained? Which months receive more or less rain?
* How often has it snowed?
* When's the average first freeze in the fall?
* When's the average last freeze in the spring?

## Purpose

These visualizations could be helpful for gardeners and farmers
that pay attention to historical precipitation amounts and/or occurrences of freezing temperatures.
The visualizations might also be helpful for researching real estate purchases,
in that learning about weather patterns may be a consideration for migration.

## Example visualizations

The following examples are for the Portland, Oregon airport (zipcode 97218).

While temperature statistics are likely the most sought after weather data,
rainfall data is also useful, but is typically less available to the public.
Although it's easy to find estimations of annual rainfall,
the following plot provides more information regarding the monthly averages and distribution of rainfall.

![Rainfall](https://github.com/wpbSabi/weather/blob/main/images/rainfall.png)

Winter weather analysis can vary greatly by region.
For Portland, Oregon, it's interesting to plot measurable snowfall as a scatterplot,
to show that it has been relatively rare in the last 20 years.

![Snowfall](https://github.com/wpbSabi/weather/blob/main/images/snowfall.png)

Gardeners and growers tend
to be particularly interested in the history of last freezes in the spring and first freezes in the fall.
The frequency of minimum temperatures at-or-below freezing might interest an even wider audience.

![Freeze](https://github.com/wpbSabi/weather/blob/main/images/Yearly_first_and_last_freeze_for_Portland_OR.png)

## How do I run the code?

Once you've cloned the repository:
* Run `Yearly first and last freeze.R` in RStudio with temperature data.
* Run `Precipitation.Rmd` in RStudio with precipitation data.
* If you prefer one R script to follow along with the
  [article](https://towardsdatascience.com/democratizing-historical-weather-data-with-r-cc3c76dde7c5),
  find that R script at `./towardsDS/weather_full_script.R`.

**TIPS**:
* You might need to change the RStudio working directory to where you cloned this repo.
  * For this, open a new script window in RStudio and execute the `setwd()` command. For example, `setwd("/Users/<username>/repos/weather")`.
* Refer to the [article](https://towardsdatascience.com/democratizing-historical-weather-data-with-r-cc3c76dde7c5)
  for additional tips on how to run the code.
