\name{findSpecies}
\alias{findSpecies}

\title{

}
\description{

}
\usage{
findSpecies(doc, htmlSection = "h2")
}

\arguments{
  \item{doc}{

}
  \item{htmlSection}{

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





function (doc, htmlSection = "h2") 
{
    xml <- FALSE
    if (class(doc)[1] == "XMLInternalDocument") 
        xml <- TRUE
    if (xml) {
        x <- xpathSApply(doc, "//article/*[self::front or self::body]//italic", 
            xmlValue)
    }
    else {
        x <- xpathSApply(doc, "//p//em", xmlValue)
    }
    x <- gsub(" *$", "", x)
    spx <- x[grep("^[^ ]* [^ ]*$", x)]
    spx <- gsub(",$", "", spx)
    spx <- spx[!grepl("^[a-z]", spx)]
    not_species <- c("SI Text", "P value", "In silico", "Boolean function")
    spx <- spx[!spx \%in\% not_species]
    print(paste("Found", length(spx), "species citations"))
    spx <- gsub("E. coli", "Escherichia coli", spx)
    spx <- unabbrev(spx)
    spx
  }
}


\keyword{ ~kwd1 }

