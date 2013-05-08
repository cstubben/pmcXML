
## ncbiPubmed in genomes uses efetch

## this uses esummary

ncbiPubmed2<-function(term, ... )
{ 
   if(length(term) > 1){ 
     x <- esummary(term, version="2.0", parse=FALSE)
   }else{
     x <- esummary(esearch(term), version="2.0", parse=FALSE)
   } 
   # authorsN=3, journalFull=TRUE 
   parse_pubmed_XML(x, ...)

}
