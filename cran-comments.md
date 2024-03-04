# CRAN submission seguid 0.1.0

on 2024-03-01

Tweaks in package title and description:

* shorten title to < 65 characters
* Drop 'An R'
* 'SEGUID' -> SEGUID

on 2024-02-28

This is new-package submission. Incoming CRAN checks report on:

Possibly misspelled words in DESCRIPTION:
  Babnigg (11:103)
  Checksums (3:53)
  Giometti (11:115)

These are false positives. The first and the last are author surnames.



## Notes not sent to CRAN

### R CMD check validation

The package has been verified using `R CMD check --as-cran` on:

| R version | GitHub | mac/win-builder |
| --------- | ------ | --------------- |
| 3.5.x     | L      |                 |
| 4.0.x     | L      |                 |
| 4.2.x     | L M W  |    W            |
| 4.3.x     | L M W  | M1 W            |
| devel     | L M W  |    W            |

_Legend: OS: L = Linux, M = macOS, M1 = macOS M1, W = Windows_
