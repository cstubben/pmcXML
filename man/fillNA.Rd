\name{fillNA}
\alias{fillNA}

\title{

}
\description{

}
\usage{
fillNA(x)
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
    for (i in seq_along(x)[-1]) {
        if (is.na(x[i]) | x[i] == "" | x[i] == "<U+00A0>") 
            x[i] <- x[i - 1]
    }
    x
  }
}


\keyword{ ~kwd1 }

