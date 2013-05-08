\name{parseTags}
\alias{parseTags}

\title{

}
\description{

}
\usage{
parseTags(y, tags, prefix, suffix, expand = TRUE, digits = 4)
}

\arguments{
  \item{y}{

}
  \item{tags}{

}
  \item{prefix}{

}
  \item{suffix}{

}
  \item{expand}{

}
  \item{digits}{

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





function (y, tags, prefix, suffix, expand = TRUE, digits = 4) 
{
    if (nchar(suffix) > 1) {
        if (!grepl("^(\\[|\\()", suffix)) 
            stop("suffix should be single letter \"a\" or character class \"[ac]\"  or grouping brackets \"(a|c|\\.1)\"")
    }
    tag <- paste(prefix, "[0-9]+", sep = "")
    if (is.numeric(digits)) 
        tag <- paste(prefix, "[0-9]{", digits, "}", sep = "")
    y$citation <- gsub("\342\200\223", "-", y$citation)
    y$citation <- gsub(" *- *", "-", y$citation)
    y$citation <- gsub("\n *", "", y$citation)
    y$citation <- gsub("\t *", " ", y$citation)
    if (!missing(suffix)) 
        tag <- paste(tag, suffix, "?", sep = "")
    ids0 <- str_extract_all(y$citation, ignore.case(tag))
    if (expand) {
        ids <- str_extract_all(y$citation, ignore.case(paste(tag, 
            " to ", tag, "|", tag, "-", tag, "|", tag, "-[0-9]+|", 
            tag, sep = "")))
        n <- grepl("-|to", ids)
        if (sum(n) > 0) 
            ids[n] <- lapply(ids[n], function(y) unlist(lapply(y, 
                seqIds, tags = tags)))
        ids <- lapply(ids, unique)
        inRange <- !unlist(mapply(function(x, y) toupper(x) \%in\% 
            toupper(y), ids, ids0, SIMPLIFY = FALSE))
        n2 <- sapply(ids, length)
        if (sum(n) > 0) 
            print(paste("Expanded", sum(n), "citations to", paste(n2[n], 
                collapse = ", "), "tags"))
        ids <- unlist(ids)
        y <- data.frame(source = rep(y$section, n2), locus = ids, 
            range = inRange, citation = rep(y$citation, n2), 
            stringsAsFactors = FALSE)
    }
    else {
        n2 <- sapply(ids0, length)
        ids <- unlist(ids0)
        y <- data.frame(source = rep(y$section, n2), locus = ids, 
            citation = rep(y$citation, n2), stringsAsFactors = FALSE)
    }
    if (grepl("^[A-Za-z_]+$", prefix)) {
        y$locus <- gsub(prefix, prefix, y$locus, ignore.case = TRUE)
    }
    else {
        n <- !y$range
        if (sum(n) > 0) {
            n2 <- min(nchar(y$locus[n]))
            y$locus[!y$range] <- paste(toupper(substr(y$locus[n], 
                1, (n2 - 1))), substring(y$locus[n], n2), sep = "")
        }
    }
    y <- unique(y)
    print(paste(nrow(y), " locus tags cited (", length(unique(y$locus)), 
        " unique)", sep = ""))
    y
  }
}


\keyword{ ~kwd1 }

