# source("~/plague/R/packages/pubmed/R/fixText.R")

fixText <-function(x){
   x <- removeSpecChar(x)
   x <- gsub("NA; ", "", x)  # section titles only
   x <- gsub("\n", " ", x) 
   x <- gsub("  *", " ", x) 
   x
}

