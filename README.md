## pubmed

`pubmed` is an `R` package to download and parse XML documents from [Pubmed Central](http://www.ncbi.nlm.nih.gov/pmc) (PMC).  There are now over 2.7 million full-text articles in PMC and 22% are available for text mining in the [Open Access](http://www.ncbi.nlm.nih.gov/pmc/tools/openftlist) (OA) subset.  The number of OA publications is increasing rapidly each year and 67% of PMC articles published in 2012 are open access (view [code](/inst/doc/pmc_growth.R) ).  

![PMC growth](/inst/doc/pmc_growth.png)

Due to the rapid growth of microbial genome sequencing and the lack of model prokaryotic organism databases (containing high-quality annotations linking features to literature), our main objective is to use the OA subset as an annotation database and extract features and citations from reference microbial genomes. Initially, we are focusing on locus tags, but many other features such as gene names, accession numbers, sequences and coordinates (start/stop) will also be needed before attempting to summarize functions, interactions and pathways.  Our goal is to extract the features from *full text, tables and supplements* and output tab-delimited files in a variety of formats, for example, as GFF3 files that can then be viewed in genome browsers. An example of the basic steps using *Burkholderia pseudomallei* is outlined below.  

# Overview

The [Burkholderia pseudomallei](http://www.ncbi.nlm.nih.gov/genome/476) page in Entrez Genomes lists the Reference genome (strain K96243) and this strain is used to download the RefSeq gff3 file from the [ftp site](ftp.ncbi.nlm.nih.gov/genomes/Bacteria/Burkholderia_pseudomallei_K96243_uid57733) (the `pubmed`, `genomes` and `genomes2` packages have a number of extra functions and datasets to automate these steps below).

	referenceGenome("Burkholderia pseudomallei")
	[1] "Reference genome, Community selected, UniProt : Burkholderia pseudomallei K96243"
	[2] "Project id : 57733"
	
	data(Bacteria)  # list of directories in ftp
	subset(Bacteria, pid ==  57733)
	                                         name mode size       date   pid
	386 Burkholderia_pseudomallei_K96243_uid57733    d 4096 2010-12-06 57733
	
	org <- "Burkholderia_pseudomallei_K96243_uid57733"
	bpgff <- read.ncbi.ftp( org, "gff")
	
	# list prefixes (for PMC search), suffixes, tag range for coding regions 
	summaryTag(bpgff)

	# check if features are sorted (needed for range expansion) 
	is.sorted(bpgff)
	bplocus <- values(bpgff)$locus
	bpgenes<- sort(unique(unlist( strsplit(values(bpgff)$gene, ",") )))

Using the locus tag prefixes from the coding regions in the GFF3 file above, the next step is to use a wildcard search to find relevant publications in the OA subset of PMC. All the remaining steps detailed below may be combined in a single loop to download the XML and parse tags from full text and tables into a file.  

	tags <- "(BPSL0* OR BPSL1* OR BPSL2* OR BPSL3* OR BPSS0* OR BPSS1* OR BPSS2*)"
	tiab <-  "AND (Burkholderia[TITLE] OR Burkholderia[ABSTRACT])"
	bp <- ncbiPMC(paste(tags, tiab, "AND open access[FILTER]")) 
	[1] "46 results found"
	head(bp)
	pmcLoop(bp, tags= bplocus, prefix = "BPS[SL]" , suffix= "[abc]",  file="bp.tab")


## Details







