\name{findTags}
\alias{findTags}
\title{ Find locus tags }
\description{  Find and extract locus tags in PMC text or tables }
\usage{
findTags(txt, tags, prefix, suffix, notStartingWith, expand = TRUE, digits = 4, ...)
}
\arguments{
  \item{ txt }{ output from \code{\link{pmcText}} or \code{\link{pmcTable}}    }
  \item{tags}{  an ordered list of locus tags, used for expanding locus tag pairs }
  \item{prefix}{ locus tag prefix, can be a regular expression such as "BPS[SL]" or "VCA?" }
  \item{suffix}{ locus tag suffix, should be a  single letter  "a" or character class "[ac]"  or grouping brackets "(a|c|\\.1)" }
  \item{notStartingWith}{ optional single letter to exclude matches, eg, use "J" to match "HP" but not "JHP" tags in Helicobacter    }
  \item{expand}{ expand locus tags pairs marking the start and end of a operon, island or other region }
  \item{digits}{ number of digits in locus tags, use NA for 1 or more }
  \item{\dots}{ other options passed to \code{\link{searchPMC}} }
}
\details{
Searches for locus tags in text and tables using \code{\link{searchPMC}} and extracts locus tags using \code{\link{parseTags}} and expands tag pairs using \code{\link{seqIds}}.  The prefix, digits and suffix options are used to build the pattern string "YPO[0-9]{4}a?" where prefix="YPO" and digits=4 and optional suffix="a".  The notStartingWith option is used to add a negative lookbehind "(?<!J)HP[0-9]{4}" to avoid tags starting with a given letter.

}
\value{
A data.frame with locus tag, section title or table name and sentence or table row containing the mention
}
% \references{ }
\author{ Chris Stubben }
\note{ Matches tag pairs including YPO1774-YPO1779 OR YPO1774 to YPO1779 OR YPO1774-1779 OR YPO1774-9.  Some matches may include interaction pairs and other non-ranges and therefore range expansions should be checked (or set expand=FALSE to skip) }

\seealso{\code{\link{parseTags}} }

\examples{

\dontrun{
doc <- pmcOAI("PMC2231364" )
data(yplocus)
# text  - 33 tags
txt <- pmcText(doc)
y <- findTags(txt, yplocus, "YPO", "a")
head(y)
table2(y$range)   ## within range
table2(y$mention) # check range expansions
subset(y, locus == "YPO0988")
# or tables
x <- pmcTable(doc)
y <- findTags(x[[2]], yplocus, "YPO", "a")
}

}
\keyword{ methods }
