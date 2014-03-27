
# source("~/plague/R/packages/pubmed/R/findGenes.R")


findGenes<-function(txt ){
   id <- attr(txt, "id")
   # if TABLE?
   if(is.data.frame(txt) ){
      ## use label and caption for source?
      label <- attr(txt, "label")
      txt <- list(  Table = collapse3(txt ) )
      names(txt) <- label
      attr(txt, "id") <- id
   }

   # start of sentence - do not match PubMed (=PubM), so include flanking [^a-z]
 #  y <-      searchP(txt, "(^|[^a-zA-Z])[A-Za-z][a-z]{2}[A-Z0-9][^a-z]", ignore.case=FALSE)

## no mutant strains like ΔtofR using word boundary 
     ## y <-      searchP(txt, "\\b[A-Za-z][a-z]{2}[A-Z0-9][^a-z]", ignore.case=FALSE)
     y <-      searchP(txt, "\\b[A-Za-z][a-z]{2}[A-Z0-9]+\\b", ignore.case=FALSE)
 
if(is.null(y)){
   x<-NULL
}else{

   ## str_extract_all( "get boaA-BoaB sctU1 and purM (bimA or bimBm) not bpsl001 or HIS1 and get thiS", "[A-Za-z][a-z]{2}([A-Z]+|[0-9]|[A-Z][0-9])\\b")
 ## need a better parser for plasmids  (returned in same sentence as gene) ..  split into words and then parse?
 ## str_extract_all( "flanking regions of tofR from pKKtofRUD was cloned to pKKSacB", "\\b[A-Za-z][a-z]{2}([A-Z]+|[0-9]|[A-Z][0-9])\\b")


   # match A-Z to any length for operons, or ending in 1 or 2 numbers (for omp85) or letter-number like dnaE2

   z <- str_extract_all( y$mention, "\\b[A-Za-z][a-z]{2}([A-Z]+|[0-9]{1,2}|[A-Z][0-9])\\b")    

   # select unique 
   z <- lapply(z, unique) 
   n <- sapply(z, length)

   gene <- unlist(z)
   if(length(gene)==0){
      x<-NULL
  }else{
     gene  <- paste(tolower(substr(gene, 1,1)), substring(gene, 2) , sep="")
     x <- data.frame( id, source= rep(y$section, n),  gene, mention= rep(y$mention, n), stringsAsFactors=FALSE)
     #  may have same protein and gene in sentence, eg, BimA and bimA
     x <- unique(x)
     rownames(x)<-NULL

     ## DROP
     x <- subset(x, !gene %in% c("log2", "taqDNA", "traDIS", "log10", "ecoRI", "bamHI", "chr1", "chr2", "orf1", "orf2", "xbaI") )
     if(nrow(x)==0){
       x<-NULL
     }else{
        print(paste("Found ", nrow(x), " gene mentions (", length(unique(x$gene)), " unique)", sep=""))
        # split operons? or use synonym table - tauABCD = tauA, tauB, tauC, tauD)
        n <- which( nchar(unique(x$gene) )>5) 
        if( length(n)>0) {
           print(paste("  possible operons:", paste( unique(x$gene)[n], collapse=", " )))   
        }
     }
   }
 }
 x
}






