#  parse searchXML output and (optionally?) expand tag ranges

#  used by findLocus.R and citeTable.R

# use 1 or more numbers - or 4?
## suffix is optional 


parseTags<-function(y, tags, prefix, suffix, expand=TRUE, digits = 4 ){

 ## check "ac"
  if(nchar(suffix)>1){
     if(!grepl("^(\\[|\\()", suffix)) stop('suffix should be single letter "a" or character class "[ac]"  or grouping brackets "(a|c|\\.1)"')
  } 

  tag <- paste(prefix, "[0-9]+", sep="")  # 1 or more
  if(is.numeric(digits ) )  tag <- paste(prefix, "[0-9]{", digits, "}", sep="")   


   # replace long dash
   y$citation <- gsub("–", "-", y$citation)
   y$citation <-  gsub(" *- *", "-", y$citation)

   ## fix newlines AND tabs
   y$citation <- gsub("\n *", "", y$citation)
   y$citation <- gsub("\t *", " ", y$citation)
    
   # add suffix (only single letters?  tag1a - FIX?  should match tag1.1 )  
   if(!missing(suffix)) tag<- paste(tag, suffix, "?", sep="")
             
   ## ALL IDs.  str_extract_all in stringr package
   ## IGNORE case - default for searchXML
   ids0 <- str_extract_all(y$citation, ignore.case( tag  ) )

## EXPAND ranges...
   if(expand){ 
   
      ## IDs including ranges  tag1 to tag2 OR tag1-tag2 OR tag1-n
      ## FIX?  should skip tag1 to tag2 if "compare" in sentence!
      ids <- str_extract_all(y$citation,  ignore.case( paste(tag, " to ", tag, "|", tag, "-", tag, "|",  tag,"-[0-9]+|", tag, sep=""  ) ))
 
      ## Expand ranges
      n <- grepl("-|to", ids)
      if(sum(n) > 0) ids[n] <- lapply(ids[n], function(y) unlist(lapply(y, seqIds, tags= tags )))
  
      ## locus may be in range and directly cited... select unique
      ids <- lapply(ids, unique) 
 
      ## check if ID is part of range (by comparing to IDs in that specific citation)
      ## fix - lower case range converted to uppercase...

      ## inRange <- !unlist( mapply(function(x,y) x %in% y, ids, ids0, SIMPLIFY=FALSE)) 
      inRange <- !unlist( mapply(function(x,y) toupper(x) %in% toupper(y), ids, ids0, SIMPLIFY=FALSE) )


      n2 <- sapply(ids, length)
      if(sum(n) >0 ) print(paste("Expanded", sum(n), "citations to", paste(n2[n], collapse=", "), "tags"))
      ids <- unlist(ids)
     
      y <- data.frame( source= rep(y$section, n2),  locus=ids, range=inRange,  citation= rep(y$citation, n2), stringsAsFactors=FALSE)
   }else{
      n2 <- sapply(ids0, length)
      ids <- unlist(ids0)
      
       y <- data.frame( source= rep(y$section, n2),  locus=ids, citation= rep(y$citation, n2), stringsAsFactors=FALSE)
    }
   ## fix tag prefix... rv, Rv, RV and remove duplicates (sometime same citation with 2 prefixes, eg, bpsl2179 AND BPSL2179) 
     # prefix without special characters like [] or ?,  use gsub... 
   if(  grepl("^[A-Za-z_]+$", prefix) ) {     
      y$locus <- gsub(prefix, prefix, y$locus, ignore.case=TRUE)
   }else{   
      ## else use UPPER case? - may not work for all tag prefixes! (do not change suffix!) - 
      ##   do not change tags in RANGES, may include RNAS like  VCr  VCt and VCAt - only change searched tags VC and VCA  (fix vc, Vc, vca, Vca )   
      n <- !y$range   # in case all ranges - should not happen (fixed lower case range in parse tags)
      if(sum(n)>0){
         n2 <- min(nchar(y$locus[n]))
         y$locus[!y$range] <- paste(toupper(substr(y$locus[n],1,(n2-1) )), substring(y$locus[n], n2), sep="")
      }
   }
   y <- unique(y)
   print(paste(nrow(y), " locus tags cited (", length(unique(y$locus)), " unique)" , sep=""))
   y
}
