meshTerms<-function(term )
{  
   if(is.vector(term)){
      if(length(term) > 1){ term <- paste(term, collapse = ",") }  
   }else{
   ## Or Pubmed Doc
      term <- pmid(doc)
   }


   # CHECK if IDs (and skip esearch)
   if( grepl("^[0-9, ]*$", term)){
     x <- efetch(term, "pubmed", retmode="xml")
   }else{
     x <- efetch(esearch(term, "pubmed") , retmode="xml" )
   }

      doc <- xmlParse(x)  
      z<- getNodeSet(doc, "//PubmedArticle")
      n<-length(z)
      if(n==0){stop("No results found")} 
      pubs<-vector("list",n)
      for(i in 1:n)
      {
         # use xmlDoc or memory leak -see ?getNodeSet for queries on subtree..
         z2<-xmlDoc(z[[i]])

         pmid    <- as.numeric(xvalue(z2, "//PMID"))  # first PMID id
          

      mesh <- xvalues(z2, "//MeshHeading/*")
       # fix for multiple qualifiers in node
       n<-grepl("/.*/", mesh)
       if(sum(n)>0){
         mesh2 <- mesh[n]
         y <- strsplit(mesh2, "/")
         mesh2<-unlist(sapply(y, function(z) paste(z[1], z[-1], sep="/")))
         mesh <- sort( c(mesh[!n], mesh2))
       }
      #  mesh <- paste(mesh, collapse="; ")  # one row per pmid

       if(! is.na(mesh[1]))  pubs[[i]]<-data.frame(pmid, term=mesh, stringsAsFactors=FALSE)
    
          free(z2)
      }
      x<- do.call("rbind", pubs)
      x
}


