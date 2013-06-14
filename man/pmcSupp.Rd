\name{pmcSupp}
\alias{pmcSupp}

\title{ List and read PMC supplementary files }
\description{ List supplementary file names within XML documents and optionally read supplementary tables from PMC  }
\usage{
pmcSupp(doc, file)
}

\arguments{
  \item{doc}{ XML document }
  \item{ file }{  Supplementary file name or row number }
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

data(doc)
pmcSupp(doc)

\dontrun{
# DOWNLOAD tables
# x2 <- pmcSupp(doc, "1471-2180-7-96-S2.xls"  # OR
x2 <- pmcSupp(doc, 2)
## most supplementary tables require some updates 
names(x2) <- gsub("\xb0", "", names(x2) )  # degree symbol
dim(x2)
head(x2)

# pdfs return a vector, use pdf2df to convert (and repeat subheader)
x3 <- pmcSupp(doc, 3)
x3
x3 <- gsub("For ", "", x3) # to keep subheader in 1st column only
x <- pdf2df(x3, "w w", labels=c(1,3) )
x <-repeatSub(x, "For")
x
}
}


\keyword{ methods }

