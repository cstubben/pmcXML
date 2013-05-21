
# collapse in Iranges

## skip NA, "", and values in na.string

collapse2 <- function(x, caption=FALSE, footnotes= FALSE, na.string ){
 
  y <- names(x)
  # combine (and skip empty fields)
  cx <- vector("character", nrow(x))
  # avoid loop?
  for(i in 1:nrow(x)){ 
     n2 <- is.na(x[i,]) | x[i,]== "" 
     if(!missing(na.string) ) n2<- n2 | x[i,]== na.string 
     cx[i] <- paste(paste(y[!n2], x[i, !n2], sep="="), collapse=";")
  }
  if(caption) cx <- paste("Caption=", attr(x, "caption") , ";", cx, sep="")
  if(footnotes){
      fn <- attr(x, "footnotes")
      if(!is.null(fn)){
        fn <- paste(fn, collapse=". ") 
        cx <- paste(cx, ";Footnotes=", fn , sep="")
      }
  }
  cx
}


