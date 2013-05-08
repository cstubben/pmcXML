\name{footnotes}
\alias{footnotes}

\title{

}
\description{

}
\usage{
footnotes(x, ...)
}

\arguments{
  \item{x}{

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





function (x, ...) 
{
    y <- attr(x, "footnotes")
    if (is.null(y)) {
        print("No table footnotes")
    }
    else {
        strwrap2(y, ...)
    }
  }
}


\keyword{ ~kwd1 }

