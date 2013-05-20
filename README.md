## pubmed

`pubmed` is an `R` package to download and parse XML documents from [Pubmed Central](http://www.ncbi.nlm.nih.gov/pmc) (PMC).  There are over 2.7 million full-text articles in PMC and 22% are available for text mining in the [Open Access](http://www.ncbi.nlm.nih.gov/pmc/tools/openftlist) (OA) subset.  The number of OA publications is increasing rapidly each year and 67% of PMC articles published in 2012 are open access (view [code](/inst/doc/pmc_growth.R) ).  

![PMC growth](/inst/doc/pmc_growth.png)

Due to the rapid growth of microbial genome sequencing and the lack of model prokaryotic organism databases (containing high-quality annotations linking features to literature), our main objective is to use the OA subset as a genome annotation database and extract features from reference microbial genomes directly from the literature. Initially, we are focusing on locus tags, but many other features such as gene names, accession numbers, sequences and coordinates (start/stop) should be collected before attempting to summarize functional annotations.  Our goal is to extract passages containing locus tags from *full text, tables and supplements* and output tab-delimited files in a variety of formats, for example, as GFF3 files that can then be viewed in a genome browser.  This guide describes some of the functions included within the package by using *Burkholderia pseudomallei* as an example.

Download Reference Genomes
Find all publications with locus tags
Download PMC XML into R
Parse citations from text and tables


## Download Reference Genomes

The [Burkholderia pseudomallei](http://www.ncbi.nlm.nih.gov/genome/476) page in Entrez Genomes lists the Reference genome (strain K96243). This strain may also be identified using the `referenceGenome` function, which searches Entrez genome using a species name.  The next step is to identifiy the organism directory in the Genomes ftp site (ftp.ncbi.nlm.nih.gov/genomes/Bacteria) and download annotations and sequences.  The organism directory is usually the name and project id and can also be found in the Bacteria dataset.  The `read.ncbi.ftp` function reads most of the RefSeq files on the site including GFF3 files below.   


	referenceGenome("Burkholderia pseudomallei")
	[1] "Reference genome, Community selected, UniProt : Burkholderia pseudomallei K96243"
	[2] "Project id : 57733"
	
	data(Bacteria)  # list of directories in ftp
	subset(Bacteria, pid ==  57733)
	                                         name mode size       date   pid
	386 Burkholderia_pseudomallei_K96243_uid57733    d 4096 2010-12-06 57733
	
	bpgff <- read.ncbi.ftp( "Burkholderia_pseudomallei_K96243_uid57733", "gff")
	bpgff
	GRanges with 2 ranges and 4 metadata columns:
	       seqnames       ranges strand |       locus     feature              description        gene
	          <Rle>    <IRanges>  <Rle> | <character> <character>              <character> <character>
	  [1] NC_006350 [   1, 1116]      - |    BPSL0001         CDS carboxylate-amine ligase            
	  [2] NC_006350 [1161, 2375]      - |    BPSL0002         CDS     hypothetical protein   

	table(values(bpgff)$feature)

	    CDS miscRNA  pseudo    rRNA    tRNA 
	   5728       8     126      12      61 
     

The summaryTag function lists the locus tag prefixes, suffixes and tag ranges from coding regions that are needed to search PMC and also create the string pattern to search the XML for locus tags  (alternately, the locus tags or gene names could be used as a dictionary to find matches within the document, but in many cases there are new locus tags and expecially gene names in the literature that are not found within GFF3 files)

	summaryTag(bpgff)
	$prefix
	BPSL BPSS 
	3399 2329 

	$suffix
	 a  A  b  B  c  d 
	36 42  3  6  1  1 

	$range
	[1]    1 3431

	$digits
	   4 
	5728 

Finally, check if features within the GFF3 file are sorted  and then save the the tags (needed for range expansion described later) and optionally gene names.

	is.sorted(bpgff)
	bplocus <- values(bpgff)$locus
	bpgenes<- sort(unique(unlist( strsplit(values(bpgff)$gene, ",") )))


## Find relevant publications 

The next step is to 













, which returns 46 [publications](/inst/doc/bp_refs.tab) with 2959 locus tag [citations](/inst/doc/bp.tab). 




	bpgff <- read.ncbi.ftp( "Burkholderia_pseudomallei_K96243_uid57733", "gff")
	
	tags <- "(BPSL0* OR BPSL1* OR BPSL2* OR BPSL3* OR BPSS0* OR BPSS1* OR BPSS2*)"
	bp <- ncbiPMC(paste(tags, "AND (Burkholderia[TITLE] OR Burkholderia[ABSTRACT]) AND open access[FILTER]")) 
	
	pmcLoop(bp, tags= bpgff, prefix = "BPS[SL]" , suffix= "[abc]",  file="bp.tab")


## Details





