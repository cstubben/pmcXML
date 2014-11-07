\name{unabbrev}
\alias{unabbrev}

\title{ Unabbreviate genus names }
\description{ Match and unabbreviate genus names  }
\usage{
unabbrev(species)
}

\arguments{
  \item{species}{ A vector of species with genus abbreviations }
}
\details{
Typically, the genus name is abbreviated after the first use and this function matches the abbreviated genus to complete names and replaces genus abbreviations.

}
\value{
A vector of species without genus abbreviations
}
% \references{ }
\author{ Chris Stubben}
% \note{ }
\seealso{ \code{\link{findSpecies}} }
\examples{
y <- unabbrev(c( "Yersinia pestis", "Y. pestis", "Y. pseduotuberculosis", "Z. formosa" ))
y
}
\keyword{ methods }

