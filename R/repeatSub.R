# repeat sub headings in new column.  Must start in first row (with empty second column)
# first option to add as first (or last) column


repeatSub <- function(x, column="subheading", first =TRUE, ...){
 
   if(!is.data.frame(x)){
      message("x should be a data.frame")
   }else if(ncol(x)==1){
        message("Only one column in table")
   }else{
 
      ## columns 2 to ncol(x) should be empty
      ## \u00A0 is non-breaking space
      n <- apply(x[,-1, FALSE], 1, function(z) all(  is.na(z) | z=="NA"| z==""| z=="\u00A0")) 

      if(sum(n) == 0){
         message("No subheaders found")
      }else if( sum(diff(which(n)) == 1) > 1){
         ## check for consecuitive subheaders (and then probably not subheaders)
         ## SEE http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3334355/table/pone-0035971-t003/
         message("Too many subheaders in consecutive rows") 
      }else if(which(n)[1] != 1){
         message("No subheader in row 1")
      }else{
         # keep copy of original table
         y <- x
         x[[column]] <- rep(x[n,1],   times= diff( c(which(n) , nrow(x)+1)) )
         # subset drops attributes
         y <- subset(x, !n )
         rownames(y)<-NULL
         y <-fixTypes(y, ...)
         if(first) y <- y[, c( ncol(y), 1:(ncol(y)-1)) ]
         # keep attributes - if NULL, then not added
         for(i in c("id", "file", "label", "caption", "footnotes"))  attr(y, i) <- attr(x, i)
         attr(y, "subheaders") <- x[n,1]
         x <- y
      }
   }
   x
}

