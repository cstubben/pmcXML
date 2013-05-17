\name{matchTag}
\alias{matchTag}

\title{ test

}
\description{

}
\usage{
matchTag(id, tags)
}

\arguments{
  \item{id}{

}
  \item{tags}{

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





function (id, tags) 
{
    n1 <- grep(paste("^", id, "$", sep = ""), tags, ignore.case = TRUE)
    if (length(n1) != 1) {
        if (grepl("[0-9]$", id)) {
            n1 <- grep(id, tags, ignore.case = TRUE)
        }
        else {
            n1 <- grep(substring(id, 1, nchar(id) - 1), tags, 
                ignore.case = TRUE)
        }
        if (length(n1) > 1) 
            n1 <- n1[1]
        if (length(n1) == 1) {
            print(paste("Warning: no match to ", id, ". Using ", 
                tags[n1], " instead.", sep = ""))
        }
        else {
            n1 <- NULL
        }
    }
    n1
  }
}


\keyword{ ~kwd1 }

