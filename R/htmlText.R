# split PMC HTML into sentences with section labels


htmlText <- function(doc, h=2,  references = FALSE ){

   z <- vector("list")
   z[["Title"]] <- xpathSApply(doc, "//head/title", xmlValue)

   ## split into main sections  

  ## INTRODUCTION is often missing... this might work, but not always!
##  xpathSApply(doc, "//div[@class='sec headless whole_rhythm']", xmlValue)

   x <- getNodeSet(doc, paste( "//div[h", h, "]", sep="" ))

   ## LOOP through sections
   for(i in 1: length(x) ){

      doc2 <- xmlDoc(x[[i]])

      title <- xvalue(doc2, paste( "//h", h, sep="")  )
      title <- gsub("^[0-9.]* (.*)", "\\1", title )  # remove numbered sections
   
      ## get paragraphs 
      y <-  xpathSApply(doc2, "//p", xmlValue)
    
      y <- gsub("â\u0080\u008b\\(?Table[0-9])?.", "", y)

      y <- gsub("â\u0080\u008bFigure[0-9]", "", y)
     y <- gsub("â\u0080\u008b\\(?Fig.[0-9][A-Za-z])?.", "", y)
      y <- gsub("â\u0080\u008b\\(?Fig.[0-9])?.", "", y)

      y <- gsub("\u200B\\(?Table[0-9])?.", "", y)
      y <- gsub("\u200B\\(?Fig.[0-9])?.", "", y)

      y <- gsub("â\u0080\u008b", "", y)


      y <- gsub("â\u0088\u0092", "-", y)
      y <- gsub("â\u0080\u0093", "-", y)

      y <- gsub("â\u0080\u009c", "'", y)
      y <- gsub("â\u0080\u009d", "'", y)

      y <- gsub("â\u0080²", "'", y)
      y <- gsub("Î\u0094", "Δ", y)

      y <- gsub("Î²", "β", y)
      y <- gsub("Î±", "α", y)
      y <- gsub("Â°", "°", y)
      y <- gsub("Î¼", "μ", y)
      y <- gsub("Î»", "λ", y)
     y <- gsub("Ã¼", "ü", y)
     y <- gsub("Ã\u0097", "×", y)


     ## {\"type\":\"entrez-protein\",\"attrs\":{\"text\":\"AAG33249\",\"term_id\":\"11230854\"}}
      y <- gsub("\\{[^}]*\\}\\}" , "", y)


       z[[title ]] <- splitP( y) 
      free(doc2)
   }

   # list h3 section titles
    h3 <- xpathSApply(doc, paste("//h", h+1, sep=""), xmlValue) 
   if(length(h3)>0) {
      h3 <- gsub("Î\u0094", "Δ", h3)
     z[["Subsections"]] <-  h3
}
   # get figure and table captions (and truncated text) ?
   y<-   xpathSApply(doc, "//div[starts-with(@class, 'fig')]", xmlValue)

    y<-  gsub("\n", "", y)
    y<-  gsub("FIG. ", "Fig. ", y)  # don't split after FIG. 
    z[["Figure caption"]]   <-  splitP(y)


   y<-   xpathSApply(doc, "//div[starts-with(@class, 'table')]", xmlValue)
   y<-  gsub("\n", "", y)
 z[["Table caption"]]   <-  splitP(y)

   attr(z, "id") <- attr(doc, "id")
   z
}


