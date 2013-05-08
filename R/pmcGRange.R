
# CONVERT pmc Table to GRange - requires start, end and strand columns (for now)

pmcGRange<-function(x, acc){

   if(missing(acc)){acc <- x$seqnames}
   n <- match(c("start", "end", "strand"), tolower(names(x)))
   if(any(is.na(n))){stop("Need columns matching start, end, strand")}

   gr <- GRanges(seqnames= acc,
          ranges = IRanges( x[, n[1]] ,   x[, n[2]]   ),
          strand = x[, n[3]],
          data.frame(x[, -n ]))
   seqlengths(gr) <- ncbiNucleotide(acc)$size
   # inlcude file (from read.xls2)
   metadata(gr) <- list( 
      file = attr(x, "file"),
      caption =  attr(x, "caption"),
      footnotes = attr(x, "footnotes" ))
   gr
}

