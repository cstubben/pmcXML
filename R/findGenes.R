
# source("~/plague/R/packages/pubmed/R/findGenes.R")


findGenes<-function(txt){
   id <- attr(txt, "id")
   # if TABLE?
   if(is.data.frame(txt) ){
      label <- attr(txt, "label")
      txt <- list(  Table = collapse3(txt, caption=TRUE) )
      names(txt) <- label
      attr(txt, "id") <- id
   }

   # start of sentence - do not match PubMed (=PubM), so include flanking [^a-z]
   y <-      searchP(txt, "(^|[^a-z])[A-Za-z][a-z]{2}[A-Z0-9][^a-z]", ignore.case=FALSE)

   ## str_extract_all( "get boaA-BoaB sctU1 and purM (bimA) not bpsl001 or HIS1 and get thiS", "[A-Za-z][a-z]{2}([A-Z]+|[0-9]|[A-Z][0-9])\\b")

   z <- str_extract_all( y$mention, "[A-Za-z][a-z]{2}([A-Z]+|[0-9]|[A-Z][0-9])\\b")    

   # select unique 
   z <- lapply(z, unique) 
   n <- sapply(z, length)

   gene <- unlist(z)
   gene  <- paste(tolower(substr(gene, 1,1)), substring(gene, 2) , sep="")
   x <- data.frame( id, source= rep(y$section, n),  gene, mention= rep(y$mention, n), stringsAsFactors=FALSE)
   #  may have same protein and gene in sentence, eg, BimA and bimA
   x <- unique(x)
   rownames(x)<-NULL
 print(paste("Found ", nrow(x), " gene mentions (", length(unique(x$gene)), " unique)", sep=""))
   # split operons? or use synonym table - tauABCD = tauA, tauB, tauC, tauD)
   n<-which( nchar(unique(x$gene) )>5) 
   if( length(n)>0) {
      print(paste("  possible operons:", paste( unique(x$gene)[n], collapse=", " )))   
  }
   x
}






