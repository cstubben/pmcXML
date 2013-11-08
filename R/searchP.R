
### search pmcText output  - search in base used to list packages...

# other options to grep  (or collapse2 ?)  

# some grep like options to print sentence before and after 

searchP <- function(x , pattern, caption=TRUE, before=FALSE, after=FALSE, ignore.case=TRUE, na.string = "", ...){

   ## x should be list (sentences or tables) OR  table -  is.list(data.frame()) = TRUE
   if(class(x)!="list" ){
         y <- attr(x, "label")
         if(is.null(y)) y <- "Unknown"  # in case label is missing
         x <- list(x)
         names(x) <- y
   } 

   z <- vector("list", length(x))
   for ( i in 1: length(x) ){
      
      if(class(x[[i]] )=="data.frame"){
         #COLLAPSE table rows  - add caption after search
         x2 <- collapse2( x[[i]], na.string= na.string ) 
         n <- grep(pattern, x2,  ignore.case=ignore.case, ...)
         if(length(n) >0){
             z[[i]] <- data.frame( section = names(x[i]), mention = x2[n] , stringsAsFactors=FALSE )
             if(caption) z[[i]]$mention <- paste("Caption=", attr(x[[i]], "caption") , ";", z[[i]]$mention, sep="")
         }
      }else{
         # FULL TEXT
         n <- grep(pattern, x[[i]],  ignore.case=ignore.case, ...)
         if(length(n) >0){
            z[[i]] <- data.frame( section = names(x[i]), mention = x[[i]][n] , stringsAsFactors=FALSE)
            # if(number) z[[i]]$n <- n
            if(before) z[[i]]$mention <- ifelse(n==1, z[[i]]$mention,  paste( x[[i]][n-1], z[[i]]$mention)  )
            if(after)  z[[i]]$mention <- ifelse( n==length(x[[i]]),  z[[i]]$mention,  paste( z[[i]]$mention , x[[i]][n+1] ) )
         }
      }       
   }
   do.call("rbind", z)
}


