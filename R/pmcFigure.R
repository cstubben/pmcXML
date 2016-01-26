pmcFigure <- function(doc,  attr = FALSE ){

   x <-  getNodeSet(doc, "//fig" )
   if (length(x) > 0) {

      ## should have label and caption (and caption with title and p)
      f1 <- sapply(x, xpathSApply, "./label", xmlValue)
      f1 <- gsub("[ .]+$", "", f1)

      # get caption title and paragraphs together since some caption titles are missing, in bold tags or have long caption title names that should be split 
      f2 <- sapply(x, xpathSApply, "./caption", xmlValue)

     ## get caption title to first :; or . (check if some caption/title missing a period?)

      z <-  lapply(f2, splitP, "[;:.]")
      cap <-  sapply(z, "[", 1)
      cap <- gsub("\\.$", "", cap) # drop period ??
          
      z <- lapply(z, function(x) paste(x[-1], collapse=" "))

      names(z) <- paste(f1, cap, sep=". ")
       
      if(attr) 
      {
      ## URL  
      ids <- sapply(x, xpathSApply, ".", xmlGetAttr, "id")

      ids <- paste("http://www.ncbi.nlm.nih.gov/pmc/articles", attr(doc, "id"), "figure", ids, sep="/")     
      txt <- pmcText2(doc)

      for(i in 1:length(x) ){
          message(paste(" ",  f1[i], ". ", cap[i], sep="" ))
         attr(z[[i]], "label") <-  f1[i]
         attr(z[[i]], "caption") <-  cap[i]
         attr(z[[i]], "file") <-  ids[i]
         # cite
         fig <- f1[i]  
         # how to match "Fig. 1, 3"

         fig <- gsub("Fig[^ ]*", "Fig[.ure]*", fig)
         cs <- searchP(txt, fig)
         if(!is.null(cs)){
             attr(z[[i]], "cite") <- fixText( as.vector( apply(cs, 1, paste, collapse=". ") )) 
         }else{
            message("No sentences citing " , fig)   
         }
       }
      }else{
        for(i in 1:length(z)) message(" ", names(z)[i])

}
      z
   }else{
      NULL
   }
}

