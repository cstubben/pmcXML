

# supplmentary materials

pmcSupp <-function(doc, file, ... ){
   if(!is.xml(doc )) stop("An XML document is required")
  ## using file name
  if(!missing(file) && is.character(file) )
  {
    getSupp(doc, file, ...)

  }else{
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

         filex <- xattr(z2, "//supplementary-material/media", "href")
         type <- xattr(z2, "//supplementary-material/media", "mime-subtype")

         type <-gsub("vnd.ms-", "", type)    

         y[[i]] <- data.frame(label, caption, file=filex, type, stringsAsFactors=FALSE)
         free(z2)
      }
      y <- do.call("rbind", y)
       # print list of supplements
      if(missing(file) ){
         y
      }else{
        ## download using file number, 1,2,3, etc
        print(paste("Downloading", y$label[file] ))      
         getSupp(doc, y$file[file], ...)
      }
   }
   
}

