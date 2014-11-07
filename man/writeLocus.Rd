\name{writeLocus}
\alias{writeLocus}

\title{ Write mentions to file }
\description{  Write locus tag and other mentions to file

}
\usage{
writeLocus(x, file = "locus.tab", append = TRUE)
}

\arguments{
  \item{x}{ data frame   }
  \item{file}{ file name}
  \item{append}{ append to existing file }
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

