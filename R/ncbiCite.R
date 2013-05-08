# get formatted citation, citedby or references from PMC OR pubmed id

ncbiCite <-function(id,  fetch="citation" , ...){
   pmc <- substr(id,1,3) == "PMC"
   if(fetch %in% 1:3) fetch <- c("citation", "citedby", "references")[fetch] 

   if(fetch=="citation"){
      if(pmc){  x <- ncbiPMC(id) 
      }else{    x <- ncbiPubmed(id) }
      bibformat(x, width=300)
   }else{
      ## NEED pmid for links
      id2<- id
      if( pmc ){
         id2 <- as.numeric( substring(id2, 4) ) # remove PMC for elink
         id2 <- elink(id2, dbfrom="pmc",  db="pubmed", linkname="pmc_pubmed", cmd="neighbor")
      }
      # CITED by pmc articles
      if(fetch=="citedby"){
        xml <- esummary( elink(id2, dbfrom="pubmed", db="pmc",  linkname="pubmed_pmc_refs"), version="2.0", parse=FALSE)
        x <- parse_pmc_XML(xml)
        print(paste("Found", nrow(x), "PMC articles citing", id))
      ## REFERENCES
      }else{
        xml <-esummary ( elink(id2,   linkname="pubmed_pubmed_refs"),  version="2.0", parse=FALSE)
        x <- parse_pubmed_XML( xml )
        print(paste("Found", nrow(x), "references cited in",  id))
      }     
      x <- x[order(x$authors),]
      rownames(x)<-NULL
      x
   }
}
