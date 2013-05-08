\name{repeatSub}
\alias{repeatSub}

\title{

}
\description{

}
\usage{
repeatSub(x, column = "subheading", first = TRUE, ...)
}

\arguments{
  \item{x}{

}
  \item{column}{

}
  \item{first}{

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





function (x, column = "subheading", first = TRUE, ...) 
{
    n <- apply(x[, -1, FALSE], 1, function(z) all(is.na(z) | 
        z == "NA" | z == "" | z == "<U+00A0>"))
    y <- x
    if (sum(diff(which(n)) == 1) > 1) {
        print("Too many subheaders in consecutive rows")
    }
    else if (which(n)[1] != 1) {
        print("No subheader in row 1")
    }
    else if (length(n) == 0) {
        print("No subheaders found")
    }
    else {
        x[[column]] <- rep(x[n, 1], times = diff(c(which(n), 
            nrow(x) + 1)))
        y <- subset(x, !n)
        rownames(y) <- NULL
        y <- fixTypes(y, ...)
        if (first) 
            y <- y[, c(ncol(y), 1:(ncol(y) - 1))]
        attr(y, "id") <- attr(x, "id")
        attr(y, "pmid") <- attr(x, "pmid")
        attr(y, "file") <- attr(x, "file")
        attr(y, "label") <- attr(x, "label")
        attr(y, "caption") <- attr(x, "caption")
        attr(y, "footnotes") <- attr(x, "footnotes")
    }
    y
  }
}


\keyword{ ~kwd1 }

