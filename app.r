

# install.packages('ggmap')

library(dplyr)
library(ggmap)
library(leaflet)

# import data
grad <- read.csv('1617__DISTRICT_Grad_Rate.csv', stringsAsFactors = F)

# transform data
grad <- grad %>% 
  # combined address and city/state/zip, separated by comma
  mutate(Add = paste(Address,',',City.and.Zip.Code)) %>%
  # removed '#' symbol, lat/lon were not pulling accurately for 3 rows
  mutate(Add = gsub('#','', Add)) 

system.time({
  grad.geo <- grad %>% mutate_geocode(Add,source='dsk',messaging=F) 
})

grad.geo <- grad.geo %>% mutate(grade4yr = Letter.Grade.of.4.year.Graduation.Rate.2016)

# Pass the palette function a data vector to get the corresponding colors
pal <- colorFactor(c("green", "yellow", "yellow",'yellow','red', 'black'), c('A','B','C','D','F','NR'))

leaflet(grad.geo) %>% 
    addTiles(
      urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
      attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
    ) %>%
  addCircleMarkers(popup = ~District.Name,radius = 2,color = ~pal(grade4yr),opacity = .9) %>%
  addLegend(pal = pal,values= grad.geo$grade4yr)
