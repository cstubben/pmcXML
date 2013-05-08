\name{sr}
\alias{sr}

\title{

}
\description{

}
\usage{
sr(x, pattern, replacement)
}

\arguments{
  \item{x}{

}
  \item{pattern}{

}
  \item{replacement}{

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





function (x, pattern, replacement) 
{
    n <- apply(x, 2, function(y) any(grepl(pattern, y)))
    if (sum(n) > 0) {
        for (i in which(n)) x[, i] <- gsub(pattern, replacement, 
            x[, i])
    }
    x
  }
}


\keyword{ ~kwd1 }

