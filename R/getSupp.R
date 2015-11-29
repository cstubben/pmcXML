# download supplements from web

getSupp <- function( file, type,  opts="-raw -nopgbrk",  header=TRUE, ...)
{
   # match file type to filename extension? some xls are actually text files! 
   if(missing(type)){
       type <- tolower( gsub(".*\\.([^.]*)", "\\1", file) )
   }
   rm <- FALSE

   ## tar.gz files in pmc FTP ( read from web or local file) 
   if(substr(file,1,4) == "http"){
       tmpfile <- paste0( "tmp.", type)
       message("Downloading ", file)
       download.file( file , tmpfile, quiet=TRUE)
       file <- tmpfile 
       rm <- TRUE
    }

   if(type == "zip"){

       x <- system( paste("unzip", file) , intern=TRUE)
       file2 <- gsub(" *inflating: ([^ ]*) *", "\\1", x[2])
       print(paste("Inflating", file2))
       type <- tolower( gsub(".*\\.([^.]*)", "\\1", file2 ) )
       if(rm) file.remove(file)
       file <- file2  
   }

   ## PDF files 
   if(type == "pdf"){ 
  
      outfile <- paste(file, ".out", sep="")
      command <- paste("pdftotext", opts, file,  outfile)
      system(command)
      x <- readLines(outfile, ...)  # encoding =latin1

      # FIX latin characters
      x <- iconv(x, "latin1", "ASCII", sub="byte")
      x <- gsub("<e2><80><90>", "-", x)   # minus
      x <- gsub("<c2><a0>", " ", x)       #spaces
      x <- gsub("  *", " ", x)  # replace 2 or more spaces
      x <- gsub(" $", "", x)  # trim trailing space
      x <- x[grep("^$", x, invert=TRUE)] # remove empty rows
      print(paste("Returned", length(x), "rows"))

   ## WORD documents

## replace with https://github.com/hrbrmstr/docxtractr


   } else if(type == "doc" | type == "docx" ){



      command <- paste("unoconv -f xhtml", file)
      system(command)

      outfile <- paste0( gsub("(.*)\\.[^.]*", "\\1", file), ".html")

      ## read html or  table ??  read html to see captions, footnotes 
      doc2 <- htmlParse2( outfile )

      x <-readHTMLTable(doc2, stringsAsFactors=FALSE, header=header, ...)    # fixed July 25, 2013  -add header=header

      ## if empty, get text?
      if(length(x) == 0){
           print("Warning: no tables found in Word Doc")
           x <- xpathSApply(doc2, "//p", xmlValue)
           x<-x[! x %in% c("", " ")]
      }else{
           ## add captions and footnotes?
           xp <- xpathSApply(doc2, "//body/p", xmlValue)
           xp<-xp[! xp %in% c("", " ")]
        if(length(xp)>0){
            caption <- xp[1]
            print(paste("  ", caption))
            label <- gsub("([^.:-]*).*", "\\1", caption)
            label <- gsub(" *$", "", label)
            caption <- gsub("[^.:-]*. *(.*)", "\\1", caption)
            for(j in 1:length(x)){
                  attr(x[[j]], "label") <-  label
                  attr(x[[j]], "caption") <- caption
                  names(x)[j] <- paste(label, caption, sep=". ")
            }
         }         
         if(length(x) == 1){
               # x <- x[[1]]   
                if(length(xp[-1])>0)  attr(x, "footnotes") <- xp[-1]
         }else{     # multiple tables - use same caption and label for all???
              print(paste("  Note:", length(x), "tables found"))  
             if(length(xp[-1])>0){  
                    print("  Possible text for captions and footnotes")
                    print( xp[-1])
                 }
         }
      }  


   ## TEXT 
   } else if(type=="txt"){
      x <- readLines(file, ...)
 

   ## TEXT tables 
   } else if(type=="csv"){
      ##  default separator ?  
      x <- read.table(file, stringsAsFactors=FALSE, check.names=FALSE, ...)
      x <- guessTable(x)
 
   ## HTML tables   
   }else if( type == "html"){
      # html supplements have formatting AND data tables..
      x <- readHTMLTable(file, stringsAsFactors=FALSE)
      x <- x[[which.max(sapply(x, nrow) )]]   # find table with most rows
       colnames(x) <- x[1,]   #assign colnames from row 1 
       x <- x[-1,]
       rownames(x)<-NULL
       for(i in 1:ncol(x)) x[,i]<-gsub("\u0096", "-", x[,i])
       for(i in 1:ncol(x)) x[,i]<-gsub("^\u00A0$", NA, x[,i])  # nbsp


   ## EXCEL files  
   ## June 11, 2013  fix to read multiple sheets
   }else{
    
    #  some delimited-files have excel extension   - try unix file command to determine file type?
    ##   n <- sheetCount(file)
    n <- suppressWarnings( try(sheetCount(file), silent=TRUE))
    if(class(n)[1]=="try-error"){
       message("Possible delimited text file with Excel extension?") 
}else{

       sheets <- sheetNames(file)
       x <-vector("list", n)
       if(length(sheets) == n) names(x) <- sheets
       for( i in 1:n){
          ## excel files - xlsx or xls
          print(paste("Reading Sheet", i))
          ## check for empty sheets
         x[[i]] <- try( read.xls2( file , sheet= i , ...)   , silent=TRUE)
         # x[[i]] <- try( read.xls2( file , sheet= i , header=header, ...)   , silent=TRUE)
           if(class(x[[i]])[1] == "try-error"){
               x[[i]] <- NA
               print("Empty Sheet")
           }

       }
       # remove empty sheets
       x[is.na(x)] <- NULL

     }
   }

      # remove files
      if(rm) file.remove(file)
      file.remove(outfile)


## list or data.frame?

if(is.list(x) & length(x)==1)	x <- x[[1]] 
x

}

