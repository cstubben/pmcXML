\name{htmlParse2}
\alias{htmlParse2}

\title{ Parse an HTML file  }
\description{  Parse an HMTL file and add carets within superscript tags}
\usage{
htmlParse2(url, ...)
}

\arguments{
  \item{url}{ URL or file with HTML }
  \item{\dots}{ other options passed to \code{\link{readLines}}   }
}
\details{  Reads an HTML file and add carets (^) to superscript tags before parsing using \code{htmlParse} in the XML package

}
\value{
HTMLInternalDocument
}
\references{}
\author{ Chris Stubben}
%\note{ }

\seealso{ \code{\link{htmlParse}}  }
\examples{

x <- "<p>Some locus tags and numbers have superscript tags than should be preserved when converting to text like BPSL0075<sup>a</sup> at start coordinate 1234<sup>1</sup></p>"
xpathSApply(htmlParse(x), "//p", xmlValue)
# compare to
xpathSApply(htmlParse2(x), "//p", xmlValue)
}

\keyword{ methods }

