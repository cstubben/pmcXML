# GET PMC xml article metadata 

pmcMetadata <-function(doc ){

   z <- vector("list")

   # TITLE  - some title with footnotes  see PMC2293206
#   xpathSApply(doc, "//front//article-title/xref", removeNodes)  # OR
   x <- xpathSApply(doc, "//front//article-title/node()[not(self::xref)]", xmlValue)
   x <- paste(x, collapse="")
   x <- gsub(" +$", "", x)
   z[["Title"]] <-  x

   #AUTHORS

   x1 <- xpathSApply(doc, "//contrib[not(@contrib-type='editor')]/name/given-names", xmlValue)
   x2 <- xpathSApply(doc, "//contrib[not(@contrib-type='editor')]/name/surname", xmlValue)

   fauthor <- x2[1]

   if(length(x1)!=length(x2) ) stop("Check author names -missing first or last")
   authors <-  paste(x1, x2)

   # as vector or collapsed string?  
   z[["Authors"]] <- authors

  # pmc displays journal abbrev, Published print; volume(issue): pages. Published online. Doi

   # Journal volume pages

   journal <- xpathSApply(doc,  "//journal-id[@journal-id-type='nlm-ta']", xmlValue)
   if(length(journal) >0 )    z[["Journal"]] <- journal
 
   volume <- xpathSApply(doc, "//article-meta/volume", xmlValue)
   if(length(volume) >0 ) z[["Volume"]] <- volume
 
   issue <- xpathSApply(doc, "//article-meta/issue", xmlValue)
   if(length(issue) >0 ) z[["Issue"]] <- issue

   #PAGES
   p1 <- xpathSApply(doc, "//article-meta/fpage", xmlValue)
   if(length(p1)>0){
      p2 <- xpathSApply(doc, "//article-meta/lpage", xmlValue)
      if(p1 != p2) p1 <- paste(p1, p2, sep="-")
   }else{
      p1 <- xpathSApply(doc, "//article-meta/elocation-id", xmlValue)
   }
   z[["Pages"]]  <- p1

   # PUB Dates

   x <- pubdate(doc)
   if(!is.null(x))  z[["Published online"]] <-  x

   x <- suppressMessages( pubdate(doc, "ppub") )
   if(!is.null(x))  z[["Published in print"]] <-  x

   x <- suppressMessages( pubdate(doc, "pmc-release"))
   if(!is.null(x))  z[["PMC release"]] <-  x

  ## DOI
   x <- xpathSApply(doc, '//article-id[@pub-id-type="doi"]',  xmlValue)
   if(length(x)>0) z[["DOI"]] <- x 

   pmcid <- attr(doc, "id")
   z[["PMCID"]] <-  pmcid

   pmid <- xpathSApply(doc, '//article-id[@pub-id-type="pmid"]',  xmlValue)
   z[["PMID"]] <- pmid

   # first author
   z[["First author"]] <- fauthor

   # full journal name?
   x <- xpathSApply(doc,  "//journal-meta//journal-title", xmlValue)
   if(length(x)>0) z[["Full journal"]] <- x
   # publisher
   x <- xpathSApply(doc,  "//journal-meta//publisher-name", xmlValue)
   if(length(x)>0) z[["Publisher"]]<- x

   # URL link 
   url <- paste("http://www.ncbi.nlm.nih.gov/pmc/articles/", pmcid, sep="")
   z[["URL"]] <- url


   x <- xpathSApply(doc,  "//subject", xmlValue)
    if(length(x)>0) z[["Subjects"]] <- x

   # MeSH terms
   x <- meshTerms(pmid)
   if(is.null(x)){
      message("NO MeSH terms found")
   }else{
      z[["MeSH terms"]] <- x 
   }

   # add attribute 
   attr(z, "id") <- attr(doc, "id")
   z
}




