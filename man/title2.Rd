\name{title2}
\alias{title2}

\title{

}
\description{

}
\usage{
title2(doc)
}

\arguments{
  \item{doc}{

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





function (doc) 
{
    if (class(doc)[1] == "XMLInternalDocument") {
        xpathSApply(doc, "//title-group/article-title", xmlValue)[1]
    }
    else {
        xpathSApply(doc, "//title", xmlValue)[1]
    }
  }
}


\keyword{ ~kwd1 }

