

# supplmentary materials

pmcSupp<-function(doc, capN){
   if(class(doc)[1]=="XMLInternalDocument"){
      z <- getNodeSet(doc, "//supplementary-material")
      if(length(z)==0){stop("No supplementary materials found", call. = FALSE)}
      y <- vector("list", length(z) )
      for(i in 1: length(z) ){
         z2 <- xmlDoc(z[[ i ]])
         label <- xvalue(z2, "//label")
         if(is.na(label)) label <- xvalue(z2, "//title")
  

         caption <- xpathSApply(z2, "//caption/p", xmlValue) 
         n <-grep("^Click here", caption, invert=TRUE)
         caption <- paste( caption[n], collapse= " ")

         file <- xattr(z2, "//supplementary-material/media", "href")
         type <- xattr(z2, "//supplementary-material/media", "mime-subtype")

         type <-gsub("vnd.ms-", "", type)    

         y[[i]] <- data.frame(label, caption, file, type, stringsAsFactors=FALSE)
         free(z2)
      }
      y<- do.call("rbind", y)
      if(!missing(capN)){
         y[,2] <- substr(y[,2], 1, capN)
      }
      y
    ## HTML docs   Click here to view with link?
   }else{
      print("Warning: this function is for XML docs")
      y<-xpathSApply(doc, '//div[@class="sec suppmat"]', xmlValue)
      y<-gsub("\n", "", y)
      y<- gsub("  *", " ", y)
      y
    }
}

