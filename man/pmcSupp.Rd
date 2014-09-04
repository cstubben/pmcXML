\name{pmcSupp}
\alias{pmcSupp}

\title{ List and read PMC supplementary files }
\description{ List supplementary file names within XML documents and optionally read supplementary tables from PMC  }
\usage{
pmcSupp(doc, file, ...)
}

\arguments{
  \item{doc}{ XML document }
  \item{ file }{  supplementary file name or row number }
  \item{\dots}{ other options passed to \code{\link{getSupp}} }
}
\details{ List supplementary files and optionally read tables using \code{\link{getSupp}}  }
\value{ If file is missing, a data.frame listing supplementary file names and captions.
}
% \references{ }
\author{ Chris Stubben }
\note{ If file is specified, then \code{\link{getSupp}} is used to download the file (currently supports Excel, Word, HTML, PDF, text, and zip files depending of operating system and installed dependencies )

}

\seealso{\code{\link{getSupp}} for complete details }

\examples{

\dontrun{
doc <- pmcOAI("PMC2231364" )
pmcSupp(doc)
s2 <- pmcSupp(doc, 3)
s2
}
}


\keyword{ methods }

