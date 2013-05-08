\name{sections}
\alias{sections}

\title{

}
\description{

}
\usage{
sections(doc, html = "//h2")
}

\arguments{
  \item{doc}{

}
  \item{html}{

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





function (doc, html = "//h2") 
{
    if (class(doc)[1] == "XMLInternalDocument") {
        xpathSApply(doc, "//article/body/sec/title", xmlValue)
    }
    else {
        xpathSApply(doc, html, xmlValue)
    }
  }
}


\keyword{ ~kwd1 }

