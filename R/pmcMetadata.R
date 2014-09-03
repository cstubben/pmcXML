# GET PMC xml metadata

# source("~/plague/R/packages/pubmed/R/pmcMetadata.R")

pmcMetadata <-function(doc, tables, supps ){

   z <- vector("list")

  # use pmid for id
   pmid <- xpathSApply(doc, '//article-id[@pub-id-type="pmid"]',  xmlValue)
   z[["id"]] <- pmid

# for pubType 
  doc2 <- esummary(pmid, version="2.0", parse=FALSE)

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
   z[["year"]] <- y1


   journal <- xpathSApply(doc,  "//journal-id[@journal-id-type='nlm-ta']", xmlValue)
if(length(journal)==0) stop("No match to nlm-ta journal type")

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


   z[["doc_type"]] <-  xpathSApply(doc2, "//PubType/flag", xmlValue)
   z[["doc_source"]] <- "PMC OA"

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
   # x <-  xpathSApply(doc, "//kwd", xmlValue)
   #if(length(x)>0) z[["Keywords"]] <- x

   z[["subject"]] <- xpathSApply(doc,  "//subject", xmlValue)

   # MeSH terms
   x <- meshTerms(pmid)
if(is.null(x)){
print("NO MeSH terms found")
}else{
   z[["mesh"]] <-removeSpecChar( x$term )
}
   # ABSTRACT ...skip author summary
   
   x <- paste( xpathSApply(doc, "//abstract[not(@abstract-type='summary')]//p", xmlValue) , collapse=" ")
   z[["abstract"]] <- removeSpecChar(x) 

   # get sections
   txt <- pmcText3(doc)
   x <- names(txt)
   z[["section_title"]] <- removeSpecChar(x )

   y <- mainLookup(x)
   for(i in unique(y)){
      z[[i]] <- removeSpecChar(unlist(txt[y %in% i ]  ))
   }
 

   f1 <- xpathSApply(doc, "//fig/label", xmlValue)
   if( length(f1) > 0){
      f2 <- xpathSApply(doc, "//fig/caption/title", xmlValue)
      f3 <- xpathSApply(doc, "//fig/caption/p", xmlValue)
      f3 <- gsub("\n", " ", f3)
      z[["figure_caption"]]     <-  removeSpecChar(paste(f1, f2, f3) )
   }


  #TABLES
   if(missing(tables)) tables <- pmcTable(doc, verbose=FALSE, simplify=FALSE)

   x <- tables
   if( is.list(x) ){
      captions <- lapply(x, function(y) paste( attr(y, "label") , " ", attr(y, "caption"), ".", sep=""))
    # caption may already have period 
     captions <- gsub("\\.+$", ".", captions)

      z[["table_caption"]] <- removeSpecChar(captions )
      for (i in 1:length(x)){        
        x[[i]] <- paste( c(captions[i], collapse(x[[i]])), collapse="\n")      
      }
      z[["table"]] <- removeSpecChar(unlist(x) )
   }

##  LIST all supplements?  Some pdf supps with many tables and will not be inlcuded

   if(!missing(supps)){
      x <- supps
      captions <- sapply(x, function(y) paste( attr(y, "label") , " ", attr(y, "caption"), ".", sep=""))
     captions <- gsub("\\.+$", ".", captions)

      z[["supplement_caption"]] <- removeSpecChar(captions )
      for (i in 1:length(x)){   
             ## check if data.frame
             txt <- x[[i]] 
             if(is.data.frame(txt ))  txt <- collapse( txt )
             x[[i]] <- paste( c(captions[i], txt), collapse="\n")
      }
      z[["supplement"]] <- removeSpecChar(unlist(x) )
   }


# REFERENCES
x<-bibr(doc, FALSE)

x1 <- gsub("\n", " ", bibformat2(x))
z[["references"]] <- removeSpecChar( paste( x1, collapse=" \n") )
z[["pmid_cited"]] <- as.vector(na.omit(unique(x$pmid)))


# add attribute for file name

attr(z, "id") <- attr(doc, "id")
z

 
}




