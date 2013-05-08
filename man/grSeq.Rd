\name{grSeq}
\alias{grSeq}

\title{

}
\description{

}
\usage{
grSeq(gr, dna, id = 1)
}

\arguments{
  \item{gr}{

}
  \item{dna}{

}
  \item{id}{

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





function (gr, dna, id = 1) 
{
    n <- as.logical(strand(gr) == "+")
    y <- Views(dna, ranges(gr))
    seqs <- ifelse(n, as.character(y), as.character(reverseComplement(y)))
    def <- paste(">", values(gr)[, id], "|", ifelse(n, paste(start(gr), 
        end(gr), sep = "-"), paste("c", end(gr), "-", start(gr), 
        sep = "")), sep = "")
    DataFrame(def, seqs)
  }
}


\keyword{ ~kwd1 }

