\name{unwrap}
\alias{unwrap}

\title{ Unwrap rows }
\description{Fix rows wrapped over two or more lines
}
\usage{
unwrap(x, subset, startRow, sep = " ", ...)
}

\arguments{
  \item{x}{  a vector of pdf text containing a structured table }
  \item{subset}{  index of rows to keep (optional).  Added to save table attributes }
  \item{startRow}{  common row identifier at start of each new row }
  \item{sep}{ separator used to join multiple lines }
  \item{...}{ other options passed to \code{\link{grep}} }
}
\details{  PDF tables may contain rows that wrap over two or more lines and this function attempts to join multiple lines into single row  before converting pdf text to data frame using \code{\link{pdf2df}} 

}
\value{ A vector }
% \references{ }
\author{ Chris Stubben}
% \note{ }
\seealso{  \code{\link{pdf2df}}}
\examples{
x <- c("Table 1", "locus start strand def", "YPO0001 271 - flavodoxin", "YPO0002 804 - DNA-binding", "transcriptional regulator AsnC", "YPO0003 1435 + asparagine", "synthetase AsnA")
unwrap(x, "YPO")
pdf2df(unwrap(x, "YPO"), "w d w a")


}
\keyword{ methods }

