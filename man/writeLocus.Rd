\name{writeLocus}
\alias{writeLocus}

\title{ test

}
\description{

}
\usage{
writeLocus(x, file = "locus.tab")
}

\arguments{
  \item{x}{

}
  \item{file}{

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





function (x, file = "locus.tab") 
{
    n <- nrow(x)
    x <- unique(x)
    if (nrow(x) < n) {
        print(paste("Removed", n - nrow(x), "duplicates"))
    }
    write.table(x, file, row.names = FALSE, col.names = FALSE, 
        append = TRUE, quote = FALSE, sep = "\t")
  }
}


\keyword{ ~kwd1 }

