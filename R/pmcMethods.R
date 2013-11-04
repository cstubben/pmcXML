# split METHODS only 

pmcMethods <-function(doc ){

   z <- vector("list")
   ## get methods section  - 2 ways?
   x <- getNodeSet(doc, "//body/sec[contains(@sec-type, 'methods')]/sec")
print(paste("Checking @sec-type:", length(x), "subsections"))

   x <- getNodeSet(doc, "//body/sec/title[contains(translate(text(), 'METHODS', 'methods'), 'methods')]/../sec")
   if(is.null(x)) {
      print("No section title containing Methods found")
   }else if(length(x)==0){
      print("No subsections in Methods")
   }else{
      print(paste("Found", length(x), "subsections in Methods"))
      ## LOOP through body sections
      for(i in 1: length(x) ){
         doc2 <- xmlDoc(x[[i]])
         title <-  xvalue(doc2, "//title")  
          ## get paragraphs
         y <-  xpathSApply(doc2, "//p", xmlValue)
         z[[title ]] <- splitP( y) 
         free(doc2)
      }
   }
   z
}




