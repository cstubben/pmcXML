#  write R List to Solr XML import


listToSolr <- function(x, file  ){

   # default file
   if(missing(file)){
      id  <- attr(x, "id")
      if(is.null(id)) stop("No id found")
      if(grepl("^[0-9]", id) ) id <- paste("pmid", id, sep="")
 
      file <- paste(id, ".xml", sep="")
   }
   cat("<add>\n<doc>\n", file=file)
   for(i in 1:length(x)){
      cat( paste('  <field name="', names(x)[i], '">',  x[[i]], '</field>\n', sep=""), file=file, append=TRUE)
   }
   cat("</doc>\n</add>\n", file=file, append=TRUE)
   print(paste("Wrote XML to", file))
}
