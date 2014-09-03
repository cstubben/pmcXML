## remove/fix chars  for pmcMetadata


removeSpecChar <- function(txt){  
  txt <- gsub("&", "&amp;", txt)   ## check for &lt; in file?
  txt <- gsub("&amp;lt;", "&lt;", txt) 
  txt <- gsub("&amp;gt;", "&gt;", txt) 

  txt <- gsub("<", "&lt;", txt)
  txt <- gsub("“", '"', txt)
  txt <- gsub("”", '"', txt)
  txt <- gsub("″", '"', txt)

  txt <- gsub("′", "'", txt)
  txt <- gsub("’", "'", txt)

  txt <- gsub("−", "-", txt)
  txt <- gsub("–", "-", txt)
  txt <- gsub("∼", "~", txt)
  txt <- gsub("×", "x", txt)
#  txt <- gsub("\u00A0", "", txt)  # non-break?
  txt <- gsub("‥", "..", txt)
  txt <- gsub("ö", "o", txt)

#  txt <- gsub("", "", txt)
     txt
}

