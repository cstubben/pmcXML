## pubmed

`pubmed` is an `R` package to download and parse XML documents from [Pubmed Central](http://www.ncbi.nlm.nih.gov/pmc) (PMC).  There are over 2.7 million full-text articles in PMC and 22% are available for text mining in the [Open Access](http://www.ncbi.nlm.nih.gov/pmc/tools/openftlist) (OA) subset.  The number of OA publications is increasing rapidly each year and 67% of PMC articles published in 2012 are open access (view [code](/inst/doc/pmc_growth.R) ).  

![PMC growth](/inst/doc/pmc_growth.png)

Due to the rapid growth of microbial genome sequencing and the lack of model prokaryotic organism databases (containing high-quality annotations linking features to literature), our main objective is to use the OA subset as a genome annotation database and extract features from reference microbial genomes directly from the literature. Initially, we are focusing on locus tags, but many other features such as gene names, accession numbers, sequences and coordinates (start/stop) will also be needed before attempting to summarize functions, interactions and pathways.  Our goal is to extract locus tags from *full text, tables and supplements* and output tab-delimited files in a variety of formats, for example, as GFF3 files that can then be viewed in a genome browser. An example of the basic steps using *Burkholderia pseudomallei* is outlined below.  

## Overview

The following code downloads *B. pseudomallei* GFF3 files from the Genomes FTP site. The locus tag prefixes in the GFF3 file are use to build a wildcard search and find 46 relevant [publications](/inst/doc/bp_refs.tab) in the OA subset of PMC. Finally, a loop is run to download the XML and parse the 2959 locus tag citations from the full text and tables into a [file](/inst/doc/bp.tab). 

	bpgff <- read.ncbi.ftp( "Burkholderia_pseudomallei_K96243_uid57733", "gff")
	bplocus <- values(bpgff)$locus

	tags <- "(BPSL0* OR BPSL1* OR BPSL2* OR BPSL3* OR BPSS0* OR BPSS1* OR BPSS2*)"
	bp <- ncbiPMC(paste(tags, "AND (Burkholderia[TITLE] OR Burkholderia[ABSTRACT]) AND open access[FILTER]")) 
	[1] "46 results found"
	pmcLoop(bp, tags= bplocus, prefix = "BPS[SL]" , suffix= "[abc]",  file="bp.tab")


## Details







