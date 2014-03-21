## misc. xref functions...

## bibr is most common type, also aff, table, figure and others... SEE
## table2(xpathSApply(doc, "//xref", xmlGetAttr, "ref-type"))

# need better function names for all these


#------------------------------------------------
## find sentences citing pmid - only works if brackets within xref tag  <xref>[3]

xref <- function(doc, id){
   # find reference with pub-id = pmid (and go up two levels to get xref id attribute )
   rid <- xpathSApply(doc, paste( "//pub-id[text()='", id, "']/../..", sep=""), xmlAttrs) 

   if( is.null(rid )) {
      stop("No references with PMID ", id) 
   }else{
      txt <- pmcText(doc)
      ## search using label within xref tags (may be repeated outside xref tags?)
      label <- unique( xpathSApply(doc, paste("//xref[@rid='", rid, "']", sep=""), xmlValue) )

      ## TEXT only search by label... search [22] or (22) or any 22 (may or may not be reference!) but NOT  21-24 

      searchP(txt, label, fixed=TRUE, ignore.case=FALSE)
   }
}

#------------------------------------------------
## LIST of references cited in dataframe... 

## CHECK publication types... table2(xpathSApply(doc, "//ref/element-citation", xmlGetAttr,  "publication-type"))
##         OR  //ref/mixed-citation
##        OR called citation-type in //ref/citation

bibr <- function ( doc, authorsN=2 ) 
{
    z <- getNodeSet(doc, "//ref")
    
    n <- length(z)
    refs <- vector("list", n)
    for (i in 1:n) {
        
        z2 <- xmlDoc(z[[ i ]])
        label <- xvalue(z2, "//label")
        if(is.na(label)) label <- xpathSApply(z2, "//ref", xmlGetAttr,  "id")
         # mixed or element-citation?
        type <- xpathSApply(z2, "//ref/element-citation|//ref/mixed-citation", xmlGetAttr,  "publication-type")
        if(length(type)==0){
           ## BMC genomics from 2007 PMC1853089
               type <- xpathSApply(z2, "//ref/citation", xmlGetAttr,  "citation-type")
         }
       
        a1 <- xpathSApply(z2, "//surname", xmlValue)
        a2 <- xpathSApply(z2, "//given-names", xmlValue)
        a3 <- paste(a1, a2)
          # et al.  should replace 2 or more authors (not 1) 
        if (length(a3) > authorsN+1) {
            a3 <- paste(c(a3[1:authorsN], "et al"), collapse = ", ")
        }
        else {
            a3 <- paste(a3, collapse = ", ")
        }
        year <- xvalue(z2, "//year")
        title <- xvalue(z2, "//article-title")
        title <- gsub("\\.$", "", title)
        journal <- xvalue(z2, "//source")
        volume <- xvalue(z2, "//volume")
        pages <- paste(xvalue(z2, "//fpage"), 
                       xvalue(z2, "//lpage"), sep = "-")
        pages <- gsub("-NA$", "", pages)
        pmid <- xvalue(z2, '//pub-id[@pub-id-type="pmid"]')

        if(type=="book"){
            title <- journal
            journal <- xvalue(z2, "//publisher-name")
                 y <- xvalue(z2, "//publisher-loc")
               if(!is.na(y)) journal <- paste(y, journal, sep=": ")
        }
        ## PLOS one has ref type = "OTHER" with journal citation on one line
         ## some URLs, others have full reference tags and therefore use is.na(title) to skip
        if(type=="other" & is.na(title) ){
             x <-  xvalue(z2, "//element-citation|//mixed-citation")   
           
           if(grepl("http:", x)){
                year   <-  gsub(".*? ([0-9]{4}).*", "\\1", x)
                title <- x

           }else{
               a3 <-  gsub("(.*?) \\(?[0-9]{4}.*", "\\1", x) 
               year   <-  gsub(".*?([0-9]{4}).*", "\\1", x)      
               title  <- gsub(".*?[0-9]{4}\\)? (.*)", "\\1", x)   
            }   
         }

        refs[[i]] <- data.frame(pmid, authors=a3, year,
            title, journal, volume, pages, label, type, 
         stringsAsFactors=FALSE)

        free(z2)
    }
    do.call("rbind", refs)
}


#------------------------------------------------
## format references using cited number...

ref <- function( label,  pmcXML=doc){
   n <- length(label)
   refs <- vector("list", n) 
   for(i in 1:n ){
      z <- getNodeSet( pmcXML, paste("//ref/label[text()=", label[i], "]/..", sep="") )

## FIX July 25, 2013--  see PMC3175480  USES <ref id="B2">  AND <xref ref-type="bibr" rid="B2">2</xref> to cite -
      if(is.null(z)){
             rid <-  paste("B",  label[i], sep="")
             print(paste("Warning: No //ref/label node found, trying //ref[@id='", rid, "']", sep=""))
             z <- getNodeSet( pmcXML, paste("//ref[@id='", rid , "']", sep="") )
}

      z2 <- xmlDoc(z[[1]])

      a1 <- xpathSApply(z2, "//surname", xmlValue)
      a2 <- xpathSApply(z2, "//given-names", xmlValue)
      a3 <-  paste(a1, a2)
      if (length(a3) > 3) {
         a3 <- paste(c(a3[1:2], "et al"), collapse = ", ")
      }else {
         a3 <- paste(a3, collapse = ", ")
      }
      year <- xpathSApply(z2, "//year", xmlValue)
      title <- xpathSApply(z2, "//article-title", xmlValue)
      title <- gsub("\\.$", "", title)  ## may or may not have period
      journal <- xpathSApply(z2, "//source", xmlValue)
      volume <- xpathSApply(z2, "//volume", xmlValue)
      pages <- paste( xpathSApply(z2, "//fpage", xmlValue), xpathSApply(z2, "//lpage", xmlValue), sep="-")
      pages <- gsub("-$", "", pages)
      refs[[i]]<- paste(label[i], ". ", a3, ". ", year, ". ", title,  ". ", journal, " ", volume, ":", pages, ".", sep="")
      free(z2)
   }
   unlist( refs )
}

   
 

