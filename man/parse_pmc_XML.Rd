\name{parse_pmc_XML}
\alias{parse_pmc_XML}

\title{ test

}
\description{

}
\usage{
parse_pmc_XML(xml, authorsN = 3, journalFull = TRUE)
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
        pmc <- xtags(z2, "//ArticleId", "IdType", "Value", "pmcid")
        a3 <- xpathSApply(z2, "//Author/Name", xmlValue)
        if (length(a3) > authorsN) {
            authors <- paste(c(a3[1:authorsN], "et al"), collapse = ", ")
        }
        else {
            authors <- paste(a3, collapse = ", ")
        }
        year <- as.numeric(substr(xvalue(z2, "//SortDate"), 1, 
            4))
        title <- xvalue(z2, "//Title")
        title <- gsub(" *$", "", title)
        title <- gsub("\\.$", "", title)
        if (journalFull) {
            journal <- xvalue(z2, "//FullJournalName")
        }
        else {
            journal <- xvalue(z2, "//Source")
        }
        volume <- xvalue(z2, "//Volume")
        pages <- xvalue(z2, "//Pages")
        epubdate <- xvalue(z2, "//EPubDate")
        if (epubdate == "") 
            epubdate <- xvalue(z2, "//PubDate")
        pmid <- xtags(z2, "//ArticleId", "IdType", "Value", "pmid")
        pubs[[i]] <- data.frame(pmc, authors, year, title, journal, 
            volume, pages, epubdate, pmid, stringsAsFactors = FALSE)
        free(z2)
    }
    do.call("rbind", pubs)
  }
}


\keyword{ ~kwd1 }

