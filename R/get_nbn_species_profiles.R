require(purrr)
require(jsonlite)
require(httr)

get_nbn_species_profiles <-
  function(species_list) {
    request_body <- jsonlite::toJSON(list(names = species_list))
    
    message("Requesting data...")
    response <-
      POST(url = "https://species-ws.nbnatlas.org/species/lookup/bulk",
           body = request_body)
    
    sp_profiles_list <- response %>% content()
    
    profile_table <-
      sp_profiles_list %>%
      map_depth(.depth = 2,
                ~ paste0(.x, collapse = "; ")) %>%
      map( ~ as_tibble(.x)) %>% bind_rows()
    
    return(profile_table)
  }


