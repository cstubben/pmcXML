\name{ncbiPMC}
\alias{ncbiPMC}

\title{ Search NCBI PMC database  }
\description{ Searches the Pubmed Central database at NCBI and returns a short
citation with author, year, title, journal and published date. }

\usage{
ncbiPMC(term, ...)
}

\arguments{
  \item{term}{ Entrez search terms or a vector of PMC IDs }
  \item{\dots}{other options passed to parse_pmc_xml, current defaults are authorsN=3 and journalFull=TRUE }
}
\details{Searches the PubMed database and parses the XML returned by E-summary 
}
\value{
A data.frame
}
\references{ \url{http://www.ncbi.nlm.nih.gov/pmc } }
\author{ Chris Stubben }
% \note{ }
%\seealso{ }
\examples{

ncbiPMC("PMC2231364")
\dontrun{
yp <- ncbiPMC("(YPO0* OR YPO1* OR YPO2* OR YPO3* OR YPO4*) AND (Yersinia[TITLE] OR Yersinia[ABSTRACT]) AND open access[FILTER]")
head(yp)
}

}
\keyword{ methods }

