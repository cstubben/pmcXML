# Get XML from pmc OAI OR HTML from PMC website

## update August 13, 2013

pmc <- function(id, local=TRUE, dir="~/downloads/pmc", ...){
   
   # check for PMC prefix 
   if(!grepl("^PMC", id))  id<- paste("PMC", id, sep="")

   file <- paste("http://www.ncbi.nlm.nih.gov/pmc/articles/", id, sep="")

   localfile <- paste(dir, "/", id, sep="")
   xmlfile <- paste(localfile, ".xml", sep="")
   htmlfile <- paste(localfile, ".html", sep="")

   #########################
   if(local && file.exists( xmlfile ) ){
      message("Loading local XML copy")
      doc <- xmlParse( xmlfile)  
   }else if(local && file.exists( htmlfile ) ){
      message("Loading local HTML copy")
      doc <- htmlParse( htmlfile  )
   }else{
   #########################
      url <- "http://www.pubmedcentral.nih.gov/oai/oai.cgi?verb=GetRecord&metadataPrefix=pmc&identifier=oai:pubmedcentral.nih.gov:"
       # no prefix
      id2 <- gsub("PMC", "", id)
      # will complain about incomplete final line
      x <- suppressWarnings( try(readLines(paste(url, id2, sep=""), ...), silent=TRUE))
     
      if(class(x)[1] == "try-error"){
         ## NOT in open access subset
          x <- suppressWarnings( try( readLines(file)  , silent=TRUE))

         if(class(x)[1] == "try-error"){
            stop("No results found")
         }else{
            ## SEE Open Access Subset description at http://www.ncbi.nlm.nih.gov/pmc/tools/openftlist/
             #  The publisher of this article does not allow downloading of the full text in XML form
            message("No XML results in Open Access Subset.  Downloading HTML from PMC (please check copyright restrictions)")

             x <- gsub("<sup>", "<sup>^", x)
              x <- gsub("<sub>", "<sub>_", x)   ## subscripts -  use _ like Latex math 

            ## SPECIAL characters
            x <- gsub("â\u0080²", "'", x)  ## 3' and 5'
            x <- gsub("–", "-", x)         ## long dashes
            x <- gsub("&#x02013;", "-", x)
            x <- gsub("\u00A0", " ", x)     # nbsp

            doc <- htmlParse( x)
            saveXML(doc, file= htmlfile )
         }
      }else{
         # remove namespace (from OAI)
         x[1] <- gsub(" xmlns=[^ ]*" , "", x[1])
      
         ## SPECIAL characters
         x <- gsub("â\u0080²", "'", x)  ## 3' and 5'
         x <- gsub("–", "-", x)         ## long dashes
         x <- gsub("\u00A0", " ", x)     # nbsp

         ## replace ALL superscripts and subscripts
         x <- gsub("<sup>", "<sup>^", x)
         x <- gsub("<sub>", "<sub>_", x)   ## use _ like Latex math 
## Bib cross-references?  should include RID in text...
# <xref ref-type="bibr" rid="B13">
#        x <- gsub('(<xref ref-type="bibr"[^>]*)>', "\\1>XREF#", x)
#        x <- gsub('(<xref ref-type="bibr"[^>]*)>', "\\1>XREF#", x)

         ## AND hyperlinked footnotes in TABLES only
         n <- grep("table-fn", x)
         x[n] <- gsub(">([^<])</xref>", ">^\\1</xref>", x[n])
         doc <- xmlParse(x)
         saveXML(doc, file= xmlfile )
      }
   }
   ## ADD attributes  
   attr(doc, "id") <- id
   ## pmid is unique identifier for all articles (pmc or not) - PMID may be missing from NEW articles...
   attr(doc, "pmid") <- pmid(doc)
   attr(doc, "file") <- file
   doc
}

