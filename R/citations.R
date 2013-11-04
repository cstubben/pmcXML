## RETURN list of all sentences containing citation to pubmed ID


citations <- function(doc){

   ## Search for XREF tags in full text

   # use anyP to include table-wrap, figures, formulas -- SEE PMC3737546 for missing citations because paragraphs contain tables and formulas).
   ## if reference in table or figure caption, may be counted TWICE

  txt <- pmcText(doc, anyP =TRUE )   

   xref <- searchP(txt, "XREF#")

   ## List all reference labels and PMIDs
   z <- getNodeSet(doc, "//ref")
   n <- length(z)
   refs <- vector("list", n)
   for(i in 1:n)
   {
      z2<-xmlDoc(z[[i]])
      label <-  xvalue(z2, "//label")
      rid <- xpathSApply(z2, "//ref", xmlGetAttr, "id")
      pmid <-  as.integer( xvalue(z2, '//pub-id[@pub-id-type="pmid"]') )
      refs[[i]] <- data.frame(label, pmid, rid, stringsAsFactors=FALSE)
      free(z2)
   }
   refs <- do.call("rbind", refs)
   print(paste(nrow(refs), " total references (", sum(is.na(refs$pmid)), " missing PMIDs)", sep="") )

## check if labels are NULL
  if( all(is.na(refs$label)) ){
         print("No lablels in ref tags - using rid to map")
          # map rid to label
          refs$label <- gsub("[^0-9]", "", refs$rid)
     # check mapping???
       x1 <- xpathSApply(doc, "//xref[@ref-type='bibr']", xmlValue)
       x1 <-gsub("XREF#", "", x1)
       x2 <- xpathSApply(doc, "//xref[@ref-type='bibr']", xmlGetAttr, "rid")
       if(any(x1 != gsub("[^0-9]", "", x2))) print("Warning: rids do not match cited labels")
   }

   ## EXTRACT xref tags
   ##x <- str_extract_all(xref$citation , "XREF#[[\\^ 0-9,XREF#-]+")
     ## fix for  XREF#[9]-XREF#[11]
    x <- str_extract_all(xref$citation , "XREF#[][\\^ 0-9,XREF#-]+")
   x <- lapply(x, function(y) gsub("[^0-9,-]", "", y))

   # citation row in xref
   n <-  rep(1:length(x), times=sapply(x, length))
   x <-  unlist(x)
   x<- gsub(",$", "", x)  # remove trailing commas

   # convert "9,52-55" and other citation groups to list of numbers
   x <- lapply(x, function(x) eval(parse(text = paste("c(", gsub("\\-", ":", x), ")"))) )
   n <- rep(n, sapply(x, length))

   xref2 <- data.frame(
     pmid   = refs$pmid [ match(unlist(x), refs$label) ],
     label  = unlist(x),
     sentence  =  n,
     group =  rep(1:length(x), sapply(x, length)),
     section =  xref$section[n],
     citation = gsub("XREF#", "", xref$citation[n] )
   )
   xref2 <- subset(xref2, !is.na(pmid))
   rownames(xref2)<-NULL
 print(paste(nrow(xref2), "citations from",  length(unique(xref2$pmid)), "references in full text" ) )
   xref2
}
