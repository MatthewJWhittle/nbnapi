#' Get Occurance
#'
#' Get NBN Occurance Data
#'
#'
#' @param taxon a string detailing the taxon name
#' @param lat the latitude coordinate
#' @param lon the longitude coordinate
#' @param radius_km the radius in kilometers within which to return records
get_occurence <-
  function(taxon, lat, lon, radius_km) {
    # Check that all arguments are numeric
    # This will be redundant if sf support is brought in
    if (!all(purrr::map_lgl(list(lat, lon, radius_km), is.numeric))) {
      stop(paste0(
        "Non-numeric argument passed to one of: ",
        paste0(names(num_args), collapse = ", ")
      ))
    }


    # Specify the endpoint to download data from
    endpoint <-
      "https://records-ws.nbnatlas.org/occurrences/index/download"

    # Specify in a list so it can be combined into the request string
    # ACTION: add in more parameters that can be specified such as the data type etc
    query_params <-
      list(
        reasonTypeId = 15,
        q = gsub(" ", "+", taxon),
        lat = lat,
        lon = lon,
        radius = radius_km,
        qa = "none",
        fileType = "shp"
      )

    query_string <- collapse_query_parameters(query_params)

    request <- paste0(endpoint, "?", query_string)

    data <- download_nbn_data(request)

    return(data)

  }
