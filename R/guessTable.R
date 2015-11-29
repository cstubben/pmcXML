guessTable <-function(x, header= 1, ...){
   # other options like na.strings passed to fixTypes
 
   # EMPTY columns -see Sharma 2010
   n <- apply(x, 2, function(y) sum(! (is.na(y) | y == "" | y == " ") ))
   if(any(n == 0)){
      message(paste("Deleted", sum(n == 0), "empty columns"))
      x <- x[, n != 0] 
   }

   #EMPTY ROWs... NA or empty strings..
   n <- apply(x, 1, function(y) sum(! (is.na(y) | y == "" | y ==" ") ))
   if(any(n==0)){
      message(paste("Deleted", sum(n == 0), "empty rows"))
      x <- x[n != 0,] 
      n <- n[n != 0]
   }

   # extra spaces in last column - Rasmussen 2009
   if( any(grepl(" $", x[,ncol(x)]))){
      message("Trimmed spaces in last column")
      x[,ncol(x)] <- gdata::trim(x[,ncol(x)] )
   }

   # FOOTNOTES (some footnotes in first and second columns!)
   footnotes <- NULL
   if(n[length(n)] == 1) {
      z<-rle(n)$lengths
      n2 <-  (length(n) - z[length(z)] + 1) : length(n)
      footnotes <- x[ n2 ,1]
      x <- x[-n2,]
   }else{
      if(n[length(n)] == 2 & ncol(x) > 3 ) {
         # z<-rle(n)$lengths    # ALL footnotes have 2 columns
         z<-rle(n > 2)$lengths     # or footnotes have 1 or 2 columns (see Feldon 2011)
         n2 <-  (length(n) - z[length(z)] + 1) : length(n)
         footnotes <- apply(x[ n2 ,1:2], 1, paste, collapse=" ")
         x <- x[-n2,]
     }
   }
   caption <- ""
   # CAPTION (if row 1 has only 1 column)
   if(n[1] == 1) {
      # use rle for multi-line captions
      n1 <- 1 : rle(n)$lengths[1]
      caption <- x[ n1 ,1]
      x <- x[-n1,]
       n <- n[-n1]
   }

   if(length(caption)>1)  caption <- paste(caption, collapse=" ")

      ## check for sub-caption
        subcaption <- NULL
        zz <- splitP(caption)
            label<- zz[1]
            caption <- zz[2]
       if( length(zz) > 2 ) subcaption <- zz[3 : length(zz)]
        

   # CHECK subheaders (other rows with only 1 column) -- see repeatSub

   # COLUMN NAMES (ALWAYS in first complete ROW?)  OR specify rows???
   if( is.numeric(header)  ){
         ## OR if header is logical T/F
         ##   header <- which(n == ncol(x))[1]  # find first rows with all columns filled?

         if(header==1){
             xx <- as.vector(unlist(x[1,])) 
             x <- x[-1,]
         }else{
             xx <- gdata::trim(apply(x[1:header,],2, paste, collapse=" "))
             x <- x[-(1:header),]
          }
      ## CHECK for EMPTY strings -- to avoid  structure(c("", "", "", "", "", "", ... as PRINTED name
     #print(xx)
     if(any(is.na(xx)))  xx[is.na(xx) ] <-" "
     if(any(xx==""))    xx[xx==""] <-" "

      xx<-gsub(" +", " ", xx)
     # xx<-gsub('"', '', xx)   # with quote=""
      colnames(x) <- xx
      
   }

    #fix column types (by running read.delim)
   x <- fixTypes(x, ...)


  # 
  
   attr(x, "label") <-  gsub("\\.$", "", label)
   attr(x, "caption") <-  gsub("\\.$", "", caption)
attr(x, "subcaption") <-  subcaption
   attr(x, "footnotes") <- footnotes
   
   x
}

