# uses PMC-OAI service only (Pubmed Central Open Archives Initiative)
# NOTE: pmc function gets HTML from pmc website IF XML not available from OAI (also tries efetch if OAI is down)

# id should be PMC id like "PMC3443583"

pmcOAI <- function(id, local=TRUE, dir="~/downloads/pmc",  ...){
   
   # check for PMC prefix 
   if(!grepl("^PMC[0-9]+$", id))  stop("Please include a valid PMC id like PMC3443583")
   # file name for attributes
   file      <- paste("http://www.ncbi.nlm.nih.gov/pmc/articles/", id, sep="")
   xmlfile   <- paste(dir, "/", id, ".xml", sep="")
   
   #########################
   if(local && file.exists( xmlfile ) ){
      print("Loading local XML copy")
      doc <- xmlParse( xmlfile)  
   }else{
   #########################
      url <- "http://www.pubmedcentral.nih.gov/oai/oai.cgi?verb=GetRecord&metadataPrefix=pmc&identifier=oai:pubmedcentral.nih.gov:"
       # no prefix
      id2 <- gsub("PMC", "", id)
      # will complain about incomplete final line
      x <- suppressWarnings( readLines(paste(url, id2, sep=""), ...))
     
      if(grepl("<error", x[1])){
         ## NOT in open access subset
         x <- try( readLines(file)  , silent=TRUE)
         if(class(x)[1] == "try-error"){
            stop("No results found using ", id)
         }else{
            ## SEE Open Access Subset description at http://www.ncbi.nlm.nih.gov/pmc/tools/openftlist/
             # error = The publisher of this article does not allow downloading of the full text in XML form
            stop("No results in Open Access Subset (publisher does not allow downloading of full text XML)")
         }
      }else{
         # if pmc OAI not working ?
         if(length(x) == 0 ){ 
            stop("WARNING: Cannot connect to PMC OAI service")
         }else{
            # remove namespace (from OAI) - for EASIER xpath queries
            x[1] <- gsub(" xmlns=[^ ]*" , "", x[1])
         }

         ## FIX some SPECIAL characters
         x <- gsub("â\u0080²", "'", x)  ## 3' and 5'
         x <- gsub("–", "-", x)         ## long dashes
         x <- gsub("\u00A0", " ", x)     # nbsp

         ## ADD ^ caret symbol inside all superscripts tags 
         x <- gsub("<sup>", "<sup>^", x)
         ## ALso add ^ caret to hyperlink footnotes in column headers and other table cells with xref tags  <xref ref-type="table-fn" rid="tf1-1">a</xref>
         n <- grep("table-fn", x)
         x[n] <- gsub(">([^<])</xref>", ">^\\1</xref>", x[n])

         doc <- xmlParse(x)
          ## save file to reload from local copy (may change the display of some special characters)
         saveXML(doc, file= xmlfile )
      }
   }
   ## ADD attributes  
   attr(doc, "id") <- id
   attr(doc, "file") <- file
   doc
}

