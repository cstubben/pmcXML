## collapse a data.frame into key-value pairs 

collapse2 <- function(x, na.string=NULL, ...){
   if(class(x)=="list"){
      y<- lapply(x, collapse.df, na.string, ... )
      attr(y, "id") <- attr(x[[1]], "id")  
      y
   }else if(class(x)=="data.frame"){
     collapse.df(x, na.string, ...)
   }else{
     message("A data.frame or list of data.frames is required")
     x
   }
}


collapse.df <- function(x, na.string=NULL, rowid=TRUE, captions=TRUE){

   if(class(x) != "data.frame") stop("A data.frame is required")
   # add subheaders if present
   x <- suppressMessages( repeatSub(x) )
   y <- names(x)
   n <- nrow(x)

   ## convert factors to character...
   for(i in 1:ncol(x)){
      if(class(x[,i]) =="factor") x[,i] <- as.character(x[,i])
   }

   # combine (and skip empty fields)
   cx <- vector("character", n)
   # TO DO - replace loop?
   for(i in 1: n ){ 
      n2 <- is.na(x[i,]) | as.character(x[i,]) == ""  | x[i,] == "\u00A0"
      if(!is.null(na.string)  ) n2 <- n2 | as.character(x[i,] ) == na.string 
      rowx <- paste(paste(y[!n2], x[i, !n2], sep="="), collapse="; ")
      if(rowid)  rowx <- paste( "Row ", i, " of ", n, "; ", rowx, sep="")
      cx[i] <-rowx 
 
   }
   if(captions){
      subcap <- attr(x, "subcaption")
      if(!is.null(subcap ))   cx <- c(paste("Subcaption=", splitP(subcap) , sep=""), cx  )

      fn <- attr(x, "footnotes")
      n <- is.null(fn)|| fn==""
      if(!n) cx <- c(cx,  paste("Footnotes=", splitP(fn) , sep="") )
   }
   cx
}
