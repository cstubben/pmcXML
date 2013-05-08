# get subsequences using DNAstring and GRANGEs object  - make ID optional?

grSeq  <- function(gr, dna, id=1){
   n <- as.logical(strand(gr)=="+")
   y <- Views(dna, ranges(gr))
   seqs <- ifelse(n, as.character(y), as.character(reverseComplement( y )))
   def <- paste(">",  values(gr)[, id], "|",
         ifelse( n,  paste( start(gr), end(gr), sep="-"),
                 paste("c", end(gr), "-", start(gr), sep="")), sep="")
  
   #data.frame(def, seqs, stringsAsFactors=FALSE)
   #DataFrame(def, seqs=DNAStringSet(seqs))
   DataFrame(def, seqs)   
}
