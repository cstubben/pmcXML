# download Excel supplements from web (need option to read local file and skip download.file lines)

## NOTE: some .xls files are actually text /csv

## June 25, 2013.  add pmc=TRUE to allow downloads of supplements outside PMC (then file = url).
## change 1st option doc to pmcid

# aug 18, 2013 - removed option encoding="latin1" for pdf
# Aug 27, 2014 - use htmlParse for doc files and get caption/ footnotes


# SAVE pmid and file

getSupp <- function(pmcid, file, type,  opts="-raw -nopgbrk", rm=TRUE,  header=TRUE, pmc=TRUE, ...)
{
   ## option to read id from XML doc
   if( !is.vector(pmcid) ){
      pmcid <- attr(pmcid , "id")
      if(is.null(pmcid)) stop("Missing PMC id attribute")
   }
   if(missing(file)) stop("Missing file name") 

   # match file type to filename extension? some xls are actually text files! 
   if(missing(type)){
       type <- tolower( gsub(".*\\.([^.]*)", "\\1", file) )
   }
 if(pmc){
   url <- paste("http://www.ncbi.nlm.nih.gov/pmc/articles", pmcid, "bin", file, sep="/")
}else{
   url <- file
   file <- paste("tmp", type, sep=".")

}

   ZIP <- FALSE
   if(type=="zip"){
       print("Downloading zip file")
       download.file( url , "tmp.zip")
       x <- system("unzip tmp.zip", intern=TRUE)

       file2 <- gsub(" *inflating: ([^ ]*) *", "\\1", x[2])
       print(paste("Inflating", file2))

       type <- tolower( gsub(".*\\.([^.]*)", "\\1", file2 ) )

       ## Use local file for read.* commands
         urlzip <- url 
         url <- file2
        ##  set ZIP flag and skip download.files in pdf and doc (also rename file for system commands)
        ZIP <- TRUE
       
       if(type=="doc")  file.rename(file2, "tmp.doc")
       if(type=="docx") file.rename(file2, "tmp.docx")
       if(type=="pdf") file <-  file2
        
       if(rm) file.remove("tmp.zip")
   }
   ## PDF files 
   if(type=="pdf"){ 
      if(!ZIP) download.file(url, file, quiet=TRUE)
      outfile <- paste(file, ".out", sep="")
      command <- paste("pdftotext", opts, file,  outfile)
      system(command)
      x <- readLines(outfile, ...)  # encoding =latin1
      # remove files
      if(rm){
         file.remove(file)
         file.remove(outfile)
      }
      # FIX latin characters
        x <- iconv(x, "latin1", "ASCII", sub="byte")
        x <- gsub("<e2><80><90>", "-", x)   # minus
        x <- gsub("<c2><a0>", " ", x)       #spaces
        x <- gsub("  *", " ", x)  # replace 2 or more spaces
        x <- gsub(" $", "", x)  # trim trailing space
        x <- x[grep("^$", x, invert=TRUE)] # remove empty rows
      print(paste("Returned", length(x), "rows"))

   ## WORD documents
   } else if(type=="doc" | type == "docx" ){
      ## word doc - use unoconv
      if(type=="doc"){
         if(!ZIP) download.file(url, "tmp.doc", quiet=TRUE)
         command <- "unoconv -f xhtml tmp.doc"
      # need docx for unoconv
      }else{
         if(!ZIP) download.file(url, "tmp.docx", quiet=TRUE)
         command <- "unoconv -f xhtml tmp.docx"
      }
      system(command)
      ## read html or  table ??  read html to see captions, footnotes 
      doc2 <- htmlParse2("tmp.html")

      x <-readHTMLTable(doc2, stringsAsFactors=FALSE, header=header, ...)    # fixed July 25, 2013  -add header=header

      ## if empty, get text?
      if(length(x)==0){
           print("Warning: no tables found in Word Doc")
           x <- xpathSApply(doc2, "//p", xmlValue)
           x<-x[! x %in% c("", " ")]
      }else{
           ## add captions and footnotes?
           xp <- xpathSApply(doc2, "//body/p", xmlValue)
           xp<-xp[! xp %in% c("", " ")]
        if(length(xp)>0){
            caption <- xp[1]
            print(paste("Parsing caption: ", caption))
            label <- gsub("([^.:-]*).*", "\\1", caption)
            label <- gsub(" *$", "", label)
            caption <- gsub("[^.:-]*. *(.*)", "\\1", caption)
            for(j in 1:length(x)){
                  attr(x[[j]], "label") <-  label
                  attr(x[[j]], "caption") <- caption
            }
         }         
         if(length(x)==1){
                x <- x[[1]]   
                if(length(xp[-1])>0)  attr(x, "footnotes") <- xp[-1]
         }else{     # multiple tables - use same caption and label for all???
              print(paste("  Note:", length(x), "tables found"))  
             if(length(xp[-1])>0){  
                    print("  Possible text for captions and footnotes")
                    print( xp[-1])
                 }
         }
      }  

      # remove files
      if(rm){
         if(type=="doc"){
           file.remove("tmp.doc")
         }else{
           file.remove("tmp.docx")
         }
         file.remove("tmp.html")
      }

   ## TEXT 
   } else if(type=="txt"){
      x <- readLines(url, ...)
      if(rm & ZIP) file.remove(file2)

   ## TEXT tables 
   } else if(type=="csv"){
      ##  default separator ?  
      x <- read.table(url, stringsAsFactors=FALSE, check.names=FALSE, ...)
      x <- guessTable(x)
      if(rm & ZIP) file.remove(file2)


   ## HTML tables   
   }else if( type == "html"){
      # html supplements have formatting AND data tables..
      x <- readHTMLTable(url, stringsAsFactors=FALSE)
      x <- x[[which.max(sapply(x, nrow) )]]   # find table with most rows
       colnames(x) <- x[1,]   #assign colnames from row 1 
       x <- x[-1,]
       rownames(x)<-NULL
       for(i in 1:ncol(x)) x[,i]<-gsub("\u0096", "-", x[,i])
       for(i in 1:ncol(x)) x[,i]<-gsub("^\u00A0$", NA, x[,i])  # nbsp

      if(rm & ZIP) file.remove(file2)
   ## EXCEL files  
   ## June 11, 2013  fix to read multiple sheets
   }else{
       if(ZIP){
          file <- file2
       }else{
           download.file(url, file, quiet=TRUE)
       }
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
       # 1 sheet then return data.frame
       if(length(x)==1) x <- x[[1]]
       if(rm) file.remove(file)
     }
   }
   attr(x, "id") <-  pmcid
   attr(x, "file") <- url 
   ## 
   zz <- attr(x, "footnotes")
   if(!is.null(zz)){
     if(length(zz)==1 && zz =="") attr(x, "footnotes")<-NULL
   }

   if(ZIP)  attr(x, "file") <- urlzip
   x
}

