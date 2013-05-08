\name{bibformat}
\alias{bibformat}

\title{

}
\description{

}
\usage{
bibformat(refs, id = FALSE, ...)
}

\arguments{
  \item{refs}{

}
  \item{id}{

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





function (refs, id = FALSE, ...) 
{
    refs[, 5] <- gsub("Proceedings of the National Academy of Sciences of the United States of America", 
        "PNAS", refs[, 5])
    x <- apply(refs, 1, function(x) paste(c(x[2], ". ", x[3], 
        ". ", x[4], ". ", x[5], " ", x[6], ":", x[7], "."), collapse = ""))
    if (id) 
        x <- paste(x, refs[, 1])
    strwrap2(x, ...)
  }
}


\keyword{ ~kwd1 }

