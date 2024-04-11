#' @importFrom base64enc base64encode
b64encode <- function(s) {
  base64encode(s) 
}

b64encode_urlsafe <- function(s) {
  s <- b64encode(s)
  s <- gsub("+", "-", s, fixed = TRUE)
  s <- gsub("/", "_", s, fixed = TRUE)
  s
}

#' @import digest digest
sha1_b64encode <- function(seq) {
  checksum <- digest(seq, algo = "sha1", serialize = FALSE, raw = TRUE)
  checksum <- b64encode(checksum)

  ## Drop newlines (just in case)
  checksum <- sub("[\n]+$", "", checksum)

  ## SHA-1 (160 bits = 20 bytes = 40 hexadecimal character) needs
  ## at most 160/log2(64) = 26.6667 = 27 symbols. Base64 pads to
  ## multiples of 4 symbols, i.e. 28 symbols.  Thus, the last
  ## symbol is always a pad symbol, when using SHA-1. This is
  ## why we drop the last symbol.
  checksum <- sub("[=]$", "", checksum)

  checksum
}    

#' @import digest digest
sha1_b64encode_urlsafe <- function(seq) {
  checksum <- digest(seq, algo = "sha1", serialize = FALSE, raw = TRUE)
  checksum <- b64encode_urlsafe(checksum)

  ## Drop newlines (just in case)
  checksum <- sub("[\n]+$", "", checksum)

  ## SHA-1 (160 bits = 20 bytes = 40 hexadecimal character) needs
  ## at most 160/log2(64) = 26.6667 = 27 symbols. Base64 pads to
  ## multiples of 4 symbols, i.e. 28 symbols.  Thus, the last
  ## symbol is always a pad symbol, when using SHA-1. This is
  ## why we drop the last symbol.
  checksum <- sub("[=]$", "", checksum)

  checksum
}    


with_prefix <- function(s, prefix, form = c("long", "short", "both")) {
  form <- match.arg(form)
  
  checksum <- sub("^(|(l|c)(s|d))*seguid=", "", s)
  assert_checksum(checksum, prefix = "")

  if (form == "both") form <- c("short", "long")

  res <- character(0L)
  for (ff in form) {
    if (ff == "long") {
      res <- c(res, paste0(prefix, checksum))
    } else if (ff == "short") {
      res <- c(res, substr(checksum, start = 1L, stop = 6L))
    }
  }
  
  res
}

.seguid <- function(seq, alphabet, encoding, prefix = "") {
    assert_alphabet(alphabet)
    assert_in_alphabet(seq, alphabet = names(alphabet))
    stopifnot(is.function(encoding))
    stopifnot(length(prefix) == 1, is.character(prefix), !is.na(prefix))

    checksum <- encoding(seq)

    checksum <- paste0(prefix, checksum)
    assert_checksum(checksum, prefix = prefix)
    checksum
}
