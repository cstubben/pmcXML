\name{meshTerms}
\alias{meshTerms}

\title{

}
\description{

}
\usage{
meshTerms(term)
}

\arguments{
  \item{term}{

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





function (term) 
{
    if (is.vector(term)) {
        if (length(term) > 1) {
            term <- paste(term, collapse = ",")
        }
    }
    else {
        term <- pmid(doc)
    }
    if (grepl("^[0-9, ]*$", term)) {
        x <- efetch(term, "pubmed", retmode = "xml")
    }
    else {
        x <- efetch(esearch(term, "pubmed"), retmode = "xml")
    }
    doc <- xmlParse(x)
    z <- getNodeSet(doc, "//PubmedArticle")
    n <- length(z)
    if (n == 0) {
        stop("No results found")
    }
    pubs <- vector("list", n)
    for (i in 1:n) {
        z2 <- xmlDoc(z[[i]])
        pmid <- as.numeric(xvalue(z2, "//PMID"))
        mesh <- xvalues(z2, "//MeshHeading/*")
        n <- grepl("/.*/", mesh)
        if (sum(n) > 0) {
            mesh2 <- mesh[n]
            y <- strsplit(mesh2, "/")
            mesh2 <- unlist(sapply(y, function(z) paste(z[1], 
                z[-1], sep = "/")))
            mesh <- sort(c(mesh[!n], mesh2))
        }
        if (!is.na(mesh[1])) 
            pubs[[i]] <- data.frame(pmid, term = mesh, stringsAsFactors = FALSE)
        free(z2)
    }
    x <- do.call("rbind", pubs)
    x
  }
}


\keyword{ ~kwd1 }

