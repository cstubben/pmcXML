\name{repeatSub}
\alias{repeatSub}

\title{ Repeat table subheadings }
\description{ Repeat table subheadings down a new column }
\usage{
repeatSub(x, column = "subheading", first = TRUE, ...)
}

\arguments{
  \item{x}{  a data.frame with subheadings }
  \item{column}{  column name }
  \item{first}{  add subheader as first column }
  \item{\dots}{other options passed to \code{\link{fixTypes}}  }
}
\details{  Identifies subheadings in a data frame by checking for rows with a non-empty first column and all other columns empty. Removes subheader rows and repeats values down a new column.

}
\value{ A data frame }

% \references{ }
\author{ Chris Stubben}
% \note{ }
% \seealso{ }
\examples{

\dontrun{
doc <- pmcOAI("PMC2231364" )
t1<-pmcTable(doc, 1)
head(t1, 10)
t1<-repeatSub(t1)
head(t1,10)
table2(t1$sub)
}

}
\keyword{ methods }
