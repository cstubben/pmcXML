\name{citeTable}
\alias{citeTable}

\title{ test

}
\description{

}
\usage{
citeTable(x, tags, prefix, suffix, expand = TRUE, digits = 4, ...)
}

\arguments{
  \item{x}{

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





function (x, tags, prefix, suffix, expand = TRUE, digits = 4, 
    ...) 
{
    citation <- collapse2(x, ...)
    y <- data.frame(section = attr(x, "label"), citation)
    z <- parseTags(y, tags, prefix, suffix, expand, digits)
    capt <- attr(x, "caption")
    capt <- gsub("\n", "", capt)
    z$citation <- paste("Caption=", capt, ";", z$citation, sep = "")
    z <- data.frame(id = attr(x, "id"), z, stringsAsFactors = FALSE)
    z
  }
}


\keyword{ ~kwd1 }

