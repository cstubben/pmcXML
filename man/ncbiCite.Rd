\name{ncbiCite}
\alias{ncbiCite}

\title{ List citations linked to PMC articles }
\description{  List PMC artices that cite another article or references cited at end of the article
}
\usage{
ncbiCite(id, citedby=TRUE)
}

\arguments{
  \item{id}{ a pubmed or PMC id}
  \item{citedby}{ list cited by references in PMC, default true  }

}
\details{ Uses E-link to get either "pubmed_pmc_refs" or "pubmed_pubmed_refs" links in PMC.  The first (and default) returns PMC articles citing the given ID and the second returns the references cited at the end of a PMC article. 

}
\value{ A data.frame }
% \references{ }
\author{  Chris Stubben }
% \note{ }

% \seealso{ }
\examples{
ncbiCite("PMC2231364")
}

\keyword{ methods }

