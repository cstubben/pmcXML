findGenes <- function( txt ){
   id <- attr(txt, "id")

   if(is.null(id)){
       if(is.list(txt)) id <- attr(txt[[1]], "id")   # list of tables
       if(is.null(id)){
          message("Warning: No id attribute found")
          id <- NA
       }
    }


 
   # start of sentence - do not match PubMed (=PubM), so include flanking [^a-z]
   #  y <-      searchPMC(txt, "(^|[^a-zA-Z])[A-Za-z][a-z]{2}[A-Z0-9][^a-z]", ignore.case=FALSE)

   ## OR use word boundary AND include mutant strains like ΔtofR ??    
   # June 23, 2014 Added = for genes in collapsed tables.  Not sure why this is needed (code seems to works line by line but not in function
   # July 13, 2014 added (\\b|_) for genes with subscripts 
  
   y <- searchPMC(txt, "\\b[=Δ]?[A-Za-z][a-z]{2}[A-Z0-9]+(\\b|_)", ignore.case=FALSE)
 
   if(is.null(y)){
      x<-NULL
   }else{

      ## str_extract_all( "get boaA-BoaB sctU1 and purM (bimA or bimBm) not bpsl001 or HIS1 and get thiS", "[A-Za-z][a-z]{2}([A-Z]+|[0-9]|[A-Z][0-9])\\b")
      ## need a better parser for plasmids  (returned in same sentence as gene) ..  split into words and then parse?
      ## str_extract_all( "flanking regions of ΔpurM tofR sctU_Bp2from pKKtofRUD was cloned to pKKSacB", "\\b[A-Za-z][a-z]{2}([A-Z]+|[0-9]|[A-Z][0-9])\\b")

      # match A-Z to any length for operons, or ending in 1 or 2 numbers (for omp85) or letter-number like dnaE2

      z <- str_extract_all( y$mention, "\\bΔ?[A-Za-z][a-z]{2}([A-Z]+|[0-9]{1,2}|[A-Z][0-9])(\\b|_)")    

      # select unique 
      z <- lapply(z, unique) 
      n <- sapply(z, length)

      gene <- unlist(z)
      if(length(gene)==0){
         x<-NULL
      }else{
         gene <- gsub("_$", "", gene)
         gene  <- ifelse(grepl("^[A-Z]", gene), paste(tolower(substr(gene, 1,1)), substring(gene, 2) , sep=""), gene)
         gene  <- ifelse(grepl("^Δ[A-Z]", gene), paste(substr(gene, 1,1), tolower(substr(gene, 2,2)), substring(gene, 3) , sep=""), gene)

         x <- data.frame( id, source= rep(y$section, n),  gene, mention= rep(y$mention, n), stringsAsFactors=FALSE)
         #  may have same protein and gene in sentence, eg, BimA and bimA
         x <- unique(x)
         rownames(x)<-NULL

         ## DROP??
         x <- subset(x, !gene %in% c("log2", "taqDNA", "traDIS", "log10", "ecoRI", "bamHI", "chr1", "chr2", "orf1", "orf2", "xbaI", "xhoI","bglII" ) )
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






