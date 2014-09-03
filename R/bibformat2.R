
## format for pmcMetadata.R 


bibformat2 <- function(refs){
   #labels are missing
   if( all(is.na(refs[,8])) ) refs[,8] <- as.character( 1: nrow(refs))

# all authors missing
   if( all(is.na(refs[,2] ))){
       x <- apply(refs, 1, function(x) paste(c( "[", x[8], "] ", x[4], " [PubMed ", x[1], "]."), collapse="") )
   }else{
      ## books with missing volume - use pages, pp. p ?
      x <- apply(refs, 1, function(x) paste(c( "[", x[8], "] ", 
        ifelse(is.na(x[2]), "", x[2]), 
        ifelse(is.na(x[3]), "", paste(" (", x[3], ") ", sep="")), 
        ifelse(is.na(x[4]), "", paste(x[4], ", ", sep="")),             # title
        ifelse(is.na(x[5]), "", paste(x[5], " ", sep="")),              #journal
        ifelse(is.na(x[6]), "", paste(x[6], ":", sep="")), 
        ifelse(is.na(x[7]), "", x[7]), " [PubMed ", x[1], "]."),
       collapse="") )
   }

x <- gsub(" [PubMed NA]", "", x, fixed=TRUE)
x <- gsub("[;, ]+\\.$", ".", x)
 x
}

