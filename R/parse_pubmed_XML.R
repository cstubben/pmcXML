## two XML results from pubmed

## esummary(19923228, parse=FALSE, version="2.0")
## OR
##  xmlParse(efetch(19923228, retmode="xml"))

# no pmc or abstract from esummary

parse_pubmed_XML<-function(xml, authorsN=3, journalFull=TRUE)
{ 
   # xml results returned by efetch 
   z<- getNodeSet(xml, "//DocumentSummary")
   n<-length(z)
   if(n==0){stop("No results found")} 
   pubs<-vector("list",n)
   for(i in 1:n)
   {
      # use xmlDoc or memory leak -see ?getNodeSet for queries on subtree..
      z2<-xmlDoc(z[[i]])
     pmid    <- as.numeric( xpathSApply(z2, "//DocumentSummary", xmlGetAttr, "uid"   )   )  # first PMID id 

 
     ## check for error?
    ##<DocumentSummary uid="1368770">
    ##  <error>cannot get document summary</error>
    ## </DocumentSummary>
   if( length(xpathSApply(z2, "//error"))>0 ){
        print(paste("No results found for pmid:", pmid)) 
       next
    }

      a3 <-xpathSApply(z2, "//Author/Name", xmlValue)
      
      if(length(a3) > authorsN){
         authors <- paste(c(a3[1: authorsN], "et al"),  collapse=", ")
      }else{
         authors <- paste(a3,  collapse=", ")
      }
      
      title   <- xvalue(z2, "//Title")
      title   <- gsub("\\.$", "", title)
      ## full journal (with lower case )  OR abbrev
      if(journalFull){
          journal <- xvalue(z2, "//FullJournalName")
      }else{
          journal <- xvalue(z2, "//Source")
      }
      volume  <- xvalue(z2, "//Volume")
      pages   <- xvalue(z2, "//Pages")
      
      pubdate <- xvalue(z2, "//PubDate")
      year    <- as.numeric(substr(pubdate, 1,4))

      ## also PrintPubDate, ePubDate, SortDate
      sortdate <- xvalue(z2, "//SortPubDate")
      sortdate <- as.Date(substr(sortdate, 1,10))

## PMC (if available)
     pmc <-  xtags(z2, "//ArticleId", "IdType", "Value", "pmc")  

      pubs[[i]]<-data.frame(pmid, authors, year, title, journal, volume, pages, pubdate, sortdate, pmc,
         stringsAsFactors=FALSE)
      free(z2)
   }
   x<- do.call("rbind", pubs)
   x
}




