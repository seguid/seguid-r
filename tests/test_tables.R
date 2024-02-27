get_alphabet <- seguid:::get_alphabet
make_alphabet <- seguid:::make_alphabet

alphabet <- get_alphabet("{DNA}")
stopifnot(length(alphabet) == 4L)

alphabet <- get_alphabet("{RNA}")
stopifnot(length(alphabet) == 4L)

alphabet <- get_alphabet("{DNA-IUPAC}")
stopifnot(length(alphabet) == 13L)

alphabet <- get_alphabet("{RNA-IUPAC}")
stopifnot(length(alphabet) == 13L)

alphabet <- get_alphabet("{protein}")
stopifnot(length(alphabet) == 20L)

alphabet <- get_alphabet("{protein-IUPAC}")
stopifnot(length(alphabet) == 24L)

## Unknown alphabet
res <- tryCatch({
  alphabet <- get_alphabet("unknown")
}, error = identity)
stopifnot(inherits(res, "error"))


truth <- get_alphabet("{DNA}")
alphabet <- make_alphabet("AT,TA,CG,GC")
stopifnot(identical(sort(alphabet), sort(truth)))
alphabet <- make_alphabet("AT,CG")
stopifnot(identical(sort(alphabet), sort(truth)))

truth <- get_alphabet("{RNA}")
alphabet <- make_alphabet("AU,UA,CG,GC")
stopifnot(identical(sort(alphabet), sort(truth)))
alphabet <- make_alphabet("AU,CG")
stopifnot(identical(sort(alphabet), sort(truth)))

truth <- get_alphabet("{DNA-IUPAC}")
alphabet <- make_alphabet("AT,BV,CG,DH,GC,HD,KM,MK,NN,SS,TA,VB,WW")
stopifnot(identical(sort(alphabet), sort(truth)))
alphabet <- make_alphabet("AT,BV,CG,DH,KM,NN,SS,WW")
stopifnot(identical(sort(alphabet), sort(truth)))

truth <- get_alphabet("{protein}")
alphabet <- make_alphabet("A,C,D,E,F,G,H,I,K,L,M,N,P,Q,R,S,T,V,W,Y")
stopifnot(identical(sort(alphabet), sort(truth)))

## Invalid components; should be either one or two characters
res <- tryCatch({
  alphabet <- make_alphabet("ATT")
}, error = identity)
stopifnot(inherits(res, "error"))

## Incompatible components
res <- tryCatch({
  alphabet <- make_alphabet("AT,T")
}, error = identity)
stopifnot(inherits(res, "error"))

truth <- c(get_alphabet("{DNA}"), a = "u", u = "a")
alphabet <- get_alphabet("{DNA},au,ua")
stopifnot(identical(sort(alphabet), sort(truth)))
