
htmlParse2 <- function(url, ...){
   x <- suppressWarnings( try( readLines(url, ...), silent=TRUE ))
  if(class(x) == "try-error"){ stop("No url found")  } 
  x <- gsub("<sup>", "<sup>^", x)
  x <- htmlParse(x)
  x
}

