# get a pmid from XML doc - to assign attribute

pmid <-function(doc){
   if(is.xml(doc) ){
      ID <- xpathSApply(doc, '//article-id[@pub-id-type="pmid"]', xmlValue)
  }else{
      ID <- xpathSApply(doc, '//head/meta[@name="citation_pmid"]', xmlGetAttr, "content") 
  }
  if( length(ID)==0){
     print("WARNING: No pubmed ID found")
     ID <- 0
  }
  as.numeric(ID)
}
