
# used by getTable

# SEARCH all columns and REPLACE

sr<-function(x, pattern, replacement ){
    n <- apply(x, 2, function(y) any(grepl(pattern, y)))
    if(sum(n)>0){
         for(i in which(n) ) x[,i]<-gsub(pattern, replacement, x[,i])
    }
    x
}

