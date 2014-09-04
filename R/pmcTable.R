## GET tables from pmc XML file
# this  uses rowspan and colspan attributes to format table including multi-line headers.  
# Repeats cell values down columns if rowspan > 1 since single rows should stand-alone as a mention 

pmcTable  <- function(doc, whichTable, simplify=TRUE,...)
{
   tables  <- getNodeSet(doc, "//table-wrap")
   if(length(tables)==0){ 
      NULL
   }else{
      if(!missing(whichTable)) tables <- tables[ whichTable ]
      n <-  length(tables)
 
      y <- vector("list", n )
 
      for(k  in 1: n ){
         z2 <- xmlDoc( tables[[ k ]])

         ## TABLE id in URL string
         id      <- xpathSApply(z2, "//table-wrap", xmlGetAttr, "id")
         label   <- xpathSApply(z2, "//table-wrap/label",      xmlValue)
         caption <- xpathSApply(z2, "//table-wrap/caption",    xmlValue)

         ## label and caption missing  see PMC3119406  - table is appendix 
          if(length(caption)==0 & length(label)==0 ) {
             caption<-""
             label <- "Table ?"
          } else if( length(label)==0){
            # missing label - may be part of caption... see PMC3544749
             label<- genomes::strsplit2(caption, "\\. ")
             caption <- gsub(paste(label, ". " ,sep="") , "", caption)
          }
          caption <- gsub("\\.$", "", caption)


         message(paste("Parsing", paste(label, caption) ))

         #--------------------------------------------------------------------
         # PARSE footnotes (with option label and captions)
         flabel <- xpathSApply(z2, "//table-wrap-foot/fn/label", xmlValue)
         fn     <- xpathSApply(z2, "//table-wrap-foot/fn/p",     xmlValue)
          
         if(length(flabel) > 0){   
            fn <- paste(flabel, fn, sep=". ") 
         }
         # OR any text if no fn/p... 
         if(length(fn)==0){
            fn <- xpathSApply(z2, "//table-wrap-foot", xmlValue)
         }

         #--------------------------------------------------------------------
         ## GET table tag 
         t1 <- getNodeSet(z2, "//table")
  
         ## some table tags are missing   
         ## SEE http://www.ncbi.nlm.nih.gov/pmc/articles/PMC2211553/table/ppat-0040009-t001/
         if(length(t1)==0){ 
            print("  No table node - possible link to image?") 
            x <- data.frame()
            thead <- NA
            free(z2)
         }else{
             # a few table-wrap with 2 tables!  see Table 2 PMC3161971 
            t1 <- t1[[1]]
           
            #--------------------------------------------------------------------
            #PARSE HEADER
            ##  some XML use th (header cell) instead of td (standard cell)?  

            x <- getNodeSet(t1, ".//thead/tr")

            if(length(x) == 0){
                thead<-NA

            ## 1 header row...
            }else if(length(x) == 1 ){
                colspan <- as.numeric( xpathSApply(x[[1]], ".//td|.//th", xmlGetAttr, "colspan", 1) )
                thead <- xpathSApply(x[[1]], ".//td|.//th", xmlValue)
                if( any(colspan>1) ){ 
                   thead <- rep(thead, colspan)
                }

            # OR collapse mutliline header into single row
            # SEE  tables 1 and 2 in http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3109299 
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

                  ## truncate to avoid warning - see PMC3119406
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
               thead <- gsub(": : ", ": ", thead)  # some mutliline rows with horizontal lines only
               thead <- gsub("^: ", "", thead) 
               thead <- gsub(": $", "", thead) 

            }

            #--------------------------------------------------------------------
            #PARSE TABLE
            ## Does not repeat values with colspans across rows (usually table subheaders) 
            ## Repeats values with rowspan down columns  - since single rows are often needed

            x <- getNodeSet(t1, "//tbody/tr")
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
            }
            
            free(z2)
            # table
            x <- c2
            if( !is.na( thead[1] )){
                ## see table 3 from PMC3020393  -more colnames than columns
                colnames(x) <- thead[1:ncol(x)]
            }
            #DELETE empty rows  - 
            if(nrow(x)>1){
               nX <- apply(x, 1, function(y) sum(! (is.na(y) | y=="") ))
               x  <- x[nX != 0,, FALSE]   # use FALSE in case only 1 column in TABLE
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
         }
         ### Attributes
         attr(x, "id")   <- attr(doc, "id")
         attr(x, "file") <- paste( attr(doc, "file"), "table", id, sep="/") 
         attr(x, "label") <- label
         attr(x, "caption") <- caption

         if(length(fn)>0){
           attr(x, "footnotes") <- fn
          }
         y[[ k ]] <- x
         names(y)[k ] <- label
      }
      if(simplify & length(y)==1) y<-y[[1]]
      y
   }
}
