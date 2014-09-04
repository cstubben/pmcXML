\name{collapse}
\alias{collapse}

\title{ Collapse a data.frame }
\description{  Collapse a data.frame into a delimited list with column names and cell values
}
\usage{
collapse(x, footnotes = TRUE, rowid=TRUE, na.string)
}

\arguments{
  \item{x}{ a data.frame }
  \item{footnotes}{ include footnotes in collapsed row }
  \item{rowid}{ include row number }
  \item{na.string}{  additional cell values to skip, default is NA and "" }
}
% \details{   }
\value{  A vector with collapsed table rows  }
% \references{ }
\author{ Chris Stubben }
 \note{ Will detect subheaders and add column using \code{\link{repeatSub}} }

% \seealso{ }
\examples{
x <- data.frame(id=1:4, genes=c("aroB", "glnP", "ndhA","pyrF"))
collapse(x)
}
\keyword{ methods }

