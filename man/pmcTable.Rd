\name{pmcTable}
\alias{pmcTable}

\title{

}
\description{

}
\usage{
pmcTable(pmc, whichTable, verbose = TRUE, ...)
}

\arguments{
  \item{pmc}{

}
  \item{whichTable}{

}
  \item{verbose}{

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





function (pmc, whichTable, verbose = TRUE, ...) 
{
    tables <- getNodeSet(pmc, "//table-wrap")
    if (length(tables) == 0) {
        NULL
    }
    else {
        if (!missing(whichTable)) 
            tables <- tables[whichTable]
        n <- length(tables)
        y <- vector("list", n)
        for (k in 1:n) {
            z2 <- xmlDoc(tables[[k]])
            id <- xpathSApply(z2, "//table-wrap", xmlGetAttr, 
                "id")
            label <- xpathSApply(z2, "//label", xmlValue)
            caption <- xpathSApply(z2, "//caption", xmlValue)
            if (verbose) 
                print(paste("Parsing", paste(label, caption)))
            flabel <- xpathSApply(z2, "//table-wrap-foot/fn/label", 
                xmlValue)
            fn <- xpathSApply(z2, "//table-wrap-foot/fn/p", xmlValue)
            if (length(flabel) > 0) {
                fn <- paste(flabel, fn, sep = ". ")
            }
            if (length(fn) == 0) {
                fn <- xpathSApply(z2, "//table-wrap-foot", xmlValue)
            }
            t1 <- getNodeSet(z2, "//table")
            if (length(t1) == 0) {
                print("  No table node - possible link to image?")
                x <- data.frame()
                thead <- NA
                free(z2)
            }
            else {
                t1 <- t1[[1]]
                x <- getNodeSet(t1, "//thead/tr")
                if (length(x) == 0) {
                  thead <- NA
                }
                else if (length(x) == 1) {
                  colspan <- as.numeric(xpathSApply(x[[1]], ".//td|.//th", 
                    xmlGetAttr, "colspan", 1))
                  thead <- xpathSApply(x[[1]], ".//td|.//th", 
                    xmlValue)
                  if (any(colspan > 1)) {
                    thead <- rep(thead, colspan)
                  }
                }
                else {
                  nr <- length(x)
                  for (i in 1:nr) {
                    rowspan <- as.numeric(xpathSApply(x[[i]], 
                      ".//td|.//th", xmlGetAttr, "rowspan", 1))
                    colspan <- as.numeric(xpathSApply(x[[i]], 
                      ".//td|.//th", xmlGetAttr, "colspan", 1))
                    thead <- xpathSApply(x[[i]], ".//td|.//th", 
                      xmlValue)
                    if (any(colspan > 1)) {
                      thead <- rep(thead, colspan)
                      rowspan <- rep(rowspan, colspan)
                    }
                    if (i == 1) {
                      nc <- length(thead)
                      c2 <- data.frame(matrix(NA, nrow = nr, 
                        ncol = nc))
                    }
                    n <- which(is.na(c2[i, ]))
                    c2[i, n] <- thead
                    if (any(rowspan > 1)) {
                      for (j in 1:length(rowspan)) {
                        if (rowspan[j] > 1) {
                          c2[(i + 1):(i + (rowspan[j] - 1)), 
                            n[j]] <- thead[j]
                        }
                      }
                    }
                  }
                  if (nrow(c2) > nr) 
                    c2 <- c2[1:nr, ]
                  thead <- apply(c2, 2, function(x) paste(unique(x), 
                    collapse = "; "))
                  thead <- gsub("; ; ", "; ", thead)
                  thead <- gsub("^; ", "", thead)
                }
                x <- getNodeSet(t1, "//tbody/tr")
                nr <- length(x)
                for (i in 1:nr) {
                  rowspan <- as.numeric(xpathSApply(x[[i]], ".//td", 
                    xmlGetAttr, "rowspan", 1))
                  colspan <- as.numeric(xpathSApply(x[[i]], ".//td", 
                    xmlGetAttr, "colspan", 1))
                  val <- xpathSApply(x[[i]], ".//td", xmlValue)
                  if (any(colspan > 1)) {
                    val <- rep(val, colspan)
                    val[-1][val[-1] == val[-length(val)]] <- NA
                    rowspan <- rep(rowspan, colspan)
                  }
                  if (i == 1) {
                    nc <- length(val)
                    c2 <- data.frame(matrix(NA, nrow = nr, ncol = nc))
                  }
                  n <- which(is.na(c2[i, ]))
                  if (length(val) != length(n)) 
                    val <- val[1:length(n)]
                  c2[i, n] <- val
                  if (any(rowspan > 1)) {
                    for (j in 1:length(rowspan)) {
                      if (rowspan[j] > 1) {
                        c2[(i + 1):(i + (rowspan[j] - 1)), n[j]] <- val[j]
                      }
                    }
                  }
                }
                free(z2)
                x <- c2
                if (!is.na(thead[1])) 
                  colnames(x) <- thead
                if (nrow(x) > 1) {
                  nX <- apply(x, 1, function(y) sum(!(is.na(y) | 
                    y == "")))
                  x <- x[nX != 0, , FALSE]
                }
                colnames(x) <- gsub("\n *", "", colnames(x))
                x2 <- try(fixTypes(x, na.strings = "", ...), 
                  silent = TRUE)
                if (class(x2) == "try-error") {
                  print("ERROR fixing types - skipped")
                }
                else {
                  x <- x2
                }
            }
            attr(x, "id") <- attr(pmc, "id")
            attr(x, "file") <- paste(attr(pmc, "file"), "table", 
                id, sep = "/")
            attr(x, "label") <- label
            attr(x, "caption") <- caption
            if (length(fn) > 0) {
                attr(x, "footnotes") <- fn
            }
            y[[k]] <- x
            names(y)[k] <- label
        }
        if (length(y) == 1) 
            y <- y[[1]]
        y
    }
  }
}


\keyword{ ~kwd1 }

