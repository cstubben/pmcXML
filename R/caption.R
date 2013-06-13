

caption<-function(x, ...){
   ## if XML
   if(is.xml(x) ){
        y  <- xpathSApply(x, "//table-wrap/caption", xmlValue)
   }else if(class(x)=="list") {
      y <- sapply(x, attr, "caption")
   }else{
      y <- attr(x, "caption")
      if(is.null(y)) y <- "No table caption"
   }
   strwrap2(y, ...)
}


