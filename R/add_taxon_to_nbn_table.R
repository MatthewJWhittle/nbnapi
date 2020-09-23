add_taxon_to_nbn_table <- function(table) {
  
  family_tree <-
    table %>%
    select(kingdom, phylum, classs, order, family, genus, name)
  
  
  # Which detail is missing
  
  position <-
    family_tree %>% apply(
      FUN = function(x) {
        x == ""
      },
      MARGIN = 2
    ) %>%
    apply(function(x) {
      missing <- which(x)
      if (length(missing) > 0) {
        min(missing)
      } else{
        NA
      }
    }, MARGIN = 1)
  
  
  column <- colnames(family_tree)[position]
  
  rows <- 1:nrow(family_tree)
  
  entry_table <-
    tibble(r = rows, c = column)
  
  
  rows %>%
    lapply(function(i) {
      # Extract entry
      entry <- entry_table[i,]
      valid_entry <- complete.cases(entry) %>% unlist() %>% all()
      if (valid_entry) {
        # Enter taxon info
        table[entry$r, entry$c] <- family_tree$name[i]
      }
      
      return(table[i,])
    }) %>% bind_rows()
  
}
