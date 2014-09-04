\name{pmcRef}
\alias{pmcRef}
\title{  Format PMC references 
}
\description{ Format references in PMC XML as a data.frame
}
\usage{
pmcRef(doc)
}
\arguments{
  \item{doc}{ XML document from PMC }
}
\details{  
}
\value{ a data.frame with pmid, authors, year, title, journal, volume, pages, label, id, and type
}
%\references{ }
\author{ Chris Stubben }
%\note{ }
%\seealso{ }
\examples{

\dontrun{
doc <- pmcOAI("PMC2231364" )
x<-pmcRef(doc)
head(x)

}

}
\keyword{ methods }
