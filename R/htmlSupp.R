
htmlSupp <- function(doc){

   x <- xpathSApply(doc, "//div[@class='sup-box half_rhythm']/a", xmlGetAttr, "href")
   if(is.null(x)){ 
      print("No supplementary tag found") 
   } else{
     # check file type - may be link to file
       filex <-  rev(strsplit(x, "/")[[1]])[1]
# supplements listed on new page
      if(grepl("html$", filex) ){
          url <- paste( "http://www.ncbi.nlm.nih.gov", x, sep="")
         print(paste("Checking links at", url))
         y <- htmlParse( url )
         z1 <-  xpathSApply(y, "//a[@href]", xmlGetAttr, "href")
         z2 <- xpathSApply(y, "//li", xmlValue)
        
      }else{
          z1 <- filex
          z2 <- xpathSApply(doc, "//div[@class='sec suppmat']", xmlValue)
          z2 <- gsub("Click here to view", "", z2)
      }
      data.frame(file=z1, name =z2, stringsAsFactors=FALSE)

   }
}
