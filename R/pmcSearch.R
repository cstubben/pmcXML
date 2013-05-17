# Search PMC xml file by sections


pmcSearch <- function(doc, pattern, ...){
  
   ## 3 parts to pmc XML: front (incl abstract), body (main article) and back (references)
   ## ONLY searches abstract and body 

   # PLOS may have two abstracts,  Abstract and Author summary  
   x1 <- getNodeSet(doc, "//abstract")
   ## no title in abstract 
   title1 <- "Abstract"

   # split body into sections (and skip subsections) 
   x2 <- getNodeSet(doc, "//body/sec[not(ancestor::sec)]")

   x <- c( x1, x2)
   ## IF no abstract OR sections? - see PMC3471637 
   if(length(x)==0){
       x<- getNodeSet(doc, "//body") 
       title1 <- ""
   }

   z <- vector("list", length(x))
   ## LOOP through sections
   for(i in 1:length(x)){
      doc2 <- xmlDoc(x[[i]])
      #  when i==1, use title1
      title <- ifelse(i == 1, title1,  xvalue(doc2, "//title") )  
                 
      y <- searchXML(doc2, pattern, ...)     

      free(doc2)

      if(length(y) > 0)  z[[i]] <- cbind(title, y)
   }
  z <- do.call("rbind", z)
  if(!is.null(z)){
     z <- data.frame(z, stringsAsFactors=FALSE)
     names(z) <- c("section", "citation")
     z <- unique(z)   # may have dups if path="//*"   - use /* instead?
     rownames(z) <- NULL
     z$section <- gsub("^[0-9.]* (.*)", "\\1", z$section )  # remove numbered sections
     z$section <- gsub("\n", "", z$section )  # some newlines
  }
  z
}
