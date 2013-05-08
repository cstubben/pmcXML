## GET tables from pmc XML file
# additional options passed to read.delim option of fixTypes


pmcTable_old <- function(pmc, strAsFactors=FALSE, verbose=TRUE, ...)
{
   z <- getNodeSet(pmc, "//table-wrap")
   if(length(z)==0){ 
      NULL
   }else{
      n <- 1 : length(z)
      y <- vector("list", length(n) )
      for(i in 1: length(n) ){
         z2 <- xmlDoc(z[[ i ]])

         ## TABLE links - 
         id <-      xattr( z2, "//table-wrap", "id")
         label <-   xvalue(z2, "//label")
         caption <- xvalue(z2, "//caption") 
         if(verbose)   print(paste("Parsing", paste(label, caption) ))

         # footnotes (with label and captions)
         flabel <- xpathSApply(z2, "//table-wrap-foot/fn/label", xmlValue)
         fn     <- xpathSApply(z2, "//table-wrap-foot/fn/p", xmlValue)
     
         if(length(flabel) > 0){   
            fn <- paste(flabel, fn, sep=". ")
         # or footnotes with <fn><p> tags only
         }else{
          #or footnotes
            if(length(fn)==0) fn <- xpathSApply(z2, "//table-wrap-foot", xmlValue)
         }

          ## SOME tables may be images.   SEE http://www.ncbi.nlm.nih.gov/pmc/articles/PMC2211553/table/ppat-0040009-t001/

         t1 <- getNodeSet(z2, "//table")
         if(length(t1)==0){ 
            print("  Cannot parse table node - links to image?") 
            x <-data.frame()
            c1<-"Cannot parse table node"
            free(z2)
         }else{
            t1 <- t1[[1]]
            x <- readHTMLTable(t1, stringsAsFactors=strAsFactors, header=FALSE, ...)
            ## check if empty table - link to image  see PMC2677876 ?

            ##  some XML use th (header cell) instead of td (standard cell)?  
            c1 <- xpathSApply(t1, "//thead/tr/td|//thead/tr/th", xmlValue)  

            # no column names
            if(length(c1)==0){
                c1<-"No table header"
            ## single row with column names
            }else if(length(c1) == ncol(x) ){
                colnames(x) <- c1
            # Try to format multi-line header using colspan 
            }else{
               c2 <- xpathApply( t1, "//thead/tr/td|//thead/tr/th", xmlAttrs)
               c2 <- lapply(c2, "[", "colspan")  
               c2[is.na(c2 == "NA")]<-1
               c2[sapply(c2, is.null)] <- 1 
               c2 <- as.numeric(unlist(c2))
               if(length(c1)==length(c2)){
                  ## repeat headers using colspan
                  ## some headers with rowspan > 1 will NOT work
                  ## SEE  tables 1 and 2 in http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3109299 

                  c3 <- rep(c1, times=c2)
                  if( length(c3) %% ncol(x) != 0 ){ 
                     if(verbose)  print("WARNING: cannot format multi-line table header")
                  }else{
                     # create matrix and paste together multi-lines
                     c4 <- matrix(c3, ncol= ncol(x), byrow=TRUE)
                     c4 <- apply(c4, 2, paste, collapse="; ")
                     c4 <- gsub("[; ]*$", "", c4)
                     c4 <- gsub("^[ ;]*", "", c4)
                     c4 <- gsub("; ; ", "; ", c4)  # some mutliline rows with horizontal lines only
                     colnames(x) <- c4
                  }
               } else{
                  if(verbose)   print("WARNING: cannot format multi-line table header")
               }
            }
            free(z2)

            #DELETE empty rows
            if(nrow(x)>1){
               nX <- apply(x, 1, function(y) sum(! (is.na(y) | y=="") ))
               x  <- x[nX != 0,, FALSE]   # use FALSE in case only 1 column in TABLE
            }
            # fix integer and numeric columns 
           ## errors if newlines and tabs in cells (or colnames!)
            colnames(x) <- gsub("\n *", "", colnames(x))

           # also quotes in cells will cause errors...

            x2  <- try( fixTypes(x, na.strings="", ...) , silent=TRUE)
            if(class(x2)=="try-error"){
                 print("ERROR fixing types - skipped")
            }else{
                 x <-x2
            }

     
         }
         ### Attributes
         attr(x, "id")   <- attr(pmc, "id")
         attr(x, "pmid") <- attr(pmc, "pmid")
         attr(x, "file") <- paste( attr(pmc, "file"), "table", id, sep="/") 
         attr(x, "label") <- label
         attr(x, "caption") <- caption
         attr(x, "thead") <- c1
         if(length(fn)>0){
           attr(x, "footnotes") <- fn
          }
         y[[i]] <- x
         names(y)[i] <- label
      }
      y
   }
}
