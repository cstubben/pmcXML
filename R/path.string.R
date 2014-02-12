
# x = ordered list of names
# n = indentation level

## x <- c("carnivores", "bears", "polar", "grizzly", "cats", "tiger", "rodents")
##  n <- c(1,2,3,3,2,3,1)
## path.string(x, n)
## [1] "carnivores"                
## [2] "carnivores; bears"         
## [3] "carnivores; bears; polar"  
## [4] "carnivores; bears; grizzly"
## [5] "carnivores; cats"          
## [6] "carnivores; cats; tiger"   
## [7] "rodents"             

path.string<-function(x,n){
   n2 <-length(n)
   z <- vector("list", n2)
   if(min(n) > 1) n <- n - min(n) + 1
   path<-""
   for(i in 1: n2){
      path[n[i] ] <- x[i]
      path <- path[1:n[i]]
      z[[i]] <- paste(path, collapse="; ")
   }
   unlist(z)
}
