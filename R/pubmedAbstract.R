## get title and abstract from pubmed ID 

pubmedAbstract <- function(id){
   doc <- xmlParse( efetch(id, retmode="xml"))
   y<- vector("list")
   y[["Main Title"]] <- xpathSApply(doc, "//ArticleTitle", xmlValue)
   x <- xpathSApply(doc, "//Abstract", xmlValue)
   y[["Abstract"]]<- splitP(x)

   x <- xpathSApply(doc, "//Keyword", xmlValue)
   if(length(x) > 0)  y[["Keywords"]]<- paste(x, collapse=", ")

   attr(y, "id") <- id
   y
}
