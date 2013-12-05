\name{pmcXML-package}
\alias{pmcXML-package}
\alias{pubmed}
\docType{package}
\title{ 
XML documents from Pubmed Central 
}
\description{
Download XML documents from the Open Access subset of Pubmed Central and search for genes and locus tags in full text, tables, and supplmentary materials. 
}
\details{
\tabular{ll}{
Package: \tab pmcXML\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2013-05-08\cr
License: \tab GPL 3.1\cr
}
An overview of how to use the package, including the most important functions ~~
}
\author{
Chris Stubben

stubben at lanl.gov
}
%\references{ }

\keyword{ package }
% \seealso{ }
\examples{
\dontrun{
doc <- pmcOAI("PMC2231364" )
txt <-pmcText(doc)
tab <- pmcTable(doc)
sup <- pmcSupp(doc)
txt[1:2]
tab[1]
sup
pmcSupp(doc, 3)
}
}
