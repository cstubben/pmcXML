
# split paragraph into sentences...


splitP <- function( z ){
# check if empty list (returned by xpathSApply)

if(length(z)==0){
   NULL
}else{
    z <- gsub("\n", " ", z)
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

      ## remove placeholders
   z2 <- gsub("X.X",    ".", z2, fixed = TRUE)
    ## add period 
      z2 <- paste(z2, ".", sep="") 
 z2
 }  
}





