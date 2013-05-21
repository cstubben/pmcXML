
### search pmcText output  - search in base used to list packages...

# some grep like options to print sentence before and after 

searchP <- function(x , pattern, before=FALSE, after=FALSE, ignore.case=TRUE, ...){

   ## x should be list (sentences or tables) Or supplementary table - 
   if(!is.list(x)){


   } 

   z <- vector("list", length(x))
   for ( i in 1: length(x) ){
      x2 <- x[[i]]
      #COLLAPSE table rows
      if(class(x2)=="data.frame") x2<- collapse2(x2) 

      n <- grep(pattern, x2,  ignore.case=ignore.case, ...)
      if(length(n) >0){
          z[[i]] <- data.frame( section = names(x[i]), citation = x2[n] )
          # if(number) z[[i]]$n <- n
          if(before) z[[i]]$citation <- ifelse(n==1, z[[i]]$citation,  paste( x2[n-1], z[[i]]$citation)  )
          if(after)  z[[i]]$citation <- ifelse( n==length(x2),  z[[i]]$citation,  paste( z[[i]]$citation , x2[n+1] ) )
      }     
   }
   do.call("rbind", z)
}


