\name{pdf2df}
\alias{pdf2df}

\title{ Convert pdf tables to data.frames }
\description{ Converts pdf tables loaded using readLines to a data.frame }
\usage{
pdf2df(x, split, captionRow = 1, headerRow = 2, labels, subset)
}

\arguments{
  \item{x}{ a vector of pdf text containing a structured table }
  \item{split}{ space delimited string defining columns where w = single word (no spaces), s=single letter, d = decimal 0-9 and characters in scientific notation [Ee.-], a = any character including spaces. }
  \item{captionRow}{  row(s) containing caption }
  \item{headerRow}{ row(s) containing header }
  \item{labels}{  an optional vector to specify which words in headerRow to assign to column names, see note for details) }
  \item{subset}{  optional vector for indexing x to avoid dropping attributes }
}
\details{ see \code{\link{pmcSupp}} to read supplementary tables in pdf formats. This function converts vector into a data.frame }
\value{  A data.frame}

% \references{ }
\author{ Chris Stubben}
\note{  If the headerRow contains more words than columns, the labels option is used to specify which words to assign to column names.  For example, if a two column table has a header row containing "Primer name Sequence", then there are three options for assigning column names 1) list words from header to keep as colNames = 1,3  returns  "Primer" "Sequence"  2) list number of words in each column name = 2,1 returns "Primer name" "Sequence" or 3) assign new column names = "id" "seq"   }

%\seealso{ }
\examples{

\dontrun{
id <- "PMC2231364"
doc <-pmcOAI(id)
s2 <- pmcSupp(doc, 3)
s2 <- gsub("For ", "", s2) # hack to keep subheader in 1st column only
s2 <- pdf2df(s2, "w w", labels=c(1,3) )
head(s2)
attributes(s2)
repeatSub(s2, "For") 

}

}
\keyword{ methods }

