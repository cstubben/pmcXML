\name{getSupp}
\alias{getSupp}

\title{

}
\description{

}
\usage{
getSupp(doc, file, type, opts = "-raw -nopgbrk", rm = TRUE, header = TRUE, ...)
}

\arguments{
  \item{doc}{

}
  \item{file}{

}
  \item{type}{

}
  \item{opts}{

}
  \item{rm}{

}
  \item{header}{

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





function (doc, file, type, opts = "-raw -nopgbrk", rm = TRUE, 
    header = TRUE, ...) 
{
    pmcid <- attr(doc, "id")
    if (is.null(pmcid)) 
        stop("Missing PMC id attribute")
    if (missing(file)) 
        stop("Missing file name")
    if (missing(type)) {
        type <- tolower(gsub(".*\\.([^.]*)", "\\1", file))
    }
    url <- paste("http://www.ncbi.nlm.nih.gov/pmc/articles", 
        pmcid, "bin", file, sep = "/")
    ZIP <- FALSE
    if (type == "zip") {
        print("Downloading zip file")
        download.file(url, "tmp.zip")
        x <- system("unzip tmp.zip", intern = TRUE)
        file2 <- gsub(" *inflating: ([^ ]*) *", "\\1", x[2])
        print(paste("Inflating", file2))
        type <- tolower(gsub(".*\\.([^.]*)", "\\1", file2))
        urlzip <- url
        url <- file2
        ZIP <- TRUE
        if (type == "doc") 
            file.rename(file2, "tmp.doc")
        if (type == "docx") 
            file.rename(file2, "tmp.docx")
        if (type == "pdf") 
            file <- file2
        if (rm) 
            file.remove("tmp.zip")
    }
    if (type == "pdf") {
        if (!ZIP) 
            download.file(url, file, quiet = TRUE)
        outfile <- paste(file, ".out", sep = "")
        command <- paste("pdftotext", opts, file, outfile)
        system(command)
        x <- readLines(outfile, encoding = "latin1", ...)
        if (rm) {
            file.remove(file)
            file.remove(outfile)
        }
        x <- iconv(x, "latin1", "ASCII", sub = "byte")
        x <- gsub("<e2><80><90>", "-", x)
        x <- gsub("<c2><a0>", " ", x)
        x <- gsub("  *", " ", x)
        x <- gsub(" $", "", x)
        x <- x[grep("^$", x, invert = TRUE)]
        print(paste("Returned", length(x), "rows"))
    }
    else if (type == "doc" | type == "docx") {
        if (type == "doc") {
            if (!ZIP) 
                download.file(url, "tmp.doc", quiet = TRUE)
            command <- "unoconv -f xhtml tmp.doc"
        }
        else {
            if (!ZIP) 
                download.file(url, "tmp.docx", quiet = TRUE)
            command <- "unoconv -f xhtml tmp.docx"
        }
        system(command)
        x <- readHTMLTable("tmp.html", stringsAsFactors = FALSE, 
            header = header, ...)
        if (length(x) == 1) 
            x <- x[[1]]
        if (rm) {
            if (type == "doc") {
                file.remove("tmp.doc")
            }
            else {
                file.remove("tmp.docx")
            }
            file.remove("tmp.html")
        }
    }
    else if (type == "txt") {
        x <- read.table(url, stringsAsFactors = FALSE, ...)
        x <- guessTable(x, file)
        if (rm & ZIP) 
            file.remove(file2)
    }
    else if (type == "html") {
        x <- readHTMLTable(url, stringsAsFactors = FALSE)
        x <- x[[which.max(sapply(x, nrow))]]
        colnames(x) <- x[1, ]
        x <- x[-1, ]
        rownames(x) <- NULL
        for (i in 1:ncol(x)) x[, i] <- gsub("<U+0096>", "-", 
            x[, i])
        for (i in 1:ncol(x)) x[, i] <- gsub("^<U+00A0>$", NA, 
            x[, i])
        if (rm & ZIP) 
            file.remove(file2)
    }
    else {
        x <- read.xls2(url, ...)
        if (rm & ZIP) 
            file.remove(file2)
    }
    attr(x, "id") <- pmcid
    attr(x, "file") <- url
    if (ZIP) 
        attr(x, "file") <- urlzip
    x
  }
}


\keyword{ ~kwd1 }

