\name{fillNA}
\alias{fillNA}

\title{ Fill missing values  }
\description{  Fill mising values with last valid string }
\usage{
fillNA(x)
}

\arguments{
  \item{x}{  a vector}
}
\details{ Many tables include columns with values that should be repeated down the same columns and this replaces NA, empty spaces, and non-breaking spaces with the last valid string. See \code{\link{repeatSub}} to repeat subheaders down a new column. 

}
\value{ a vector }
%\references{ }
\author{ Chris Stubben  }
%\note{ }

\seealso{ \code{\link{repeatSub}} }
\examples{

x <- c("A", "B", NA, "C", NA, NA, "", "D", NA)
fillNA(x)

}
\keyword{ methods }

