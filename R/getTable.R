## get Table from pubmed central directly - HTML docs only have table links)

getTable<-function(doc, n, ...){
   url <- "http://www.ncbi.nlm.nih.gov"
   z <- htmlTableLinks(doc)
   if(z[1]=="No table links found") stop(z)
   if(missing(n)){
      n <- 1 : length(z)
   }else{
      if(any(!n %in% 1:length(z) )){stop("Only ", length(z) , " table links available")} 
   }
   y <- vector("list", length(n) )
   for(i in 1: length(n) ){
      url1 <- paste(url, z[ n[i] ], sep="")
      t1 <- try( htmlParse2(url1))
      if(class(t1)[1] == "try-error"){stop("Cannot download ", url1) }

      x <- try( readHTMLTable(t1, stringsAsFactors=FALSE, which=1, ...) , silent=TRUE)
      if(class(x)[1] == "try-error"){
         print("Warning: cannot parse table header")
         x <- readHTMLTable(t1, stringsAsFactors=FALSE, header=FALSE, which=1, ...) 
         ## parse mutli-line header like pmcTable??
      }
      x <- sr(x, "â\u0088\u0092|â\u0080\u0093|â\u0080\u0094|â\u0086\u0093", "-")
      x <- sr(x, "Ã\u0097", "x")   # times
      x <- sr(x, "â\u0089\u0088", "~")  
      x <- sr(x, "â\u0080²|â\u0080\u0099", "'")  

     # EMPTY columns
     n <- apply(x, 2, function(y) sum(! (is.na(y) | y == "" | y == " " | y =="\u00A0") ))
     if(any(n == 0)){
        # print(paste("Deleted", sum(n == 0), "empty columns"))
        x <- x[, n != 0] 
     }

      ## fix types 
      x <- fixTypes(x)      

      ## GET caption
      c1<- xpathSApply(t1, "//h1[@class='content-title']", xmlValue)
      c1 <- gsub("\\.$", "", c1)
      c2 <-xpathSApply(t1, "//div[@class='caption']", xmlValue)
 
     attr(x, "id") <- attr(doc, "id")
      attr(x, "pmid") <- attr(doc, "pmid")
      attr(x, "file") <- url1
      # check if empty list?
      attr(x, "label") <- c1
      attr(x, "caption") <- c2

      ## footnotes - 
       fn<- xpathSApply(t1, "//div[contains(@id, 'fn')]", xmlValue)
      if(length(fn)==0)  fn<- xpathSApply(t1, "//div[contains(@id, 'TF')]",    xmlValue) 
      if(length(fn)>0){
          fn <- gsub( "â\u0080\u0099", "'", fn)  
          ## ADD space
          fn <- paste( substr(fn, 1,2), substring(fn, 3))
          attr(x, "footnotes") <- fn
      }  
      y[[i]] <- x
   }
   if(length(y)==1)  y <- y[[1]]
   y
}




