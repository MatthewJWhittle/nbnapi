str_get <-
    function(x, pattern, negate = FALSE) {
      x[str_detect(x, pattern, negate = negate)]
    }