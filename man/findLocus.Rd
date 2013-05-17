\name{findLocus}
\alias{findLocus}

\title{ test

}
\description{

}
\usage{
findLocus(doc, tags, prefix, suffix, expand = TRUE, digits = 4, ...)
}

\arguments{
  \item{doc}{

}
  \item{tags}{

}
  \item{prefix}{

}
  \item{suffix}{

}
  \item{expand}{

}
  \item{digits}{

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





function (doc, tags, prefix, suffix, expand = TRUE, digits = 4, 
    ...) 
{
    id <- attr(doc, "id")
    tag <- paste(prefix, "[0-9]+", sep = "")
    if (is.numeric(digits)) 
        tag <- paste(prefix, "[0-9]{", digits, "}[^0-9_]", sep = "")
    y <- searchXML(doc, tag, ...)
    if (!is.null(y)) {
        print(paste("Matched", nrow(y), "sentences"))
        y <- parseTags(y, tags, prefix, suffix, expand, digits)
        y <- data.frame(id, y, stringsAsFactors = FALSE)
    }
    y
  }
}


\keyword{ ~kwd1 }

