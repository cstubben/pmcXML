\name{collapse}
\alias{collapse}

\title{ Collapse a data.frame }
\description{  Collapse a data.frame into a delimited list with column names and cell values
}
\usage{
collapse(x, caption = FALSE, footnotes = FALSE, na.string)
}

\arguments{
  \item{x}{ a data.frame }
  \item{caption}{ include caption in collapsed row }
  \item{footnotes}{ include footnotes in collapsed row }
  \item{na.string}{  additional cell values to skip, default is NA and "" }
}
\details{  Used by \code{\link{searchP}}  }
\value{  A vector with collapsed table rows  }
% \references{ }
\author{ Chris Stubben }
% \note{ }

% \seealso{ }
\examples{

doc <- pmcOAI("PMC2231364" )
t1 <- pmcTable(doc, 1)
t1 <- repeatSub(t1)
head(t1)
collapse2(head(t1) )
# or to skip references with "-"
collapse2(head(t1), na.string="-")

}
\keyword{ methods }

