\name{fixTypes}
\alias{fixTypes}

\title{ test

}
\description{

}
\usage{
fixTypes(x, stringsAsFactors = FALSE, ...)
}

\arguments{
  \item{x}{

}
  \item{stringsAsFactors}{

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





function (x, stringsAsFactors = FALSE, ...) 
{
    xx <- apply(x, 1, paste, collapse = "\t")
    if (length(xx) == 1 && xx == "") {
        x
    }
    else {
        xx <- gsub("\n", "", xx)
        zz <- textConnection(xx)
        y <- read.delim(zz, header = FALSE, stringsAsFactors = stringsAsFactors, 
            ...)
        close(zz)
        names(y) <- names(x)
        y
    }
  }
}


\keyword{ ~kwd1 }

