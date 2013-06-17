\name{ncbiPubmed2}
\alias{ncbiPubmed2}

\title{ Search NCBI PubMed database }
\description{Searches the PubMed database at NCBI and returns a short
citation with author, year, title, journal and published date.  }
\usage{
ncbiPubmed2(term, ...)
}

\arguments{
  \item{term}{Entrez search terms or a vector of pubmed IDs }
  \item{\dots}{Other options passed to parse_pubmed_xml, current defaults are authorsN=3 and journalFull=TRUE}
}
\details{ Searches the PubMed database and parses the XML returned by E-summary.  The \code{ncbiPubmed} function in the \code{genomes} package uses E-fetch to return a citation and abstract.
}
\value{ A data.frame }
\references{ \url{http://www.ncbi.nlm.nih.gov/pubmed } }
\author{ Chris Stubben }
% \note{ }
%\seealso{ }
\examples{
\dontrun{
yp2 <- ncbiPubmed("(YPO0* OR YPO1* OR YPO2* OR YPO3* OR YPO4*) AND Yersinia NOT pubmed pmc[FILTER]")
yp2
}
}
\keyword{ methods }

