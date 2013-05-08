## need locus tags from GFF file  values(bpgff)$locus

# could automatically find prefix and suffix in vector of tags?
# table(substring(ftlocus, 8))

## some have two prefixes like BPSS and BPSL (and BPS[SL] may not work - check!)

## add option of length of number ID string = 4 - always padded???

  ## HOW to avoid V. cholerae strains... VC274080_0898   or VC0395_A2856?
## tag <- paste(prefix, "[0-9]{4}[^0-9_]", sep="")    



findLocus <-function(doc, tags, prefix, suffix, expand=TRUE, digits=4, ...){

   id<- attr(doc, "id")
  
   ## one or more digits
   tag <- paste(prefix, "[0-9]+", sep="")

   ## exactly 4 digits
   if(is.numeric(digits ) )  tag <- paste(prefix, "[0-9]{", digits, "}[^0-9_]", sep="")   
 
   ## should not use before or after options IF locus tags are found in those sentences (will be counted twice!)
   y <-  searchXML(doc, tag , ...)

   if(!is.null(y)){
      print(paste("Matched", nrow(y), "sentences"))
      y <- parseTags(y, tags, prefix, suffix, expand, digits )
       ## add ID
       y <-data.frame(id, y, stringsAsFactors=FALSE)
   }
   y  
}


#
