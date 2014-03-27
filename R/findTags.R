## need locus tags from GFF file  values(bpgff)$locus
##  avoid V. cholerae strain tags... VC274080_0898   or VC0395_A2856?
## tag <- paste(prefix, "[0-9]{4}[^0-9_]", sep="")  
# or Helicobacter strain j99 tags -- HP not JHP_   
# txt should be list returned by pmcText or table

findTags <-function(txt, tags, prefix, suffix, notStartingWith, expand=TRUE, digits=4, na.string="", ...){

   id <- attr(txt, "id")

   if(is.null(id)) stop("Missing ID attribute")

   if(is.data.frame(txt) ){
      ## use label and caption for source?
      label <- attr(txt, "label")
      txt <- list(  Table = collapse3(txt ) )
      names(txt) <- label
      attr(txt, "id") <- id
   }


     ## one or more digits
   tag <- paste(prefix, "[0-9]+", sep="")
   ## exactly 4 digits - will not match if tag at end of table row    or primers with underscore BPSL0001_f1  -- NEED for vibrios
   # if(is.numeric(digits ) )  tag <- paste(prefix, "[0-9]{", digits, "}[^0-9_]", sep="")   
   # avoid before or after since tags will also be extracted. If tag in table caption, 
   # then that will be repeated... see PMC1525188 for problems
   y <-  searchP(txt, tag , na.string=na.string, ...)
   if(!is.null(y)){
      print(paste(nrow(y), "matches"))
      y <- parseTags(y, tags, prefix, suffix, notStartingWith, expand, digits )
      ## may not extract any tags if using notStartingWith
      if(nrow(y) == 0){
         y <- NULL
      }else{
         ## add ID
         y <- data.frame(id, y, stringsAsFactors=FALSE)

      }
   }
   y  
}


#
