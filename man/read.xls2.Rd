\name{read.xls2}
\alias{read.xls2}

\title{ test

}
\description{

}
\usage{
read.xls2(file, sheet = 1, skip = 0, ...)
}

\arguments{
  \item{file}{

}
  \item{sheet}{

}
  \item{skip}{

}
  \item{\dots}{

}
}
\details{

}
\value{





}
\references{

}
\author{

}
\note{

}



\seealso{

}
\examples{





function (file, sheet = 1, skip = 0, ...) 
{
    x <- read.xls(file, stringsAsFactors = FALSE, header = FALSE, 
        sheet = sheet, method = "tab", quote = "", skip = skip)
    for (i in 1:ncol(x)) x[, i] <- gsub("\"", "", x[, i])
    guessTable(x, file, ...)
  }
}


\keyword{ ~kwd1 }

