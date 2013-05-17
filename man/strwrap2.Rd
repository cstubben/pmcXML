\name{strwrap2}
\alias{strwrap2}

\title{ test

}
\description{

}
\usage{
strwrap2(x, exdent = 5, width = 120, ...)
}

\arguments{
  \item{x}{

}
  \item{exdent}{

}
  \item{width}{

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





function (x, exdent = 5, width = 120, ...) 
{
    if (is.data.frame(x)) 
        x <- apply(x, 1, paste, collapse = ". ")
    cat(paste(strwrap(x, exdent = exdent, width = width, ...), 
        collapse = "\n"), "\n")
  }
}


\keyword{ ~kwd1 }

