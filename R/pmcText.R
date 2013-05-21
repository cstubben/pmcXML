# split PMC xml into sentences with section labels

pmcText<-function(doc, references = FALSE ){

   z <- vector("list")
   z[["Main title"]] <- splitP( xpathSApply(doc, "//front//article-title", xmlValue) )
   z[["Abstract"]] <- splitP( xpathSApply(doc, "//abstract//p", xmlValue) )

   ## BODY - split into main sections

   x <- getNodeSet(doc, "//body/sec")
   ## IF no  sections? - see PMC3471637 
   if(length(x)==0){
       x <- getNodeSet(doc, "//body") 
   }
 
   ## LOOP through body sections
   for(i in 1: length(x) ){
      doc2 <- xmlDoc(x[[i]])
      title <-  xvalue(doc2, "//title")   # xpathSApply(doc2, "/sec/title", xmlValue)  # xvalue returns NA instead of list()
      title <- gsub("^[0-9.]* (.*)", "\\1", title )  # remove numbered sections
   
       ## get paragraphs, but not within footnotes, captions or containing table-wrap tags (since cell values will be mashed together - only a few PMC ids)
      y <-  xpathSApply(doc2, "//p[not(ancestor::table-wrap|ancestor::caption|descendant::table-wrap)]", xmlValue)
       z[[title ]] <- splitP( y) 
      free(doc2)
   }
   # SINCE only main sections are parsed, get list of all section titles
   z[["Section title"]] <- xpathSApply(doc, "//sec/title", xmlValue) 
   z[["Figure caption"]]     <- splitP( xpathSApply(doc, "//fig/caption/title", xmlValue) )
   z[["Figure text"]]        <- splitP( xpathSApply(doc, "//fig/caption/p", xmlValue) )
   z[["Table caption"]]      <- splitP( xpathSApply(doc, "//table-wrap/caption", xmlValue))
   z[["Table footnotes"]]    <- splitP( xpathSApply(doc, "//table-wrap-foot/fn", xmlValue))
   z[["Supplement caption"]] <-         xpathSApply(doc, "//supplementary-material/caption/p[1]", xmlValue)
  if(references)  z[["References"]] <-  xpathSApply(doc, "//ref//article-title" , xmlValue) 


# CONVERT to dataframe ?
## z <-data.frame( section=rep(names(z), sapply(z, length) ), cite=unlist(z))
# OR leave as list
## package(tm) - convert using Corpus(VectorSource(z))

z

 
}




