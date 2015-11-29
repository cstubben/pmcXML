## remove/fix chars  for pmcMetadata


removeSpecChar <- function(txt){  
  txt <- gsub("&", "&amp;", txt)   ## check for &lt; in file?
  txt <- gsub("&amp;lt;", "&lt;", txt) 
  txt <- gsub("&amp;gt;", "&gt;", txt) 

  txt <- gsub("<", "&lt;", txt)
  txt
}

