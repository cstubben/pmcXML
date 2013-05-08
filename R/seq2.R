# used by seqIds

seq2<-function(id, stop){
   if(!grepl("^[^0-9]+[0-9]+", id)){stop("Start is not a valid sequence ID")}
      ## use .? to drop suffix a,b,c, etc ( eg, YPO0001a ).
      pre <- gsub("([^0-9]+)([0-9]+).?", "\\1", id)
      n   <- gsub("([^0-9]+)([0-9]+).?", "\\2", id) 
      n2  <- gsub("([^0-9]+)([0-9]+).?", "\\2", stop)
      
      pad <- nchar(n)   
      n <-  as.numeric(n)
      n2 <- as.numeric(n2)
      ids <- seq(n,n2)
      paste(pre, sprintf(paste("%0", pad, "d", sep=""), ids) , sep="")
}



