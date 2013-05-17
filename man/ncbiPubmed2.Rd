\name{ncbiPubmed2}
\alias{ncbiPubmed2}

\title{ test

}
\description{

}
\usage{
ncbiPubmed2(term, ...)
}

\arguments{
  \item{term}{

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





function (term, ...) 
{
    if (length(term) > 1) {
        x <- esummary(term, version = "2.0", parse = FALSE)
    }
    else {
        x <- esummary(esearch(term), version = "2.0", parse = FALSE)
    }
    parse_pubmed_XML(x, ...)
  }
}


\keyword{ ~kwd1 }

