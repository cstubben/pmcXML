\name{unwrap}
\alias{unwrap}

\title{

}
\description{

}
\usage{
unwrap(x, startRow, sep = " ")
}

\arguments{
  \item{x}{

}
  \item{startRow}{

}
  \item{sep}{

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





function (x, startRow, sep = " ") 
{
    startRow = paste("^", startRow, sep = "")
    n <- grep(startRow, x)
    for (i in length(x):n[1]) {
        if (!grepl(startRow, x[i])) {
            x[i - 1] <- paste(x[i - 1], x[i], sep = sep)
        }
    }
    if (n[1] > 1) {
        n <- c(1:(n[1] - 1), n)
    }
    x[n]
  }
}


\keyword{ ~kwd1 }

