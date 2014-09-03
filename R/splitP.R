# split paragraphs into sentences...  should replace with sentDetect in openNLP
## but openNLP does not split on sentences ending with numbers like table 2 or  roman numbers I 

splitP <- function( z ){
# check if empty list (returned by xpathSApply)

if(length(z)==0){
   NULL
}else{
    z <- gsub("\n", " ", z)

z <-gsub("([A-Z]\\.[A-Z])\\. ",    "\\1X.X ",  z)   ## INITIALS (with or without space)
 z <-gsub("([A-Z])\\. ([A-Z])\\. ",    "\\1X.X \\2X.X ",   z)

   # dont split on abbrev B. subtilis 
   #    z <- gsub(" ([A-Z])\\.", " \\1X.X", z)

   ## July 25, 2013 some sentences end in single letter, so check next word.  
      # Also inlcude optional parentheses 
     z <- gsub(" (\\(?[A-Z])\\. ([a-z])", " \\1X.X \\2", z)    
     z <- gsub(" (\\[?[A-Z])\\. ([a-z])", " \\1X.X \\2", z)    

   # OR abbrev at start of paragraph!
    z <- gsub("^([A-Z])\\. ", "\\1X.X ", z)

   z <- gsub("\\.$", "", z)
  
     # some abbrevations may be after parentheses (so drop space if no other words end in that abbrev.)
  # z <- gsub(".^",       "X.X^",        z, fixed = TRUE)   # reference superscripts
    z <- gsub(".^",       ". ^",        z, fixed = TRUE)   # reference superscripts after period 
   z <- gsub("Fig. ",    "FigX.X ",     z, fixed = TRUE)   # Fig. 
   z <- gsub("Suppl. ",   "SupplX.X ",     z, fixed = TRUE)   # Supplement
   z <- gsub("Supp. ",    "SuppX.X ",     z, fixed = TRUE)   # Supplement 
   z <- gsub("et al. ",  "et alX.X ",   z, fixed = TRUE)   # et al. 
   z <- gsub("et. al. ",  "et alX.X ",   z, fixed = TRUE)   # et. al. 
   z <- gsub(" no. ",    " noX.X ",     z, fixed = TRUE)   # acc no. 
   z <- gsub(" nos. ",   " nosX.X ",    z, fixed = TRUE)   # acc nos.
   z <- gsub(" No. ",    " NoX.X ",     z, fixed = TRUE) 
   z <- gsub(" S. Typhi",    " SX.X Typhi",     z, fixed = TRUE) # see PMC3536570 for S. Typhimurium  (will split due to capital)

   z <- gsub("e.g. ",    "e.gX.X ",     z, fixed = TRUE)   # e.g.
   z <- gsub("(eg. ",    "(egX.X ",     z, fixed = TRUE)   # eg.  .. add paren to avoid words ending in eg.
   z <- gsub("i.e. ",    "i.eX.X ",     z, fixed = TRUE)   # i.e. 

   z <- gsub(" spp. ",   " sppX.X ",    z, fixed = TRUE)   # species
   z <- gsub(" sp. ",    " spX.X ",     z, fixed = TRUE) 
   z <- gsub("subsp. ", "subspX.X ",  z, fixed = TRUE)   # subspecies
   z <- gsub(" var. ",   " varX.X ",    z, fixed = TRUE)   # varieties
     z <- gsub(" bv. ",   " bvX.X ",    z, fixed = TRUE)   # biovars
     z <- gsub(" sv. ",   " svX.X ",    z, fixed = TRUE)   # serovars

        z <- gsub("i.n. ",   "i.nX.X ",    z, fixed = TRUE)  #intranasal i.n.
        z <- gsub("i.p. ",   "i.pX.X ",    z, fixed = TRUE) 

   z <- gsub(" ca. ",    " caX.X ",     z, fixed = TRUE)  # approx 
   z <- gsub("approx. ", "approxX.X ",  z, fixed = TRUE)
   z <- gsub(" vs. ",    " vsX.X ",     z, fixed = TRUE)  # vs.
   z <- gsub(" Dr. ",    " DrX.X ",     z, fixed = TRUE)  # Dr.
   z <- gsub(" Mr. ",    " MrX.X ",     z, fixed = TRUE)  # Mr.
   z <- gsub(" Mrs. ",    " MrsX.X ",     z, fixed = TRUE)  # Mrs.
  z <- gsub("cfu. ",    "cfuX.X ",     z, fixed = TRUE)  # cfu
 z <- gsub("c.f.u. ",    "c.f.uX.X ",     z, fixed = TRUE)  #

## table or fig at start of sentence
 z <-  gsub("^(Table [0-9]+)\\. ", "\\1X.X ", z)
 z <-  gsub("^(Figure [0-9]+)\\. ", "\\1X.X ", z)
 z <-  gsub("^(Fig. [0-9]+)\\. ", "\\1X.X ", z)

## any letter  A. 
 z <-  gsub("(\\. [A-Z])\\. ", "\\1X.X ", z)


   # split sentences
   z2 <- unlist( strsplit(z, ". ", fixed=TRUE) )

      ## remove placeholders
   z2 <- gsub("X.X",    ".", z2, fixed = TRUE)
    ## add period 
      z2 <- paste(z2, ".", sep="") 
 z2
 }  
}





