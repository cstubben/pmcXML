
## format parse pmc or pubmed articles


bibformat <- function(refs, id=FALSE, ...){

  # full journal title is default
 refs[,5] <-gsub("Proceedings of the National Academy of Sciences of the United States of America", "PNAS", refs[,5])

  x <- apply(refs, 1, function(x) paste(c( x[2], ". ", x[3], ". ", x[4], ". ", x[5], " ", x[6], ":", x[7], "."), collapse="") )

  ## add ID
  if(id)  x<-paste(x, refs[,1])
   

  strwrap2(x, ...)

}

