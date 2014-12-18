parse_pmc_XML<-function(xml, authorsN=3, journalFull=TRUE )
{ 
   # results returned from esummary version 2.0 

   z <- getNodeSet(xml, "//DocumentSummary")

   n<-length(z)
   if(n==0){stop("No results found")} 
   pubs<-vector("list",n)
   for(i in 1:n)
   {
      # use xmlDoc or memory leak -see ?getNodeSet for queries on subtree..
      z2<-xmlDoc(z[[i]])
      ## PMC id
      # pmc <-  xattr(z2, "//DocumentSummary", "uid")   # PMCid  
      ##  OR with PMC prefix
       pmc <- xtags(z2, "//ArticleId", "IdType", "Value", "pmcid")

      #authors
      a3<- xpathSApply(z2, "//Author/Name", xmlValue)   # all authors
       # fix march 19, 2014 -  et al should represent two or more authors (not 1)
      if(length(a3) > authorsN+1){
         authors <- paste(c(a3[1: authorsN], "et al"),  collapse=", ")
      }else{
         authors <- paste(a3,  collapse=", ")
      }
      ## SortDate = EPubDate else PubDate ?   Also PmcLiveDate

      year    <- as.numeric(substr(xvalue(z2, "//SortDate"),1,4))
      title   <- xvalue(z2, "//Title")
      title <- gsub(" *$", "", title)    # extra spaces
      title <- gsub("\\.$", "", title)  # some end in period

      if(journalFull){
         journal <- xvalue(z2, "//FullJournalName")
      }else{
         journal <- xvalue(z2, "//Source")
      }
      volume  <- xvalue(z2, "//Volume")
      # issue <- xvalue(z2, "//Issue")
      pages   <- xvalue(z2, "//Pages")
      # use epub date else pub date
      epubdate <- xvalue(z2, "//EPubDate")
      pubdate <- xvalue(z2, "//PubDate")

      pmid <- xtags(z2, "//ArticleId", "IdType", "Value", "pmid")
       doi <- xtags(z2, "//ArticleId", "IdType", "Value", "doi")

      pubs[[i]]<-data.frame(pmc, authors, year, title, journal, volume, pages, pubdate, epubdate, pmid, doi,
         stringsAsFactors=FALSE)
    
      free(z2)
   }
   do.call("rbind", pubs)
}
