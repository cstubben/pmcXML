#  parse searchPMC output and (optionally?) expand tag ranges

#  used by findTags.R 
# if digits is NA (or not numeric) then use 1 or more numbers 
## suffix is optional 

# May 8, 2013 - add notStartingWith to parse HP and not JHP tags in Helicobacter..
## USES a negative lookbehind 
##  str_extract_all("HP0001,HP0002 but not JPH0003", perl( "(?<!J)HP[0-9]{4}" ) )

# y = searchPMC output -change name?

parseTags<-function(y, tags, prefix, suffix, notStartingWith, expand=TRUE, digits = 4 ){
   ## check suffix
   if(!missing(suffix) ){
      if(nchar(suffix)>1){
         if(!grepl("^(\\[|\\()", suffix)){
         stop('suffix should be single letter "a" or character class "[ac]"  or grouping brackets "(a|c|\\.1)"')
         }
      }
   } 

   tag <- paste(prefix, "[0-9]+", sep="")  # 1 or more
   if(is.numeric(digits ) )  tag <- paste(prefix, "[0-9]{", digits, "}", sep="")   
   # replace long dash   en dash "\u2013"  - OR all u2010 to u2014?
   y$mention <- gsub("–", "-", y$mention)
   y$mention <-  gsub(" *- *", "-", y$mention)

   ## fix newlines AND tabs
   y$mention <- gsub("\n *", "", y$mention)
   y$mention <- gsub("\t *", " ", y$mention)
    
   # add suffix 
   if( !missing(suffix) ) tag<- paste(tag, suffix, "?", sep="")
             
   ## ALL IDs.  str_extract_all in stringr package
   ## use IGNORE case - 

   tag1 <- tag
   if(!missing(notStartingWith)){
      tag1 <- paste("(?<!", notStartingWith, ")", tag1, sep="")
   }
   ids0 <- str_extract_all(y$mention, perl( ignore.case( tag1  ) ) )

## EXPAND ranges...
   if(expand){ 
      ## IDs including ranges  tag1 to tag2 OR tag1-tag2 OR tag1-n
      ## FIX?  should skip "compare tag1 to tag2" if "compare" in sentence!

# July 31, 2015  range may include prefix BP1026B_I0126-I0135  (added [AI]? below)

      ids <- str_extract_all(y$mention,  perl( ignore.case( paste(tag1, " to ", tag, "|", tag1, "-", tag, "|",  tag1,"-[AI]?[0-9]+|", tag1, sep=""  ) )) )
 
      ## Expand ranges
      n <- grepl("-|to", ids)
      if(sum(n) > 0) ids[n] <- lapply(ids[n], function(y) unlist(lapply(y, seqIds, tags= tags )))
  
      ## locus may be in range and directly cited... select unique
      ids <- lapply(ids, unique) 
 
      ## check if ID is part of range (by comparing to IDs in that specific mention)
      ## fix - lower case range converted to uppercase...

      ## inRange <- !unlist( mapply(function(x,y) x %in% y, ids, ids0, SIMPLIFY=FALSE)) 
      inRange <- !unlist( mapply(function(x,y) toupper(x) %in% toupper(y), ids, ids0, SIMPLIFY=FALSE) )

      n2 <- sapply(ids, length)
      if(sum(n) > 0 ) message("Expanded ", sum(n), " matches to ", paste(n2[n], collapse=", "), " tags")
      ids <- unlist(ids)
     
      y <- data.frame( source= rep(y$section, n2),  locus=ids, range=inRange,  mention= rep(y$mention, n2), stringsAsFactors=FALSE)
   }else{
      n2 <- sapply(ids0, length)
      ids <- unlist(ids0)
      
       y <- data.frame( source= rep(y$section, n2),  locus=ids, mention= rep(y$mention, n2), stringsAsFactors=FALSE)
    }
   ## fix tag prefix... rv, Rv, RV and remove duplicates (sometime same sentence/row with 2 prefixes, eg, bpsl2179 AND BPSL2179) 
     # prefix without special characters like [] or ?,  use gsub... 
   if(  grepl("^[A-Za-z_]+$", prefix) ) {     
      y$locus <- gsub(prefix, prefix, y$locus, ignore.case=TRUE)
   }else{   
      ## else use UPPER case? - may not work for all tag prefixes! (do not change suffix!) - 
      ##   do not change tags in RANGES, may include RNAS like  VCr  VCt and VCAt - only change searched tags VC and VCA  (fix vc, Vc, vca, Vca )   
      n <- !y$range   # in case all ranges - should not happen (fixed lower case range in parse tags)
      if(sum(n) > 0){
         n2 <- min(nchar(y$locus[n]))
         y$locus[!y$range] <- paste(toupper(substr(y$locus[n],1,(n2-1) )), substring(y$locus[n], n2), sep="")
      }
   }
   y <- unique(y)
   message(nrow(y), " locus tags cited (", length(unique(y$locus)), " unique)" )
   y
}
