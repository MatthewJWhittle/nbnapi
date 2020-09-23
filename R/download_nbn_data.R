#' Download NBN data
#'
#' Download data from an nbn endpoint
#'
#' This function handles steps to download, unzip and read shapefile data
#' @param request a request string
#' @return an sf object
#' @importFrom sf st_read
#' @importFrom httr GET
#' @importFrom httr write_disk
download_nbn_data <-
  function(request) {
    # Set up cache file and directory
    cache_file <- tempfile(fileext = ".zip")
    unzipdir <- tempdir()
    # Create a folder with the same name as the zip file to unzip contents into
    file_cache_path <- str_remove(cache_file, "\\.zip")
    if (!dir.exists(file_cache_path)) {
      dir.create(file_cache_path)
    }


    # Make request
    message("Requesting data.")
    response <- httr::GET(request,
                    httr::write_disk(cache_file, overwrite = T))

    if (response$status_code != 200) {
      stop(paste0("Request failed: API Status Code ",
                  response$status_code, ":\n",
                  # Print the api error and strip out html tags for readability
                  gsub(pattern = "<.*?>", replacement = "", httr::content(response, as = "text"))
                  ))
    }


    # Data is received as a zip file within a zip file
    # The following series of operations unpack the zip file and read it in using the sf package
    # First unzip the top level
    unzip(zipfile = cache_file, exdir = file_cache_path)

    # Then unzip the second level
    unzip(
      zipfile = list.files(file_cache_path, full.names = T, pattern = "data\\.zip"),
      exdir = file_cache_path
    )

    # This tells the user where cached files are but not sure if this is useful. maybe for debugging
    # message(paste("Cached files in:\n", unzipdir))

    shapefile_path <-
      list.files(file_cache_path, full.names = T, pattern = "\\.shp")
    stopifnot(length(shapefile_path) == 1)
    data <- sf::st_read(shapefile_path, stringsAsFactors = FALSE)

    return(data)
  }
