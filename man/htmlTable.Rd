\name{htmlTable}
\alias{htmlTable}

\title{ List HTML tables

}
\description{List linked tables in HTML documents from PMC articles not in Open Access 

}
\usage{
htmlTable(doc)
}

\arguments{
  \item{doc}{ HTML file from PMC }
}
%\details{  }
\value{ A data.frame listing table links and captions }
%\references{ }
\author{ Chris Stubben }
%\note{ }

\seealso{ \code{\link{getTable}} }
\examples{
\dontrun{
doc2<-pmc("PMC2687345")
htmlTable(doc2)
}
}

\keyword{ methods }

