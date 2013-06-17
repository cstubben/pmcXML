\name{writeLocus}
\alias{writeLocus}

\title{ Write citations to file }
\description{  Write locus tag and other citations to file

}
\usage{
writeLocus(x, file = "locus.tab")
}

\arguments{
  \item{x}{ data frame from \code{\link{findTags}}  }
  \item{file}{ file name

}
}
\details{ Writes data frame to file using \code{write.table} }
%\value{ }
% \references{ }
\author{ Chris Stubben}
% \note{ }
%\seealso{ }
\examples{
\dontrun{
doc <- pmcOAI("PMC2231364" )
data(yplocus)
txt <- pmcText(doc)
y <- findTags(doc, yplocus, "YPO", "a")
writeLocus(y)

}

}
\keyword{ methods }

