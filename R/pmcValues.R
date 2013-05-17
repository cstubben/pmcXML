# print values at xml tag

# replace abstract, title2

# title are section titles -
## article-title in references, so use 
# title = front//article-title  OR //title-group/article-title  OR main

pmcValues <- function(doc, tag="ref", ... ){

  if(tag =="main" ) tag <- "//title-group/article-title"

  # FORMAT references
  if(tag == "ref"){
     x <- xpathSApply(doc, "//ref", xmlValue)
     x <- gsub("([A-Z])\\.([A-Z])", "\\1., \\2", x)
     x <- gsub("([a-z])([A-Z])\\.", "\\1 \\2.", x)

     # REMOVE DOI (some may be missing and will use PMID instead -not sure how to add only @pub-id-type='doi' with xmlChildren below 

     x2 <- xpathSApply(doc, "//mixed-citation", function(x) xmlValue(xmlChildren(x)$`pub-id` ) )

     for (i in 1:length(x)){
        if( grepl("^[0-9]+$",x2[i])   ){
           x[i] <- gsub(x2[i], paste(". PMID=", x2[i], sep="") , x[i], fixed=TRUE)
        }else{
           x[i] <- gsub(x2[i], ". PMID=", x[i], fixed=TRUE)
        }  
     }
     strwrap2(x, ...)
  }else if(tag == "abstract"){
      # check for abstract subtitles?
      x1 <- xpathSApply(doc, "//abstract/sec/title", xmlValue)
      if(length(x1)>0){
         x2 <- xpathSApply(doc, "//abstract/sec/p", xmlValue)
         strwrap2(paste(x1, x2, sep=": "),  exdent=exdent, ... )
      }else{
         x1 <- xpathSApply(doc, "//abstract", xmlValue)
         strwrap2(x1, exdent=0, ...)
      }
   }else{
     tag <- paste("//", tag, sep="")
      x <- xpathSApply(doc, tag, xmlValue)

      if(tag == "//italic"){
           table(x)
      }else{
           strwrap2(x, ...)
      }
   }
}
