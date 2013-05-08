## 

citeTable<-function(x,  tags, prefix, suffix, expand=TRUE, digits=4, ...){

   ## collapse first.  ... for na.string 
   citation <- collapse2(x, ...)
   
   y <- data.frame( section = attr(x, "label"), citation)

   z <- parseTags(y, tags, prefix, suffix, expand, digits)

   #add caption to citation (for searching)
   capt <- attr(x, "caption")
   capt <- gsub("\n", "", capt) # remove newlines, eg table 2 in PMC2867773
   z$citation <- paste("Caption=", capt , ";", z$citation, sep="")
   ## ADD id
   z <-  data.frame( id=attr(x, "id"), z, stringsAsFactors=FALSE)
   z
  
}

