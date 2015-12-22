# xvalue in genomes - 1 value

xvalue <- function(doc, tag) {
        n <- xpathSApply(doc, tag, xmlValue)
        if ( length(n)>0 ) 
           ## if multiple values, return first (for pubmed) or paste?
           n[1]  
           #paste(n, collapse=",")
        else NA
    }



xtags <- function(doc, tag, subtag1, subtag2, value1 ) {
         n <- xpathSApply(doc, paste(tag, subtag1, sep="/"), xmlValue)==value1
         if ( any(n) ) 
             xpathSApply(doc, paste(tag, subtag2, sep="/"), xmlValue)[n] 
         else NA
}


