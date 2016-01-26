# Get XML from PMC-OAI service  (Pubmed Central Open Archives Initiative)

# http://www.ncbi.nlm.nih.gov/pmc/tools/oai/

pmcOAI <- function(id,  ...){
  
   # check for PMC prefix (needed for attribute)
   if(!grepl("^PMC[0-9]+$", id))  stop("Please use a PMC id like PMC3443583")

   # no prefix for URL string
   id2 <- gsub("PMC", "", id)

   # file name for attributes
   file  <- paste("http://www.ncbi.nlm.nih.gov/pmc/articles/", id, sep="")
 
   # use getURL in RCurl package (readlines returns incomplete line warning and does not get errors (just 404 NOT found)
  #  url <- "http://www.pubmedcentral.nih.gov/oai/oai.cgi?verb=GetRecord&metadataPrefix=pmc&identifier=oai:pubmedcentral.nih.gov:"   
     url <- "http://www.ncbi.nlm.nih.gov/pmc/oai/oai.cgi?verb=GetRecord&metadataPrefix=pmc&identifier=oai:pubmedcentral.nih.gov:"

   x <- getURL( paste0(url, id2), .encoding="UTF-8", ...)
   
   #error codes=  idDoesNotExist  OR cannotDisseminateFormat (not Open Access)  
   if (grepl("<error code", x[1])) {
      error <- gsub('.*error code="([^"]+).*', "\\1", x[1])
      if(error=="idDoesNotExist") stop("No results found using ", id)

      message("No full text in Open Access Subset, downloading metadata only" )        
    #  url <- "http://www.pubmedcentral.nih.gov/oai/oai.cgi?verb=GetRecord&metadataPrefix=pmc_fm&identifier=oai:pubmedcentral.nih.gov:"
       url <- "http://www.ncbi.nlm.nih.gov/pmc/oai/oai.cgi?verb=GetRecord&metadataPrefix=pmc_fm&identifier=oai:pubmedcentral.nih.gov:"

      x <- getURL( paste0(url, id2), .encoding="UTF-8", ...)
  
   }
   # Remove namespace for easier XPath queries
#   x[1] <- gsub(" xmlns=[^ ]*" , "", x[1])
# see PMC4515827 with tab before xmlns,  \txmlns=
   x[1] <- gsub("xmlns=[^ ]*" , "", x[1])

   ## ADD ^ caret symbol inside all superscripts tags 
   x <- gsub("<sup>", "<sup>^", x)
   ## Also add ^ caret to hyperlink footnotes in tables with xref tags like <xref ref-type="table-fn" rid="tf1-1">a</xref>
   n <- grep("table-fn", x)
   x[n] <- gsub(">([^<])</xref>", ">^\\1</xref>", x[n])

   doc <- xmlParse(x)  
 
   ## ADD attributes  
   attr(doc, "id") <- id
   attr(doc, "file") <- file
   doc
}

