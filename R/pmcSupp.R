# supplmentary materials in XML only  
#  use getSupp to download tables using file name in comments

pmcSupp <-function( doc , sentence = TRUE ){
   x <- getNodeSet(doc, "//supplementary-material" )
   if( length(x) == 0){
      message("No supplementary-material tag found")
      NULL
   }else{
      f1 <- sapply(x, xpathSApply, "./label", xmlValue)
      if (length(unlist(f1) ) == 0) {
         message("WARNING: No label tag found")
         # check xpathSApply(x[[1]], "./*", xmlName)
         ## ONLY caption and media tags - see PMC4390269
         f2 <- sapply(x, xpathSApply, "./caption/title", xmlValue)   
         z <- lapply(x, xpathSApply, "./media", xmlGetAttr, "href")
         names(z) <- f2
      }else{
         f1 <- gsub("[ .]+$", "", f1)
         # check for titles
         f2 <- sapply(x, xpathSApply, "./caption/title", xmlValue)
         f2p <-  sapply(x, function(y) paste( xpathSApply(y, "./caption/p", xmlValue), collapse=". "))
         if(length(unlist(f2)) == 0){
            #message("NOTE: NO caption/title")
            f2 <- f2p  # no paragraphs??
         }else{
            f2 <- paste(f2, f2p, sep=". ")
         }
         f2 <- gsub("..", ".", f2, fixed=TRUE)
         f2 <- gsub(" Download $", "", f2) 

         z <-  lapply(f2, splitP)
         cap <-  sapply(z, "[", 1)
         cap <- gsub("\\.$", "", cap)
          
         z <- lapply(z, function(x) paste(x[-1], collapse=" "))
         names(z) <- paste(f1, cap, sep=". ")
         if(sentence) z <- lapply(z, splitP)

         ## ADD file name as comment
         ids <- sapply(x, xpathSApply, "./media", xmlGetAttr, "href")
         ids <- paste("http://www.ncbi.nlm.nih.gov/pmc/articles", attr(doc, "id"), "bin", ids, sep="/")    
   
         for(i in 1: length(z) ){
            message(paste(" ",  f1[i], ". ", cap[i], sep="" ))
            comment(z[[i]] ) <-  ids[i]
         }
      z
      }
   }
}  
