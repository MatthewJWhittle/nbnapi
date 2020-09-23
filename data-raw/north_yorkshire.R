rm(list = ls())
require(getarc)

# devtools::load_all()

counties_endpoint <- "https://ons-inspire.esriuk.com/arcgis/rest/services/Administrative_Boundaries/Counties_and_Unitary_Authorities_December_2016_Boundaries/MapServer/0"

north_yorkshire <- query_layer(endpoint = counties_endpoint,
                        query = c(returnRecordCount = 1,
                                  where = c("ctyua16nm LIKE 'North Yorkshire'")))

north_yorkshire <- north_yorkshire["ctyua16nm"]
usethis::use_data(north_yorkshire, overwrite = T)
