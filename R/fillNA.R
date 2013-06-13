
## see ..na.locf() from package 'zoo'


fillNA<-function(x){
  for(i in seq_along(x)[-1]){
     # \u00A0 is non-breaking space
    if(is.na(x[i]) | x[i]=="" | x[i] == "\u00A0") x[i] <- x[i-1]
  }
  x
}

