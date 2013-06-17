\name{meshTerms}
\alias{meshTerms}

\title{ List MeSH terms in Pubmed }
\description{ List MeSH terms assigned to articles in Pubmed }
\usage{
meshTerms(term)
}

\arguments{
  \item{term}{ a search term, pubmed IDs or document with pmid attribute (returned by \code{pmid})
}
}
\details{ Parses MeSH headings in XML document returned by E-fetch

}
\value{ A data.frame listing pubmed ID and MeSH term }
%\references{ }
\author{ Chris Stubben }
%\note{ }

%\seealso{ }
\examples{
meshTerms(17963531)

}
\keyword{ methods }

