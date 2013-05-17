
# list all tags in pmc doc


pmcTags<- function(doc, tag ){

 if(missing(tag) ){
      tag <- "//*"
 }else{
      tag <- paste("//", tag, "//*", sep="")
 # OR tag <- paste("//", tag, "/*")   # next level
  }

 # LIST ALL tags
 x <- xpathSApply(doc, tag, xmlName)
  if(length(x)>0) x<- table(x)
  x
}
