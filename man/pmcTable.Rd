\name{pmcTable}
\alias{pmcTable}

\title{ Format PMC tables as data.frames }
\description{  Formats PMC XML tables into a list of data.frames

}
\usage{
pmcTable(doc, whichTable, verbose = TRUE, simplify=TRUE, ...)
}

\arguments{
  \item{doc}{ XML document from PMC }
  \item{whichTable}{  Table number to parse, default all tables }
  \item{verbose}{ Print captions to screen before parsing }
  \item{\dots}{ Other options passed to \code{\link{fixTypes}} 
}
}
\details{ Saves the caption and footnotes as attributes and uses rowspan and colspan attributes to format multi-line headers.  Repeats cell values down columns if rowspan > 1 since single rows should stand-alone as a citation.

}
\value{ A list of data.frames, or if simplify = TRUE and only 1 table, then a data.frame.}
% \references{ }
\author{ Chris Stubben}
% \note{ }
\seealso{ \code{\link{repeatSub}} to repeat subheadings }
\examples{

doc <- pmc("PMC2231364" )
tab <- pmcTable(doc)
sapply(tab, nrow
tab

}
\keyword{ methods }

