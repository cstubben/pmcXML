
## write mentions to file...

writeLocus <-function(x, file= "locus.tab" , append=TRUE){
   n <- nrow(x)
   x  <- unique(x)
   if(nrow(x) < n){ print(paste("Removed", n - nrow(x), "duplicates")) }
   # print(paste("Saved", nrow(x), "rows to", file))
   write.table(x, file , 
      row.names=FALSE, col.names=FALSE, append=append, quote=FALSE, sep="\t")
}

