\name{getTable}
\alias{getTable}

\title{ test

}
\description{

}
\usage{
getTable(doc, n, ...)
}

\arguments{
  \item{doc}{

}
  \item{n}{

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





function (doc, n, ...) 
{
    url <- "http://www.ncbi.nlm.nih.gov"
    z <- htmlTableLinks(doc)
    if (z[1] == "No table links found") 
        stop(z)
    if (missing(n)) {
        n <- 1:length(z)
    }
    else {
        if (any(!n \%in\% 1:length(z))) {
            stop("Only ", length(z), " table links available")
        }
    }
    y <- vector("list", length(n))
    for (i in 1:length(n)) {
        url1 <- paste(url, z[n[i]], sep = "")
        t1 <- try(htmlParse2(url1))
        if (class(t1)[1] == "try-error") {
            stop("Cannot download ", url1)
        }
        x <- try(readHTMLTable(t1, stringsAsFactors = FALSE, 
            which = 1, ...), silent = TRUE)
        if (class(x)[1] == "try-error") {
            print("Warning: cannot parse table header")
            x <- readHTMLTable(t1, stringsAsFactors = FALSE, 
                header = FALSE, which = 1, ...)
        }
        x <- sr(x, "<U+00E2><U+0088><U+0092>|<U+00E2><U+0080><U+0093>|<U+00E2><U+0080><U+0094>|<U+00E2><U+0086><U+0093>", 
            "-")
        x <- sr(x, "<U+00C3><U+0097>", "x")
        x <- sr(x, "<U+00E2><U+0089><U+0088>", "~")
        x <- sr(x, "<U+00E2><U+0080><U+00B2>|<U+00E2><U+0080><U+0099>", 
            "'")
        n <- apply(x, 2, function(y) sum(!(is.na(y) | y == "" | 
            y == " " | y == "<U+00A0>")))
        if (any(n == 0)) {
            x <- x[, n != 0]
        }
        x <- fixTypes(x)
        c1 <- xpathSApply(t1, "//h1[@class='content-title']", 
            xmlValue)
        c1 <- gsub("\\.$", "", c1)
        c2 <- xpathSApply(t1, "//div[@class='caption']", xmlValue)
        attr(x, "id") <- attr(doc, "id")
        attr(x, "pmid") <- attr(doc, "pmid")
        attr(x, "file") <- url1
        attr(x, "label") <- c1
        attr(x, "caption") <- c2
        fn <- xpathSApply(t1, "//div[contains(@id, 'fn')]", xmlValue)
        if (length(fn) == 0) 
            fn <- xpathSApply(t1, "//div[contains(@id, 'TF')]", 
                xmlValue)
        if (length(fn) > 0) {
            fn <- gsub("<U+00E2><U+0080><U+0099>", "'", fn)
            fn <- paste(substr(fn, 1, 2), substring(fn, 3))
            attr(x, "footnotes") <- fn
        }
        y[[i]] <- x
    }
    if (length(y) == 1) 
        y <- y[[1]]
    y
  }
}


\keyword{ ~kwd1 }

