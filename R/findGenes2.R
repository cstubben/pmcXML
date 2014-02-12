## Methods to find gene names


#2 Gene names in italics with length = 4.  Misses genes with 3 or 5 characters - includes other italicized names in Journal titles and elsewhere (Cell Host..) 
#3 Protein names with initial and final capital, e.g. SpoT

## many genes part of mutant strain name.... ΔfptA

findGenes2 <- function(doc, three=FALSE){


   # skip references? also check //front and //body ?  
#ONLY in paragraph tags?   //body gets tables, equations, captions and others
   it <-  xpathSApply(doc, "//body//p//italic", xmlValue)  
    # drop species
    it <- it[!grepl("^[A-Z]\\. [a-z]", it)]
    it <- it[!grepl("^[A-Z][a-z]{5}", it)]

   # SPLIT comma separated lists
   # gph, trpS, pepD, accBC, mutS, ppc, cydAB, fadBA, fadL, fumA, mdh
it <- unlist( strsplit(it, ", *"))
   # and operons like rpsP-rimM-trmD-rplS
it <- unlist( strsplit(it, "- *"))

   ## also operons like tauABCD ?  use 3 or more to avoid groEL, bmaII and others - some 5 char genes should be split like virAG). Also need way to search for mention
 n <- grep("[a-z]{3}[A-Z]{3}", it)
if(length(n)>0){
     z <- vector("list", length(n))
     for(i in 1:length(n)){
         print(paste("Splitting", it[n][i]))
         z[[i]] <- paste(substr(it[n][i],1,3), unlist(strsplit(substring(it[n][i],4), "")), sep="")
     }
     it <- c(it[-n], unlist(z))  
}
   ## GENES have 3 letters and then capital or number in 4th char (avoid 1439 or N_KEGG and others - any letter keeps human genes mostly?
  # n <- grep("a-z]{3}[A-Z0-9]", substr(it, 1,4) ) - skip ILV1 or HIS3 and other genes in all caps?
 n <- grep("[A-Za-z]{3}[A-Z0-9]", substr(it, 1,4) )


   n3 <- which( nchar(it)==3 )
   if(length(n3)>0){
     if(three){
         n <- c(n, n3)
     }else{
        
        print(paste("Found", paste0(unique(it[n3]), collapse=", ") , " with 3 characters.  Set three=TRUE to include in list"))

     }
   }
     genes <- it[n]
# drop initial cap  
   n <- grep("^[A-Z][a-z]{2}", genes) 
  if(length(n)>0)   genes[n] <-   paste(tolower(substr(genes[n], 1,1)), substring(genes[n], 2) , sep="")


  print(paste("Found ", length(genes), " gene mentions (", length(unique(genes)), " unique)", sep="")) 

  ## CHECK proteins
   txt <- pmcText(doc)
   
      ## PROTEINS - can start beginning of sentence.  Some proteins with numbers, but will get Chr1, Chr2 etc 
      proteins <- searchP(txt, "[A-Z][a-z]{2}[A-Z][^a-zA-Z]", ignore.case=FALSE)
      proteins <-  unlist( str_extract_all(proteins$mention, "[A-Z][a-z]{2}[A-Z]") )
# count new protein names
      n <- sum(!unique(tolower(proteins)) %in% unique(tolower(genes)))
          print(paste("Found ", length(proteins), " protein mentions (", n, " new)", sep="" )) 

          prot2  <- paste(tolower(substr(proteins, 1,1)), substring(proteins, 2) , sep="")

         genes <- table(c(genes, prot2)) 
    genes
}






