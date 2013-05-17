\name{htmlParse2}
\alias{htmlParse2}

\title{ test

}
\description{

}
\usage{
htmlParse2(url, ...)
}

\arguments{
  \item{url}{

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





function (url, ...) 
{
    x <- suppressWarnings(try(readLines(url, ...), silent = TRUE))
    if (class(x) == "try-error") {
        stop("No url found")
    }
    x <- gsub("<sup>", "<sup>^", x)
    x <- htmlParse(x)
    x
  }
}


\keyword{ ~kwd1 }

