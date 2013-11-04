## find sentences citing pmid - only works if brackets within xref tag  <xref>[3]

xref <- function(doc, id){
   # find reference with pub-id = pmid (and go up two levels to get xref id attribute )
   rid <- xpathSApply(doc, paste( "//pub-id[text()='", id, "']/../..", sep=""), xmlAttrs) 

   if( is.null(rid )) {
      stop("No references with PMID ", id) 
   }else{
      txt <- pmcText(doc)
      ## search using label within xref tags (may be repeated outside xref tags?)
      label <- unique( xpathSApply(doc, paste("//xref[@rid='", rid, "']", sep=""), xmlValue) )

      ## TEXT only search by label... search [22] or (22) or any 22 (may or may not be reference!) but NOT  21-24 

      searchP(txt, label, fixed=TRUE, ignore.case=FALSE)
   }
}
