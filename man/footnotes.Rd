\name{footnotes}
\alias{footnotes}

\title{ Parse table footnotes }
\description{ Parse footnotes from  PMC table output }
\usage{
footnotes(x, ...)
}

\arguments{
  \item{x}{  PMC table output from \code{\link{pmcTable}} }
  \item{\dots}{ Other options passed to \code{\link{strwrap2}} }
}
\details{
  Shortcut for  attr(x, "footnotes")
}
\value{  None.  strwrap2 uses \code{\link{cat}} to output footnotes. }
%\references{ }
\author{ Chris Stubben }
\note{ Fix to read XML doc like caption }

\seealso{ \code{\link{caption} }
\examples{

data(doc)
tab<- pmcTable(doc)
footnotes(tab[[1]])

\keyword{ methods }

