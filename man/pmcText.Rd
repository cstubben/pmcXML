\name{pmcText}
\alias{pmcText}
\title{  Parse PMC XML into text }
\description{  Parse PMC XML into sentences with section labels
}
\usage{
pmcText(doc, references = FALSE)
}
\arguments{
  \item{doc}{ XML document from PMC  }
  \item{references}{ include References Cited }
}
\details{ Splits the XML document into main sections and also includes title, abstract, section titles, and captions from figure, table and supplements (references are optional). The text within paragraph tags in each section is split into complete sentences using \code{\link{splitP}} by taking care to avoid splitting after genus abbreviations like E. coli or other common abbreviations such as Fig., et al., e.g., i.e., sp., ca., vs., and others. 
}
\value{ List of vectors. The sections are assigned as list names }
% \references{ }
\author{ Chris Stubben}
\note{ The output can be converted to a corpus using the text-mining package, package(tm); Corpus(VectorSource(txt)) }
%\seealso{ }
\examples{
doc <- pmc("PMC2231364" )
txt <- pmcText(doc)
sapply(txt, length)
txt[1:2]

}
\keyword{ methods }

