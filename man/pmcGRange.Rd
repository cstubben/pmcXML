\name{pmcGRange}
\alias{pmcGRange}

\title{ Convert PMC table to GRange }
\description{Convert PMC table with start, end and strand columns to GRange
}
\usage{
pmcGRange(x, acc)
}

\arguments{
  \item{x}{  Data.frame from \code{link{pmcTable}} with start, end and strand columns } 
  \item{acc}{ Accession number to assign to \code{seqnames} }
}
\details{ Converts feature table to Genomic Range object
}
\value{  A GRange object }
% \references{ }
\author{ Chris Stubben}
% \note{ }
\seealso{ \code{link{pmcTable}}}
\examples{

}
\keyword{ methods }

