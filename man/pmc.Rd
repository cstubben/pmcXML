\name{pmc}
\alias{pmc}

\title{ Download articles from PMC }
\description{  Download and save XML and HTML articles from PMC
}
\usage{
pmc(id, local = TRUE, dir = "~/downloads/pmc", ...)
}

\arguments{
  \item{id}{ PMC id }
  \item{local}{ Use local copy if available }
  \item{dir}{  Name of local directory to save file, default ~/downloads/pmc }
  \item{\dots}{ Other options passed to readLines }
}
\details{ PMC Open Access (OA) articles in XML format are downloaded from the OAI service using \code{\link{pmcOAI}}.  If a PMC id is not in the OA subset, this function will download an HTML copy directly from PMC.  The articles outside the OA subset are subject to numerous restrictions including no automated and bulk downloads, so please use the \code{link{pmcOAI}} function in loops and other code and also restrict PMC search results using the "Open Access[FITLER]".  In 2012, over two-thirds of PMC articles were in the OA subset. 

}
\value{ An XML or HTML internal document }
\references{ \url{http://www.ncbi.nlm.nih.gov/pmc/tools/openftlist} }
\author{ Chris Stubben }
\note{ A local directory should be created before downloading files }

\seealso{\code{\link{pmcOAI}} }
\examples{

doc <-pmc( "PMC2687345")
is.xml(doc)

}


\keyword{ methods }

