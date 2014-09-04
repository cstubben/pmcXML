# repeat sub headings in new column.  Must start in first row (with empty second column)

# add as first (or last) column

repeatSub <- function(x, column="subheading", first =TRUE, ...){

    ## check first column first?
   ###  apply(x[1,-1], 1, function(z) all(  is.na(z) | z=="NA"| z==""| z=="\u00A0"))
 
   ## columns 2 to ncol(x) should be empty
   ## \u00A0 is non-breaking space
   n <- apply(x[,-1, FALSE], 1, function(z) all(  is.na(z) | z=="NA"| z==""| z=="\u00A0")) 
   y <- x
   ## check for consecuitive subheaders (and then probably not subheaders)
    ## SEE http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3334355/table/pone-0035971-t003/
   if( sum(diff(which(n)) == 1) > 1){
      print("Too many subheaders in consecutive rows") 
   }else if(which(n)[1] != 1){
      print("No subheader in row 1")
   }else if(length(n) == 0 ){
      print("No subheaders found")

   }else{
      x[[column]] <- rep(x[n,1],   times= diff( c(which(n) , nrow(x)+1)) )
      # subset drops attributes
      y <- subset(x, !n )
      rownames(y)<-NULL
      y <-fixTypes(y, ...)
      if(first) y<- y[, c( ncol(y), 1:(ncol(y)-1)) ]
      # keep attributes - if NULL, then not added
      attr(y, "id")      <- attr(x, "id")
      attr(y, "pmid")    <- attr(x, "pmid")
      attr(y, "file")    <- attr(x, "file")
      attr(y, "label")   <-  attr(x, "label")
      attr(y, "caption") <-  attr(x, "caption")
      attr(y, "footnotes") <- attr(x, "footnotes")
   }
   y
}

