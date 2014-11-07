\name{pmcText}
\alias{pmcText}
\title{ Split PMC xml into subsections }
\description{  Split PMC xml into a list of subsections, where each subsection is a vector of paragraphs or sentences. }
\usage{
pmcText(doc, sentence = TRUE)
}
\arguments{
  \item{doc}{ a PMC XMLInternalDocument  }
  \item{sentence}{ split paragraphs into sentences}
}
\details{ Subsections may be nested to arbitrary depths and this function will return the entire path to the subsection title as the list name, eg. "Results; Predicted functional roles of GIs;  Pathogenicity"

}
\value{ a list of character vectors }
%\references{ }
\author{ Chris Stubben }
%\note{ }
%\seealso{  }
\examples{
\dontrun{
  id <- "PMC2612704"
  doc <- pmcOAI(id)
  txt <-pmcText(doc)
}
}
\keyword{ methods }
