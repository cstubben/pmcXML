# GEt MeSH terms for 1 pmid

# 1     <MeshHeading>
# 1        <DescriptorName 
# 0-many   <QualifierName  
#       </MeshHeading>

meshTerms<-function( id )
{  

    url <- "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&retmode=xml&id="
   x <- getURL( paste0(url, id), .encoding="UTF-8")
   doc <- xmlParse(x)  
   pmid    <- as.numeric( xpathSApply(doc, "//MedlineCitation/PMID", xmlValue) )
   # get all Descriptor and Qualifier Names
   mesh <- xpathSApply(doc , "//MeshHeading/*", xmlValue)
   if(length(mesh)>0){
      # split Names by size of MeshHeading
      n<-  xpathSApply(doc, "//MeshHeading", xmlSize)
      y <- split(mesh, rep(1:length(n), n))
      # paste first Descriptor name to all Qualifier names
      mesh <- as.vector(unlist(lapply(y, function(x) paste(x[1], x[-1], sep="/") )) )
      mesh <- gsub("\\/$", "", mesh)  # if no Qualifiers, remove /
   }else{
      mesh <- NULL
   }
   mesh
}


