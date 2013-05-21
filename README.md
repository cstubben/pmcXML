# pubmed

`pubmed` is an `R` package to download and parse XML documents from [Pubmed Central](http://www.ncbi.nlm.nih.gov/pmc) (PMC).  There are over 2.7 million full-text articles in PMC and 22% are available for text mining in the [Open Access](http://www.ncbi.nlm.nih.gov/pmc/tools/openftlist) (OA) subset.  The number of OA publications is increasing rapidly each year and 67% of PMC articles published in 2012 are open access (view [code](/inst/doc/pmc_growth.R) ).  

![PMC growth](/inst/doc/pmc_growth.png)

Due to the rapid growth of microbial genome sequencing and the lack of model prokaryotic organism databases (containing high-quality annotations linking features to literature), our main objective is to use the OA subset as a genome annotation database and extract features from reference microbial genomes directly from the literature. Initially, we are focusing on locus tags, but many other features such as gene names, accession numbers, sequences and coordinates (start/stop) should be collected before attempting to summarize functional annotations.  Our goal is to extract passages containing locus tags from *full text, tables and supplements* and output tab-delimited files in a variety of formats, for example, as GFF3 files that can be viewed in a genome browser.  This guide describes some of the functions included within the package by using *Burkholderia pseudomallei* as an example.



## Download Reference Genomes

The [Burkholderia pseudomallei](http://www.ncbi.nlm.nih.gov/genome/476) page in Entrez Genomes lists the Reference genome (strain K96243). This strain may also be identified using the `referenceGenome` function, which searches Entrez genome using a species name.  The next step is to identifiy the organism directory in the Genomes ftp site (ftp.ncbi.nlm.nih.gov/genomes/Bacteria) and download annotations and sequences.  The organism directory includes the name and project id and can also be found in the Bacteria dataset.  The `read.ncbi.ftp` function reads most types of RefSeq files on the site including GFF3 files below.   


	referenceGenome("Burkholderia pseudomallei")
	[1] "Reference genome, Community selected, UniProt : Burkholderia pseudomallei K96243"
	[2] "Project id : 57733"
	
	data(Bacteria)  # list of directories in ftp
	subset(Bacteria, pid ==  57733)
	                                         name mode size       date   pid
	386 Burkholderia_pseudomallei_K96243_uid57733    d 4096 2010-12-06 57733
	
	bpgff <- read.ncbi.ftp( "Burkholderia_pseudomallei_K96243_uid57733", "gff")
	bpgff
	GRanges with 5935 ranges and 4 metadata columns:
	       seqnames       ranges strand |       locus     feature              description        gene
	          <Rle>    <IRanges>  <Rle> | <character> <character>              <character> <character>
	  [1] NC_006350 [   1, 1116]      - |    BPSL0001         CDS carboxylate-amine ligase            
	  [2] NC_006350 [1161, 2375]      - |    BPSL0002         CDS     hypothetical protein  
	  ... 

	table(values(bpgff)$feature)

	    CDS miscRNA  pseudo    rRNA    tRNA 
	   5728       8     126      12      61 
     

The summaryTag function lists the locus tag prefixes, suffixes and tag ranges from coding regions.  These are needed to search PMC and also create the string pattern to extract locus tags from the XML  (alternately, the locus tags or gene names could be used as a dictionary to find matches within the document, but in many cases there are new locus tags and especially gene names in the literature that are not found within GFF3 files)

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

Finally, this check if the features within the GFF3 file are sorted and then saves the tags and gene names.

	is.sorted(bpgff)
	bplocus <- values(bpgff)$locus
	bpgenes <- sort(unique(unlist( strsplit(values(bpgff)$gene, ",") )))


## Find relevant publications 

The next step is to find publications containing any *B. pseudomallei* K96243 locus tag.  Searching for a single locus tag in a full-text database like PMC is straightforward, for example, enter "BPSS1492" in the search box and this returns 10 articles (accessed May 20, 2013).  To find all full-text articles with any locus tag, we use the tag prefix and first digit from the GFF3 file to build wildcard searches, in this case "(BPSL0* OR BPSL1* OR BPSL2* OR BPSL3* OR BPSS0* OR BPSS1* OR BPSS2*)" since there are two chromosomes.  We restrict the number of spurious matches by limiting the results to articles with the genus name in the title or abstract. We also find matches to articles in the OA subset only since these are available for text-mining as XML.  This query returns 46 [publications](/inst/doc/bp_refs.tab).


	tags <- "(BPSL0* OR BPSL1* OR BPSL2* OR BPSL3* OR BPSS0* OR BPSS1* OR BPSS2*)"
	bp <- ncbiPMC(paste(tags, "AND (Burkholderia[TITLE] OR Burkholderia[ABSTRACT]) AND open access[FILTER]")) 
	bp[1:10,]
	          pmc                                   authors year                                                                                                                                     title                                          journal volume   pages   epubdate     pmid
	1  PMC3623717         Hara Y, Chin CY, Mohamed R, et al 2013                                    Multiple-antigen ELISA for melioidosis - a novel approach to the improved serodiagnosis of melioidosis                          BMC Infectious Diseases     13     165 2013/04/04 23556548
	2  PMC3607239           Puah SM, Puthucheary S, Chua KH 2013 Potential Immunogenic Polypeptides of Burkholderia pseudomallei Identified by Shotgun Expression Library and Evaluation of Their Efficacy        International Journal of Medical Sciences     10 539-547 2013/03/13 23532805
	3  PMC3579680 Janse I, Hamidjaja RA, Hendriks AC, et al 2013                            Multiplex qPCR for reliable detection and differentiation of Burkholderia mallei and Burkholderia pseudomallei                          BMC Infectious Diseases     13      86 2013/02/14 23409683
	4  PMC3564208      Choh LC, Ong GH, Vellasamy KM, et al 2013                                                                                             Burkholderia vaccines: are we moving forward? Frontiers in Cellular and Infection Microbiology      3       5 2013/02/05 23386999
	5  PMC3540353                                Dowling AJ 2013                                       Novel gain of function approaches for vaccine candidate identification in Burkholderia pseudomallei Frontiers in Cellular and Infection Microbiology      2     139 2013/01/09 23316481
	6  PMC3527420     Chen R, Barphagha IK, Karki HS, et al 2012               Dissection of Quorum-Sensing Genes in Burkholderia glumae Reveals Non-Canonical Regulation and the New Regulatory Gene tofM                                         PLoS ONE      7  e52150 2012/12/20 23284909
	7  PMC3521395        Khoo JS, Chai SF, Mohamed R, et al 2012                  Computational discovery and RT-PCR validation of novel Burkholderia conserved and Burkholderia pseudomallei unique sRNAs                                     BMC Genomics     13     S13 2012/12/07 23282220
	8  PMC3443583         Ong HS, Mohamed R, Firdaus-Raih M 2012  Comparative Genome Sequence Analysis Reveals the Extent of Diversity and Conservation for Glycan-Associated Proteins in Burkholderia spp              Comparative and Functional Genomics   2012  752867 2012/09/06 22991502
	9  PMC3419357   Burtnick MN, Heiss C, Roberts RA, et al 2012                            Development of capsular polysaccharide-based glycoconjugates for immunization against melioidosis and glanders Frontiers in Cellular and Infection Microbiology      2     108 2012/08/15 22912938
	10 PMC3418162             Chieng S, Carreto L, Nathan S 2012                                                                       Burkholderia pseudomallei transcriptional adaptation in macrophages                                     BMC Genomics     13     328 2012/07/23 22823543


## Download PMC XML

The XML version of Open Access articles are downloaded from the Open Archives Initiative (OAI) service using the `pmcOAI` function.  This function also adds carets (^) within superscript tags and hyperlinked table footnotes for displaying as plain text (for example, BPSL0075<sup>a</sup> is displayed as BPSL0075^a and not BPSL0075a since both BPSL0075 and BPSL0075a are valid tag names).  The function also saves a local copy for future use  (and will use that copy instead of downloading a second time).  Finally, the function uses the `xmlParse` function from the [XML](http://cran.r-project.org/web/packages/XML/index.html) package to read the file and generate the XML tree within the R session, so objects are stored as an `XMLInternalDocument` class and can be queried using XPath expressions. In this example, the last reference in the list above from [Chieng et al 2012](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3418162) is loaded into R using the OAI service.

	id <- "PMC3418162"
	doc <- pmcOAI(id)

 A number of different XPath queries can be used to explore the document content and a few are described below, but a complete discussion is beyond the scope of this guide. Two important functions are `xpathSApply` and `getNodeSet`.  For example, this query list all 87 tags and counts the number of occurrences.

	table( xpathSApply(doc, "//*", xmlName))
	
              abstract                    aff                article     article-categories             article-id           article-meta 
                     1                      2                      1                      1                      4                      1 
         article-title                   back                   body                   bold                caption                    col 
                    62                      1                      1                     40                     13                     13 
              colgroup                contrib          contrib-group       copyright-holder    copyright-statement         copyright-year 
                     3                      3                      1                      1                      1                      1 
 

You can search down the XML tree and find the three main nodes of a PMC XML file including front with abstract, body with main text, and back with references. 

	xpathSApply(doc, "//article/child::node()", xmlName)
	[1] "front" "body"  "back"

In some cases, tag names are not specific, so searching up the tree may help to find a specific type of tag.  For example, article-titles are included within the references cited or in the title group and both tags are needed to return the main title.

	table( xpathSApply(doc, "//article-title/parent::node()", xmlName) )
	mixed-citation    title-group 
	            61              1 

	xpathSApply(doc, "//title-group/article-title", xmlValue)
	[1] "Burkholderia pseudomallei transcriptional adaptation in macrophages"


Captions may also be associated with figures, tables and supplements, so listing only table captions requires adding the table-wrap node before the caption.

	table( xpathSApply(doc, "//caption/parent::node()", xmlName) )
	   fig                  media supplementary-material             table-wrap 
  	     8                      1                      1                      3 

	xpathSApply(doc, "//table-wrap/caption", xmlValue)
	[1] "Twenty-five common up-regulated genes of B. pseudomallei during intracellular growth in host macrophages relative toin vitrogrowth"         
	[2] "Gene function enrichment analysis of B. pseudomallei common up-regulated and down-regulated genes throughout growth within host macrophages"
	[3] "List of oligonucleotides used in real-time qPCR experiments" 


The first function below will list all 27 section titles and the second functions lists only the main sections (not subsections). The `pubmed` package use this Xpath query to split the main document into sections using `getNodeSet` and then loops through each section to split the full text into complete sentences.

	xpathSApply(doc, "//sec/title", xmlValue)
	xpathSApply(doc, "//body/sec/title", xmlValue)
	[1] "Background"             "Results"                "Discussion"             "Conclusions"            "Methods"                "Competing interests"   
	[7] "Authors’ contributions" "Supplementary Material"

	x <-getNodeSet(doc, "//body/sec")
	x[[1]]

Finally, the values within italic tags are used to find species and gene names.

	table2( xpathSApply(doc, "//italic", xmlValue) )
	                          Total
	B. pseudomallei              87
	in vitro                     12
	cydB                          4
	in vivo                       4
	rpoS                          4
	atpB                          3
	bimA                          3
	Burkholderia pseudomallei     3
	fhaB                          3
	fhaC                          3


## Parse XML

The `pubmed` package includes three functions to parse full-text, tables and supplements from the XML document (`pmcText, pmcTable, pmcSupp`).  The `pmcText` function splits the XML document into main sections and also includes title, abstract, section titles, and captions from figure, table and supplements (references optional).  In addition, the text within each section is also split into complete sentences by taking care to avoid splitting after genus abbreviations like *E. coli* or other common abbreviations such as Fig., et al., e.g., i.e., sp., ca., vs., and others.  In this example, the `sapply` function is used to count the number of sentences in each section.

	unlist(xpathSApply(doc, "//article", xmlValue))
	x <- pmcText(doc)
	sapply(x, length)

            Main title               Abstract             Background                Results             Discussion 
                     1                      8                     21                     77                     52 
           Conclusions                Methods    Competing interests Authors’ contributions          Section title 
                     3                     68                      1                      4                     27 
           Figure text          Table caption     Supplement caption 
                    37                      5                      1 

	x[1:2]
	`Main title`
	[1] "Burkholderia pseudomallei transcriptional adaptation in macrophages."

	$Abstract
	[1] "Burkholderia pseudomallei is a facultative intracellular pathogen of phagocytic and non-phagocytic cells."  
	[2] "How the bacterium interacts with host macrophage cells is still not well understood and is critical to appreciate the strategies used by this bacterium to survive and how intracellular survival leads to disease manifestation." 
	[3] "Here we report the expression profile of intracellular B. pseudomallei following infection of human macrophage-like U937 cells." 
	[4] "During intracellular growth over the 6 h infection period, approximately 22 % of the B. pseudomallei genome showed significant transcriptional adaptation."


The resulting list of vectors can be converted to a corpus using the text-mining package. 

	package(tm)
	Corpus(VectorSource(x))

The list can also be searched directly using the `grep` function and a wrapper in `pubmed` called `searchP` simplifies these `grep` queries and returns the results as a single table.  The findTags, findGenes and other functions described in the next section also use `searchP` to find matches.

	lapply(x, function(y) grep( "BPS[SL]", y, value=TRUE) )
	searchP(x, "BPS[SL]")
	section                                                                                                                                                                                                                       citation
	1    Results Anaerobic metabolism pathway genes such as BPSS1279 (threonine dehydratase), BPSL1771 (cobalamin biosynthesis protein CbiG) and BPSS0842 (benzoylformate decarboxylase) were up-regulated throughout the infection period.
	3    Results       The major nitrogen source in the intracellular compartment is most likely methylamine and purine as suggested by the increased expression of methylamine utilization protein (BPSS0404) and allantoicase (BPSL2945).
	5    Results                                                 One of the six clusters of the type VI secretion system, the tss-5 cluster (BPSS1493-BPSS1511), was up-regulated up to 182-fold during intracellular infection (Figure 8).
	6    Results                                                         We also observed the induction of genes flanking the tss-5 cluster, bimA (Burkholderiaintracellular motility A)(BPSS1492) and BPSS1512 at 2 to 6 h post-infection.
	7    Results                                                                              Moreover, the hemolysin activator-like protein precursor, fhaC (BPSS1728) gene was significantly up-regulated during intracellular infection.
	8    Results                                       Consistently, the large filamentous hemagglutinin precursor, fhaB (BPSS1727) gene, a potential virulence factor of B. pseudomallei[20], was induced between 2 to 6 h post-infection.
	9 Discussion                                                                                         In this study, high induction of tssD-5 (BPSS1498), an effector Hcp1 protein of T6SS was observed throughout the infection period.



The `pmcTable` function parses the XML tables into a list of data.frames.  This functions uses rowspan and colspan attributes to correctly format and repeat cell values.  For example, [Table 1](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3418162/table/T1) includes a multi-line header spanning four columns which is repeated within each cell and then the mulitple lines are combine into a single header row for display.  The caption and footnotes for each table are also saved as attributes.

	x <- pmcTable(doc)
	[1] "Parsing Table 1 Twenty-five common up-regulated genes of B. pseudomallei during intracellular growth in host macrophages relative to in vitro growth"
	[1] "Parsing Table 2 Gene function enrichment analysis of B. pseudomallei common up-regulated and down-regulated genes throughout growth within host macrophages"
	[1] "Parsing Table 3 List of oligonucleotides used in real-time qPCR experiments"

	x[[1]][1:4, 1:4]
	      Gene                            Description Fold Change (in vivo/in vitro) at the indicated time (h): 1 Fold Change (in vivo/in vitro) at the indicated time (h): 2
	1 BPSL0184 Putative rod shape-determining protein                                                       23.83                                                       15.31
	2 BPSL0842           Benzoylformate decarboxylase                                                       70.27                                                       31.78
	3 BPSL0886                   Hypothetical protein                                                       12.29                                                        8.36
	4 BPSL1067                   Hypothetical protein                                                        8.39                                                        5.15

	attributes(x[[1]])
	$id
	[1] "PMC3418162"
	$file
	[1] "http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3418162/table/T1"
	$label
	[1] "Table 1"
	$caption
	[1] "Twenty-five common up-regulated genes ofB. pseudomallei during intracellular growth in host macrophages relative to in vitro growth"
	$footnotes
	[1] "Note: * Genes selected for real-time qPCR analysis."


Subheadings are common in many tables like [Table 2](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3418162/table/T2) and these may be repeated down the rows using `repeatSub`.  Since main objective is to search tables and display a single row, we collapse the row into a single delimited string containing column names and row values using `collapse2`.  Optionally, table captions and footnotes can be included in the string.  The `searchP` function may also be used to search the tables and returns the table name and matching rows (in collapsed format). 

	t2 <- repeatSub(x[[2]])
        t2
	             subheading                 Functional class or pathway No. of genes regulated No. of genes in genome Significance (p-value)
	1    Up-regulated genes      Benzoate degradation via hydroxylation                      3                     29           3.33 × 10^-2
	2  Down-regulated genes Amino sugar and nucleotide sugar metabolism                     22                     39          7.98 × 10^-10
	3  Down-regulated genes                        Bacterial chemotaxis                     23                     46           2.65 × 10^-9

	collapse2(t2)[1:3]
	[1] "subheading=Up-regulated genes;Functional class or pathway=Benzoate degradation via hydroxylation;No. of genes regulated=3;No. of genes in genome=29;Significance (p-value)=3.33 × 10^-2"         
	[2] "subheading=Down-regulated genes;Functional class or pathway=Amino sugar and nucleotide sugar metabolism;No. of genes regulated=22;No. of genes in genome=39;Significance (p-value)=7.98 × 10^-10"
	[3] "subheading=Down-regulated genes;Functional class or pathway=Bacterial chemotaxis;No. of genes regulated=23;No. of genes in genome=46;Significance (p-value)=2.65 × 10^-9" 
	
	collapse2(t2, TRUE)[1:3]
        searchP(x, "BPS[SL]")

The `pmcSupp` function parses the list of supplementary files and file names into a data.frame.  Currently, most supplementary files may be loaded directly into R using the 'getSupp` function (optionally, the PMC ftp site includes XML versions and all supplementary files and creating a `pmcFTP` function that automatically gets both files is on the to do list).  The `getSupp` read files in a variety of formats including Excel, Word, HTML, PDF, text (and compressed files are automatically unzipped using the unix `unzip` command).   Excel files are read using the `read.xls` function in the gdata package.  We added some extra code to the perl function xls2csv.pl within the package to add carets before superscripts (again, in many cases numeric footnotes are associated with numeric values or character footnotes are added to ends of locus tags which may be a valid suffix).  The entire file is read into a data.frame and reformatted by moving captions and footnotes into attributes and updating column types.   Microsoft Word documents are converted to html files using the Universal Office Converter unoconv and then tables within the html files are read using `readHTMLtable`.  The tables within HTML files are also loaded using `readHTMLtable`.  PDF files are converted to text using the unix script `pdftotext` and the resulting file is read into R using `readLines`.  Most of these files require some manual post-processing (for example, fixing the multi-line header missed by read.xls below). 

	y <- pmcSupp(doc)
	y
	              label                                                                                                                                  caption                    file  type
	1 Additional file 1 List of 1259 common down-regulated genes of B. pseudomallei during intracellular growth in host macrophages relative to in vitro growth. 1471-2164-13-328-S1.xls excel

	s1 <- getSupp(doc, "1471-2164-13-328-S1.xls")
	head(s1)
	      Gene                               Description Fold change (in vivo/in vitro) at the indicated time (h)                   
	1                                                                                                         1.00  2.00  4.00  6.00
	2 BPSL0001                      Hypothetical protein                                                     -4.68 -2.81 -5.56 -3.47
	3 BPSL0004        hupA, DNA-binding protein HU-alpha                                                    -10.39 -7.77 -9.82 -3.07
	4 BPSL0005 Putative cobalamin synthesis protein/P47K                                                     -5.69 -3.97 -5.77 -2.98
	5 BPSL0006                      Hypothetical protein                                                     -6.42 -3.98 -7.50 -6.94
	6 BPSL0008 gspE, general secretory pathway protein E                                                     -6.42 -3.00 -4.74 -4.79


## Find features




with 2959 locus tag [citations](/inst/doc/bp.tab). 

pmcLoop(bp, tags= bpgff, prefix = "BPS[SL]" , suffix= "[abc]",  file="bp.tab")





