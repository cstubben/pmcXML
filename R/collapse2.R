
# collapse in Iranges

## skip NA, "", and values in na.string

## add caption and footnotes (or after searching for pattern?)
## fix :  footnotes should only be added to rows with footnote


collapse2 <- function(x, sep=";", caption=FALSE, footnotes= FALSE, na.string="" ){
  y <- names(x)
  # combine (and skip empty fields)
  cx <- vector("character", nrow(x))
  # avoid loop?
  for(i in 1:nrow(x)){ 
    # if Date column , then x[,i]=="" returns Error in charToDate(x) :  character string is not in a standard unambiguous format
    # n2 <- is.na(x[i,]) | x[i,]== "" 
     n2 <- is.na(x[i,]) | as.character(x[i,]) == "" 
     if(na.string !="" ) n2<- n2 | as.character(x[i,])== na.string 
     cx[i] <- paste(paste(y[!n2], x[i, !n2], sep="="), collapse=sep)
  }
  if(caption) cx <- paste("Caption=", attr(x, "caption") , sep, cx, sep="")
  if(footnotes){
      fn <- attr(x, "footnotes")
      if(!is.null(fn)){
        fn <- paste(fn, collapse=". ") 
        cx <- paste(cx, sep, "Footnotes=", fn , sep="")
      }
  }
  cx
}


