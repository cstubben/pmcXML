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
