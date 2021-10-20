library(data.table)
library(dplyr)

wp <- read.table("https://raw.githubusercontent.com/LeanColisko/puntos_notificacion_aeronauticos/master/puntos_siginificativos_AIP_NOV_21/aip-nov-21-puntos_significativos.csv", 
                 sep = ";", dec = ",", header = T)


vor <- fread("https://raw.githubusercontent.com/LeanColisko/puntos_notificacion_aeronauticos/master/radioayudas_AIRAC_12018/aip-radioayudas_en_ruta.csv", encoding = "UTF-8")

vor <- vor %>% 
  mutate(lat = as.numeric(substr(lat_cat, start = 1, stop = 2)) +  
         as.numeric(substr(lat_cat, start = 3, stop = 4)) / 60 +
         as.numeric(substr(lat_cat, start = 5, stop = 6)) / 3600,
       long = as.numeric(substr(long_cat, start = 1, stop = 3)) +  
         as.numeric(substr(long_cat, start = 4, stop = 5)) / 60 +
         as.numeric(substr(long_cat, start = 6, stop = 7)) / 3600,
       posicion_lat = substr(lat_cat, start = 7, stop = 8),
       posicion_long = substr(long_cat, start = 8, stop = 9)) %>% 
  mutate(lat = ifelse(posicion_lat == "S", lat * -1, lat),
         long = ifelse(posicion_long == "W", long * -1, long)) %>% 
  select(-c("posicion_lat", "posicion_long")) %>% 
  filter(RADIOAYUDA %in% c('VOR', 'VOR/DME'))


library(leaflet)

leaflet() %>%
  addTiles() %>%
  addCircleMarkers(data = wp, color = "blue", lng = ~long, lat = ~lat, label = ~puntos_significativos, radius = 0.1) %>%
  addCircleMarkers(data = vor, color = "red", lng = ~long, lat = ~lat, label = ~ID, radius = ~log(Cobertura_km))

















