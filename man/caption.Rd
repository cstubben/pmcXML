\name{caption}
\alias{caption}

\title{ Parse table caption }
\description{ Parse table captions from XML document or PMC table output }
\usage{
caption(x, ...)
}

\arguments{
  \item{x}{  XML document or PMC table output }
  \item{\dots}{ Other options passed to \code{\link{strwrap2}} }
}
\details{ Prints the table captions in XML documents or the caption attribute from data.frames returned by \code{\link{pmcTable}} 

}
\value{ None.  strwrap2 uses \code{\link{cat}} to output captions. }
% \references{ }
\author{ Chris Stubben }
% \note{ }
% \seealso{ }
\examples{
data(doc)
caption(doc)

\keyword{ methods }

