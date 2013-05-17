\name{collapse2}
\alias{collapse2}

\title{ test

}
\description{

}
\usage{
collapse2(x, na.string)
}

\arguments{
  \item{x}{

}
  \item{na.string}{

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





function (x, na.string) 
{
    y <- names(x)
    cx <- vector("character", nrow(x))
    for (i in 1:nrow(x)) {
        n2 <- is.na(x[i, ]) | x[i, ] == ""
        if (!missing(na.string)) 
            n2 <- n2 | x[i, ] == na.string
        cx[i] <- paste(paste(y[!n2], x[i, !n2], sep = "="), collapse = ";")
    }
    cx
  }
}


\keyword{ ~kwd1 }

