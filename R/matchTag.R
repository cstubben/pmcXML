# used by seqIds

matchTag<-function( id, tags){
   
   # n1 <- grep(id, tags, ignore.case=TRUE)
   n1 <- grep(paste("^", id, "$", sep=""), tags, ignore.case=TRUE)

   if(length(n1) != 1) {
      # IF no suffix on id
      if( grepl("[0-9]$", id) ){   
         n1 <- grep( id, tags, ignore.case=TRUE) 
      }else{
         ## drop suffix...
         n1 <- grep( substring(id, 1, nchar(id)-1) , tags, ignore.case=TRUE) 
      }
      if(length(n1)>1) n1<-n1[1]  # in case tag with two or more suffix?
      if(length(n1)==1){
         print(paste("Warning: no match to ", id, ". Using ", tags[n1] , " instead.", sep="" ))
      }else{
         n1<-NULL
      }
   }
   n1
}

