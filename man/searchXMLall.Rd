\name{searchXMLall}
\alias{searchXMLall}

\title{

}
\description{

}
\usage{
searchXMLall(doc, pattern, before = 0, after = 0, path = "//p", ignore.case = TRUE, ...)
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





function (doc, pattern, before = 0, after = 0, path = "//p", 
    ignore.case = TRUE, ...) 
{
    z <- xpathSApply(doc, path, xmlValue)
    z <- gsub(" ([A-Z])\\.", " \\1X.X", z)
    z <- gsub("^([A-Z])\\. ", "\\1X.X ", z)
    z <- gsub("\\(([A-Z])\\.", "\\(\\1X.X", z)
    z <- gsub("\\.$", "", z)
    z <- gsub(".^", ". ^", z, fixed = TRUE)
    z <- gsub("Fig. ", "FigX.X ", z, fixed = TRUE)
    z <- gsub("et al. ", "et alX.X ", z, fixed = TRUE)
    z <- gsub(" no. ", " noX.X ", z, fixed = TRUE)
    z <- gsub(" nos. ", " nosX.X ", z, fixed = TRUE)
    z <- gsub("e.g. ", "e.gX.X ", z, fixed = TRUE)
    z <- gsub("(eg. ", "(egX.X ", z, fixed = TRUE)
    z <- gsub("i.e. ", "i.eX.X ", z, fixed = TRUE)
    z <- gsub(" spp. ", " sppX.X ", z, fixed = TRUE)
    z <- gsub(" sp. ", " spX.X ", z, fixed = TRUE)
    z <- gsub(" subsp. ", " subspX.X ", z, fixed = TRUE)
    z <- gsub(" var. ", " varX.X ", z, fixed = TRUE)
    z <- gsub(" ca. ", " caX.X ", z, fixed = TRUE)
    z <- gsub("approx. ", "approxX.X ", z, fixed = TRUE)
    z <- gsub(" vs. ", " vsX.X ", z, fixed = TRUE)
    z2 <- unlist(strsplit(z, ". ", fixed = TRUE))
    if (!is.xml(doc)) 
        z2 <- gsub("\\{[^}]*\\}*", "", z2)
    z2 <- gsub("X.X", ".", z2, fixed = TRUE)
    z2 <- paste(z2, ".", sep = "")
    n <- grep(pattern, z2, ignore.case = ignore.case, ...)
    x <- z2[n]
    if (length(x) > 0) {
        if (before > 0) 
            for (i in 1:before) {
                x <- paste(z2[ifelse((n - i) > 0, n - i, NA)], 
                  x)
            }
        if (after > 0) 
            for (i in 1:after) {
                x <- paste(x, z2[n + i])
            }
    }
    x
  }
}


\keyword{ ~kwd1 }

