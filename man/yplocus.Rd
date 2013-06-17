\name{yplocus}
\alias{yplocus}
\docType{data}
\title{ Yersinia pestis locus tags }
\description{ Yersinia pestis CO92 locus tags
}
\usage{data(yplocus)}

\format{
  The format is:
 chr [1:4087] "YPO0001" "YPO0002" "YPO0003" "YPO0004" "YPO0005" "YPO0006" "YPO0007" "YPO0008" "YPO0009" "YPO0010" ...
}
\details{  A vector of locus tags in the RefSeq GFF3 file.   See example for details

}
\source{  \url{ftp://ftp.ncbi.nlm.nih.gov/genomes/Bacteria/Yersinia_pestis_CO92_uid57621} } 
% \references{ }
\examples{
data(yplocus)
head(yplocus)
table(gsub("([^0-9]+)[0-9]+.*", "\\1", yplocus))

\dontrun{
org <- "Yersinia_pestis_CO92_uid57621"
ypgff <- read.ncbi.ftp( org, "NC_003143.gff")
yplocus <- values(ypgff)$locus
}



}
\keyword{datasets}
