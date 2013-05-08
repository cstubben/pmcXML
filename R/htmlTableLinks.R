## OR list table links - needed for getTable

htmlTableLinks<-function(doc){
  y<- xpathApply(doc, "//a[@target='table']", xmlAttrs)
 if (length(y) == 0) {
        print("No table links found")
    }
    else {
        z <-sapply( y, "[[", "href")
        ## z <- gsub(".*PMC[0-9]*/(.*)/", "\\1", z) 
         unique( z )      
    }
}
