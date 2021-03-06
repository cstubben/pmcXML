\name{splitP}
\alias{splitP}
\title{  Split paragraphs into sentences
}
\description{  Split paragraphs into complete sentences
}
\usage{
splitP(z,  split= "[.?]")
}
\arguments{
  \item{z}{  A character vector }
  \item{ split}{  regular expression used by strsplit for splitting, default period and questions marks }
}
\details{ Splits text within paragraph tags into complete sentences by taking care to avoid splitting after genus abbreviations like E. coli or other common abbreviations such as Fig., et al., e.g., i.e., sp., ca., vs., and many others.  
}
\value{  A vector of sentences
}
% \references{ }
\author{ Chris Stubben}
% \note{ }
\seealso{ \code{\link{pmcText}} }
\examples{
  splitP("See Fig. 1. Or acc no. 1234? E. coli and Y. pestis.")
}
\keyword{ methods }

