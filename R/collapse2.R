## collapse a data.frame into key-value pairs 

collapse2 <- function(x, footnotes= TRUE, rowid=TRUE, na.string ){

  # add subheaders if present
  x <- suppressMessages( repeatSub(x) )

   y <- names(x)
   # check for column names ending in period for SentDetect
   if(any( grepl("\\.$", y) )){
     print("Note: removing period from column names for Solr")
     y <- gsub("\\.$", "", y)
     names(x) <- y
   }
   n <- nrow(x)

  
   ## convert factors to character...
   for(i in 1:ncol(x)){
      if(class(x[,i]) =="factor") x[,i] <- as.character(x[,i])
   }

   # combine (and skip empty fields)
   cx <- vector("character", n)
   # TO DO - replace loop?
   for(i in 1: n ){ 
      n2 <- is.na(x[i,]) | as.character(x[i,]) == "" 
      if(!missing(na.string)  ) n2<- n2 | as.character(x[i,] ) == na.string 
      rowx <- paste(paste(y[!n2], x[i, !n2], sep="="), collapse="; ")
      if(rowid)  rowx <- paste( "Row ", i, " of ", n, "; ", rowx, sep="")
      ## add period to end of row?
      cx[i] <- paste(rowx , ".", sep="")
   }
   if(footnotes){
      fn <- attr(x, "footnotes")
       n <- is.null(fn)|| fn==""
       if(!n){
        fn <- paste(fn, collapse=" ") 
        cx[length(cx)+1] <- paste("Footnotes=", fn , sep="")
      }
   }
   cx
}
