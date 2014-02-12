## get Table from pubmed central directly - HTML docs only have table links)

getTable <-function(doc, whichTable, verbose=TRUE, simplify=TRUE, ...){
   url <- "http://www.ncbi.nlm.nih.gov"

    y <- xpathApply(doc, "//a[@target='table']", xmlAttrs)
    if (length(y) == 0) {
        print("No table links found")
        NULL
    }else{
  
    tableLinks <- unique( sapply(y, "[[", "href") )

   if(missing(whichTable)){
      whichTable <- 1 : length(tableLinks)
   }else{
      if(any(!whichTable %in% 1:length(tableLinks) )){stop("Only ", length(tableLinks) , " table links available")} 
   }
   y <- vector("list", length(whichTable) )

   for(k in 1: length(whichTable) ){
      if(verbose) print(paste("Downloading Table", whichTable[k] ))
      url1 <- paste(url, tableLinks[ whichTable[k] ], sep="")
      t1 <- try( htmlParse2(url1))
      if(class(t1)[1] == "try-error"){stop("Cannot download ", url1) }

           ## from pmcTable

           #--------------------------------------------------------------------
            #PARSE HEADER
            ##  some XML use th (header cell) instead of td (standard cell)?  

            x <- getNodeSet(t1, "//thead/tr")

            if(length(x) == 0){
                thead<-NA

            ## 1 header row...
            }else if(length(x) == 1 ){
                colspan <- as.numeric( xpathSApply(x[[1]], ".//td|.//th", xmlGetAttr, "colspan", 1) )
                thead <- xpathSApply(x[[1]], ".//td|.//th", xmlValue)
                if( any(colspan>1) ){ 
                   thead <- rep(thead, colspan)
                   thead<-gsub("\n", "", thead)
                }

            # OR collapse mutliline header into single row
         
            }else{
               nr <- length(x)
                 c2 <- data.frame()       
                 for (i in 1:nr){
                   rowspan <- as.numeric( xpathSApply(x[[i]], ".//td|.//th", xmlGetAttr, "rowspan", 1) )
                   colspan <- as.numeric( xpathSApply(x[[i]], ".//td|.//th", xmlGetAttr, "colspan", 1) )
                   thead <- xpathSApply(x[[i]], ".//td|.//th", xmlValue)

                   if( any(colspan>1) ){ 
                     thead      <- rep(thead, colspan)
                     rowspan <- rep(rowspan, colspan)
                   }
                  ## create empty data.frame
                  if( i ==1){
                     nc <- length(thead)
                     c2 <- data.frame(matrix(NA, nrow = nr , ncol =  nc ))
                  }
                  # fill values into empty cells
                  n <- which(is.na(c2[i,]))

                  if(length(thead ) != length(n) )  thead <- thead[1: length(n) ]

                  c2[ i ,n] <- thead

                  if( any(rowspan > 1) ){
                     for(j in 1:length( rowspan ) ){
                        if(rowspan[j] > 1){
                            ## repeat value down column
                              c2[ (i+1):(i+ ( rowspan[j] -1) ) , n[j] ]   <- thead[j]
                        }
                     }
                  }
               }
              
               ## COLLAPSE into single row...
               ## some rowspans may extend past nr!  see table 1 PMC3109299 
               if(nrow(c2) > nr) c2<- c2[1:nr, ]
          
                ## collapsing column names and row values uses ";" as separator
               thead <- apply(c2, 2, function(x) paste(unique(x), collapse=": "))
               thead<-gsub("\n", "", thead)
               thead <- gsub(": *: ", ": ", thead)  # some mutliline rows with horizontal lines only
               thead <- gsub("^: ", "", thead) 
               thead <- gsub(": $", "", thead) 

            }

            #--------------------------------------------------------------------
            #PARSE TABLE
            ## Does not repeat values with colspans across rows (usually table subheaders) 
            ## Repeats values with rowspan down columns  - since single rows are often needed

            x <- getNodeSet(t1, "//tbody/tr")
            ##   added July 25, 2013 see PMC3166833
            if(length(x) == 0){
                 print("Warning: no table rows with node //tbody/tr.  May be link to image")
                 c2 <- data.frame()
            }else{

               # number of rows 
               nr <- length(x)
               for (i in 1:nr){
                  ## some table use //th  see table1 PMC3031304
                  rowspan <- as.numeric( xpathSApply(x[[i]], ".//td|.//th", xmlGetAttr, "rowspan", 1) )
                  colspan <- as.numeric( xpathSApply(x[[i]], ".//td|.//th", xmlGetAttr, "colspan", 1) )
                  val <- xpathSApply(x[[i]], ".//td|.//th", xmlValue)

                  if( any(colspan>1) ){ 
                     val      <- rep(val, colspan)
                     ##  DON't repeat subheaders and other colspans (optional?)
                     val[-1][val[-1]==val[-length(val)]] <- NA
                     rowspan <- rep(rowspan, colspan)
                  }

                  # how to get # columns? - could check header if present ... length(thead)
                  # OR  check every row (but some rows may have extra columns)
                  # nc <- max( sapply(x, function(y) sum( xpathSApply(y, ".//td", xmlGetAttr, "colspan", 1)) ) )
                  # this just uses # columns IN first row 
                  ## create empty data.frame
                  if( i ==1){
                     nc <- length(val)
                     c2 <- data.frame(matrix(NA, nrow = nr , ncol =  nc ))
                  }
   
                  # fill values into empty cells
                  n <- which(is.na(c2[i,]))
  
                  # some tables have extra td tags  see table 2  PMC3109299
                  # <td align="left" rowspan="1" colspan="1"/> 
                  # truncate to avoid warning.... may lose data???
                  if(length(val) != length(n) )  val<-val[1: length(n) ]
                  c2[ i ,n] <- val

                  if( any(rowspan > 1) ){
                     for(j in 1:length( rowspan ) ){
                        if(rowspan[j] > 1){
                           ## repeat value down column
                           c2[ (i+1):(i+ ( rowspan[j] -1) ) , n[j] ]   <- val[j]
                        }
                     }
                  }
              }  # end for
          } # end else
                
         x <- c2
         if(nrow(x)>0){
            # add column names

            if( !is.na( thead[1] )){
               colnames(x) <- thead[1:ncol(x)]
            }
            #DELETE empty rows  - 
            if(nrow(x)>1){
               nX <- apply(x, 1, function(y) sum(! (is.na(y) | y=="") ))
               x  <- x[nX != 0,, FALSE]   # use FALSE in case only 1 column in TABLE
            }
            # EMPTY columns
            if(ncol(x)>1){
               n <- apply(x, 2, function(y) sum(! (is.na(y) | y == "" | y == " " | y =="\u00A0") ))
               if(any(n == 0)){
                  # print(paste("Deleted", sum(n == 0), "empty columns"))
                  x <- x[, n != 0] 
               }
            } 
            # FIX column typess 
            ## errors if newlines and tabs in cells (or colnames!)
            colnames(x) <- gsub("\n *", "", colnames(x))
            # also quotes in cells will cause errors...
            x2  <- try( fixTypes(x, na.strings="", ...) , silent=TRUE)
            if(class(x2)=="try-error"){
                print("ERROR fixing types - skipped")
            }else{
                x <- x2
            }
            ## fix characters.. better way?
            x <- sr(x, "â\u0088\u0092|â\u0080\u0093|â\u0080\u0094|â\u0086\u0093", "-")
            x <- sr(x, "Ã\u0097", "x")   # times
            x <- sr(x, "â\u0089\u0088", "~")  
            x <- sr(x, "â\u0080²|â\u0080\u0099", "'")  
            ## fix types 
            x <- fixTypes(x)      
            ## GET caption
            c1<- xpathSApply(t1, "//h1[@class='content-title']", xmlValue)
            c1 <- gsub("\\.$", "", c1)
            c2 <-xpathSApply(t1, "//div[@class='caption']", xmlValue)
            attr(x, "id") <- attr(doc, "id")
            attr(x, "file") <- url1
            # check if empty list?
            attr(x, "label") <- c1
            attr(x, "caption") <- c2
            ## footnotes - 
            fn <- xpathSApply(t1, "//div[contains(@id, 'fn')]", xmlValue)
            if(length(fn)==0)  fn<- xpathSApply(t1, "//div[contains(@id, 'TF')]",    xmlValue) 
            if(length(fn)>0){
                fn <- gsub( "â\u0080\u0099", "'", fn)  
                ## ADD space
                fn <- paste( substr(fn, 1,2), substring(fn, 3))
                attr(x, "footnotes") <- fn
            }  
         y[[k]] <- x
         }
      }
      if(simplify & length(y)==1) y<-y[[1]]
      y
   }
}



