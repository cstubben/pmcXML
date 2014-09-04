## source("~/plague/R/packages/pubmed/R/pdf2df.R")


# SPLIT is a space delimited string with either 
# w = single word (no spaces)
# s = single letter  ## added July 31, 2013 since "-" strand matches d (which can mess up splitting)
# d = decimal 0-9 and characters in scientific notation [Ee.-]
# a = any character including spaces
# e = optional last column on end of line 

## need NA, NaN for digit?

## backreferences only from 1 to 9 allowed

## OPTIONS for column/header labels 
  # "Locus tag Name COG"
  # A) elements from header to keep as colNames = 1,3,4  returns  "Locus" "Name" "COG"
   ## Will not always work since this must have at least one value greater than number of columns 4>3

  # B) number of words in each column name      = 2,1,1  returns  "Locus tag" "Name" "COG"
  # C) new character names = "id" "def" "cog" 

  # "id gene name"
  # A) 1,3 returns "id", "name"
  # B) 1,2 returns "id",  "gene name"  


pdf2df <-function(x, split, captionRow=1, headerRow=2, labels , subset)
{
   xAttr <- attributes(x)
   ## subsetting loses attributes...
   if(!missing(subset))  x <- x[subset]
   caption <- "";  
   header <- NULL
   if(missing(split)){stop("Please enter a string to split columns -see help for details")}

   if(is.numeric(captionRow)){
       caption <- x[captionRow]
       if(length(caption)>1) caption <- paste(caption, collapse=" ")
   } 
   if(is.numeric(headerRow)){
      xx <- x[headerRow]
      header <- unlist( strsplit(xx, " "))
      if(!missing( labels )){
           if(is.numeric(labels)){
              n <-length(labels) 
              # vector with ELEMENTS to keep.
              if(max(labels) > n){
                 header <- header[labels]
              # vector with number of words in column names
              }else{
                 z  <- split(header, rep(1:n, labels))
                 header <- as.vector(sapply(z, paste, collapse=" "))
              }
           }else{
              header <- labels
           }
           # header <- tolower(header)
           header <- gsub("/", "_", header)
      }  
   
      #remove caption header
      if(is.numeric(captionRow)){
         x <-x[-c(captionRow, headerRow)]
      }else{
         x <-x[- headerRow]
      }
   }
  
   y <- strsplit(split, " ")[[1]]
   if(length(y)>9) stop("Can only split 9 or more columns (ie, backreferences \\10 and above are not allowed in gsub)")
   # regular expression 
     ##  fix July 31, 2013 - use non-greedy match 
     #.*? doesn't work if at end of row!  see Staph PMC2790875
     

   z  <- list(w="([^ ]*)", d="([0-9Ee.-]*)", s="([^ ])", a="(.*)", e="?(.*?)")
   z1 <- paste( z[ match(y, names(z))], collapse= " ")   #pattern
   z2 <-  paste( "\\", paste(1:length(y), collapse="\t\\"), sep="")  #capture strings \\1\t\\2\t\\3
#print(z1)
#print(z2)
   x <- gsub( z1,z2, x)
   # read into data.frame
   zz <- textConnection(x)
   x <- read.delim(zz, header=FALSE, stringsAsFactors=FALSE, fill=TRUE)
   close(zz)
   if(length(header) ==  ncol(x) ) names(x) <- header

   y <-strsplit(caption, ". ", fixed=TRUE)[[1]]
   attr(x, "label") <- y[1]
   attr(x, "caption") <- paste(y[2:length(y)], collapse=". ")
if(length(xAttr)>0){
   for(i in 1:length(xAttr) ){
       attr(x, names(xAttr)[i]) <- xAttr[[i]]
   }
}
   x
}
