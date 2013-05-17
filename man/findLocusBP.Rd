\name{findLocusBP}
\alias{findLocusBP}

\title{ test

}
\description{

}
\usage{
findLocusBP(doc, ...)
}

\arguments{
  \item{doc}{

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





function (doc, ...) 
{
    id <- attr(doc, "id")
    tag <- "BPS[SL][0-9]{4}[^0-9_]"
    y <- searchXML(doc, tag, ...)
    y2 <- searchXMLall(doc, tag)
    if (length(y2) != ifelse(is.null(y), 0, nrow(y))) {
        y2 <- y2[!y2 \%in\% y$citation]
        if (length(y2) > 0) {
            print(paste("Found", length(y2), "citations in unknown sections"))
            y <- rbind(y, data.frame(section = "Unknown", citation = y2, 
                stringsAsFactors = FALSE))
        }
    }
    if (!is.null(y)) {
        print(paste("Matched", nrow(y), "sentences"))
        y <- parseTags(y, bplocus, "BPS[SL]", "[abc]", expand = TRUE, 
            digits = 4)
        y <- data.frame(id, y, stringsAsFactors = FALSE)
    }
    y
  }
}


\keyword{ ~kwd1 }

