## format references using cited number...

ref <- function( label,  pmcXML=doc){
   n <- length(label)
   refs <- vector("list", n) 
   for(i in 1:n ){
      z <- getNodeSet( pmcXML, paste("//ref/label[text()=", label[i], "]/..", sep="") )

## FIX July 25, 2013--  see PMC3175480  USES <ref id="B2">  AND <xref ref-type="bibr" rid="B2">2</xref> to cite -
      if(is.null(z)){
             rid <-  paste("B",  label[i], sep="")
             print(paste("Warning: No //ref/label node found, trying //ref[@id='", rid, "']", sep=""))
             z <- getNodeSet( pmcXML, paste("//ref[@id='", rid , "']", sep="") )
}

      z2 <- xmlDoc(z[[1]])

      a1 <- xpathSApply(z2, "//surname", xmlValue)
      a2 <- xpathSApply(z2, "//given-names", xmlValue)
      a3 <-  paste(a1, a2)
      if (length(a3) > 2) {
         a3 <- paste(c(a3[1:2], "et al"), collapse = ", ")
      }else {
         a3 <- paste(a3, collapse = ", ")
      }
      year <- xpathSApply(z2, "//year", xmlValue)
      title <- xpathSApply(z2, "//article-title", xmlValue)
      title <- gsub("\\.$", "", title)  ## may or may not have period
      journal <- xpathSApply(z2, "//source", xmlValue)
      volume <- xpathSApply(z2, "//volume", xmlValue)
      pages <- paste( xpathSApply(z2, "//fpage", xmlValue), xpathSApply(z2, "//lpage", xmlValue), sep="-")
      pages <- gsub("-$", "", pages)
      refs[[i]]<- paste(label[i], ". ", a3, ". ", year, ". ", title,  ". ", journal, " ", volume, ":", pages, ".", sep="")
      free(z2)
   }
   unlist( refs )
}

   
 
