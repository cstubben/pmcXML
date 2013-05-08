## title in graphics
title2<-function(doc){
 
  ## section titles for XML
  if(class(doc)[1]=="XMLInternalDocument"){
     xpathSApply(doc, "//title-group/article-title", xmlValue)[1]
  }else{
    xpathSApply(doc, "//title", xmlValue)[1]
  }
}


