
read.xls2 <- function(file, sheet=1, skip=0, ...){
   # if a single quote " is in cell, then use quote="" 
   # x <- read.xls(file, stringsAsFactors=FALSE, header=FALSE, sheet=sheet, method="tab", quote="", skip=skip)

    #  adding quote will mess up rows if newlines in cell   
   ## July 31, 2013 add ... in case file encoding or other options needed.  see table S2 from PMC3074167
   x <- read.xls(file, stringsAsFactors=FALSE, header=FALSE, sheet=sheet, method="tab", skip=skip, ...)
    # remove quotes? AND newlines
    for(i in 1:ncol(x)) x[,i]<- gsub('"|\n', '', x[,i] )
   x<- guessTable(x )
   attr(x, "file") <- file
  ## check for attributes added to footnotes...
   y <- attr(x, "footnotes")
   if(!is.null(y) ){
      n <- grep("^id=", y)
      if(length(n) == 1){
         attr(x, "id") <-  gsub("id=", "", y[n])
         y <- y[-n]
      }
      n <- grep("^file=", y)
      if(length(n)==1){
         attr(x, "file") <-  gsub("file=", "", y[n])
         y <- y[-n]
      }
      if(length(y)==0){
         attr(x, "footnotes") <- NULL  
      }else{
         attr(x, "footnotes") <- y
      }
   }
  x
}


