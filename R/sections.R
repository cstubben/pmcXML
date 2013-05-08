
sections<-function(doc, html="//h2"){
 
  ## section titles for XML
  if(class(doc)[1]=="XMLInternalDocument"){
     xpathSApply(doc, "//article/body/sec/title", xmlValue)
  }else{
     # h3 (or h2?) for HTML
     xpathSApply(doc, html, xmlValue)
  }
}

