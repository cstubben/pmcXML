
##  bplocus <- values(bpgff)$locus

findLocusBP<-function(doc, ...){
  id<- attr(doc, "id")
   tag <- "BPS[SL][0-9]{4}[^0-9_]"
 
   ## should not use before or after options IF locus tags are found in those sentences (will be counted twice!)
   y <-  pmcSearch(doc, tag, ...)

    
   ## check for unmarked sections in html
   y2 <-searchXML(doc,tag )
   ## if y is null, use 0 to avoid logical(0)
   if(length(y2) !=  ifelse(is.null(y), 0, nrow(y))){
      y2 <- y2[!y2 %in% y$citation]
      if(length(y2)>0){
         print(paste("Found" , length(y2), "citations in unknown sections"))
         y <- rbind(y, data.frame( section="Unknown", citation=y2, stringsAsFactors=FALSE))
      }
   }
   if(!is.null(y)){
       print(paste("Matched", nrow(y), "sentences"))
      y <- parseTags(y, bplocus, "BPS[SL]", "[abc]", expand=TRUE, digits=4 )
       ## add ID
       y <-data.frame(id, y, stringsAsFactors=FALSE)
   }
   y
}

