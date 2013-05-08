 
# format grSeq output as FASTA

toFasta <- function(grseq, width=70, ...){
   grseq[,2] <- gsub(paste("(.{", width, "})", sep=""), "\\1\n", grseq[,2])
   cat(t(as.data.frame(grseq)), sep="\n", ...)
}


