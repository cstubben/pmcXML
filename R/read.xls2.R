
read.xls2<-function(file, sheet=1, skip=0, ...){
   # in case double quotes in cell, use quote="" 
   x <- read.xls(file, stringsAsFactors=FALSE, header=FALSE, sheet=sheet, method="tab",  quote="", skip=skip)
    # remove quotes 
     for(i in 1:ncol(x)) x[,i]<- gsub('"', '', x[,i] )
   guessTable(x, file, ...)
}


