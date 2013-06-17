
## write citations to file...

writeLocus <-function(x, file= "locus.tab" ){
   n <- nrow(x)
   x  <- unique(x)
   if(nrow(x) < n){ print(paste("Removed", n - nrow(x), "duplicates")) }
   # print(paste("Saved", nrow(x), "rows to", file))
   write.table(x, file , 
      row.names=FALSE, col.names=FALSE, append=TRUE, quote=FALSE, sep="\t")
}

