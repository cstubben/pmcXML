htmlLoop <- function( pmcresults, tags, prefix, suffix , file="locus.tab", notStartingWith, expand=TRUE, digits=4 ){

  if(class(tags) == "GRanges") tags <- values(tags)$locus

   for(j in 1:nrow( pmcresults)) {
      id  <- pmcresults$pmc[j]
      print(paste(j, ". Checking ", pmcresults$title[j], sep=""))
      doc <- pmc(id)  

      x1 <- htmlText(doc)
 
      y <- findTags(x1, tags, prefix, suffix, notStartingWith, expand, digits)
      if(is.null(y)){
         print("WARNING: no locus tags in full text")
      }else{
         writeLocus( y, file )
      }

      # TABLES
      x <- getTable(doc, verbose=FALSE, simplify=FALSE)
      if( is.list(x) ){
         for (i in 1:length(x)){
             xtag <- paste(prefix, "[0-9]+", sep="")
             if(is.numeric(digits ) )  xtag <- paste(prefix, "[0-9]{", digits, "}[^0-9_]", sep="")   
             hasTags <- searchTable(x[[i]] , xtag )  
        
            if(hasTags){
               print(paste(" Found tags in", paste(attr(x[[i]], "label") , attr(x[[i]], "caption"), sep=". ") )) 
               ## check for subheadings
              if(ncol(x[[i]]) >1){
                  hasSubs <-  apply(x[[i]][1,-1,FALSE], 1, function(z) all(  is.na(z) | z=="NA"| z==""| z=="\u00A0"))
                  if(hasSubs){
                      print(" REPEATING subheadings") 
                      x[[i]]<- repeatSub(x[[i]])
                  }
               }
               # add caption after...see PMC1525188 for problems with locus tag in caption
               y <-  findTags(x[[i]], tags, prefix, suffix, notStartingWith, expand, digits, caption =FALSE)
               if(!is.null(y)){
                  y$mention  <- paste("Caption=", attr(x[[i]], "caption") , ";", y$mention, sep="")
                  writeLocus( y, file )
                }
            }
         }
      }
      print("")
   }
}
