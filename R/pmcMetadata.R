# GET PMC xml article metadata (mainly for Solr)

pmcMetadata <-function(doc ){

   z <- vector("list")

  # use pmid for id
   pmid <- xpathSApply(doc, '//article-id[@pub-id-type="pmid"]',  xmlValue)
   z[["id"]] <- pmid

   # TITLE
   z[["title"]] <-  xpathSApply(doc, "//front//article-title", xmlValue) 

   #------
   #AUTHORS
   x1 <- xpathSApply(doc, "//contrib/name/given-names", xmlValue)
   x2 <- xpathSApply(doc, "//contrib/name/surname", xmlValue)
   fauthor <- x2[1]

   if(length(x1)!=length(x2) ) stop("Check author names -missing first or last")
   authors <-  paste(x1, x2)

   # as string
   z[["author_display"]] <- paste(authors, collapse=", ")


   # Journal volume pages

   ## include published YEAR?
   y1 <- xpathSApply(doc, "//pub-date[@pub-type='ppub']/year", xmlValue)
   if(is.null(y1))   y1 <- xpathSApply(doc, "//pub-date[@pub-type='collection']/year", xmlValue)


   journal <- xpathSApply(doc,  "//journal-id[@journal-id-type='nlm-ta']", xmlValue)
   if(length(journal) == 0) stop("No match to nlm-ta journal type")

   volume <- xpathSApply(doc, "//article-meta/volume", xmlValue)

   #PAGES?
   p1 <- xpathSApply(doc, "//article-meta/fpage", xmlValue)
   if(length(p1)>0){
      p2 <- xpathSApply(doc, "//article-meta/lpage", xmlValue)
      if(p1 != p2) p1 <- paste(p1, p2, sep="-")
   }else{
      p1 <- xpathSApply(doc, "//article-meta/elocation-id", xmlValue)
   }
   pages <- p1

   z[["journal_display"]] <- paste(y1, " ", journal, " ", volume, ":", pages, sep="") 
   z[["year"]] <- y1
 

   #------
   # PUB Date

   x1 <- xpathSApply(doc, "//pub-date[@pub-type='epub']/year", xmlValue)
   x2 <- xpathSApply(doc, "//pub-date[@pub-type='epub']/month", xmlValue)
   x3 <- xpathSApply(doc, "//pub-date[@pub-type='epub']/day", xmlValue)
   x <-  paste(x1, x2, x3, sep="-")

   # format to match PMC
   z[["published_online"]] <-  format(as.Date(x), "%Y %B %d")


   # first author
   z[["first_author"]] <- fauthor

   # full journal name?
   z[["journal"]] <- removeSpecChar(xpathSApply(doc,  "//journal-meta//journal-title", xmlValue))

   # publisher
   z[["publisher"]] <- removeSpecChar(xpathSApply(doc,  "//journal-meta//publisher-name", xmlValue))

   ## IDs
   z[["pmid"]] <- pmid

   pmcid <- attr(doc, "id")
   z[["pmcid"]] <-  pmcid

   ## DOI
   x <- xpathSApply(doc, '//article-id[@pub-id-type="doi"]',  xmlValue)
   if(length(x)>0) z[["doi"]] <- x 

   # URL link 
   url <- paste("http://www.ncbi.nlm.nih.gov/pmc/articles/", pmcid, sep="")
   z[["URL"]] <- url

   # LIST of authors
   z[["author"]] <- authors

   ## Affiliations
   x <- xpathSApply(doc, "//aff/institution", xmlValue)
   if(length(x)>0){
      x <- paste(x,  xpathSApply(doc, "//aff/country", xmlValue) , sep=", ")
   }else{
      # PLOS (skip editor addr-line)
      x <- xpathSApply(doc, "//aff[not(starts-with(@id, 'edit'))]/addr-line", xmlValue)
   }
   if(length(x)==0){
      x <- xpathSApply(doc, "//aff/text()", xmlValue, trim=TRUE)
   }
   z[["affiliation"]] <- removeSpecChar(x)


   # keywords?
    x <-  xpathSApply(doc, "//kwd", xmlValue)
   if(length(x)>0) z[["Keywords"]] <- x

   z[["subject"]] <- xpathSApply(doc,  "//subject", xmlValue)

   # MeSH terms
   x <- meshTerms(pmid)
   if(is.null(x)){
      print("NO MeSH terms found")
   }else{
      z[["MeSH"]] <-removeSpecChar( x$term )
   }


# add attribute for file name

attr(z, "id") <- attr(doc, "id")
z

 
}




