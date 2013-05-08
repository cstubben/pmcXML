# Search XML by sections

## path to search... use //p for paragraphs  or //* for captions, labels, titles, references, etc.

## default is to skip paragraphs with tables (since cells will be mashed together in one string). 
## Some text before table will be dropped, but only a few  pubmed XML files with table-wrap inside <p> tag

searchXML <- function(doc, pattern, before=0, after=0, path="//p[not(descendant::table-wrap)]", ignore.case=TRUE, htmlSection="h2", ...){
  
   if(is.xml(doc) ){
      ## 3 parts to pmc XML: front (incl abstract), body (main article) and back (references)
      ## ONLY searches abstract and body 

      # split into sections (and skip subsections) 
      x <- getNodeSet(doc, "//body/sec[not(ancestor::sec)]")
      # include abstract
      x <- c( getNodeSet(doc, "//abstract"), x)
      ## IF empty list? -- see PMC3471637
      if(length(x)==0) x<- getNodeSet(doc, "//body")  ## first section (empty) will be abstract below
   }else{
      # HTML    x <- getNodeSet(doc, "//div[h2]")
      x <- getNodeSet(doc, paste("//div[", htmlSection, "]", sep=""))
   }
   z <- vector("list", length(x))
   for(i in 1:length(x)){
      doc2 <- xmlDoc(x[[i]])
         # XML - no title for abstract when i==1
         # PLOS may have 2 abstracts, Abstract and Author summary  
      title <- ifelse(is.xml(doc), ifelse(i == 1, "Abstract",  xvalue(doc2, "//title")), 
                           xvalue(doc2, paste("//", htmlSection, sep="") ))
      y <- searchXMLall(doc2, pattern, before, after, path, ignore.case, ...)     
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
