

pmcLoop<-function( pmcresults, tags, prefix, suffix="" , file="locus.tab", notStartingWith, expand=TRUE, digits=4 ){
   for(j in 1:nrow( pmcresults)) {
      id  <- pmcresults$pmc[j]
      print(paste(j, ". Checking ", pmcresults$title[j], sep=""))
      doc <- pmc(id)  

      x1 <- pmcText(doc)
 
      y <- findTags(x1, tags, prefix, suffix, notStartingWith, expand, digits)
      if(is.null(y)){
         print("WARNING: no locus tags in full text")
      }else{
         writeLocus( y, file )
      }
      # TABLES
      x <- pmcTable(doc, verbose=FALSE)
      if( is.list(x) ){
         for (i in 1:length(x)){
             xtag <- paste(prefix, "[0-9]+", sep="")
             if(is.numeric(digits ) )  xtag <- paste(prefix, "[0-9]{", digits, "}[^0-9_]", sep="")   
             hasTags <- searchTable(x[[i]] , xtag )  
        
            if(hasTags){
               print(paste(" Found tags in", paste( names(x[i]), attr(x[[i]], "caption"), sep=". ") )) 
               ## check for subheadings
              if(ncol(x[[i]]) >1){
                  hasSubs <-  apply(x[[i]][1,-1,FALSE], 1, function(z) all(  is.na(z) | z=="NA"| z==""| z=="\u00A0"))
                  if(hasSubs){
                      print(" REPEATING subheadings") 
                      x[[i]]<- repeatSub(x[[i]])
                  }
               }
               # y <- citeTable(x[[i]], tags, prefix, suffix, notStartingWith, expand, digits)

               # add caption after...see PMC1525188 for problems

               y <-  findTags(x[[i]], tags, prefix, suffix, notStartingWith, expand, digits, caption =FALSE)

               if(!is.null(y)){
                  y$citation  <- paste("Caption=", attr(x[[i]], "caption") , ";", y$citation, sep="")
                  writeLocus( y, file )
                }
 
            }
         }
      }
      print("")
   }
}
