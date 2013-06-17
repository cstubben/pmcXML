\name{findGenes}
\alias{findGenes}

\title{ Find gene names }
\description{  Find gene names within XML documents downloaded from PMC Open Access}
\usage{
findGenes(doc, tag, length = 4, proteins = FALSE)
}

\arguments{
  \item{doc}{ XML document  }
  \item{tag}{ XML tag, default //italic }
  \item{length}{  length of gene name, default 4}
  \item{proteins}{ also search for protein names with initial and final capital }
}
\details{ There are a few ways to find gene names, and probably the best approach will use a combination of sources, including 1) Match to known list of genes. Some genes are common names like 'thiS' and many gene names are not listed in Refseq and other databases.  2) Find gene names in italic tags with length = 4.  Misses genes with 3 or 5 characters and may include some 4 letter words that are not genes.  3) Find protein names with initial and final capital, e.g. SpoT.  Often genes are cited using both protein and gene names.
}
\value{
A data.frame with gene names, section title and sentence containing the citation

}
% \references{ }
\author{ Chris Stubben  }

\note{ In progress }

%\seealso{ }
\examples{

doc <- pmcOAI("PMC2231364" )
#lots of terms in italics.  findGenes will miss operons and other genes like ymt
table2(xpathSApply(doc, "//body//italic", xmlValue), n=20)

y <-findGenes(doc)
table(y$gene)
y

y2<-findGenes(doc, proteins=TRUE)
table(y2$gene)

y3<-findGenes(doc, length=3)
table(y3$gene)
head(y3) # cis is not a gene

}


\keyword{ methods }

