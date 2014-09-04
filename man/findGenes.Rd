\name{findGenes}
\alias{findGenes}

\title{ Find gene names }
\description{  Find gene names in PMC text or tables using pattern matching }
\usage{
findGenes(txt)
}

\arguments{
  \item{ txt }{ A PMC txt or table object   }
}
\details{ Find genes names in  \code{\link{pmcText}} or \code{\link{pmcTable}} output.  PMC text should be split into sentences   }

\value{
A data.frame with id, source, gene and mention

}
% \references{ }
\author{ Chris Stubben  }

\note{ Matches words with second and third letter lower case and fourth letter upper case. This does not find three letter gene names  }

%\seealso{ }
\examples{

\dontrun{
doc <- pmcOAI("PMC2231364" )
txt <-pmcText(doc)
y <-findGenes(txt)
table(y$gene)

## italics (inlcuding tables)
x <- gdata::trim( xpathSApply(doc, "//body//italic", xmlValue) )
## most of these are not genes...
table( x[nchar(x)==3] )
}

}


\keyword{ methods }

