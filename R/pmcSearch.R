# Search PMC xml file by sections


pmcSearch <- function(doc, pattern, ...){
  
   ## 3 parts to pmc XML: front (incl title & abstract), body (main article) and back (references)

   # MAIN text.  split body into main sections 
   x <- getNodeSet(doc, "//body/sec")
   ## IF no  sections? - see PMC3471637 
   if(length(x)==0){
       x <- getNodeSet(doc, "//body") 
   }
   n <- length(x)
   z <- vector("list", n + 4)


   ## SEARCH title
   y <- searchXML(doc, pattern, "//front//article-title")
   if(length(y) > 0)  z[[1]] <- cbind("Main title", y)

   # ABSTRACT ...  PLOS may have two abstracts,  Abstract and Author summary  
   y <-  searchXML(doc, pattern, "//abstract//p")
   if(length(y) > 0)  z[[2]] <- cbind("Abstract", y)

  
   ## LOOP through body sections
   for(i in 1:n){
      doc2 <- xmlDoc(x[[i]])
      title <-  xvalue(doc2, "//title")    
       ## search by paragraphs without table-wrap tags 
      y <- searchXML(doc2, pattern, ...)     
      free(doc2)
      if(length(y) > 0)  z[[ i + 2 ]] <- cbind(title, y)
   }

   ## Section titles...
   y <- searchXML(doc, pattern, "//sec/title")
   if(length(y) > 0)   z[[ n + 3]] <- cbind("Section title", y)

   ## include REFERENCES?
    y <- searchXML(doc, pattern, "//ref//article-title")
   if(length(y) > 0)   z[[ n + 4]] <- cbind("References", y)


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
