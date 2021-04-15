library("cowplot")
library("dplyr")
library ("tidyr")
library("tidyverse")

#Download latest county landings information from:
#https://public.myfwc.com/FWRI/PFDM/ReportCreator.aspx

#Select the year, select Food and Bait

#In Additional Output Columns select:
#County, Pounds, Average Price, and Estimated Value


### Reading in the csv
county_landings<- read.csv("oys_fl_landings_shiny_app/data/ReportCreatorResults-County.csv", header= T, skip = 9)


### Manipulating the county data to only display Apalachicola Counties
apalach <- county_landings %>% 
  filter (County.Landed== "FRANKLIN" | County.Landed=="WAKULLA")%>%
  select(Year, Pounds, Trips) %>% 
  group_by(Year) %>% 
  mutate(pounds_sum= sum (Pounds)) %>% 
  mutate(trips_sum= sum (Trips)) %>% 
  mutate (per_trip= pounds_sum/trips_sum) %>% #<- calculating per trips
  filter (! duplicated(Year)) %>% 
  rename ("Landings (lbs)"= pounds_sum, "Total Trips"= trips_sum, "CPUE"= per_trip) %>% 
  gather(value, measurement, c("Landings (lbs)", "Total Trips", "CPUE")) %>% 
  group_by (Year, value) %>% 
  summarise(measurement=measurement) %>% 
  add_column(area= "Apalachicola")

apalach_df<- data.frame(apalach)

### Manipulating the county data to only display Suwannee Counties
suwannee <- county_landings %>% 
  filter (County.Landed== "TAYLOR" | County.Landed=="DIXIE" | County.Landed=="LEVY") %>% #<- filtering out counties
  select(Year, Pounds, Trips) %>% 
  group_by(Year) %>% 
  mutate(pounds_sum= sum (Pounds)) %>% 
  mutate(trips_sum= sum (Trips)) %>% 
  mutate (per_trip= pounds_sum/trips_sum) %>% #<- calculating per trips
  filter (! duplicated(Year)) %>% 
  rename ("Landings (lbs)"= pounds_sum, "Total Trips"= trips_sum, "CPUE"= per_trip) %>% 
  gather(value, measurement, c("Landings (lbs)", "Total Trips", "CPUE")) %>% 
  group_by (Year, value) %>% 
  summarise(measurement=measurement) %>% 
  add_column(area= "Suwannee Sound")

suwannee_df<- data.frame(suwannee)

### Manipulating the county data to only display all Counties
state <- county_landings %>% 
  select(Year, Pounds, Trips) %>% 
  group_by(Year) %>% 
  mutate(pounds_sum= sum (Pounds)) %>% 
  mutate(trips_sum= sum (Trips)) %>% 
  mutate (per_trip= pounds_sum/trips_sum) %>% #<- calculating per trips
  filter (! duplicated(Year)) %>% 
  rename ("Landings (lbs)"= pounds_sum, "Total Trips"= trips_sum, "CPUE"= per_trip) %>% 
  gather(value, measurement, c("Landings (lbs)", "Total Trips", "CPUE")) %>% 
  group_by (Year, value) %>% 
  summarise(measurement=measurement) %>% 
  add_column(area= "State")

state_df<- data.frame(state)

### Merging all dataframes for easy facet_wrapping, needed to be in data.frame for rbind to function

all_landings <- rbind(apalach_df, suwannee_df, state_df, by= c("Year"))


### Some error where the last line is creating a "year", "year", "year" row, need to remove

all_landings <- all_landings[-c (316),]

all_landings$area<- factor(all_landings $area,levels=c ("Apalachicola", "Suwannee Sound", "State"))
all_landings$value<- factor(all_landings$value,levels=c ("Landings (lbs)", "Total Trips", "CPUE"))


write.csv( all_landings, file="oys_fl_landings_shiny_app/data/landings_data.csv")
