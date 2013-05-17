\name{toFasta}
\alias{toFasta}

\title{ test

}
\description{

}
\usage{
toFasta(grseq, width = 70, ...)
}

\arguments{
  \item{grseq}{

}
  \item{width}{

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





function (grseq, width = 70, ...) 
{
    grseq[, 2] <- gsub(paste("(.{", width, "})", sep = ""), "\\1\n", 
        grseq[, 2])
    cat(t(as.data.frame(grseq)), sep = "\n", ...)
  }
}


\keyword{ ~kwd1 }

