\name{pmcMetadata}
\alias{pmcMetadata}
\title{  Get PMC metadata
}
\description{ Get a list of PMC metadata fields
}
\usage{
pmcMetadata(doc)
}
\arguments{
  \item{doc}{ XML document from PMC }
}
%\details{  }
\value{ a list  }
%\references{ }
\author{ Chris Stubben }
%\note{ }
%\seealso{ }
\examples{

\dontrun{
doc <- pmcOAI("PMC2231364" )
x<-pmcMetadata(doc)
head(x)

}

}
\keyword{ methods }
