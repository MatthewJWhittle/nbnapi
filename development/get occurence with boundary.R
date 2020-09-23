require(getarc)
require(sf)
devtools::load_all()

# counties_endpoint <- "https://ons-inspire.esriuk.com/arcgis/rest/services/Administrative_Boundaries/Counties_and_Unitary_Authorities_December_2016_Boundaries/MapServer/0"
#
# counties <- query_layer(endpoint = counties_endpoint,
#                         query = c(returnRecordCount = 4,
#                                   where = c("ctyua16nm LIKE 'Hartlepool'")))


taxon = "Betula pendula"
taxon = "Cyanistes caeruleus"
taxon = "Epipactis dunensis"

#
# boundary <- xy_to_points(x = c(208503, 208503),
#                          y = c(921764, 921564)) %>% st_buffer(10000) %>% st_union()
boundary <- north_yorkshire$geometry

if(is.null(boundary)) {
  boundary_wkt <- NULL
} else{
  # Check and simplify the boundary to the request isn't too long
  boundary_simple <-
    simplify_sf_to_nchar(st_transform(boundary, 27700), char = 1000)
  boundary_simple <- st_transform(boundary_simple, crs = 4326)
  # Convert it to well known text
  boundary_wkt <- st_as_text(boundary_simple)
}

# lat = 58.143170
# lon = -5.2550805
# radius_km = 10

# Check that all arguments are numeric
# This will be redundant if sf support is brought in
# if (!all(purrr::map_lgl(list(lat, lon, radius_km), is.numeric))) {
#   stop(paste0(
#     "Non-numeric argument passed to one of: ",
#     paste0(names(num_args), collapse = ", ")
#   ))
# }


# Specify the endpoint to download data from
endpoint <-
  "https://records-ws.nbnatlas.org/occurrences/index/download"


# Specify in a list so it can be combined into the request string
# ACTION: add in more parameters that can be specified such as the data type etc
query_params <-
  list(
    reasonTypeId = 15,
    q = gsub(" ", "+", taxon),
    # lat = lat,
    # lon = lon,
    # radius = radius_km,
    wkt = boundary_wkt,
    qa = "none",
    fileType = "shp"
  )

query_string <- collapse_query_parameters(query_params, drop_null = T)

request <- URLencode(paste0(endpoint, "?", query_string))


data <- download_nbn_data(request)
