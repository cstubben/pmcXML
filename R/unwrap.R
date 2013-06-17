##


# fix multiline Row on new line

unwrap <- function(x, startRow, sep= " "){    
   startRow <- paste("^", startRow, sep="")
   n <- grep(startRow, x)
   # use loop (backwards)
   for(i in length(x):n[1]){
      if( !grepl(startRow, x[i])) {
         x[i - 1] <- paste(x[i - 1], x[i], sep=sep)
      }
   }
   # KEEP header?
   if(n[1] > 1){  n <- c(1:(n[1] - 1)   , n)  }
   x[n]
}

