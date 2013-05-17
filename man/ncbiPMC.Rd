\name{ncbiPMC}
\alias{ncbiPMC}

\title{ test

}
\description{

}
\usage{
ncbiPMC(term, ...)
}

\arguments{
  \item{term}{

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





function (term, ...) 
{
    if (length(term) > 1) {
        term <- paste(term, collapse = ",")
    }
    term <- gsub("PMC", "", term)
    if (grepl("^[0-9,]*$", term)) {
        x <- esummary(term, "pmc", version = "2.0", parse = FALSE)
    }
    else {
        x <- esummary(esearch(term, "pmc"), version = "2.0", 
            parse = FALSE)
    }
    parse_pmc_XML(x, ...)
  }
}


\keyword{ ~kwd1 }

