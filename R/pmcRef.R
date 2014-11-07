#------------------------------------------------
## LIST of references cited in dataframe... 

## CHECK publication types... table2(xpathSApply(doc, "//ref/element-citation", xmlGetAttr,  "publication-type"))
##         OR  //ref/mixed-citation
##        OR called citation-type in //ref/citation


pmcRef <- function ( doc ) 
{
   z <- getNodeSet(doc, "//ref")
   # element-citation, mixed-citation, or citation?
 
   n <- length(z)
   refs <- vector("list", n)
   for (i in 1:n) {
     
      z2 <- xmlDoc(z[[ i ]])
      # label <- xvalue(z2, "//label")
      label <- xpathSApply(z2, "//label",xmlValue, trim=TRUE)
      if(length(label)==0) label<- NA

      id <- xpathSApply(z2, "//ref", xmlGetAttr,  "id")
      # mixed or element-citation?
      type <- xpathSApply(z2, "//ref/element-citation|//ref/mixed-citation", xmlGetAttr,  "publication-type")

      if(length(type)==0){
         ## BMC genomics from 2007 PMC1853089
         type <- xpathSApply(z2, "//ref/citation", xmlGetAttr,  "citation-type")
      }

      # CHECK TAGS 

      tags <- unique( xpathSApply(z2, "//ref/element-citation//*|//ref/mixed-citation//*|//ref/citation//*", xmlName) )

# no spaces between surname and given name, so need to parse

      if("surname"%in% tags){
         a1 <- xpathSApply(z2, "//surname", xmlValue)
         a2 <- xpathSApply(z2, "//given-names", xmlValue)
         a3 <- paste(a1, a2)

         etal <- xpathSApply(z2, "//etal", xmlValue)
         if(length(etal) >0){
            if(etal=="") etal <- "et al"   # may be tag only see PMC2374372
            a3<- c(a3, etal)
         }
         a3 <- paste(a3, collapse=", ")
         year <- xvalue(z2, "//year")
         title <- xvalue(z2, "//article-title")
         title <- gsub("\\.$", "", title)

         journal <- xvalue(z2, "//source")
         volume <- xvalue(z2, "//volume")

         pages <- xvalue(z2, "//fpage")
         if(!is.na(pages)){
            x2 <- xvalue(z2, "//lpage")
            if(!is.na(x2)) pages <- paste(pages, x2, sep = "-")
         }
         pmid <- xvalue(z2, '//pub-id[@pub-id-type="pmid"]')

       
         bookpub <- xvalue(z2, "//publisher-name")
       
          ## TO DO need better parsing for books
            if(!is.na(bookpub)){
               y <- xvalue(z2, "//publisher-loc")
               bookpub <- paste(y, journal, sep=": ")
               title <- journal
               journal <- bookpub 
            }
# missing title and other tags see PMC3559055
        if(is.na(title)){
            title <-  paste(xpathSApply(z2, "//ref/element-citation/text()|//ref/mixed-citation/text()|//ref/citation/text()", xmlValue) , collapse="")
            title <- gsub("^[,. ]+", "", title)
 
         }
         refs[[i]] <- data.frame(pmid, authors=a3, year,
            title, journal, volume, pages, label, id, type, 
         stringsAsFactors=FALSE)
      }else{
         ## use node() to avoid combining words like "CDC 2014 Map of" into "CDC2104Map of "
        title <- paste( xpathSApply(z2, "//ref/element-citation/node()|//ref/mixed-citation/node()|//ref/citation/node()", xmlValue), collapse=" ")
        title <- gsub("  ", " ", title)
       title <- gsub(" . ", ". ", title, fixed=TRUE)

        pmid <- xvalue(z2, '//pub-id[@pub-id-type="pmid"]')
        if(!is.na(pmid)) title <- gsub(pmid, "", title)
        title<- gsub("( ", "(", title, fixed=TRUE)
        refs[[i]] <- data.frame(pmid, authors=NA, year= NA, title, journal=NA, volume=NA, pages=NA, label, id, type,  stringsAsFactors=FALSE)
      }
      free(z2)
   }
   do.call("rbind", refs)
}

