\name{getTable}
\alias{getTable}

\title{ Get linked HTML tables }
\description{  Get linked HTML tables for PMC articles not in Open Access  }
\usage{
getTable(doc, whichTable, ...)
}

\arguments{
  \item{doc}{  HTML file from PMC  }
  \item{whichTable}{ table number to download, default is all tables }
  \item{\dots}{ other options passed to \code{\link{fixTypes}} }
}
\details{  PMC articles outside Open Access only include links to tables.  This reads the table links using \code{htmlTable} and downloads tables

}
\value{ A list of data frames or a data.frame if 1 table returned }
% \references{ }
\author{ Chris Stubben }
\note{ Should be combined with \code{\link{htmlTable}}  }

\seealso{\code{\link{htmlTable}}  }
\examples{

# Yersinia pestis Virulence factors
\dontrun{
 doc2<- pmc( "PMC2687345")
 t1 <- getTable(doc2, 1)
 t1 <- repeatSub(t1)  
 # split into 2 columns
 names(t1)[1:2] <- c("Function", "Protein name")
 head(t1)
 table2(t1$Function)
}

}

\keyword{ methods }

