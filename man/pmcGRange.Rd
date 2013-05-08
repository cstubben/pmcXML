\name{pmcGRange}
\alias{pmcGRange}

\title{

}
\description{

}
\usage{
pmcGRange(x, acc)
}

\arguments{
  \item{x}{

}
  \item{acc}{

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





function (x, acc) 
{
    if (missing(acc)) {
        acc <- x$seqnames
    }
    n <- match(c("start", "end", "strand"), tolower(names(x)))
    if (any(is.na(n))) {
        stop("Need columns matching start, end, strand")
    }
    gr <- GRanges(seqnames = acc, ranges = IRanges(x[, n[1]], 
        x[, n[2]]), strand = x[, n[3]], data.frame(x[, -n]))
    seqlengths(gr) <- ncbiNucleotide(acc)$size
    metadata(gr) <- list(file = attr(x, "file"), caption = attr(x, 
        "caption"), footnotes = attr(x, "footnotes"))
    gr
  }
}


\keyword{ ~kwd1 }

