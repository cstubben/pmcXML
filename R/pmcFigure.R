
# source("~/plague/R/packages/pmcXML2/R/pmcFigure.R")

pmcFigure <- function(doc,  attr = FALSE ){

   x <-  getNodeSet(doc, "//fig" )
   if (length(x) > 0) {

      ## should have label and caption (and caption with title and p)
      f1 <- sapply(x, xpathSApply, "./label", xmlValue)
      f1 <- gsub("[ .]+$", "", f1)

      # get caption since some missing caption titles or have long caption title names that should be split 
      f2 <- sapply(x, xpathSApply, "./caption", xmlValue)

      cap <- gsub("([^:;.]+).*", "\\1", f2)
       p1 <- gsub("[^:;.]+(.*)", "\\1", f2)
       p1 <- gsub("^[:;.] ?", "", p1)
   
      z <- as.list(p1)
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

