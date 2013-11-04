
# CONVERT pmc Table to GRange 

# collapse columns except ID into single attributes column



pmcGRange2<-function(x, acc, seqlength, id =1, columns = c("start", "end", "strand") ){

   if(missing(acc)){ stop("Missing accession number") }
   # columns can be numbers
   if(is.numeric(columns) ){
      n <- columns
   }else{
      n <- match(columns, tolower(names(x)))
      if(any(is.na(n))){stop("Need columns matching start, end, strand")}
   } 
   ## check if start - end in same column, then split
   if( n[1] == n[2]){
      z <- strsplit( x[,n[1]]  , "-")
      x$START <- as.numeric( sapply(z, "[", 1) )
      x$END <- as.numeric( sapply(z, "[", 2) )
      n[1] <- which(names(x) =="START")
      n[2] <- which(names(x) =="END")
   }

   # check if character...  remove footnotes and convert to number - see table 1 in PMC3542284
   if(!is.numeric(x[, n[1]] ) ){
      x[,n[1]] <-   gsub(".*?([0-9]*).*", "\\1", x[,n[1]] )
      x[,n[1]] <- suppressWarnings( as.numeric( x[,n[1]]) )
   }
   if(!is.numeric(x[, n[2]] ) ){
      x[,n[2]] <-   gsub(".*?([0-9]*).*", "\\1", x[,n[2]] )
      x[,n[2]] <- suppressWarnings( as.numeric( x[,n[2]]) )
   }
   # check for NAS
   zz<- is.na(x[,n[2]] ) | is.na(x[,n[1]]) 
   if(any(zz) ) {
      print(paste("Deleting", sum(zz), "rows with NAs"))
      x<- x[!zz,]
   }

   ## Check strand
   if( ! all( x[,n[3]]  %in% c( "+", "-", "*" ) )){
      x[, n[3]] <- gsub( "\u2010|\u2011|\u2012|\u2013|\u2014|\u2015|\u2212", "-", x[, n[3]] )
      x[, n[3]] <- gsub("?", "*", x[, n[3]] , fixed=TRUE)
      x[, n[3]] <- gsub(">|1|F|forward", "+", x[, n[3]] )
      x[, n[3]] <- gsub("<|-1|R|reverse", "-", x[, n[3]] )
      ## remove footnotes...
      if( any( nchar(x[,n[3]])>1) )  x[, n[3]] <- substr( x[, n[3]], 1,1) 
   }

   # check if start < end  - see checkStart in genomes2
   x <- checkStart(x, names(x)[n[1]], names(x)[ n[2]] , ok=FALSE)
    
   attrs <- x[, -c(n, id) , FALSE]    # in case 1 column use drop= FALSE
   if(ncol(attrs)>=1){
        eM <-  data.frame(id= x[, id], attrs = collapse2( attrs) , stringsAsFactors=FALSE )  
   }else{
       eM <-  data.frame(id= x[, id], stringsAsFactors=FALSE )    
   }
   gr <- GRanges(seqnames= acc,
          ranges = IRanges( x[, n[1]] ,   x[, n[2]]   ),
          strand = x[, n[3]],
          eM )   
   if(missing(seqlength)){
        seqlengths(gr) <- ncbiNucleotide(acc)$size
}else{
          seqlengths(gr) <- seqlength
}
 
   gr
}

