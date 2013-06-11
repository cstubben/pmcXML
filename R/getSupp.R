# download Excel supplements - some .xls files are actually text

# SAVE pmid and file

getSupp <-function(doc, file, type,  opts="-raw -nopgbrk", rm=TRUE,  header=TRUE, ...)
{
   pmcid <- attr(doc, "id")
   if(is.null(pmcid)) stop("Missing PMC id attribute")
   if(missing(file)) stop("Missing file name") 

   # match file type to filename extension? some xls are actually text files! 
   if(missing(type)){
       type <- tolower( gsub(".*\\.([^.]*)", "\\1", file) )
   }
   url <- paste("http://www.ncbi.nlm.nih.gov/pmc/articles", pmcid, "bin", file, sep="/")

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
      x <- readLines(outfile, encoding="latin1", ...)
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
     # x <- htmlParse2("tmp.html", ...)
      x <-readHTMLTable("tmp.html", stringsAsFactors=FALSE, header=header, ...)
      if(length(x)==1) x <- x[[1]]


      # remove files
      if(rm){
         if(type=="doc"){
           file.remove("tmp.doc")
         }else{
           file.remove("tmp.docx")
         }
         file.remove("tmp.html")
      }

   ## TEXT tables 
   } else if(type=="txt"){
      x <- read.table(url, stringsAsFactors=FALSE, ...)
      x <- guessTable(x, file)
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
          file < -file2
       }else{
           download.file(url, file, quiet=TRUE)
       }
       n <- sheetCount(file)
       sheets <- sheetNames(file)
       x <-vector("list", n)
       if(length(sheets) == n) names(x) <- sheets
       for( i in 1:n){
          ## excel files - xlsx or xls
          print(paste("Reading Sheet", i, sheets[i]))
          x[[i]] <- read.xls2( file , sheet= i , ...)    
       }
       if(rm) file.remove(file)

   }
   attr(x, "id") <-  pmcid
   attr(x, "file") <- url 
   if(ZIP)  attr(x, "file") <- urlzip
   x
}

