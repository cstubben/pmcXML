\name{removeFoot}
\alias{removeFoot}

\title{ test

}
\description{

}
\usage{
removeFoot(x)
}

\arguments{
  \item{x}{

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





function (x) 
{
    n <- grep("^", names(x), fixed = TRUE)
    if (length(n) > 0) 
        names(x)[n] <- gsub("\\^.", "", names(x)[n])
    for (i in 1:ncol(x)) {
        n <- grep("^", x[, i], fixed = TRUE)
        if (length(n) > 0) 
            x[n, i] <- gsub("\\^.", "", x[n, i])
    }
    attr(x, "footnotes") <- NULL
    x <- fixTypes(x)
    x
  }
}


\keyword{ ~kwd1 }

