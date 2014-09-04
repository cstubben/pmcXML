
htmlParse2 <- function(url, ...){
   x <- suppressWarnings( try( readLines(url, ...), silent=TRUE ))
  if(class(x) == "try-error"){ 
     ##stop("No url found")  
     x<-url
  } 
  x <- gsub("<sup>", "<sup>^", x)
  x <- gsub("<sub>", "<sub>_", x)
  x <- htmlParse(x)
  x
}

