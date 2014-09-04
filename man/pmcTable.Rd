\name{pmcTable}
\alias{pmcTable}

\title{ Format PMC tables as data.frames }
\description{  Formats PMC XML tables into a list of data.frames

}
\usage{
pmcTable(doc, whichTable, simplify=TRUE, ...)
}

\arguments{
  \item{doc}{ XML document from PMC }
  \item{whichTable}{  table number to parse, default all tables }
  \item{simplify}{ simplify to data frame if 1 table }
  \item{\dots}{ other options passed to \code{\link{fixTypes}} 
}
}
\details{ Saves the caption and footnotes as attributes and uses rowspan and colspan attributes to format multi-line headers.  Repeats cell values down columns if rowspan > 1 since single rows should stand-alone as a mention.

}
\value{ A list of data.frames, or if simplify = TRUE and only 1 table, then a data.frame.}
% \references{ }
\author{ Chris Stubben}
% \note{ }
\seealso{ \code{\link{repeatSub}} to repeat subheadings }
\examples{

\dontrun{
doc <- pmcOAI("PMC2231364" )
x <- pmcTable(doc)
sapply(x, nrow)
x
}

}
\keyword{ methods }

