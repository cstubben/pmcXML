# pmcXML

`pmcXML` is an `R` package to download and parse XML documents from
[Pubmed Central](http://www.ncbi.nlm.nih.gov/pmc) (PMC).  


To install the package, first install the required dependencies, `stringr` and `gdata` from CRAN and `genomes` 
from Bioconductor

 	install.packages("stringr")
	install.packages("gdata")
	source("http://bioconductor.org/biocLite.R")
	biocLite("genomes")
	library(devtools)
	install_github("cstubben/pmcXML")


The `pmcSupp` function also requires a number of Unix dependencies (unzip, unoconv, pdftotext) 
to read zip, word tables and pdf supplementary files. 

Additional details about the package are on the [wiki pages](https://github.com/cstubben/pmcXML/wiki/Overview) and in [BMC Bioinformatics](http://www.biomedcentral.com/1471-2105/15/43/abstract).

Stubben, CJ and JC Challacombe, 2014. Mining locus tags in PubMed Central to improve microbial gene annotation. BMC Bioinformatics 15:43.
