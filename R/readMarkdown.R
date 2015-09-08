## read markdown file into list of paragraphs with subsection names
## 1) convert pdf to text using pdftotext
## 2) add new sections for Title, authors, affiliations, figures (and move tables into separate file) 
## 3) manually format other section titles with # or ## or ### 


readMarkdown<-function(file, sentence=TRUE ){
   x1 <- readLines(file)

   ## add empty lines at start and end
   x1 <-c("",  x1, "")

   x1 <- gsub("^ +$", "", x1)

   ## remove duplicate (empty?) rows
   x1 <- x1[cumsum(rle(x1)$lengths)]

   ## WRAP text between paragraph breaks (and remove hyphen at end of line?)
   n <- which(x1=="")
   n2 <- length(n)-1

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
   sec <- gdata::trim(sec)

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
   #sec <- gsub("([0-9])\\. ", "\\1 ", sec)
   # z[["Section title"]] <- sec

   if(sentence) z <- lapply(z, splitP)
   z 
}
