ncbiPMC <- function(term, ... )
{ 
   if(length(term) > 1){ term  <- paste(term, collapse = ",") }  
   # use efetch to get full text with retmode="xml"

   term <- gsub("PMC", "", term)
   # CHECK if IDs (and skip esearch)
   if( grepl("^[0-9,]*$", term)){
     x <- esummary(term, "pmc", version="2.0", parse=FALSE)
   }else{
     x <- esummary(esearch(term, "pmc"), version="2.0", parse=FALSE)
   } 
   # authorsN=3, journalFull=TRUE 
   parse_pmc_XML(x, ...)

}
