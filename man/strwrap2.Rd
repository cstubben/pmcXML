\name{strwrap2}
\alias{strwrap2}

\title{ Wrap character strings }
\description{ Wrap and print character strings  }
\usage{
strwrap2(x, exdent = 5, ...)
}

\arguments{
  \item{x}{ a character vector }
  \item{exdent}{indentation of subsequent lines in paragraphs}
  \item{\dots}{  other options passed to \code{\link{strwrap}} }
}
% \details{   }
\value{  None.  strwrap2 uses \code{\link{cat}} to print results. }
% \references{ }
\author{ Chris Stubben}
% \note{ }
% \seealso{ }
\examples{
doc <- pmcOAI("PMC2231364" )
strwrap2(xpathSApply(doc, "//abstract//p", xmlValue))
}
\keyword{ methods }

