

# function to print captions and footnotes


strwrap2 <- function(x, exdent=5, ...){
  if(is.data.frame(x)) x<-apply(x, 1, paste, collapse=". ")
  cat(paste(strwrap(x, exdent=exdent, ...), collapse="\n"), "\n")
}


