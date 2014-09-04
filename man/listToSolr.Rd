\name{listToSolr}
\alias{listToSolr}
\title{ Convert list to Solr XML
}
\description{  Convert PMC lists to Solr XML for import
}
\usage{
listToSolr(x, file)
}
\arguments{
  \item{x}{  list }
  \item{file}{  file name, default is attr(x, "id") + .xml }
}
\details{ Converts a list to a Solr XML file with <doc><add><field> tags for importing  }
\value{  Writes to a xml file }
%\references{ }
\author{ Chris Stubben}
\note{ }


\seealso{
}
\examples{ }
\keyword{ methods }
