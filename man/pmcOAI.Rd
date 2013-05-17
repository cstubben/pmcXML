\name{pmcOAI}
\alias{pmcOAI}

\title{ test

}
\description{

}
\usage{
pmcOAI(id, local = TRUE, dir = "~/downloads/pmc", ...)
}

\arguments{
  \item{id}{

}
  \item{local}{

}
  \item{dir}{

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





function (id, local = TRUE, dir = "~/downloads/pmc", ...) 
{
    if (!grepl("^PMC[0-9]+$", id)) 
        stop("Please include a valid PMC id like PMC3443583")
    file <- paste("http://www.ncbi.nlm.nih.gov/pmc/articles/", 
        id, sep = "")
    xmlfile <- paste(dir, "/", id, ".xml", sep = "")
    if (local && file.exists(xmlfile)) {
        print("Loading local XML copy")
        doc <- xmlParse(xmlfile)
    }
    else {
        url <- "http://www.pubmedcentral.nih.gov/oai/oai.cgi?verb=GetRecord&metadataPrefix=pmc&identifier=oai:pubmedcentral.nih.gov:"
        id2 <- gsub("PMC", "", id)
        x <- suppressWarnings(readLines(paste(url, id2, sep = ""), 
            ...))
        if (grepl("<error", x[1])) {
            x <- try(readLines(file), silent = TRUE)
            if (class(x)[1] == "try-error") {
                stop("No results found using ", id)
            }
            else {
                stop("No results in Open Access Subset (publisher does not allow downloading of full text XML)")
            }
        }
        else {
            if (length(x) == 0) {
                stop("WARNING: Cannot connect to PMC OAI service")
            }
            else {
                x[1] <- gsub(" xmlns=[^ ]*", "", x[1])
            }
            x <- gsub("<U+00E2><U+0080><U+00B2>", "'", x)
            x <- gsub("\342\200\223", "-", x)
            x <- gsub("<U+00A0>", " ", x)
            x <- gsub("<sup>", "<sup>^", x)
            n <- grep("table-fn", x)
            x[n] <- gsub(">([^<])</xref>", ">^\\1</xref>", x[n])
            doc <- xmlParse(x)
            saveXML(doc, file = xmlfile)
        }
    }
    attr(doc, "id") <- id
    attr(doc, "file") <- file
    doc
  }
}


\keyword{ ~kwd1 }

