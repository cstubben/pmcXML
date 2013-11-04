## split PMC into sentence/row and write to text file 

pmcWrite<-function( pmcresults ,file="pmc.txt" ){

   for(j in 1:nrow( pmcresults)) {
      id  <- pmcresults$pmc[j]
      print(paste(j, ". Checking ", pmcresults$title[j], sep=""))
      doc <- pmc(id)  

      txt <- pmcText(doc)

      # TABLES
      x <- pmcTable(doc, verbose=FALSE, simplify=FALSE)
      if( is.list(x) ){
         ## check for subheadings?
         for (i in 1:length(x)){
            if(ncol(x[[i]]) >1){
               hasSubs <-  apply(x[[i]][1,-1,FALSE], 1, function(z) all(  is.na(z) | z=="NA"| z==""| z=="\u00A0"))
               if(hasSubs){
                  print(paste(" REPEATING subheadings in", names(x)[i]) )
                  x[[i]]<- repeatSub(x[[i]])
               }
            } 
         }
       x <- lapply(x, collapse2)
       txt <- c(txt, x)
      }
     names(txt) <- tolower(names(txt))
     x <- unlist(lapply(names(txt), function(x) paste(id, x,  txt[[x]], sep="\t")))
     write(x, file= file, append=TRUE)
   }
}
