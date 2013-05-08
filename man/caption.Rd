\name{caption}
\alias{caption}

\title{

}
\description{

}
\usage{
caption(x, ...)
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
    y <- attr(x, "caption")
    if (is.null(y)) {
        print("No table caption")
    }
    else {
        strwrap2(y, ...)
    }
  }
}


\keyword{ ~kwd1 }

