#' SEGUID checksums for linear, circular, single- and double-stranded sequences
#'
#' Functions for calculating sequence checksums for linear, circular,
#' single- and double-stranded sequences based on either the original
#' SEGUID (SEGUID v1) algorithm (Babnigg & Giometti, 2006) or the
#' SEGUID v2 algorithm (Pereira et al., 2024).
#'
#' @param seq (character string) The sequence for which the checksum
#' should be calculated.  The sequence may only comprise of symbols
#' in the alphabet specified by the `alphabet` argument.
#'
#' @param alphabet (character string) The type of sequence used.
#' If `"{DNA}"` (default), then the input is a DNA sequence.
#' If `"{RNA}"`, then the input is an RNA sequence.
#' If `"{protein}"`, then the input is an amino-acid sequence.
#' If `"{DNA-extended}"` or `"{RNA-extended}"`, then the input is a
#' DNA or RNA sequence specified an extended set of symbols, including
#' IUPAC symbols (4).
#' If `"{protein-extended}"`, then the input is an amino-acid sequence
#' with an extended set of symbols, including IUPAC symbols (5).
#' A custom alphabet may also be used.
#' A non-complementary alphabet is specified as a comma-separated
#' set of single symbols, e.g. `"X,Y,Z"`.
#' A complementary alphabet is specified as a comma-separated
#' set of paired symbols, e.g. `"AT,CG"`.
#' It is also possible to extend a pre-defined alphabet, e.g.
#' `"{DNA},XY"`.
#'
#' @param form (character string) How the checksum is presented.
#' If `"long"` (default), the full-length checksum is outputted.
#' If `"short"`, the short, six-digit checksum is outputted.
#' If `"both"`, both the short and the long checksums are outputted.
#'
#' @return
#' The SEGUID functions return a single character string, if `form` is
#' either `"long"` or `"short"`. If `form` is `"both"`, then a character
#' vector of length two is return, where the first component holds the
#' "short" checksum and the second the "long" checksum.
#' The long checksum, without the prefix, is string with 27 characters.
#' The short checksum, without the prefix, is the first six characters
#' of the long checksum.
#' All checksums are prefixed with a label indicating which SEGUID
#' method was used.
#' Except for `seguid()`, which uses _base64_ encoding, all functions
#' produce checksums using the _base64url_ encoding ("Base 64 Encoding
#' with URL and Filename Safe Alphabet").
#'
#' `seguid()` calculates the SEGUID v1 checksum for a linear,
#' single-stranded sequence. 
#'
#' @section Base64 and Base64url encodings:
#' The base64url encoding is the base64 encoding with non-URL-safe characters
#' substituted with URL-safe ones. Specifically, the plus symbol (`+`) is
#' replaced by the minus symbol (`-`), and the forward slash (`/`) is
#' replaced by the underscore symbol (`_`).
#'
#' The Base64 checksum, which is used for the original SEGUID checksum,
#' is not guaranteed to comprise symbols that can
#' safely be used as-is in Uniform Resource Locator (URL). Specifically,
#' it may consist of forward slashes (`/`) and plus symbols (`+`), which
#' are characters that carry special meaning in a URL.
#' For the same reason, a Base64 checksum cannot safely be used
#' as a file or directory name, because it may have a forward slash.
#'
#' The checksum returned is always 27-character long. This is because the
#' SHA-1 hash (6) is 160-bit long (20 bytes), which result in the
#' encoded representation always end with a padding character (`=`) so that
#' the length is a multiple of four character. We relax this requirement,
#' by dropping the padding character.
#'
#' @example incl/seguid.R
#'
#' @references
#' 1. G Babnigg & CS Giometti, A database of unique protein sequence
#'    identifiers for proteome studies. Proteomics.
#'    2006 Aug;6(16):4514-22, \doi{10.1002/pmic.200600032}.
#' 2. H Pereira, PC Silva, WM Davis, L Abraham, G Babnigg, H Bengtsson &
#'    B Johansson, SEGUID v2: Extending SEGUID Checksums for Circular,
#'    Linear, Single- and Double-Stranded Biological Sequences,
#'    bioRxiv, \doi{10.1101/2024.02.28.582384}.
#' 3. S Josefsson, The Base16, Base32, and Base64 Data Encodings,
#'    RFC 4648, October 2006, \doi{10.17487/RFC4648}.
#' 4. Wikipedia article 'Nucleic acid notation', February 2024,
#'    <https://en.wikipedia.org/wiki/Nucleic_acid_notation>.
#' 5. Wikipedia article 'Amino acids', February 2024,
#'    <https://en.wikipedia.org/wiki/Amino_acid>.
#' 6. Wikipedia article 'SHA-1' (Secure Hash Algorithm 1), December 2023,
#'    <https://en.wikipedia.org/wiki/SHA-1>.
#'
#' @importFrom base64enc base64encode
#' @importFrom digest digest
#' @export
seguid <- function(seq, alphabet = "{DNA}", form = c("long", "short", "both")) {
  if (nchar(seq) == 0) {
    stop("A sequence must not be empty")
  }
  
  alphabet2 <- get_alphabet(alphabet)
  with_prefix(.seguid(seq, alphabet = alphabet2, encoding = sha1_b64encode), prefix = "seguid=", form = form)
}
