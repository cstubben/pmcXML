## Methods to find gene names

#1 Match to known list of genes  -some genes with common names like 'thiS'.  Many genes not listed in Refseq and other databases.
#2 Gene names in italics with length = 4.  Misses genes with 3 or 5 characters - includes other italicized names in Journal titles and elsewhere (Cell Host..) 
#3 Protein names with initial and final capital, e.g. SpoT

## many genes part of mutant strain name.... ΔfptA

# use gene length= 3:5 ?

findGenes<-function(doc, tag, length=4, proteins=FALSE){

   if(missing(tag)){
      tag<- "//em"  # for HTML
      if(is.xml(doc) ) tag<- "//italic"  
   }

   # skip references? also check //front and //body ?  
#ONLY in paragraph tags?   //body gets tables, equations, captions and others
   n <- unique( xpathSApply(doc, paste("//body//p", tag, sep=""), xmlValue) )
   #  n <- xpathSApply(doc, tag, xmlValue)
   if(length(n) == 0) { 
       print(paste("No", tag, "tags found"))
         x <- NULL
   }else{
    
   ## FIX
   # SPLIT comma separated lists
   # gph, trpS, pepD, accBC, mutS, ppc, cydAB, fadBA, fadL, fumA, mdh
n <- unlist( strsplit(n, ","))
   # and operons
   # rpsP-rimM-trmD-rplS
n <- unlist( strsplit(n, "-"))

   ## what about tauABCD ?  should split to tauA, tauB, tauC, tauD
 
   ## guess gene names based on length
   n <- gdata::trim(n)
   genes <-  unique(  n[nchar(n) %in%  length ] )


   if(is.xml(doc)){
          txt <- pmcText(doc)
       }else{
          txt <- htmlText(doc)
       }

   if(proteins){
      ## PROTEINS - can start beginning of sentence.  Some proteins with numbers, but will get Chr1, Chr2 etc 
      proteins <- searchP(txt, "[A-Z][a-z]{2}[A-Z][^a-zA-Z]", ignore.case=FALSE)
      proteins <- unique( unlist( str_extract_all(proteins$citation, "[A-Z][a-z]{2}[A-Z]") ))
      print(paste("Found", length(genes), "genes and", length(proteins), "proteins")) 
      # sometimes protein names are italicized and this avoids searching for bopA AND BopA (since searches are case-insensitive)
      genes <-sort( unique(tolower(c(genes, proteins) )))
   }else{
       print(paste("Found", length(genes), "genes")) 
   }
   genes <-paste(substr(genes, 1,3), toupper(substr(genes, 4,4)), sep="")

   # compare to known list of GENES?
   ##  genes[genes %in% Knowngenes]

   if(length(genes) == 0){
     x<-NULL
   }else{
     z <- vector("list", length(genes))
     for(i in 1:length(genes)){
        ## should not be part of larger word... 
        ## OR bogus names part of hypenated word like  para-aminobenzoate, but operon ok.. katY-cybC-cybB
        ## gene name "ure" at end of many words like temperature, figure

         x <- searchP(txt,  paste( "[^a-z]", genes[i], "[^a-z]", sep="") )
        if(!is.null(x) )  z[[i]] <-data.frame( gene=genes[i], x, stringsAsFactors=FALSE)
     }
     x <-  data.frame(do.call("rbind", z), stringsAsFactors=FALSE)
   
     if(nrow(x)==0){
        print("No gene citations found")
        x<-NULL
     }else{
        print(paste(nrow(x), "gene citations"))
        names(x)<-c("gene", "source", "citation")
        x<- data.frame( pmid= pmid(doc), x, stringsAsFactors=FALSE)
     }
  }
 }
 x
}






