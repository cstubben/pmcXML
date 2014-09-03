## collapse a data.frame into key-value pairs with row id


collapse <- function(x, footnotes= TRUE, na.string="" ){
  y <- names(x)
  # check for column names ending in period (.= will split sentence)
  if(any( grepl("\\.$", y) )){
     print("Note: removing period from column names for Solr")
     y <- gsub("\\.$", "", y)
     names(x) <- y
}
  n <- nrow(x)

  ## check for subheadings
  if(ncol(x) >1){
      hasSubs <-  apply(x[1,-1,FALSE], 1, function(z) all(  is.na(z) | z=="NA"| z==""| z=="\u00A0"))
      if(hasSubs){
          x<- repeatSub(x)
          y <- names(x)
          n <- nrow(x)
       }
  }
  # combine (and skip empty fields)
  cx <- vector("character", n)
  # avoid loop?
  for(i in 1: n ){ 
     n2 <- is.na(x[i,]) | as.character(x[i,]) == "" 
     if(na.string !="" ) n2<- n2 | as.character(x[i,] ) == na.string 
     cx[i] <- paste(" row ", i, " of ", n, "; ", paste(paste(y[!n2], x[i, !n2], sep="="), collapse="; "), ". ", sep="")
  }
  if(footnotes){
      fn <- attr(x, "footnotes")
      if(!is.null(fn)){
        fn <- paste(fn, collapse=" ") 
        cx[length(cx)+1] <- paste("Footnotes=", fn , sep="")
      }
  }
  cx
}
