\name{htmlText}
\alias{htmlText}
\title{Parse HTML into text
}
\description{ Parse HTML into sentences with section labels
}
\usage{
htmlText(doc, h = 2, references = FALSE)
}
\arguments{
  \item{doc}{ a HTML file from PMC }
  \item{h}{ section tag number, default is h2 }
  \item{references}{  include References cited in output }
}
\details{ Parses HTML doc into sections with h2 tags and saves section title as list element name and then divides paragraph tags into sentences using \code{\link{splitP}}.  Also adds figure and table captions and subsection titles (h3 tags).  In many PMC articles, the Introduction is missing a title and is assigned when div class = "sec headless whole_rhythm".

}
\value{  A list of vectors }
%\references{ }
\author{ Chris Stubben }
\note{ The output can be converted to a corpus using the text-mining package, package(tm); Corpus(VectorSource(txt))
}
\seealso{  \code{\link{pmcText}} }
\examples{
\dontrun{
 id <- "PMC3257920" 
 doc2 <- pmc(id)   
 txt2 <- htmlText(doc2)
 sapply(txt2, length)
}

}
\keyword{ methods }
