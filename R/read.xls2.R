
read.xls2<-function(file, sheet=1, skip=0, ...){
   # if a single quote " is in cell, then use quote="" 
   # x <- read.xls(file, stringsAsFactors=FALSE, header=FALSE, sheet=sheet, method="tab", quote="", skip=skip)

    #  adding quote will mess up rows if newlines in cell   
   ## July 31, 2013 add ... in case file encoding or other options needed.  see table S2 from PMC3074167
   x <- read.xls(file, stringsAsFactors=FALSE, header=FALSE, sheet=sheet, method="tab", skip=skip, ...)
    # remove quotes? AND newlines
    for(i in 1:ncol(x)) x[,i]<- gsub('"|\n', '', x[,i] )
   x<- guessTable(x )
   attr(x, "file") <- file
   x
}


