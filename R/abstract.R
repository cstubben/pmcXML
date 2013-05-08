
#PARSE abstract

abstract<-function(doc, exdent = 0 , ...){
   if(class(doc)[1]=="XMLInternalDocument"){
      # check for abstract subtitles?
      x1 <- xpathSApply(doc, "//abstract/sec/title", xmlValue)
      if(length(x1)>0){
         x2 <- xpathSApply(doc, "//abstract/sec/p", xmlValue)
         strwrap2(paste(x1, x2, sep=": "),  exdent=exdent, ... )
      }else{
         x1 <- xpathSApply(doc, "//abstract", xmlValue)
         strwrap2(x1, exdent=exdent, ...)
      }
   }else{
      x<-xpathSApply(doc, '//body//div[@class="sec"]', xmlValue)
      # empty sections
      x1<- x[x!=""][1]
      strwrap2(x1, exdent=exdent, ...)



   }
}
