\name{pmcLoop}
\alias{pmcLoop}

\title{ Loop through PMC search results }
\description{  Loops through PMC search results and downloads and extracts locus tags in text and tables }
\usage{
pmcLoop(pmcresults, tags, prefix, suffix, file = "locus.tab", notStartingWith, expand = TRUE, digits = 4)
}

\arguments{
  \item{pmcresults}{  PMC search results from \code{\link{ncbiPMC}}  }
  \item{tags}{  an ordered list of locus tags, used for expanding locus tag pairs }
  \item{prefix}{ locus tag prefix, can be a regular expression such as "BPS[SL]" or "VCA?" }
  \item{suffix}{ locus tag suffix, should be a  single letter  "a" or character class "[ac]"  or grouping brackets "(a|c|\\.1)" }
  \item{file}{ name of output file} 
  \item{notStartingWith}{ optional single letter to exclude matches, eg, use "J" to match "HP" but not "JHP" tags in Helicobacter    }
  \item{expand}{ expand locus tags pairs marking the start and end of a operon, island or other region }
  \item{digits}{ number of digits in locus tags, use NA for 1 or more } 
}

\details{ Downloads XML using \code{\link{pmcOAI}} and then parses text using \code{\link{pmcText}}  and tables using \code{\link{pmcTable}} and extracts tags using \code{\link{findTags}}.  Also adds captions to collapsed table rows and writes mentions to output file

}
\value{  None. Mentions are saved to output file }
% \references{ }
\author{ Chris Stubben}
% \note{ }
% \seealso{ }
\examples{
\dontrun{
org <- "Yersinia_pestis_CO92_uid57621"
ypgff <- read.ncbi.ftp( org, "NC_003143.gff")
yp <- ncbiPMC( "(YPO0* OR YPO1* OR YPO2* OR YPO3* OR YPO4*) AND (Yersinia[ABSTRACT] OR Yersinia[TITLE]) AND open access[FILTER]" )
pmcLoop(yp, ypgff, "YPO", "a", "YPO.tab" )
}

}
\keyword{ methods }

