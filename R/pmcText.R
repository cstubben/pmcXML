#  split pmcXML into list of subsections, and each subsection is a vector of paragraphs or sentences

pmcText <-function(doc, sentence=TRUE ){

   z <- vector("list")

   ## Also in metadata..
   z[["Main title"]] <- xpathSApply(doc, "//front//article-title", xmlValue)

   # ABSTRACT 
   
   x <- paste( xpathSApply(doc, "//abstract[not(contains(@abstract-type,'summary'))]//p", xmlValue), collapse=" ")
   z[["Abstract"]] <- fixText(x) 

   ## author or executive summary...
   x<- paste( xpathSApply(doc, "//abstract[contains(@abstract-type,'summary')]//p", xmlValue), collapse=" ")  
   if(x != "") z[["Summary"]] <- fixText(x) 
   
   ## check for //body/p  instead of //body/sec/p

   intro <- xpathSApply(doc, "//body/p", xmlValue)
   intro <- gsub("\n", " ", intro)

   ## figures - run before removing any nested fig nodes
   f1 <- suppressMessages( pmcFigure(doc) )

   ## BODY - split into sections
   x <- getNodeSet(doc, "//body//sec")

   ## IF no  sections? - EID journal
   if(length(x) == 0){
      message("NOTE: No sections found, using Main")
      z[["Main"]] <-   fixText(intro)
   }else{
      if(length(intro) > 0){
         message("NOTE: adding untitled Introduction")
         intro <- gsub("\n", " ", intro)
         z[["Introduction"]] <-   fixText(intro)
      }   

      ## check for tables and figs within p tags  

      x1 <- xpathSApply(doc, "//sec/p/table-wrap", removeNodes)

      if(length(x1) > 0) message(paste("WARNING: removed", length(x1), "nested table tag"))
      x1 <- xpathSApply(doc, "//sec/p/fig", removeNodes)
      if(length(x1) > 0) message(paste("WARNING: removed", length(x1), "nested fig tag"))

      sec <- xpathSApply(doc, "//body//sec/title", xmlValue)
      n <- xpathSApply(doc, "//body//sec/title", function(y) length(xmlAncestors(y) ))
      path <- path.string(sec, n)

      y <- lapply(x, function(y) xpathSApply(y, "./p", xmlValue))

      ##LOOP through subsections
      for(i in 1: length(y) ){
         subT <- path[i]
         subT <- gsub("\\.$", "", subT)
         subT <- gsub("[; ]{3,}", "; ", subT)  # in case of "; ; ; "
         if(length(y[[i]]) > 0)  z[[ subT ]] <- fixText( y[[i]] )
      }
   } 


   ## ACKNOWLEDGEMENTS
   ack <- xpathSApply(doc, "//back//sec/title[starts-with(text(), 'Acknow')]/../p", xmlValue)
 
   if (length(ack) == 0)  ack <- xpathSApply(doc, "//back/ack/p", xmlValue)  # scientificWorldJournal
   if (length(ack) > 0)  z[["Acknowledgements"]]<- fixText(ack)

   # Funding
   funds <-  xpathSApply(doc, "//funding-statement", xmlValue)
   if (length(funds) > 0)  z[["Funding"]]<- fixText(funds )

   sec <- names(z)
   sec<- sec[!sec %in% c("Main title", "Abstract", "Summary", "Acknowledgements", "Funding")] 

   # Figures
   if(!is.null(f1)){
      z<- c(z, f1)
      z[["Figure caption"]] <- names(f1)
   }

   ##   # SPLIT sections (not title)
   if(sentence) z[-1] <- lapply(z[-1], splitP)

   z[["Section title"]] <- sec

   # add attributes
   attr(z, "id") <- attr(doc, "id")
   z
}






