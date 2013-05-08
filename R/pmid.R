# get a formatted reference from pmid (or pmcid)
# probably should rename this function

pmid <-function(doc){
   if(class(doc)[1]=="XMLInternalDocument"){
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
