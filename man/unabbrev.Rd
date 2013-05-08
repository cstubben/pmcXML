\name{unabbrev}
\alias{unabbrev}

\title{

}
\description{

}
\usage{
unabbrev(species)
}

\arguments{
  \item{species}{

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





function (species) 
{
    x <- unique(species)
    n <- grepl("^[A-Z]\\.", x)
    x1 <- x[n]
    if (length(x1) == 0) {
        species
    }
    else {
        x2 <- x[!n]
        x3 <- unique(genus(x2))
        for (i in 1:length(x1)) {
            n <- match(x1[i], abbrev(x2))
            if (is.na(n)) {
                n <- match(substr(x1[i], 1, 1), substr(x3, 1, 
                  1))
                if (is.na(n)) {
                  print(paste("Unknown genus for", x1[i]))
                }
                else {
                  if (sum(substr(x3, 1, 1) \%in\% substr(x1[i], 
                    1, 1)) > 1) {
                    print("WARNING: matches two or more genera - using first genus in list")
                  }
                  newsp <- paste(x3[n], substring(x1[i], 4))
                  print(paste("Changing", x1[i], "to", newsp))
                  species <- gsub(x1[i], newsp, species)
                }
            }
            else {
                print(paste("Changing", x1[i], "to cited", x2[n]))
                species <- gsub(x1[i], x2[n], species)
            }
        }
        species
    }
  }
}


\keyword{ ~kwd1 }

