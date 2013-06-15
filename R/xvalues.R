# xvalue in genomes - 1 value

xvalues  <- function(doc, tag, sep ="/"){
   # if wildcard....separate values from different child tags 
   if(grepl( "/\\*$", tag)){
     x <- xpathSApply(doc, tag, xmlValue)
     if(length(x)>0){
        n <- xpathSApply(doc, gsub("/*", "", tag, fixed=TRUE), xmlSize)
        y <-split(x, rep(1:length(n), n))
        names(y) <- NULL
        sapply(y, paste, collapse= sep) 
     }else{ NA}
  }else{
     z <- xpathSApply(doc, tag, xmlValue)
     if(length(z)>0) z
     else NA
  }
}

