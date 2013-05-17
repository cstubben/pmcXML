\name{parse_pubmed_XML}
\alias{parse_pubmed_XML}

\title{ test

}
\description{

}
\usage{
parse_pubmed_XML(xml, authorsN = 3, journalFull = TRUE)
}

\arguments{
  \item{xml}{

}
  \item{authorsN}{

}
  \item{journalFull}{

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





function (xml, authorsN = 3, journalFull = TRUE) 
{
    z <- getNodeSet(xml, "//DocumentSummary")
    n <- length(z)
    if (n == 0) {
        stop("No results found")
    }
    pubs <- vector("list", n)
    for (i in 1:n) {
        z2 <- xmlDoc(z[[i]])
        pmid <- as.numeric(xpathSApply(z2, "//DocumentSummary", 
            xmlGetAttr, "uid"))
        if (length(xpathSApply(z2, "//error")) > 0) {
            print(paste("No results found for pmid:", pmid))
            next
        }
        a3 <- xpathSApply(z2, "//Author/Name", xmlValue)
        if (length(a3) > authorsN) {
            authors <- paste(c(a3[1:authorsN], "et al"), collapse = ", ")
        }
        else {
            authors <- paste(a3, collapse = ", ")
        }
        title <- xvalue(z2, "//Title")
        title <- gsub("\\.$", "", title)
        if (journalFull) {
            journal <- xvalue(z2, "//FullJournalName")
        }
        else {
            journal <- xvalue(z2, "//Source")
        }
        volume <- xvalue(z2, "//Volume")
        pages <- xvalue(z2, "//Pages")
        pubdate <- xvalue(z2, "//PubDate")
        year <- as.numeric(substr(pubdate, 1, 4))
        sortdate <- xvalue(z2, "//SortPubDate")
        sortdate <- as.Date(substr(sortdate, 1, 10))
        pubs[[i]] <- data.frame(pmid, authors, year, title, journal, 
            volume, pages, pubdate, sortdate, stringsAsFactors = FALSE)
        free(z2)
    }
    x <- do.call("rbind", pubs)
    x
  }
}


\keyword{ ~kwd1 }

