# split PMC xml into sentences with section labels

## TO do : 
# 1. add option to use sentDetect in openNLP package instead of splitP. 
#  splitP is a kludge I wrote before finding sentDetect and does not always work.  
# However, in some cases, openNLP does not detect sentence breaks, for example when "I" is at the end of a sentence (which is common in many protein names).
# TRY --  sentDetect("Another name for ENZYME entry EC 5.99.1.2 is DNA topoisomerase I. This enzyme is involved in ATP-dependent breakage of single-stranded DNA")

## 2.  add option to parse by subsections - see pmcText2 for test code


pmcText<-function(doc, references = FALSE, anyP=FALSE ){

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
      title <-  xvalue(doc2, "//title")   # xpathSApply(doc2, "/sec/title", xmlValue)  # xvalue returns NA instead of list()
      title <- gsub("^[0-9.]* (.*)", "\\1", title )  # remove numbered sections
      title <- gsub("\n", "", title ) # remove new lines
   
       ## get paragraphs, but not within tables or captions or containing tables or formulas (since cell values will be mashed together)
       y <-  xpathSApply(doc2, "//p[not(ancestor::table-wrap|ancestor::caption|descendant::table-wrap|descendant::disp-formula)]", xmlValue)

        # THESE two queries should also work and could replace the long line above     
        ## y <-  xpathSApply(doc2, "//sec/title/../p", xmlValue)
        #  y <-  xpathSApply(doc2, "//sec/p[preceding-sibling::title]", xmlValue)

    # OR any paragraph except nested paragraphs
     if(anyP)  y <-  xpathSApply(doc2, "//p[not(ancestor::p)]", xmlValue)  

       z[[title ]] <- splitP( y) 
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




