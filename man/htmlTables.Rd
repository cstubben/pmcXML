\name{htmlTables}
\alias{htmlTables}

\title{

}
\description{

}
\usage{
htmlTables(doc)
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
    y <- xpathSApply(doc, "//div[starts-with(@class, 'table')]", 
        xmlValue)
    if (length(y) == 0) {
        print("No table names found (in div tag with class attribute starting with table*) ")
    }
    else {
        y
        y <- gsub("\n", "", y)
        y <- gsub("  *", " ", y)
        y
    }
  }
}


\keyword{ ~kwd1 }

