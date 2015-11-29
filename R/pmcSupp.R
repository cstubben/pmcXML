# supplmentary materials in XML only  
#  use getSupp to download tables using file name in comments (or include number of supplement to download)

pmcSupp <-function( doc , n, sentence = TRUE ){
   x <- getNodeSet(doc, "//supplementary-material" )
   if( length(x) == 0){
      message("No supplementary-material tag found")
      NULL
# get List of supplements
   }else if( missing(n) ){
      f1 <- sapply(x, xpathSApply, "./label", xmlValue)
      f2 <- sapply(x, xpathSApply, "./caption/title", xmlValue)   
      ids  <- sapply(x, xpathSApply, "./media", xmlGetAttr, "href")

      if (length(unlist(f1) ) == 0) {
         if( grepl("index.html$", ids[1]) ){
             # see PMC4390269
            message("WARNING: Possible link to separate HTML supplementary contents page")
             supp_contents_page <- paste("http://www.ncbi.nlm.nih.gov/pmc/articles", attr(doc, "id"), "bin", ids[1], sep="/")
            doc2 <- htmlParse( suppressWarnings(readLines(supp_contents_page)) )
        
             # should be 1 less than number of files
             cap <-   xpathSApply( doc2, "//li", xmlValue )
             cap <- gsub(" - ", ". ", cap, fixed=TRUE)
             cap <- gsub("\\. *$", "", cap)
              z <- as.list(ids)
             names(z) <- c(f2, cap)
         }else{
             if (length(unlist(f2) ) == 0){
                    message("WARNING: No label or caption tag found" )
                    z<- as.list(sapply(x, function(y) paste( xpathSApply(y, ".//p", xmlValue), collapse=". ")) )
             }else{
                  message("WARNING: No label tag found" )
                 f2p <-  sapply(x, function(y) paste( xpathSApply(y, ".//caption/p", xmlValue), collapse=". "))
                 z <- as.list(f2p)
                 names(z) <- c(f2)
                 if(sentence) z <- lapply(z, splitP)
             }
         } 
      }else{
         f1 <- gsub("[ .]+$", "", f1)

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
     }

      ## ADD file name as comment

      ids <- paste("http://www.ncbi.nlm.nih.gov/pmc/articles", attr(doc, "id"), "bin", ids, sep="/")    
      for(i in 1: length(z) ){
          message(" ", i, ". " , names(z)[i] )
         comment(z[[i]] ) <-  ids[i]
      }
      z
   }else{
      ids <- sapply(x, xpathSApply, "./media", xmlGetAttr, "href")
      ids <- paste("http://www.ncbi.nlm.nih.gov/pmc/articles", attr(doc, "id"), "bin", ids, sep="/") 
      getSupp(ids[n])
   }
}  
