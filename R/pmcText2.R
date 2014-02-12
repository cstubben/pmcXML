# split PMC xml into sentences with section labels (Incl ALL subsection titles in single delimited string)

pmcText2<-function(doc, references = FALSE ){

   z <- vector("list")
   z[["Main title"]] <- splitP( xpathSApply(doc, "//front//article-title", xmlValue) )
   z[["Abstract"]] <- splitP( xpathSApply(doc, "//abstract//p", xmlValue) )

   ## BODY - split into main sections

   x <- getNodeSet(doc, "//body/sec")
   ## IF no  sections? - see PMC3471637 
   if(length(x)==0){
       x <- getNodeSet(doc, "//body") 
   }
       # abstract ONLY ?? PMC2447356
   if(length(x) > 0){
   ## LOOP through body sections
   for(i in 1: length(x) ){
      doc2 <- xmlDoc(x[[i]])

      y <- xpathSApply(doc2, "//sec/title", xmlValue)
      n <- xpathSApply(doc2, "//sec/title", function(y) length(xmlAncestors(y) ))
      path <- path.string(y, n)
       sep <- "'"
      for(i in 1:length(y) ){
          ##  need to change separator if quote in section titles like "Authors' contribution -
          if(grepl("'", y[i])) sep<-'"'
          y2 <-  xpathSApply(doc2, paste("//sec/title[.=", y[i], "]/../p", sep= sep), xmlValue)
          if(length(y2)>0)  z[[ path[i] ]] <- splitP(y2) 
      }
      free(doc2)
   }
   # SINCE only main sections are parsed, get list of all section titles
   z[["Section title"]] <- xpathSApply(doc, "//sec/title", xmlValue) 
   z[["Figure caption"]]     <- splitP( xpathSApply(doc, "//fig/caption/title", xmlValue) )
   z[["Figure text"]]        <- splitP( xpathSApply(doc, "//fig/caption/p", xmlValue) )
   z[["Table caption"]]      <- splitP( xpathSApply(doc, "//table-wrap/caption", xmlValue))
   z[["Table footnotes"]]    <- splitP( xpathSApply(doc, "//table-wrap-foot/fn", xmlValue))
   z[["Supplement caption"]] <-  splitP( xpathSApply(doc, "//supplementary-material/caption/p[1]", xmlValue))
  if(references)  z[["References"]] <-  xpathSApply(doc, "//ref//article-title" , xmlValue) 
}

# CONVERT to dataframe ?
## z <-data.frame( section=rep(names(z), sapply(z, length) ), cite=unlist(z))
# OR leave as list
## package(tm) - convert using Corpus(VectorSource(z))

# add attributes

attr(z, "id") <- attr(doc, "id")
z

 
}




