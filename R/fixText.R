

fixText <-function(x){
 
   x <- gsub("“|”|″", "\"", x)
   x <- gsub("’|′", "'", x)
   x <- gsub("−|–", "-", x)
   x <- gsub("∼", "~", x)
   x <- gsub("×", "x", x)
   x <- gsub("‥", "..", x)
   x <- gsub("ö", "o", x)
   x <- gsub("NA; ", "", x)  # section titles only
   x <- gsub("\n", " ", x) 
   x <- gsub("  *", " ", x) 
   x <- gsub("^ *", "", x) 
   x <- gsub(" *$", "", x) 
   x
}

