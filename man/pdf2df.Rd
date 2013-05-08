\name{pdf2df}
\alias{pdf2df}

\title{

}
\description{

}
\usage{
pdf2df(x, split, captionRow = 1, headerRow = 2, labels)
}

\arguments{
  \item{x}{

}
  \item{split}{

}
  \item{captionRow}{

}
  \item{headerRow}{

}
  \item{labels}{

}
}
\details{

}
\value{





}
\references{

}
\author{

}
\note{

}



\seealso{

}
\examples{





function (x, split, captionRow = 1, headerRow = 2, labels) 
{
    caption <- ""
    header <- NULL
    if (missing(split)) {
        stop("Please enter a string to split columns -see help for details")
    }
    if (is.numeric(captionRow)) {
        caption <- x[captionRow]
    }
    if (is.numeric(headerRow)) {
        xx <- x[headerRow]
        header <- unlist(strsplit(xx, " "))
        if (!missing(labels)) {
            if (is.numeric(labels)) {
                n <- length(labels)
                if (max(labels) >= n) {
                  header <- header[labels]
                }
                else {
                  z <- split(header, rep(1:n, labels))
                  header <- as.vector(sapply(z, paste, collapse = " "))
                }
            }
            else {
                header <- labels
            }
            header <- gsub("/", "_", header)
        }
        if (is.numeric(captionRow)) {
            x <- x[-c(captionRow, headerRow)]
        }
        else {
            x <- x[-headerRow]
        }
    }
    y <- strsplit(split, " ")[[1]]
    if (length(y) > 9) 
        stop("Can only split 9 or more columns (ie, backreferences \\10 and above are not allowed in gsub)")
    z <- list(w = "([^ ]*)", d = "([0-9Ee.-]*)", a = "(.*)")
    z1 <- paste(z[match(y, names(z))], collapse = " ")
    z2 <- paste("\\", paste(1:length(y), collapse = "\t\\"), 
        sep = "")
    x <- gsub(z1, z2, x)
    zz <- textConnection(x)
    x <- read.delim(zz, header = FALSE, stringsAsFactors = FALSE, 
        fill = TRUE)
    close(zz)
    if (length(header) == ncol(x)) 
        names(x) <- header
    y <- strsplit(caption, ". ", fixed = TRUE)[[1]]
    attr(x, "label") <- y[1]
    attr(x, "caption") <- paste(y[2:length(y)], collapse = ". ")
    x
  }
}


\keyword{ ~kwd1 }

