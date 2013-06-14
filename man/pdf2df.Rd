\name{pdf2df}
\alias{pdf2df}

\title{ Convert pdf tables to data.frames }
\description{ Converts pdf tables loaded using readLines to a data.frame }
\usage{
pdf2df(x, split, captionRow = 1, headerRow = 2, labels)
}

\arguments{
  \item{x}{ A vector of pdf text containing a structured table }
  \item{split}{ Space delimited string defining columns where w = single word (no spaces), d = decimal 0-9 and characters in scientific notation [Ee.-], a = any character including spaces. }
  \item{captionRow}{  Row(s) containing caption }
  \item{headerRow}{ Row(s) containing header }
  \item{labels}{  A optional vector to specify which words in headerRow to assign to column names, see note for details)
}
}
\details{ see \code{\link{pmcSupp}} to read supplementary tables in pdf formats. This function attempts to convert the loaded vector into a data.frame }
\value{  A data.frame}

% \references{ }
\author{ Chris Stubben}
\note{  If the headerRow contains more words than columns, the labels option is used to specify which words to assign to column names.  For example, if a two column table has a header row containing "Primer name Sequence", then there are three options for assigning column names 1) list words from header to keep as colNames = 1,3  returns  "Primer" "Sequence"  2) list number of words in each column name = 2,1 returns "Primer name" "Sequence" or 3) assign new column names = "id" "seq"   }

%\seealso{ }
\examples{

id <- "PMC2231364"
doc <-pmc(id)
s3 <- pmcSupp(doc, 3)
s3
x3 <- pdf2df(s3, "w w", labels=c(1,3))
head(x3)
str(x3)  # label and caption in attributes
# compare to 
pdf2df(s3[1:10], "w w", labels=c(2,2))


}
\keyword{ methods }

