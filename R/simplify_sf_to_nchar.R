#' Simplify sf to length
#'
#' Simplify SF to N Char
#'
#'
#' @param x an sf object to simplify
#' @param char numeric - the number of characters to simplify to based on st_as_text
simplify_sf_to_nchar <-
  function(x, char) {
    x_char <-  nchar(sf::st_as_text(x))
    # Don't execute the function if the character length is sufficiently low
    if(x_char <= char){return(x)}
    factor <- x_char / char

    # simplify x with increasing dtolerance
    # The effect of increasing dTolerance dimishes as x is simplified
    # So the factor is doubled on each iteration
    while (nchar(sf::st_as_text(x)) > char) {
      x <- sf::st_simplify(x, dTolerance = factor)
      factor <- factor * 2
    }
    message(
      paste0(
        "Boundary simplified for request. Returned records may not all be within supplied boundary.\nTo get all records within the boundary try applying a buffer and cropping the records."
      )
    )
    return(x)
  }
