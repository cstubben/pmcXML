\name{findGenesBP}
\alias{findGenesBP}

\title{

}
\description{

}
\usage{
findGenesBP(doc, tag, length = 4, proteins = FALSE)
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
        genes <- genes[genes \%in\% bpgenes]
        print(paste(length(genes), "genes matching RefSeq gene names"))
        print(genes)
        if (length(genes) == 0) {
            x <- NULL
        }
        else {
            z <- vector("list", length(genes))
            for (i in 1:length(genes)) {
                x <- searchXML(doc, paste(genes[i], "[^a-z-]", 
                  sep = ""))
                x2 <- searchXMLall(doc, paste(genes[i], "[^a-z-]", 
                  sep = ""))
                if (length(x2) != ifelse(is.null(x), 0, nrow(x))) {
                  x2 <- x2[!x2 \%in\% x$citation]
                  if (length(x2) > 0) {
                    x <- rbind(x, data.frame(section = "Unknown", 
                      citation = x2))
                  }
                }
                if (!is.null(x)) {
                  if (nrow(x) > 0) 
                    z[[i]] <- data.frame(gene = genes[i], x, 
                      stringsAsFactors = FALSE)
                }
            }
            x <- data.frame(do.call("rbind", z), stringsAsFactors = FALSE)
            if (nrow(x) == 0) {
                print("No gene citations found")
                x <- NULL
            }
            else {
                print(paste(nrow(x), "gene citations"))
                names(x) <- c("gene", "source", "citation")
                x <- data.frame(pmid = attr(doc, "pmid"), x, 
                  stringsAsFactors = FALSE)
            }
        }
    }
    x
  }
}


\keyword{ ~kwd1 }

