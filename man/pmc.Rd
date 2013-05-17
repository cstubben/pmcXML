\name{pmc}
\alias{pmc}

\title{ test

}
\description{

}
\usage{
pmc(id, local = TRUE, ...)
}

\arguments{
  \item{id}{

}
  \item{local}{

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





function (id, local = TRUE, ...) 
{
    if (!grepl("^PMC", id)) 
        id <- paste("PMC", id, sep = "")
    file <- paste("http://www.ncbi.nlm.nih.gov/pmc/articles/", 
        id, sep = "")
    localfile <- paste("~/downloads/pmc/", id, sep = "")
    xmlfile <- paste(localfile, ".xml", sep = "")
    htmlfile <- paste(localfile, ".html", sep = "")
    if (local && file.exists(xmlfile)) {
        print("Loading local XML copy")
        doc <- xmlParse(xmlfile)
    }
    else if (local && file.exists(htmlfile)) {
        print("Loading local HTML copy")
        doc <- htmlParse(htmlfile)
    }
    else {
        url <- "http://www.pubmedcentral.nih.gov/oai/oai.cgi?verb=GetRecord&metadataPrefix=pmc&identifier=oai:pubmedcentral.nih.gov:"
        id2 <- gsub("PMC", "", id)
        x <- suppressWarnings(readLines(paste(url, id2, sep = ""), 
            ...))
        if (grepl("<error", x[1])) {
            x <- try(readLines(file), silent = TRUE)
            if (class(x)[1] == "try-error") {
                stop("No results found")
            }
            else {
                print("No XML results in Open Access Subset.  Downloading HTML from PMC (please check copyright restrictions)")
                x <- gsub("<sup>", "<sup>^", x)
                x <- gsub("<sub>", "<sub>_", x)
                x <- gsub("<U+00E2><U+0080><U+00B2>", "'", x)
                x <- gsub("\342\200\223", "-", x)
                x <- gsub("&#x02013;", "-", x)
                x <- gsub("<U+00A0>", " ", x)
                doc <- htmlParse(x)
                saveXML(doc, file = htmlfile)
            }
        }
        else {
            if (length(x) == 0) {
                print("WARNING: Cannot connect to PMC OAI service - trying Efetch")
                x <- efetch(id2, db = "pmc", retmode = "xml")
            }
            else {
                x[1] <- gsub(" xmlns=[^ ]*", "", x[1])
            }
            x <- gsub("<U+00E2><U+0080><U+00B2>", "'", x)
            x <- gsub("\342\200\223", "-", x)
            x <- gsub("<U+00A0>", " ", x)
            x <- gsub("<sup>", "<sup>^", x)
            x <- gsub("<sub>", "<sub>_", x)
            n <- grep("table-fn", x)
            x[n] <- gsub(">([^<])</xref>", ">^\\1</xref>", x[n])
            doc <- xmlParse(x)
            saveXML(doc, file = xmlfile)
        }
    }
    attr(doc, "id") <- id
    attr(doc, "pmid") <- pmid(doc)
    attr(doc, "file") <- file
    doc
  }
}


\keyword{ ~kwd1 }

