#  split PMC xml into sentences with ALL subsection titles in a single delimited string

## TRY 
#  id <- "PMC2612704"
#  bibformat(ncbiPMC(id))
#  Tuanyok A, Leadem BR, Auerbach RK, et al. 2008. Genomic islands from five strains of Burkholderia pseudomallei. BMC Genomics 9:566.

#  doc <- pmc(id)
#  txt <-pmcText2(doc)

#  x <- getNodeSet(doc, "//body/sec")
#  doc2 <- xmlDoc( x[[2]])
#  y <- xpathSApply(doc2, "//sec/title", xmlValue)
#  y
#   [1] "Results and discussions"                               "Identification of genomic islands in B. pseudomallei" 
#   [3] "i) Genomic comparison of five B. pseudomallei strains" "ii) Nomenclature of B. pseudomallei genomic islands"  
#   [5] "a) Precedence"                                         "b) Unique gene composition"                           
#   [7] "c) Unique genomic location"                            "Genetic recombination of genomic islands"             
#   [9] "i) tRNA-SSR"                                           "ii) Gene specific recombination"                      
#  [11] "Gene contents and predicted functional roles of GIs"   "i) Prophages"                                         
#  [13] "ii) Metabolism"                                        "iii) Pathogenicity"                                   
#  [15] "iv) Unknown functional roles"                         

#  n <- xpathSApply(doc2, "//sec/title", function(y) length(xmlAncestors(y) ))
#  [1] 2 3 4 4 5 5 5 3 4 4 3 4 4 4 4

#  cat(sprintf(paste("%", (n-2) * 3, "s%s", sep=""), "", y), sep="\n")
#  Results and discussions
#    Identification of genomic islands in B. pseudomallei
#        i) Genomic comparison of five B. pseudomallei strains
#        ii) Nomenclature of B. pseudomallei genomic islands
#           a) Precedence
#           b) Unique gene composition
#           c) Unique genomic location
#     Genetic recombination of genomic islands
#        i) tRNA-SSR
#        ii) Gene specific recombination
#     Gene contents and predicted functional roles of GIs
#        i) Prophages
#        ii) Metabolism
#        iii) Pathogenicity
#        iv) Unknown functional roles

#  path.string(y, n)
#   [1] "Results"                                                                                                                                       
#   [2] "Results; Identification of genomic islands in B. pseudomallei"                                                                                 
#   [3] "Results; Identification of genomic islands in B. pseudomallei; i) Genomic comparison of five B. pseudomallei strains"                          
#   [4] "Results; Identification of genomic islands in B. pseudomallei; ii) Nomenclature of B. pseudomallei genomic islands"                            
#   [5] "Results; Identification of genomic islands in B. pseudomallei; ii) Nomenclature of B. pseudomallei genomic islands; a) Precedence"             
#   [6] "Results; Identification of genomic islands in B. pseudomallei; ii) Nomenclature of B. pseudomallei genomic islands; b) Unique gene composition"
#   [7] "Results; Identification of genomic islands in B. pseudomallei; ii) Nomenclature of B. pseudomallei genomic islands; c) Unique genomic location"
#   [8] "Results; Genetic recombination of genomic islands"                                                                                             
#   [9] "Results; Genetic recombination of genomic islands; i) tRNA-SSR"                                                                                
#  [10] "Results; Genetic recombination of genomic islands; ii) Gene specific recombination"                                                            
#  [11] "Results; Gene contents and predicted functional roles of GIs"                                                                                  
#  [12] "Results; Gene contents and predicted functional roles of GIs; i) Prophages"                                                                    
#  [13] "Results; Gene contents and predicted functional roles of GIs; ii) Metabolism"                                                                  
#  [14] "Results; Gene contents and predicted functional roles of GIs; iii) Pathogenicity"                                                              
#  [15] "Results; Gene contents and predicted functional roles of GIs; iv) Unknown functional roles"          


pmcText2<-function(doc, references = FALSE ){

   z <- vector("list")
   z[["Main title"]] <- splitP( xpathSApply(doc, "//front//article-title", xmlValue) )
   z[["Abstract"]] <- splitP( xpathSApply(doc, "//abstract//p", xmlValue) )

   ## BODY - split into main sections

   x <- getNodeSet(doc, "//body/sec")
   ## IF no  sections? - see PMC3471637 
   if(length(x)==0){
       x <- getNodeSet(doc, "//body") 
   }
       # abstract ONLY ?? PMC2447356
   if(length(x) > 0){
   ## LOOP through main sections
   for(i in 1: length(x) ){
      doc2 <- xmlDoc(x[[i]])
      # get all subsections
      y <- xpathSApply(doc2, "//sec/title", xmlValue)
      ## repeating subsection titles in PMC3564208 will cause text to repeat!
      ## PMC1557856 has lots of empty section titles, so use y[y!=""] to skip
      if( any( duplicated(y[y!=""])) ){print(paste("WARNING: duplicate subsection titles in", y[1])) }

      # count parents = level in tree
      n <- xpathSApply(doc2, "//sec/title", function(y) length(xmlAncestors(y) ))
      # format a delimited string to assign as list name
      # eg, Results and discussions; Gene contents and predicted functional roles of GIs; iii) Pathogenicity
      path <- path.string(y, n)
      sep <- "'"
      # loop through subsections
      for(j in 1:length(y) ){
          ##  need to change separator if quote in section title like "Authors' contribution"
          if(grepl("'", y[j])) sep<-'"'
          y2 <-  xpathSApply(doc2, paste("//sec/title[.=", y[j], "]/../p", sep= sep), xmlValue)
          if(length(y2)>0)  z[[ path[j] ]] <- splitP(y2) 
      }
      free(doc2)
   }
 
    # INCLUDE labels
    f1 <- xpathSApply(doc, "//fig/label", xmlValue)
    if( length(f1) > 0){
       f2 <- xpathSApply(doc, "//fig/caption/title", xmlValue)
       f3 <- xpathSApply(doc, "//fig/caption/p", xmlValue)
       z[["Figure caption"]]     <- splitP(  paste(f1, f2, f3) )
    }
    f1 <- xpathSApply(doc, "//table-wrap/label", xmlValue)
    if( length(f1) > 0){
        f2<- xpathSApply(doc, "//table-wrap/caption", xmlValue)
        z[["Table caption"]]      <- splitP( paste(f1, f2) )
    }
   ### z[["Table footnotes"]]    <- splitP( xpathSApply(doc, "//table-wrap-foot/fn", xmlValue))

    f1 <- xpathSApply(doc, "//supplementary-material/label", xmlValue)
    if( length(f1) > 0){
       f2<- xpathSApply(doc, "//supplementary-material/caption", xmlValue)
       z[["Supplement caption"]] <-  splitP( paste(f1, f2) )
    }

  if(references)  z[["References"]] <-  xpathSApply(doc, "//ref//article-title" , xmlValue) 
}


# add attributes

attr(z, "id") <- attr(doc, "id")
z

 
}




