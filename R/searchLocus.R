searchLocus<-function(doc){
   tags <- c("BPS[SL]", "BMA", "BTH_I", "BURP")
   n <- length(tags)
   x <- vector("list", n)
   names(x)<-c("BPS", "BMA", "BTH", "BURP")
   for(i in 1:n){
      y <- searchXML(doc, tags[i])
       x[[i]]<- ifelse(is.null(y), 0, length(y))
   }
   as.data.frame(x)
}

