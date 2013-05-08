## keep attributes?

fixTypes<-function(x, stringsAsFactors=FALSE, ...){
   xx <-apply(x, 1, paste, collapse="\t")
   ## check if empty table 
  if(length(xx)==1 && xx==""){
       x
  }else{
     # remove internal new line characters
     xx <- gsub("\n", "", xx)
     zz <-textConnection(xx )
     y <- read.delim(zz, header=FALSE, stringsAsFactors=stringsAsFactors, ...)
     close(zz)
     names(y) <- names(x)
     y
   }
}

