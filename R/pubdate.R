
# get pub-date from pmcXML

pubdate <- function(doc, pubtype="epub", as.date=FALSE){

   # xpath
   x <- paste0("//pub-date[@pub-type='", pubtype, "']/", c("year", "month", "day") )
   y <- lapply(x, function(y) xpathSApply(doc, y, xmlValue) )
   if( is.null(unlist(y))){
      message("No pub-date with pub-type = ", shQuote(pubtype) )
      y <- NULL
   }else{
      # missing day..  
      noDay <- FALSE
      if(length(y[[3]]) ==0 ){ 
         y[[3]] <- "1"
         noDay <- TRUE
      }
      # missing month?  Or character like Jan-Mar?
      if(length(y[[2]]) ==0 ){ 
         y[[2]] <- "1"
         message("Warning: no month found")
      }

      #Date string...
      y <- paste(unlist(y), collapse="-")
      y <-  as.Date(y)
      if(!as.date){
         # pmc format  - day of month? %d for "01" or %e for " 1"  - no option for "1"?
         y <-  format(y, "%Y %B %e")
         y <-  gsub("  ", " ", y)
         if(noDay){
            y<- gsub(" 1$", "", y)
         }
      }
   } 
   y
}
