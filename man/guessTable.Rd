\name{guessTable}
\alias{guessTable}

\title{ test

}
\description{

}
\usage{
guessTable(x, file, header = 1, ...)
}

\arguments{
  \item{x}{

}
  \item{file}{

}
  \item{header}{

}
  \item{\dots}{

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





function (x, file, header = 1, ...) 
{
    if (missing(file)) 
        file <- ""
    n <- apply(x, 2, function(y) sum(!(is.na(y) | y == "" | y == 
        " ")))
    if (any(n == 0)) {
        print(paste("Deleted", sum(n == 0), "empty columns"))
        x <- x[, n != 0]
    }
    n <- apply(x, 1, function(y) sum(!(is.na(y) | y == "" | y == 
        " ")))
    if (any(n == 0)) {
        print(paste("Deleted", sum(n == 0), "empty rows"))
        x <- x[n != 0, ]
        n <- n[n != 0]
    }
    if (any(grepl(" $", x[, ncol(x)]))) {
        print("Trimmed spaces in last column")
        x[, ncol(x)] <- gdata::trim(x[, ncol(x)])
    }
    footnotes <- ""
    if (n[length(n)] == 1) {
        z <- rle(n)$lengths
        n2 <- (length(n) - z[length(z)] + 1):length(n)
        footnotes <- x[n2, 1]
        x <- x[-n2, ]
    }
    else {
        if (n[length(n)] == 2 & ncol(x) > 3) {
            z <- rle(n > 2)$lengths
            n2 <- (length(n) - z[length(z)] + 1):length(n)
            footnotes <- apply(x[n2, 1:2], 1, paste, collapse = " ")
            x <- x[-n2, ]
        }
    }
    caption <- ""
    if (n[1] == 1) {
        n1 <- 1:rle(n)$lengths[1]
        caption <- x[n1, 1]
        x <- x[-n1, ]
        n <- n[-n1]
    }
    if (is.numeric(header)) {
        if (header == 1) {
            xx <- as.vector(unlist(x[1, ]))
            x <- x[-1, ]
        }
        else {
            xx <- gdata::trim(apply(x[1:header, ], 2, paste, 
                collapse = " "))
            x <- x[-(1:header), ]
        }
        if (any(xx == "")) {
            xx[xx == ""] <- " "
        }
        xx <- gsub(" +", " ", xx)
        xx <- gsub("\"", "", xx)
        colnames(x) <- xx
    }
    x <- fixTypes(x, ...)
    attr(x, "file") <- file
    attr(x, "label") <- gsub("([^.]*).*", "\\1", caption)
    attr(x, "caption") <- gsub("[^.]*. *(.*)", "\\1", caption)
    attr(x, "footnotes") <- footnotes
    x
  }
}


\keyword{ ~kwd1 }

