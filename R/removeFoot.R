
#remove footnotes????

removeFoot <- function(x){
   n <-grep("^", names(x), fixed=TRUE)
   if(length(n)>0)  names(x)[n] <- gsub("\\^.", "", names(x)[n])
   for(i in 1:ncol(x)){
      n <-grep("^", x[,i], fixed=TRUE)
      if(length(n)>0)  x[n,i] <- gsub("\\^.", "", x[n,i])
   }
   attr(x, "footnotes")  <-NULL
   x <-fixTypes(x)
   x
}
