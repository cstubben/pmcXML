\name{findTags}
\alias{findTags}
\title{ Find locus tags }
\description{  Find locus tags within XML documents downloaded from PMC Open Access  }
\usage{
findTags(doc, tags, prefix, suffix, notStartingWith, expand = TRUE, digits = 4, ...)
}
\arguments{
  \item{doc}{  XML document or output from \code{\link{pmcText}} or \code{\link{pmcTable}} }
  \item{tags}{  An ordered list of locus tags, used for expanding locus tag pairs }
  \item{prefix}{ Locus tag prefix, can be a regular expression such as "BPS[SL]" or "VCA?" }
  \item{suffix}{ Locus tag suffix, should be a  single letter  "a" or character class "[ac]"  or grouping brackets "(a|c|\\.1)" }
  \item{notStartingWith}{ optional single letter to exclude matches, eg, use "J" to match "HP" but not "JHP" tags in Helicobacter    }
  \item{expand}{ Expand locus tags pairs marking the start and end of a operon, island or other region }
  \item{digits}{ Number of digits in locus tags, use NA for 1 or more }
  \item{\dots}{ Other options passed to searchP }
}
\details{
Extracts locus tags from text and tables and expands tag pairs using the ordered list of locus tags

}
\value{
A data.frame with locus tag, section title or table name and sentence or table row containing the citation
}
% \references{ }
\author{ Chris Stubben }
% \note{ }

\seealso{\code{\link{parseTags}} }

\examples{
data(doc)
data(yplocus)
# text and tables - 233 tags
 y<-findTags(doc, yplocus, "YPO", "a")
head(y)
table2(y$range)
subset(y, locus=="YPO0988")

# or just text
txt<-pmcText(doc)
 y<-findTags(txt, yplocus, "YPO", "a")

}
\keyword{ methods }
