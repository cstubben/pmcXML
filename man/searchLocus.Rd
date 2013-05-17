\name{searchLocus}
\alias{searchLocus}

\title{ test

}
\description{

}
\usage{
searchLocus(doc)
}

\arguments{
  \item{doc}{

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





function (doc) 
{
    tags <- c("BPS[SL]", "BMA", "BTH_I", "BURP")
    n <- length(tags)
    x <- vector("list", n)
    names(x) <- c("BPS", "BMA", "BTH", "BURP")
    for (i in 1:n) {
        y <- searchXMLall(doc, tags[i])
        x[[i]] <- ifelse(is.null(y), 0, length(y))
    }
    as.data.frame(x)
  }
}


\keyword{ ~kwd1 }

