\name{searchXML}
\alias{searchXML}

\title{ test

}
\description{

}
\usage{
searchXML(doc, pattern, before = 0, after = 0, path = "//p[not(descendant::table-wrap)]", ignore.case = TRUE, htmlSection = "h2", ...)
}

\arguments{
  \item{doc}{

}
  \item{pattern}{

}
  \item{before}{

}
  \item{after}{

}
  \item{path}{

}
  \item{ignore.case}{

}
  \item{htmlSection}{

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





function (doc, pattern, before = 0, after = 0, path = "//p[not(descendant::table-wrap)]", 
    ignore.case = TRUE, htmlSection = "h2", ...) 
{
    if (is.xml(doc)) {
        x <- getNodeSet(doc, "//body/sec[not(ancestor::sec)]")
        x <- c(getNodeSet(doc, "//abstract"), x)
        if (length(x) == 0) 
            x <- getNodeSet(doc, "//body")
    }
    else {
        x <- getNodeSet(doc, paste("//div[", htmlSection, "]", 
            sep = ""))
    }
    z <- vector("list", length(x))
    for (i in 1:length(x)) {
        doc2 <- xmlDoc(x[[i]])
        title <- ifelse(is.xml(doc), ifelse(i == 1, "Abstract", 
            xvalue(doc2, "//title")), xvalue(doc2, paste("//", 
            htmlSection, sep = "")))
        y <- searchXMLall(doc2, pattern, before, after, path, 
            ignore.case, ...)
        free(doc2)
        if (length(y) > 0) 
            z[[i]] <- cbind(title, y)
    }
    z <- do.call("rbind", z)
    if (!is.null(z)) {
        z <- data.frame(z, stringsAsFactors = FALSE)
        names(z) <- c("section", "citation")
        z <- unique(z)
        rownames(z) <- NULL
        z$section <- gsub("^[0-9.]* (.*)", "\\1", z$section)
        z$section <- gsub("\n", "", z$section)
    }
    z
  }
}


\keyword{ ~kwd1 }

