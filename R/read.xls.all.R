read.xls.all<-function(file, ...){

## sheetcount does not work with relative paths
file <- path.expand(file)
if(!file.exists(file)) stop("No file found")
    n <- sheetCount(file)
 
       sheets <- sheetNames(file)
       x <-vector("list", n)
       for( i in 1:n){
          ## excel files - xlsx or xls
          print(paste("Reading Sheet", i))
          ## check for empty sheets
           x[[i]] <- try( read.xls2( file , sheet= i , ...)   , silent=TRUE)
           if(class(x[[i]])[1] == "try-error"){
               x[[i]] <- NA
               print("Empty Sheet")
           }
       }
       # remove empty sheets
       x[is.na(x)] <- NULL
       names(x) <- paste( sapply(x, attr, "label"),   sapply(x, attr, "caption"), sep=". ")
       # 1 sheet then return data.frame
       # if(length(x)==1) x <- x[[1]]
       x
}
