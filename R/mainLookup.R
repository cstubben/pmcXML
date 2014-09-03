## lookup "IMRD" section titles  for pmcMetadata

mainLookup <-function(y){

       y <- genomes::strsplit2(y, "; ")
  
      z <- ifelse(  grepl("background|intro", y, ignore.case=TRUE),
           "introduction",
      ifelse(grepl("method|material|^experimental", y, ignore.case=TRUE),
           "methods",
      ifelse(grepl("discussion|conclusion", y, ignore.case=TRUE),
           "discussion",
      ifelse(grepl("result", y, ignore.case=TRUE),
           "results", 
     ifelse(grepl("abbreviation", y, ignore.case=TRUE),
           "abbreviations", "NOMATCH")))))

    n <- which(z %in% "NOMATCH")
   if(length(n)>0){
      print(paste("Warning: no match to", paste(y[n], collapse=" AND "), "... USING discussion"))
      z[n] <- "discussion"
   }
   z
}

