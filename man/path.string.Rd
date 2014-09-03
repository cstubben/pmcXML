\name{path.string}
\alias{path.string}
\title{ Print path string  }
\description{  Print a hierarchical path string from an ordered list of names and levels }
\usage{
path.string(x, n)
}
\arguments{
  \item{x}{ ordered list of names }
  \item{n}{ indentation level  }
}
%%\details{ }
\value{ a character vector }
%% \references{ }
\author{ Chris Stubben }
%%\note{ }
%%\seealso{ }
\examples{

x <- c("carnivores", "bears", "polar", "grizzly", "cats", "tiger", "rodents")
n <- c(1,2,3,3,2,3,1)
path.string(x, n)

## OR section titles

id <- "PMC2612704"
doc <- pmcOAI(id)
 x <- xpathSApply(doc, "//body//sec/title", xmlValue)
 n <- xpathSApply(doc, "//body//sec/title", function(y) length(xmlAncestors(y) ))
path.string(y,n)


}
\keyword{ methods }
