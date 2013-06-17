\name{sections}
\alias{sections}

\title{ Print sections }
\description{ Print sections in PMC documents

}
\usage{
sections(doc, html = "//h2")
}

\arguments{
  \item{doc}{ Document from PMC }
  \item{html}{  HTML section tag}
}
\details{ Prints main sections in PMC articles }
\value{ None. \code{\link{strwrap2}} uses \code{\link{cat}} to print sections. }

% \references{ }
\author{ Chris Stubben}
% \note{ }
\seealso{  \code{\link{pmcText}} }
\examples{
doc <- pmcOAI("PMC2231364" )
sections(doc)
}
\keyword{ methods }
