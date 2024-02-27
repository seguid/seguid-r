make_alphabet <- function(definition) {
  stopifnot(length(definition) == 1, is.character(definition), !is.na(definition))
  alphabet <- strsplit(definition, split = ",", fixed = TRUE)[[1]]
  n <- nchar(alphabet)[1]
  stopifnot(nchar(alphabet) == n, n %in% 1:2)

  alphabet <- strsplit(alphabet, split = "", fixed = TRUE)

  ## Expand AB -> AB,BA and then drop duplicates
  if (n == 2L) {
    alphabet <- c(alphabet, lapply(alphabet, FUN = rev))
    alphabet <- unique(alphabet)
  }

  keys <- vapply(alphabet, FUN = function(x) x[1], FUN.VALUE = NA_character_)
  assert_valid_alphabet(keys)
  
  if (n == 1L) {
    values <- rep("", times = length(keys))
    names(values) <- keys
  } else if (n == 2L) {
    values <- vapply(alphabet, FUN = function(x) x[2], FUN.VALUE = NA_character_)
    assert_valid_alphabet(values)
    names(values) <- keys
    assert_alphabet(values)
  }
  values
}

get_alphabet <- function(spec) {
  stopifnot(length(spec) == 1, is.character(spec), !is.na(spec))
  
  ## Extras? Example: "{DNA}+[-]+[\n]" and "{DNA}+[-\n]"
  extras <- NULL
  pattern <- "(.*)[+][[](.*)[]]$"
  while (grepl(pattern, spec)) {
    spec0 <- spec
    extra <- sub(pattern, "\\2", spec)
    spec <- sub(pattern, "\\1", spec)
    extra <- strsplit(extra, split = "", fixed = TRUE)[[1]]
    extras <- c(extras, extra)
  }

  parts <- strsplit(spec, split = ",", fixed = TRUE)[[1]]
  for (kk in seq_along(parts)) {
    part <- parts[kk]
    if (grepl("^[{][[:alpha:]][[:alnum:]-]+[}]$", part)) {
      if (part == "{DNA}") {
        alphabet <- "AT,CG"
      } else if (part == "{RNA}") {
        alphabet <- "AU,CG"
      } else if (part == "{DNA-IUPAC}") {
        alphabet <- "AT,CG,BV,DH,HD,KM,MK,SS,VB,WW,NN"
      } else if (part == "{RNA-IUPAC}") {
        alphabet <- "AU,CG,BV,DH,HD,KM,MK,SS,VB,WW,NN"
      } else if (part == "{protein}") {
        alphabet <- "A,C,D,E,F,G,H,I,K,L,M,N,P,Q,R,S,T,V,W,Y"
      } else if (part == "{protein-IUPAC}") {
        alphabet <- "A,C,D,E,F,G,H,I,K,L,M,N,P,Q,R,S,T,V,W,Y,B,J,X,Z"
      } else {
        stop("Unknown alphabet: ", sQuote(part))
      }
      parts[kk] <- alphabet
    }
  }
  parts <- paste(parts, collapse = ",")
  alphabet <- make_alphabet(parts)

  ## Add extras?
  if (length(extras) > 0) {
    names(extras) <- extras
    alphabet <- c(alphabet, extras)
  }

  alphabet
}
