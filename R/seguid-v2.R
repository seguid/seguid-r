#' @return
#' `lsseguid()` calculates the SEGUID v2 checksum for a linear,
#' single-stranded sequence.
#'
#' @rdname seguid
#' @export
lsseguid <- function(seq, alphabet = "{DNA}", form = c("long", "short", "both")) {
  if (nchar(seq) == 0) {
    stop("A sequence must not be empty")
  }
  
  alphabet2 <- get_alphabet(alphabet)
  with_prefix(.seguid(seq, alphabet = alphabet2, encoding = sha1_b64encode_urlsafe), prefix = "lsseguid=", form = form)
}


#' @return
#' `csseguid()` calculates the SEGUID v2 checksum for a circular,
#' single-stranded sequence.
#'
#' @rdname seguid
#' @export
csseguid <- function(seq, alphabet = "{DNA}", form = c("long", "short", "both")) {
  if (nchar(seq) == 0) {
    stop("A sequence must not be empty")
  }
  
  with_prefix(lsseguid(rotate_to_min(seq), alphabet = alphabet), prefix = "csseguid=", form = form)
}


#' @param watson,crick (character strings) Two reverse-complementary DNA
#' sequences. Both sequences should be specified in the 5'-to-3' direction.
#'
#' @return
#' `ldseguid()` calculates the SEGUID v2 checksum for a linear,
#' double-stranded sequence.
#'
#' @rdname seguid
#' @export
ldseguid <- function(watson, crick, alphabet = "{DNA}", form = c("long", "short", "both")) {
  ## Make sure to collate in the 'C' locale
  old_locale <- Sys.getlocale("LC_COLLATE")
  on.exit(Sys.setlocale("LC_COLLATE", old_locale))
  Sys.setlocale("LC_COLLATE", "C")

  if (nchar(watson) == 0 || nchar(crick) == 0) {
    stop("A sequence must not be empty")
  }

  alphabet2 <- paste0(alphabet, "+[-;]")
  assert_complementary(watson, crick, alphabet = alphabet2)

  if (is_seq_less_than(watson, crick)) {
    spec <- paste(watson, crick, sep = ";")
  } else {
    spec <- paste(crick, watson, sep = ";")
  }
  with_prefix(lsseguid(spec, alphabet = alphabet2), prefix = "ldseguid=", form = form)
}


#' @return
#' `cdseguid()` calculates the SEGUID v2 checksum for a circular,
#' double-stranded sequence.
#'
#' @rdname seguid
#' @export
cdseguid <- function(watson, crick, alphabet = "{DNA}", form = c("long", "short", "both")) {
  if (nchar(watson) == 0 || nchar(crick) == 0) {
    stop("A sequence must not be empty")
  }
  
  stopifnot(nchar(watson) == nchar(crick))
  
  assert_complementary(watson, crick, alphabet = alphabet)

  amount_watson <- min_rotation(watson)
  watson_min <- rotate(watson, amount = amount_watson)
  
  amount_crick <- min_rotation(crick)
  crick_min <- rotate(crick, amount = amount_crick)

  ## Keep the "minimum" of the two variants
  if (is_seq_less_than(watson_min, crick_min)) {
      w <- watson_min
      c <- rotate(crick, amount = -amount_watson)
  } else {
      w <- crick_min
      c <- rotate(watson, amount = -amount_crick)
  }

  with_prefix(ldseguid(watson = w, crick = c, alphabet = alphabet), prefix = "cdseguid=", form = form)
}
