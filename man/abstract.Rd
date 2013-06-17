\name{abstract}
\alias{abstract}

\title{  Parse abstract }
\description{  Parses abstract from XML documents downloaded from PMC Open Access

}
\usage{
abstract(doc, exdent = 0, ...)
}

\arguments{
  \item{doc}{  XML document from PMC }
  \item{exdent}{  indentation of subsequent lines, default 0 } 
  \item{\dots}{  other options passed to \code{\link{strwrap2}} }
}
%\details{ }
\value{
 None.  strwrap2 uses \code{\link{cat}} to output abstract.
}
% \references{ }
\author{ Chris Stubben }
% \note{ }

\seealso{ \code{\link{pmcText}} to parse all sections

}
\examples{
doc <- pmcOAI("PMC2231364" )
abstract(doc)
}

\keyword{ methods }
