## read markdown file into list of paragraphs with subsection names

# source("~/plague/R/packages/pubmed/R/readMarkdown.R")

readMarkdown<-function(file, sentence=TRUE, openNLP=FALSE){
   x1 <- readLines(file)
  

   id<-NULL
## option to save pmid as attribute?
   if(grepl("^ID=", x1[1])){
        id <- as.numeric( gsub("ID=(.*)", "\\1", x1[1]) )
        x1<- x1[-1]
   }
   ## add empty lines
   x1 <-c("",  x1, "")

## remove duplicate (empty?) rows
x1 <- x1[cumsum(rle(x1)$lengths)]


   ## WRAP text between paragraph breaks (and remove hyphen at end of line?)

   n <- which(x1=="")

   n2<- length(n)-1

   x <- vector("character", n2)
   for(i in 1:n2 ){
       y<- x1[ (n[i]+1):(n[i+1]-1) ]
       ## collapse multi-lines
       if(length(y)>1){
           ## fix hyphenated words at end of line
           n3 <-  grep("-$", y)
           if(length(n3)>0){
              for(j in n3){

                   w1 <- gsub(".* ([^ ]+-)", "\\1", y[ j ]  )
                   w2 <- gsub("([^ ]+) .*", "\\1", y[j+1 ]  )
                   y[j+1] <- gsub("^[^ ]+ ", "", y[j+1]  )
                   y[j] <- paste( gsub("-$", "", y[j]), w2, sep="")
                   print(paste("Combining ", w1, w2, sep=""))
              }
           }
           y <- paste(y, collapse=" ")
       }
       x[i] <- y
    }

   ## get subsections
   n <- grep("^#", x)

   # list ALL subsections
   sec <- gsub("^#+", "", x[n])

   # list all header names...
   n1 <- nchar( gsub("(^#+).*", "\\1", x[n]))

   # get full path to subsection
   path <- path.string(sec, n1 ) 

   z <- vector("list")
   n <- c(n, length(x)+1)

   for(i in 1:(length(n)-1) ){
      # skip sections without text..
      if(n[i + 1] - n[i] > 1){
          y <- x[(n[i]+1): (n[i+1]-1)]
          z[[ path[i] ]] <- fixText( y )    
      }
   }
 sec <- gsub("([0-9])\\. ", "\\1 ", sec)
 z[["Section title"]] <- sec


   if(sentence){
        if(openNLP){  
                z <- lapply(z, sentDetect)
                z <- lapply(z, function(x) gsub(" $", "", x) )
              }else{
                 z <- lapply(z, splitP)
              }
   }
   attr(z, "id") <- id
   z 
}
