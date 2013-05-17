\name{pmcLoop}
\alias{pmcLoop}

\title{ test

}
\description{

}
\usage{
pmcLoop(pmcresults, tags, prefix, suffix, file = "locus.tab", expand = TRUE, digits = 4)
}

\arguments{
  \item{pmcresults}{

}
  \item{tags}{

}
  \item{prefix}{

}
  \item{suffix}{

}
  \item{file}{

}
  \item{expand}{

}
  \item{digits}{

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





function (pmcresults, tags, prefix, suffix, file = "locus.tab", 
    expand = TRUE, digits = 4) 
{
    for (j in 1:nrow(pmcresults)) {
        id <- pmcresults$pmc[j]
        print(paste(j, ". Checking ", pmcresults$title[j], sep = ""))
        doc <- pmc(id)
        y <- findLocus(doc, tags, prefix, suffix, expand, digits)
        if (is.null(y)) {
            print("WARNING: no locus tags in full text")
        }
        else {
            writeLocus(y, file)
        }
        x <- pmcTable(doc, verbose = FALSE)
        if (is.list(x)) {
            for (i in 1:length(x)) {
                xtag <- paste(prefix, "[0-9]+", sep = "")
                if (is.numeric(digits)) 
                  xtag <- paste(prefix, "[0-9]{", digits, "}[^0-9_]", 
                    sep = "")
                hasTags <- searchTable(x[[i]], xtag)
                if (hasTags) {
                  print(paste(" Found tags in", paste(names(x[i]), 
                    attr(x[[i]], "caption"), sep = ". ")))
                  if (ncol(x[[i]]) > 1) {
                    hasSubs <- apply(x[[i]][1, -1, FALSE], 1, 
                      function(z) all(is.na(z) | z == "NA" | 
                        z == "" | z == "<U+00A0>"))
                    if (hasSubs) {
                      print(" REPEATING subheadings")
                      x[[i]] <- repeatSub(x[[i]])
                    }
                  }
                  y <- citeTable(x[[i]], tags, prefix, suffix, 
                    expand, digits)
                  writeLocus(y, file)
                }
            }
        }
        print("")
    }
  }
}


\keyword{ ~kwd1 }

