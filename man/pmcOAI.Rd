\name{pmcOAI}
\alias{pmcOAI}

\title{ Download Open Access articles from PMC  }
\description{  Download and save XML documents from the PMC OAI service

}
\usage{
pmcOAI(id, local = TRUE, dir = "~/downloads/pmc", ...)
}

\arguments{
  \item{id}{ PMC id }
  \item{local}{ use local copy if available }
  \item{dir}{  name of local directory to save file }
  \item{\dots}{ other options passed to \code{readLines} }
}

\details{ XML documents in the Open Access (OA) subset are downloaded from the OAI service.  The namespace is removed for easier XPath queries and carets (^) are added to superscript tags and hyperlinked footnotes for displaying text.  The document is parsed using \code{xmlParse} in the \code{XML} package to generate the XML tree within the R session, so objects are stored as an XMLInternalDocument class and can be queried using XPath expressions.  Finally, a local copy is saved using \code{saveXML} for reloading
}

\value{ An XML internal document }
\references{ \url{http://www.ncbi.nlm.nih.gov/pmc/tools/openftlist} }
\author{ Chris Stubben }
%\note{ }

\seealso{\code{\link{pmcOAI}} }
\examples{
\dontrun{
doc <- pmcOAI("PMC2231364")
}

}

\keyword{ methods }

