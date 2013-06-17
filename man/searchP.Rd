\name{searchP}
\alias{searchP}
\title{ Search PMC text and tables }
\description{ Search PMC text and tables for a specific pattern }
\usage{
searchP(x, pattern, caption = TRUE, before = FALSE, after = FALSE, ignore.case = TRUE, ...)
}
\arguments{
  \item{x}{ output from pmcText or pmcTable or pmcSupp }
  \item{pattern}{ character string containing a regular expression }
  \item{caption}{ include caption in collapsed table rows }
  \item{before}{ include sentence before match }
  \item{after}{ include sentence after match } 
  \item{ignore.case}{ ignore case }
  \item{\dots}{ other options passed to \code{grep} }
}
\details{ Searches text and collpased tables using \code{\link{grep}} and returns a data.frame with section title and sentence (or table name and row).
}
\value{ A data.frame }
% \references{ }
\author{ Chris Stubben}
% \note{ }
\seealso{ \code{\link{pmcText}} }

\examples{
doc <- pmcOAI("PMC2231364" )
txt <- pmcText(doc)
searchP(txt, "virulen")
searchP(txt, "pathway")
searchP(txt, "accession")
# regular expression
searchP(txt, "[ACTGN]{6}")   # seqeunce
searchP(txt, "YPO[0-9]{4}")  # locus tag
searchP(txt, "[A-Z][a-z]{2}[A-Z]", ignore.case=FALSE)  # protein name
}
\keyword{ methods }
