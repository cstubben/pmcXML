\name{seqIds}
\alias{seqIds}

\title{

}
\description{

}
\usage{
seqIds(id, stop, tags)
}

\arguments{
  \item{id}{

}
  \item{stop}{

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





function (id, stop, tags) 
{
    if (missing(stop)) {
        id <- gsub(" to ", "-", id)
        id <- gsub("-$", "", id)
        id <- gsub("-[A-Za-z]$", "", id)
        if (grepl("-", id)) {
            z <- strsplit(id, "-")[[1]]
            id <- z[1]
            stop <- z[length(z)]
            if (nchar(stop) + 1 < nchar(id)) {
                nid <- nchar(id)
                if (!grepl("[0-9]$", id)) 
                  nid <- nid - 1
                stop <- paste(substr(id, 1, nid - nchar(stop)), 
                  stop, sep = "")
            }
        }
    }
    if (missing(stop)) {
        id
    }
    else if (missing(tags)) {
        seq2(id, stop)
    }
    else {
        n1 <- matchTag(id, tags)
        n2 <- matchTag(stop, tags)
        if (length(n1) != 1) {
            print(paste("Warning: Using integer sequence, no match to", 
                id))
            seq2(id, stop)
        }
        else if (length(n2) != 1) {
            print(paste("Warning: Using integer sequence, no match to", 
                stop))
            seq2(id, stop)
        }
        else {
            tags[n1:n2]
        }
    }
  }
}


\keyword{ ~kwd1 }

