\name{seqIds}
\alias{seqIds}

\title{ Expand tag pairs }
\description{ Expand tag pairs marking the start and end of a region }
\usage{
seqIds(id, stop, tags)
}

\arguments{
  \item{id}{  Start tag or tag pair separated by dash }
  \item{stop}{ End tag }
  \item{tags}{An ordered list of locus tags }
}
\details{  Matches tags to ordered list of locus tags and returns all tags between the start and end tags.  If ordered tags are missing, then expands tags using \code{\link{seq2}} to generate sequence of numbers between pairs.

}
\value{  A vector of locus tags }
% \references{ }
\author{ Chris Stubben}
% \note{ }
\seealso{ }
\examples{
 seqIds("YPO0010-YPO0015")
## inlcude YPO0013a and RNAs in GFF3 file
data(yplocus)
seqIds("YPO0010-YPO0015", tags=yplocus)

}
\keyword{ methods }

