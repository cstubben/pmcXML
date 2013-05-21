


## path to search... use //p for paragraphs  or //* for all captions, labels, titles, references, etc.

## DEFAULT is to skip paragraphs with tables (since cells will be mashed together in one string). see table 1 from PMC1976454
## Some text before table will be dropped, but only a few  pubmed XML files with table-wrap inside <p> tag


searchXML <- function(doc, pattern, path="//p[not(descendant::table-wrap)]", before=0, after=0, ignore.case=TRUE, ...){


   z <- xpathSApply(doc, path, xmlValue)
   # dont split on abbrev B. subtilis 
    z <- gsub(" ([A-Z])\\.", " \\1X.X", z)
   # OR abbrev at start of paragraph!
    z <- gsub("^([A-Z])\\. ", "\\1X.X ", z)
   # or if abbrev in parenthesesis
    z <- gsub("\\(([A-Z])\\.", "\\(\\1X.X", z)


   z <- gsub("\\.$", "", z)
  
     # some abbrevations may be after parentheses (so drop space if no other words end in that abbrev.)
  # z <- gsub(".^",       "X.X^",        z, fixed = TRUE)   # reference superscripts
    z <- gsub(".^",       ". ^",        z, fixed = TRUE)   # reference superscripts after period 
   z <- gsub("Fig. ",    "FigX.X ",     z, fixed = TRUE)   # Fig. 
   z <- gsub("et al. ",  "et alX.X ",   z, fixed = TRUE)   # et al. 
   z <- gsub(" no. ",    " noX.X ",     z, fixed = TRUE)   # acc no. 
   z <- gsub(" nos. ",   " nosX.X ",    z, fixed = TRUE)   # acc nos. 
   z <- gsub("e.g. ",    "e.gX.X ",     z, fixed = TRUE)   # e.g.
   z <- gsub("(eg. ",    "(egX.X ",     z, fixed = TRUE)   # eg.  .. add paren to avoid words ending in eg.
   z <- gsub("i.e. ",    "i.eX.X ",     z, fixed = TRUE)   # i.e. 
   z <- gsub(" spp. ",   " sppX.X ",    z, fixed = TRUE)   # species
   z <- gsub(" sp. ",    " spX.X ",     z, fixed = TRUE) 
   z <- gsub(" subsp. ", " subspX.X ",  z, fixed = TRUE)   # subspecies
   z <- gsub(" var. ",   " varX.X ",    z, fixed = TRUE)   # varieties
  
   z <- gsub(" ca. ",    " caX.X ",     z, fixed = TRUE)  # approx 
   z <- gsub("approx. ", "approxX.X ",  z, fixed = TRUE)
   z <- gsub(" vs. ",    " vsX.X ",     z, fixed = TRUE)  # vs.


   # split sentences
   z2 <- unlist( strsplit(z, ". ", fixed=TRUE) )

     ## remove {} from HTML docs
   if(!is.xml(doc)) z2 <- gsub("\\{[^}]*\\}*", "" , z2)
    ## remove placeholders
   z2 <- gsub("X.X",    ".", z2, fixed = TRUE)
    ## add period - for end of line matching grep("VCA?[0-9]{4}[^0-9_]", "VC0215.")
      z2 <- paste(z2, ".", sep="") 

   #x <- grep(pattern, z2, value=TRUE, ignore.case=ignore.case, ...)
   n <- grep(pattern, z2,  ignore.case=ignore.case, ...)

   x <- z2[n]
   if(length(x)>0){ 
       ## check and remove negative subscript - NOTE paste will coerce NA to "NA"
      if(before > 0) for ( i in 1:before){  x <-  paste(z2[ ifelse( (n - i) > 0, n-i,NA ) ], x)  }
      if(after  > 0) for ( i in 1:after) {  x <-  paste(x, z2[n + i])  }

   }
   x
}





