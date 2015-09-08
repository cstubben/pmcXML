# search pmcText output 
# other options to grep  (or collapse ?)  
# some grep like options to print sentence before and after 

searchPMC <- function(x , pattern, before=FALSE, after=FALSE, ignore.case=TRUE, ...){

   ## x should be list (sentences or tables) 
   if(class(x)!="list" ) x <- list(x)

   z <- vector("list", length(x))
   for ( i in 1: length(x) ){
      
      if(class(x[[i]] )=="data.frame"){
        # tables as images return data.frame with 0 columns and rows
        if(nrow(x[[i]]) == 0){
            x2<- NULL 
         }else{
            #COLLAPSE table rows  
            x2 <- collapse2( x[[i]] ) 
        }
         n <- grep(pattern, x2,  ignore.case=ignore.case, ...)
         if(length(n) >0){
             z[[i]] <- data.frame( section =  paste(attr(x[[i]], "label"), attr(x[[i]], "caption"))  , mention = x2[n] , stringsAsFactors=FALSE )
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


