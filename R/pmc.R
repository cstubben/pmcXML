# Get XML from pmc OAI
pmc <- function(id, local=TRUE, ...){
   
   # check for PMC prefix 
   if(!grepl("^PMC", id))  id<- paste("PMC", id, sep="")

   file <- paste("http://www.ncbi.nlm.nih.gov/pmc/articles/", id, sep="")

   localfile <- paste("~/downloads/pmc/", id, sep="")
   xmlfile <- paste(localfile, ".xml", sep="")
   htmlfile <- paste(localfile, ".html", sep="")

   #########################
   if(local && file.exists( xmlfile ) ){
      print("Loading local XML copy")
      doc <- xmlParse( xmlfile)  
   }else if(local && file.exists( htmlfile ) ){
      print("Loading local HTML copy")
      doc <- htmlParse( htmlfile  )
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
            stop("No results found")
         }else{
            ## SEE Open Access Subset description at http://www.ncbi.nlm.nih.gov/pmc/tools/openftlist/
             #  The publisher of this article does not allow downloading of the full text in XML form
            print("No XML results in Open Access Subset.  Downloading HTML from PMC (please check copyright restrictions)")

             x <- gsub("<sup>", "<sup>^", x)
              x <- gsub("<sub>", "<sub>_", x)   ## or use _ like Latex math  (locus tag with numeric subscript casues problems)

            ## SPECIAL characters
            x <- gsub("â\u0080²", "'", x)  ## 3' and 5'
            x <- gsub("–", "-", x)         ## long dashes
            x <- gsub("&#x02013;", "-", x)
            x <- gsub("\u00A0", " ", x)     # nbsp

            doc <- htmlParse( x)
            saveXML(doc, file= htmlfile )
         }
      }else{
         # if pmc OAI not working ?
         if(length(x) == 0 ){ 
            print("WARNING: Cannot connect to PMC OAI service - trying Efetch")
            x <- efetch(id2, db="pmc", retmode="xml")
         }else{
            # remove namespace (from OAI)
            x[1] <- gsub(" xmlns=[^ ]*" , "", x[1])
         }

         ## SPECIAL characters
         x <- gsub("â\u0080²", "'", x)  ## 3' and 5'
         x <- gsub("–", "-", x)         ## long dashes
         x <- gsub("\u00A0", " ", x)     # nbsp

         ## replace ALL superscripts and subscripts
         x <- gsub("<sup>", "<sup>^", x)
         x <- gsub("<sub>", "<sub>_", x)   ## or use _ like Latex math  (locus tag with numeric subscript casues problems)

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

