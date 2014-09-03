#  split PMC xml into subsections

pmcText <- function(doc, sentence=TRUE, openNLP=FALSE ){

   z <- vector("list")
   z[["Main title"]] <-  xpathSApply(doc, "//front//article-title", xmlValue) 
   z[["Abstract"]] <-  xpathSApply(doc, "//abstract//p", xmlValue) 

   ## BODY 
    x <- getNodeSet(doc, "//body//sec")
   # TO do : check PMC3471637 and other EID papers without sections

   sec <- xpathSApply(doc, "//body//sec/title", xmlValue)
   n <- xpathSApply(doc, "//body//sec/title", function(y) length(xmlAncestors(y) ))
   path <- path.string(sec, n)

   y <- lapply(x, function(y) xpathSApply(y, "./p", xmlValue))
  
    ##LOOP through subsections
      for(i in 1: length(y) ){
         if(length(y[[i]]) > 0)  z[[path[i] ]] <- y[[i]]
      }
      z[["Section title"]] <- sec

      f1 <- xpathSApply(doc, "//fig/label", xmlValue)
      if( length(f1) > 0){
         f2 <- xpathSApply(doc, "//fig/caption/title", xmlValue)
         f3 <- xpathSApply(doc, "//fig/caption/p", xmlValue)
         z[["Figure caption"]]     <-  paste(f1, f2, f3) 
      }
      f1 <- xpathSApply(doc, "//table-wrap/label", xmlValue)
      if( length(f1) > 0){
         f2<- xpathSApply(doc, "//table-wrap/caption", xmlValue)
         z[["Table caption"]]      <- paste(f1, f2) 
      }
      ## table footnotes
      ### z[["Table footnotes"]]    <- xpathSApply(doc, "//table-wrap-foot/fn", xmlValue)

      f1 <- xpathSApply(doc, "//supplementary-material/label", xmlValue)
      if( length(f1) > 0){
         f2<- xpathSApply(doc, "//supplementary-material/caption", xmlValue)
         z[["Supplement caption"]] <-   paste(f1, f2) 
      }

   if(sentence){
        if(openNLP){  
                z <- lapply(z, sentDetect)
                z <- lapply(z, function(x) gsub(" $", "", x) )
              }else{
                 z <- lapply(z, splitP)
              }
   }
   # add attributes
   attr(z, "id") <- attr(doc, "id")
   z
}




