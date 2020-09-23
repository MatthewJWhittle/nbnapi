require(sf)
require(tidyverse)
n <- c(1:1000)

# all_counties <- query_layer(endpoint = counties_endpoint)
counties <- st_transform(counties, crs = 27700)
# nchar(st_as_text(counties$geometry))
# nchar(st_as_text(st_buffer(counties$geometry, 1000)))

d <-  seq(from = 1, to = 100, by = 1)

char_lengths <-
  purrr::map_dbl(.x = d,
                 ~nchar(st_as_text(
                   st_simplify(counties$geometry, dTolerance = .x)
                 )))

plot(d, char_lengths)

plot(counties$geometry, border = "green")
plot(st_simplify(counties$geometry, dTolerance = 400), add = TRUE, border = "red")

