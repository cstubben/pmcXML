## Methods to find gene names

#1 Match to known list of genes  -some genes with common names like 'thiS'.  Many genes not listed in Refseq and other databases.
#2 Gene names in italics with length = 4.  Misses genes with 3 or 5 characters
#3 Protein names with initial and final capital, e.g. SpoT

## many genes part of mutant strain name.... ΔfptA

# use gene length= 3:5 ?  causes duplicates

findGenesBP<-function(doc, tag, length=4 , proteins=FALSE){

   if(missing(tag)){
      tag<- "//em"  
      if(is.xml(doc) ) tag<- "//italic"  
   }

   # skip references? check //front and //body ?  
   # n<- xpathSApply(doc, "//body//italic", xmlValue)

   n <- xpathSApply(doc, tag, xmlValue)
   if(length(n) == 0) { 
       print(paste("No", tag, "tags found"))
         x<-NULL
   }else{
   ## should match to list of valid Gene names?

   ## guess gene names based on length
   genes <-  unique(  n[nchar(n) %in%  length ])

   if(proteins){
      ## PROTEINS - can start beginning of sentence.  Some proteins with numbers, but will get Chr1, Chr2 etc 
      proteins <- searchXML(doc, "[A-Z][a-z]{2}[A-Z][^a-zA-Z]", ignore=FALSE)
      proteins <- unique( unlist( str_extract_all(proteins, "[A-Z][a-z]{2}[A-Z]") ))
      print(paste("Found", length(genes), "genes and", length(proteins), "proteins")) 
      # sometimes protein names are italicized and this avoids searching for bopA AND BopA (since searches are case-insensitive)
      genes <-sort( unique(tolower(c(genes, proteins) )))
   }else{
       print(paste("Found", length(genes), "genes")) 
   }
   genes <-paste(substr(genes, 1,3), toupper(substr(genes, 4,4)), sep="")

   # compare to known list of GENES?

    genes<-genes[genes %in% bpgenes]
    print(paste(length(genes), "genes matching RefSeq gene names")) 
     print(genes)
   if(length(genes) == 0){
     x<-NULL
   }else{
     z <- vector("list", length(genes))
     for(i in 1:length(genes)){
        ## should not be part of larger word... 
        ## OR bogus names part of hypenated word like  para-aminobenzoate

         x <- pmcSearch(doc,  paste( genes[i], "[^a-z-]", sep="") )
         x2 <-searchXML(doc, paste( genes[i], "[^a-z-]", sep="") )
         ## if x is null, use 0 to avoid logical(0)
         if(length(x2) !=  ifelse(is.null(x), 0, nrow(x))){
           x2 <- x2[!x2 %in% x$citation]
           if(length(x2)>0){
             #print(paste("Found" , length(x2), "citations in unknown sections"))
             x <- rbind(x, data.frame(section="Unknown", citation=x2))
           }
        }

        if(!is.null(x) ) {
             # drop mutant strains
       #     x<- x[ !grepl(paste("Δ\\[?", genes[i], sep=""),  x$citation),]
             ## drop methods?
            
            if(nrow(x) > 0) z[[i]] <-data.frame( gene=genes[i], x, stringsAsFactors=FALSE)
        }
     }
     x <-  data.frame(do.call("rbind", z), stringsAsFactors=FALSE)
     
     if(nrow(x)==0){
        print("No gene citations found")
        x<-NULL
     }else{
        print(paste(nrow(x), "gene citations"))
        names(x)<-c("gene", "source", "citation")
        x<- data.frame( pmid= attr(doc, "pmid"), x, stringsAsFactors=FALSE)
     }
  }
 }
 x
}






