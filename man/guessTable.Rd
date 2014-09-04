\name{guessTable}
\alias{guessTable}

\title{ Guess table formats }
\description{ Guess format of data.frames by identifying captions and footnotes  }
\usage{
guessTable(x, header = 1, ...)
}

\arguments{
  \item{x}{ a data.frame, often loaded by \code{read.xls}  }
  \item{header}{ header row(s), after removing caption}
  \item{\dots}{ other options passed to \code{\link{fixTypes}}   }
}
\details{  Counts the number of non-empty cells in a data.frame and finds consecutive runs of 1 at the start and end, which are assigned to caption and footnote attributes.  The remaining rows are reformated into a new data.frame 

}
\value{ a data.frame }
%\references{ }
\author{ Chris Stubben }
%\note{ }

\seealso{ \code{\link{read.xls2}} }
\examples{

x <- data.frame( rbind( c("Table 1. Loaded using read.xls", NA, NA, NA), letters[1:4], diag(4), c("* And some footnotes", NA, NA, NA )), stringsAsFactors=FALSE)
x
y <- guessTable(x)
y
str(y)

}


\keyword{ methods }

