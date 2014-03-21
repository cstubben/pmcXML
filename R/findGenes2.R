## Methods to find gene names

# find gene names in italics
# source("~/plague/R/packages/pubmed/R/findGenes2.R")


findGenes2 <- function(doc ){

   it <-  xpathSApply(doc, "//body//p//italic", xmlValue)  
  
    # drop species like E. coli
    it <- it[!grepl("^[A-Z]\\. [a-z]", it)]
    # drop words like Burkholderia  - initial cap and 5 letters
    it <- it[!grepl("^[A-Z][a-z]{5}", it)]

   # SPLIT comma separated lists
   # gph, trpS, pepD, accBC, mutS, ppc, cydAB, fadBA, fadL, fumA, mdh
   n <- grep(",", it)
    if( length(n)>0  ){
       print(paste("Found possible gene list:", it[n]))         
       it <- unlist( strsplit(it, ", *"))
    }
       # and operons like rpsP-rimM-trmD-rplS
    n <- grep("-", it)
    if( length(n)>0 ){
       print(paste("Found possible gene range:", it[n]))   
       it <- unlist( strsplit(it, "- *"))
    }
    ## also operons like tauABCD ?  use 3 or more to avoid groEL, bmaII and others - some 5 char genes should be split like virAG). 
 
    n <- grep("[a-z]{3}[A-Z]{3}", it)
    if(length(n)>0){
        print(paste("Found possible operon:", it[n]))  
        z <- vector("list", length(n))
        for(i in 1:length(n)){
          z[[i]] <- paste(substr(it[n][i],1,3), unlist(strsplit(substring(it[n][i],4), "")), sep="")
        }
        it <- c(it[-n], unlist(z))  
      }
   ## GENES have 3 letters and then capital or number in 4th char (avoid 1439 or N_KEGG and others - any letter keeps human genes mostly?
  # n <- grep("a-z]{3}[A-Z0-9]", substr(it, 1,4) ) - skip ILV1 or HIS3 and other genes in all caps?
 n <- grep("[A-Za-z][a-z]{2}[A-Z0-9]", substr(it, 1,4) )

   n3 <- which( nchar(it)==3 )
   if(length(n3)>0){
         n <- c(n, n3)
   }

     genes <- it[n]
# drop initial cap  
   n <- grep("^[A-Z][a-z]{2}", genes) 
  if(length(n)>0)   genes[n] <-   paste(tolower(substr(genes[n], 1,1)), substring(genes[n], 2) , sep="")


  print(paste("Found ", length(genes), " possible gene mentions in italics (", length(unique(genes)), " unique)", sep="")) 

 
   table( genes)


 
}






