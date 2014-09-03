\name{splitP}
\alias{splitP}
\title{  Split paragraphs into sentences
}
\description{  Split paragraphs into complete sentences
}
\usage{
splitP(z)
}
\arguments{
  \item{z}{  A character vector }
}
\details{ Splits text within paragraph tags into complete sentences by taking care to avoid splitting after genus abbreviations like E. coli or other common abbreviations such as Fig., et al., e.g., i.e., sp., ca., vs., and many others.  Another similar option is sentDetect in openNLP
}
\value{  A vector of sentences
}
% \references{ }
\author{ Chris Stubben}
% \note{ }
\seealso{ \code{\link{pmcText}} }
\examples{
  splitP("See Fig. 1. Or acc no. 1234. E. coli and Y. pestis.")
}
\keyword{ methods }

