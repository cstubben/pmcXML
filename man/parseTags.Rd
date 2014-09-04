\name{parseTags}
\alias{parseTags}

\title{ Parse locus tags }
\description{  Parse locus tags from text and tables and expand tag pairs marking the start and end of a region}
\usage{
parseTags(y, tags, prefix, suffix, notStartingWith, expand = TRUE, digits = 4)
}

\arguments{
  \item{y}{ output from \code{\link{searchPMC}} }
  \item{tags}{  an ordered list of locus tags, used for expanding locus tag pairs }
  \item{prefix}{ locus tag prefix, can be a regular expression such as "BPS[SL]" or "VCA?" }
  \item{suffix}{ locus tag suffix, should be a  single letter  "a" or character class "[ac]"  or grouping brackets "(a|c|\\.1)" }
  \item{notStartingWith}{ optional single letter to exclude matches, eg, use "J" to match "HP" but not "JHP" tags in Helicobacter    }
  \item{expand}{ expand locus tags pairs marking the start and end of a operon, island or other region }
  \item{digits}{ number of digits in locus tags, use NA for 1 or more } 
}
\details{ Extracts locus tags and expands tag pairs using \code{\link{seqIds}}.  Mainly used by \code{\link{findTags}}, see that functoin for details.

}
\value{ A data.frame  }
%\references{ }
\author{ Chris Stubben }
%\note{  }

\seealso{  \code{\link{findTags}} }
% \examples{ }


\keyword{ methods }

