## find species in pubmed articles using italics tags


findSpecies <-function(doc ){

   x <-xpathSApply(doc, "//article/*[self::front or self::body]//italic", xmlValue)
    ## trim spaces
    x<- gsub(" *$", "", x)
    # one space? to avoid list of genes and other italics
    spx <- x[grep("^[^ ]* [^ ]*$", x)]

   # OR any space?
   # spx <-  x[grep(" ", x)]

   spx<- gsub(",$", "", spx)

 # not species -  drop anything that does not start with Capital Letter
   # in vivo, in vitro, bona fide, et al, de novo, ...
   spx <-  spx[!grepl("^[a-z]", spx)]
   ## others...
   not_species<-c("SI Text", "P value", "In silico", "Boolean function")
   spx <- spx[!spx %in% not_species]

   print(paste("Found", length(spx), "mentions")) 
   ## fix E. coli (often without full name cited first)
   spx <- gsub("E. coli",  "Escherichia coli", spx)

   spx <-unabbrev(spx)
   spx
}








