# pubmed

`pubmed` is an `R` package to download and parse XML documents from
[Pubmed Central](http://www.ncbi.nlm.nih.gov/pmc) (PMC).  


To install the package, first install the required dependencies, `stringr` and `gdata` from CRAN, `genomes` 
from Bioconductor and `genomes2` from github.

 	install.packages("stringr")
	install.packages("gdata")
	source("http://bioconductor.org/biocLite.R")
	biocLite("genomes")
	library(devtools)
	install_github("genomes2", username="cstubben")
	install_github("pubmed", username="cstubben")


The `str_extract_all` function from the `stringr` pacakge is used by `parseTags`.  The `getSupp` function 
uses `read.xls` from the `gdata` pacakges and also requires a number of Unix dependencies (unzip, unoconv, pdftotext) 
to read zip, word tables and pdf files. 

Additional details about the package are on the wiki pages and in an upcoming publication in BMC Bioinformatics
Stubben, CJ and JC Challacombe, 2013.  Mining locus tags in Pubmed Central to improve microbial gene annotation.
