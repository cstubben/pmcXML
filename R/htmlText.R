# split HTML into  sentences with section labels

## html from different publishers - use pub option or check pub in HTML?

## NEED to check section headers using  xpathSApply(doc, "//h2", xmlValue)
# h2 option should list the positions of headers to parse
# Current defaults are  
## Elsevier   h2= 3:6  
## SGM        h2= 1:6
## Springer   h2= 1:3
## Wiley      h3= 7:12  (uses //h3 tags)
## PMC        all h2 tags (and h2 option not used)

## PARSING NOTES:  if tags in header like  <h2><em>Methods</em></h2>
## then h2[text()='Methods'] does not work but
##      h2[.='Methods'] does...

## a few ways to parse by sections 
## 1.  Get <p> after section1 and before section2 (using following and preceding xpath queries)
## 2.  Match section text and then go up one node and find all <p> tags  (/..//p ) 
## 3.  Use getNodeSet to split into sections - for PMC using //div[h2]


htmlText <- function(doc, pub = "PMC" , h2  ){

  z <- vector("list")

  pub <- tolower(pub)

#------------------------------------------------
# Elsevier
## ADD ?np=y  to end of URL string to load all dynamic content
## check sections using  xpathSApply(doc, "//h2", xmlValue)

if(  pub %in% c("elsevier", "sciencedirect")   ){

    ## sections to parse
   if(missing(h2)) h2 <- 3:6
   z[["Main Title"]] <- gsub("\n *", "", xpathSApply(doc, "//head/title", xmlValue))

## keywords after abstract do not parse (no <p> tags, so get abstract separately and start h2 loop at 3
   y <- xpathSApply(doc, "//div[starts-with(@class, 'abstract')]/p", xmlValue)
   z[["Abstract"]] <- splitP(y)     # or use sentDetect in openNLP 

   ## MAIN document in one div tag
   ##  find headers AND GET all <p> tags between two headers!   OR  use ..//p like SGM  - doesn't work 
   sec <- xpathSApply(doc, "//h2", xmlValue)
   for(i in h2){
      #  xpath <- paste( "//p[preceding::h2[text()='", sec[i],  "'] and following::h2[text()='", sec[i+1], "']]", sep="")
      # fix to skip captions
      xpath <- paste( "//p[not(@class='caption')][preceding::h2[.='", sec[i],  "'] and following::h2[.='", sec[i+1], "']]", sep="")

        y <- xpathSApply(doc, xpath, xmlValue)
         # remove numbers "1. Intro" 
         title <- gsub("^[0-9.]* (.*)", "\\1", sec[i])
       z[[ title  ]]  <- removeSpecChar(splitP(y)) 
   }
   # captions 
   #cap <- xpathSApply(doc, "//p[@class='caption']", xmlValue)
   #z[["Caption"]] <- removeSpecChar(splitP( gsub("\n *", "", cap) ))

   cap <-  xpathSApply( doc, '//dl[@class="figure"]', xmlValue)  # 
   z[["Figure caption"]] <- removeSpecChar(splitP( cap ))

   cap <- xpathSApply( doc, '//dd[@class="lblCap"]', xmlValue)
   z[["Table caption"]] <- removeSpecChar(splitP( gsub("\n *", "", cap) ))

   h3 <- xpathSApply(doc, "//h3", xmlValue)
   z[["Section title"]] <- removeSpecChar(splitP( h3 ))

#------------------------------------------------
# ACS publications

}else if(  pub %in% c("acs")   ){

    ## sections to parse
   if(missing(h2)) h2 <- 2:6
   z[["Main Title"]] <- gsub("\n *", "", xpathSApply(doc, "//title", xmlValue))
   sec <- xpathSApply(doc, "//h2", xmlValue)
   for(i in h2){
        xpath <- paste( "//p[preceding::h2[.='", sec[i],  "'] and following::h2[.='", sec[i+1], "']]", sep="")
        y <- xpathSApply(doc, xpath, xmlValue)
        z[[ sec[i]  ]]  <- removeSpecChar(splitP( gsub("\n *", " ", y ))) 
   }
   # many sections in <div> Tags only!

   z[["Table caption"]]<- xpathSApply(doc, '//div[@class="title2"]', xmlValue)
## figure caption with sections..

   h3 <- xpathSApply(doc, '//span[@class="title2"]', xmlValue)
   z[["Section title"]] <- removeSpecChar(splitP( h3 ))

#------------------------------------------------
##  Annual reviews
}else if( pub %in% c("annualreviews", "reviews")  ){

   if(missing(h2)) h2 <- 1:12
   z[["Main Title"]] <- xpathSApply(doc, '//h1[@class="arttitle"]', xmlValue)

   sec <- xpathSApply(doc, '//span[@class="headerTitle"]', xmlValue)
 
   for(i in h2){
      xpath <- paste( "//span[@class='headerTitle'][.='", sec[i],  "']/../..//p", sep="")
      y <- xpathSApply(doc, xpath, xmlValue)
      z[[ sec[i]  ]]  <- removeSpecChar(splitP(  y )) 
   }
 
   # captions
   cap <- xpathSApply(doc, '//span[@class="captionText"]', xmlValue)
   if(length(cap)>0)  z[["Caption"]] <- removeSpecChar(splitP( cap  ))
 
   sectitle <-  xpathSApply(doc, '//span[@class="title2"]', xmlValue)
   z[["Section title"]] <- removeSpecChar(splitP( sectitle  ))

#------------------------------------------------
##  ASM  check using xpathSApply(doc, "//h2", xmlValue)   # same as SGM?
}else if( pub %in% "asm"  ){

   if(missing(h2)) h2 <- 1:5
   z[["Main Title"]] <- xpathSApply(doc, '//h1[@id="article-title-1"]', xmlValue)
   sec <- xpathSApply(doc, "//h2", xmlValue)
  
   for(i in h2){
      xpath <- paste( "//h2[.='", sec[i],  "']/..//p[not(ancestor::div[contains(@class, 'caption')])]", sep="")
      y <- xpathSApply(doc, xpath, xmlValue)
      z[[ sec[i]  ]]  <- removeSpecChar(splitP( gsub("\n *", " ", y ))) 
   }
 
   # captions
   cap <- xpathSApply(doc, '//div[@class="fig-caption"]', xmlValue)
   if(length(cap)>0)  z[["Figure caption"]] <- removeSpecChar(splitP( gsub("  *", " ", gsub("\n *", " ", cap))  ))
 
   cap <- xpathSApply(doc, '//div[@class="table-caption"]', xmlValue)
   if(length(cap)>0)  z[["Table caption"]] <- removeSpecChar(splitP(  gsub("  *", " ", gsub("\n *", " ", cap))  ))
 
   sectitle <- xpathSApply(doc, '//span[@class="inline-l2-heading"]', xmlValue)
   z[["Section title"]] <- removeSpecChar(splitP( gsub("\n *", " ", sectitle)  ))

#------------------------------------------------
##  SGM  (Society for general microbiology) -  check using xpathSApply(doc, "//h2", xmlValue)
}else if( pub %in% "sgm"  ){

   if(missing(h2)) h2 <- 1:6
   z[["Main Title"]] <- xpathSApply(doc, '//h1[@id="article-title-1"]', xmlValue)
   sec <- xpathSApply(doc, "//h2", xmlValue)
   ## xpathSApply(doc, '//h2[.="Abstract"]/..//p', xmlValue)   
   for(i in h2){
     # xpath <- paste( "//h2[text()='", sec[i],  "']/..//p", sep="")
## fix to skip captions 
      xpath <- paste( "//h2[.='", sec[i],  "']/..//p[not(ancestor::div[contains(@class, 'caption')])]", sep="")

      y <- xpathSApply(doc, xpath, xmlValue)
      z[[ sec[i]  ]]  <- removeSpecChar(splitP( gsub("\n *", " ", y ))) 
   }
 
   # captions
   cap <- xpathSApply(doc, '//div[@class="fig-caption"]', xmlValue)
   if(length(cap)>0)  z[["Figure caption"]] <- removeSpecChar(splitP( gsub("  *", " ", gsub("\n *", " ", cap))  ))
 
   cap <- xpathSApply(doc, '//div[@class="table-caption"]', xmlValue)
   if(length(cap)>0)  z[["Table caption"]] <- removeSpecChar(splitP(  gsub("  *", " ", gsub("\n *", " ", cap))  ))
 
   sectitle <- xpathSApply(doc, '//h3|//h4', xmlValue)
   z[["Section title"]] <- removeSpecChar(splitP( gsub("\n *", " ", sectitle)  ))

#------------------------------------------------
## Springer   -  check using xpathSApply(doc, "//h2", xmlValue)
}else if( pub %in% "springer"  ){

   if(missing(h2)) h2 <- 1:3

   z[["Main Title"]] <- xpathSApply(doc, '//div[@class="MainTitleSection"]', xmlValue)
   z[["Abstract"]]  <- splitP( xpathSApply(doc, '//div[@class="Abstract"]/div[@class="Para"]', xmlValue) )  # skip Abstract heading
  
   kw <- xpathSApply(doc, '//div[@class="KeywordGroup"]', xmlValue)
   if(length(kw)>0)  z[["Keywords"]]  <- paste(kw, collapse=", ")

   ##   div[@class="Para"] tags instead of <p> tags
   sec <- xpathSApply(doc, "//h2", xmlValue)
   ## includes footnotes and figure captions!
   for(i in h2){
        xpath <- paste( "//h2[.='", sec[i],  "']/..//div[@class='Para']", sep="")
        y <- xpathSApply(doc, xpath, xmlValue)
         # remove numbers "1. Intro" 
         title <- gsub("^[0-9.]* (.*)", "\\1", sec[i])
       z[[ title  ]]  <- removeSpecChar(splitP(y)) 
   }
 
   # captions
   cap <- xpathSApply(doc, '//div[@class="Caption"]', xmlValue)
   if(length(cap)>0)  z[["Caption"]] <- removeSpecChar(splitP(    gsub("   *", "", cap) ))

   sectitle <- xpathSApply(doc, '//h3[@class="Heading"]', xmlValue)
   z[["Section title"]] <- removeSpecChar(splitP( sectitle ))

#------------------------------------------------
## Wiley
# h3 are section headers  --  check using  xpathSApply(doc, "//h3", xmlValue)

}else if( pub %in% "wiley"  ){

   if(missing(h2)) h2 <- 7:12
   z[["Main Title"]] <- xpathSApply(doc, '//span[@class="mainTitle"]', xmlValue)

   sec <- xpathSApply(doc, "//h3", xmlValue)
   ## includes footnotes and figure captions!
   for(i in h2){
      # xpath <- paste( "//p[preceding::h3[text()='", sec[i],  "'] and following::h3[text()='", sec[i+1], "']]", sep="")   
      # xpath <- paste( "//h3[text()='", sec[i],  "']/../..//p", sep="")  - does not work if <em> or other tags in node test
      xpath <- paste( "//h3[.='", sec[i],  "']/../..//p[not(ancestor::div[@class='caption'])]", sep="")
        y <- xpathSApply(doc, xpath, xmlValue)
         # remove numbers "1. Intro" 
         title <- gsub("^[0-9. ]*(.*)", "\\1", sec[i])
       z[[ title  ]]  <- removeSpecChar(splitP(y)) 
   } 
   # captions
   cap <- xpathSApply(doc, "//caption", xmlValue)
   if(length(cap)>0)  z[["Table caption"]] <- removeSpecChar(splitP(    gsub("   *", "", cap) ))
    
     cap <- xpathSApply(doc, '//div[@class="caption"]', xmlValue)
   if(length(cap)>0)  z[["Figure caption"]] <- removeSpecChar(splitP(   cap ))
   h4 <- xpathSApply(doc, "//h4", xmlValue)
   z[["Section title"]] <- removeSpecChar(splitP( h4 ))


#------------------------------------------------
## PMC
}else if( pub %in% c("pmc", "ncbi") ) {

   z[["Main title"]] <- xpathSApply(doc, "//head/title", xmlValue)

   ## split into main sections  
   ##NOTES: INTRODUCTION header is often missing.
   ## some papers with unlabeled main text only  - some with 'tsec sec...'

   x <- getNodeSet(doc, "//div[h2]|//div[@class='sec headless whole_rhythm']|//div[@class='tsec sec headless whole_rhythm']" )

   ## LOOP through sections
   for(i in 1: length(x) ){

      doc2 <- xmlDoc(x[[i]])

      title <- xvalue(doc2, "//h2"  )
      if(is.na(title)){
          ## in some cases this should be "Main Text"  see PMC2786597, PMC3690193
          if( "Introduction" %in% names(z)){
              print("Found another section without title - using Unknown")
              title <- "Unknown"
          }else{
              print("Missing section title - using Introduction")
              title <- "Introduction"
          }
      }
      title <- gsub("^[0-9.]* (.*)", "\\1", title )  # remove numbered sections
      title <- gsub("\n", "", title ) # remove new lines

      ## get paragraphs 
      y <-  xpathSApply(doc2, "//p", xmlValue)

      z[[title ]] <- removeSpecChar( splitP( y) )
      free(doc2)
   }


   # list h3 section titles
   h3 <- xpathSApply(doc, "//h3", xmlValue) 
   if(length(h3)>0) {
      h3 <- gsub("Î\u0094", "Δ", h3)
      h3 <- gsub("\n", "", h3 ) 
      z[["Section title"]] <-  h3
   }
   # get figure and table captions (and truncated text) ?
   y <- xpathSApply(doc, "//div[starts-with(@class, 'fig')]", xmlValue)
   y <-  gsub("\n", "", y)
   y <-  gsub("FIG. ", "Fig. ", y)  # don't split after FIG. 
   z[["Figure caption"]]   <-  splitP(y)

   y <- xpathSApply(doc, "//div[starts-with(@class, 'table')]", xmlValue)
   y <- gsub("\n", "", y)
   z[["Table caption"]]   <-  splitP(y)

}else{
  stop("No match to pub.  Pub must be PMC, Elsevier, Wiley, Springer, SGM, AnnualReviews ")
}
## ALL

   # check for empty sections
   n <- sapply(z, length)==0
   if(sum(n)>0) z <- z[!n]
   attr(z, "id") <- attr(doc, "id")
   z
}


