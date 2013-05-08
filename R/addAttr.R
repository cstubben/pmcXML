# copy extra attributes from data.frame 1 to data.frame 2 (if lost after subsetting)

addAttr<-function(x,y){
  z <- attributes(x)
  z <- z[!names(z) %in% c("names", "class", "row.names")]
  for(i in 1:length(z)){
  attr(y, names(z)[i])<- z[[i]]
  }
  y
}

