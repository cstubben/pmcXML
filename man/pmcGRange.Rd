\name{pmcGRange}
\alias{pmcGRange}

\title{ Convert PMC table to GRange }
\description{Convert PMC table with start, end and strand columns to GRange
}
\usage{
pmcGRange(x, acc)
}

\arguments{
  \item{x}{  data.frame from \code{link{pmcTable}} with start, end and strand columns } 
  \item{acc}{ accession number to assign to \code{seqnames} }
}
\details{ Converts feature table to Genomic Range object
}
\value{  A GRange object }
% \references{ }
\author{ Chris Stubben}
% \note{ }
\seealso{ \code{link{pmcTable}}}
\examples{
x <- c("Table 1", "locus start end strand def", "YPO0001 271 711 - flavodoxin", "YPO0002 804 1265 - DNA-binding", "transcriptional regulator AsnC", "YPO0003 1435 2427 + asparagine", "synthetase AsnA")
pmcGRange(pdf2df(unwrap(x, "YPO"), "w d d w a"), "NC_003143")
}
\keyword{ methods }

