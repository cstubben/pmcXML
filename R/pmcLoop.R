pmcLoop <- function( pmcresults, tags, prefix, suffix , file="locus.tab", notStartingWith, expand=TRUE, digits=4 ){

  if(class(tags) == "GRanges") tags <- values(tags)$locus

   for(j in 1:nrow( pmcresults)) {
      id  <- pmcresults$pmc[j]
      message(paste(j, ". Checking ", pmcresults$title[j], sep=""))
      doc <- pmcOAI(id)  

      x1 <- pmcText(doc)
 
      y <- suppressMessages(findTags(x1, tags, prefix, suffix, notStartingWith, expand, digits) )
      if(is.null(y)){
         message(" NO locus tags in full text")
      }else{
         writeLocus( y, file )
          message(paste(" Found", nrow(y), "tags in full text"))
      }
      # TABLES
      x <- suppressMessages( pmcTable(doc, simplify=FALSE) )
      if( is.list(x) ){
         for (i in 1:length(x)){
            y <- suppressMessages( findTags(x[[i]], tags, prefix, suffix, notStartingWith, expand, digits) )
            if(!is.null(y)){
               message(paste(" Found", nrow(y), "tags in", paste( names(x[i]), attr(x[[i]], "caption"), sep=". ") )) 
               writeLocus( y, file )         
            }
         }
      }
      message("")
   }
}
