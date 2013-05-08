\name{findGenes}
\alias{findGenes}

\title{

}
\description{

}
\usage{
findGenes(doc, tag, length = 4, proteins = FALSE)
}

\arguments{
  \item{doc}{

}
  \item{tag}{

}
  \item{length}{

}
  \item{proteins}{

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





function (doc, tag, length = 4, proteins = FALSE) 
{
    if (missing(tag)) {
        tag <- "//em"
        if (is.xml(doc)) 
            tag <- "//italic"
    }
    n <- xpathSApply(doc, tag, xmlValue)
    if (length(n) == 0) {
        print(paste("No", tag, "tags found"))
        x <- NULL
    }
    else {
        genes <- unique(n[nchar(n) \%in\% length])
        if (proteins) {
            proteins <- searchXMLall(doc, "[A-Z][a-z]{2}[A-Z][^a-zA-Z]", 
                ignore = FALSE)
            proteins <- unique(unlist(str_extract_all(proteins, 
                "[A-Z][a-z]{2}[A-Z]")))
            print(paste("Found", length(genes), "genes and", 
                length(proteins), "proteins"))
            genes <- sort(unique(tolower(c(genes, proteins))))
        }
        else {
            print(paste("Found", length(genes), "genes"))
        }
        genes <- paste(substr(genes, 1, 3), toupper(substr(genes, 
            4, 4)), sep = "")
        if (length(genes) == 0) {
            x <- NULL
        }
        else {
            z <- vector("list", length(genes))
            for (i in 1:length(genes)) {
                x <- searchXML(doc, paste(genes[i], "[^a-z-]", 
                  sep = ""))
                if (!is.null(x)) 
                  z[[i]] <- data.frame(gene = genes[i], x, stringsAsFactors = FALSE)
            }
            x <- data.frame(do.call("rbind", z), stringsAsFactors = FALSE)
            if (nrow(x) == 0) {
                print("No gene citations found")
                x <- NULL
            }
            else {
                print(paste(nrow(x), "gene citations"))
                names(x) <- c("gene", "source", "citation")
                x <- data.frame(pmid = pmid(doc), x, stringsAsFactors = FALSE)
            }
        }
    }
    x
  }
}


\keyword{ ~kwd1 }

