\name{is.xml}
\alias{is.xml}
\title{ Tests if XML document}

\description{ Tests if object is an XML document }
\usage{
is.xml(doc)
}

\arguments{
  \item{doc}{ a document object }
}
\details{Checks is document is an XMLInternalDocument (ie, XML doument downloaded from PMC Open Access service)

}
\value{ Logical }
% \references{ }
\author{ Chris Stubben }
% \note{ }

%\seealso{ }
\examples{
doc <- pmcOAI("PMC2231364" )
is.xml(doc)

}
\keyword{ methods }

