
# source("~/plague/R/packages/pmcXML2/R/pmcFigure.R")

pmcFigure <- function(doc,  attr = FALSE ){

   x <-  getNodeSet(doc, "//fig" )
   if (length(x) > 0) {

      ## some captions may have label, caption/title and caption/p tags...
      f1 <- sapply(x, xpathSApply, "./label", xmlValue)
      f1 <- gsub("[ .]+$", "", f1)

      # Always use title for caption(or first sentence in case of long titles?)
      f2 <- sapply(x, xpathSApply, "./caption/title", xmlValue)

      if(length(unlist(f2) )==0){
         message("NOTE: NO caption/title")
         f2 <- sapply(x, xpathSApply, "./caption", xmlValue)
      }else{
         f2p <-  sapply(x, function(y) paste( xpathSApply(y, "./caption/p", xmlValue), collapse=". "))
         f2 <- paste(f2, f2p, sep=". ")
      }
      f2 <- gsub(": ", ". ", f2, fixed=TRUE)
      f2 <- gsub("..", ".", f2, fixed=TRUE)
      z <-  lapply(f2, splitP)
      cap <-  sapply(z, "[", 1)
      cap <- gsub("\\.$", "", cap)
          
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

