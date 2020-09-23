


require(httr)
require(tidyverse)

get_nbn_taxon_children <- function(taxon) {
  profile <- get_nbn_species_profiles(taxon)
  
  if (all(dim(profile) == c(0, 0))) {
    stop("Unrecognized Taxon")
  }
  taxon_id <- profile$identifier
  rank <- str_to_lower(profile$rank)
  endpoint <- "https://species-ws.nbnatlas.org/download"
  query <- paste0("fq=rkid_", rank, ":", taxon_id)
  url <- paste0(endpoint, "?", query)
  
  response <- GET(url)
  
  species <- response %>% content()
  
  species <- janitor::clean_names(species)
  
  return(species)
}
