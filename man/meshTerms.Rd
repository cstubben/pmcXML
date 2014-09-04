\name{meshTerms}
\alias{meshTerms}

\title{ List MeSH terms in Pubmed }
\description{ List MeSH terms assigned to articles in Pubmed }
\usage{
meshTerms(term)
}

\arguments{
  \item{term}{ a search term or vector of pubmed IDs }
\details{ Parses MeSH headings in XML document returned by E-fetch

}
\value{ A data.frame listing pubmed ID and MeSH term }
%\references{ }
\author{ Chris Stubben }
%\note{ }

%\seealso{ }
\examples{
\dontrun{
meshTerms(17963531)
}
}
\keyword{ methods }

