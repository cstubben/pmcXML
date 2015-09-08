
# 2 methods to get seqIds..

# select sequence from vector of locus tags 
# or calculate seq between IDs using seq2.


seqIds<-function(id, stop, tags)
{
   if(missing(stop)){ 
      ## range of IDs like BPSL1774-BPSL1779  OR BPSL1774 to BPSL1779  OR BPSL1774-1779   OR even BPSL1774-9
# should work with optional prefix ...  BTH_I0126-I0135
      id <- gsub(" to ", "-", id)

      # removing trailing dash in case id = "BPSL1774-"
      id <- gsub("-$", "", id)
      id <- gsub("-[A-Za-z]$", "", id)  ## primer and other seqs FTT1275-F
      if(grepl("-", id)){
         z <- strsplit(id, "-")[[1]]
         id  <- z[1]
         stop<- z[ length(z) ]
         # ADD prefix to stop...add 1 in case id= BPSL1774a and stop=BPSL1779 
         if(nchar(stop) + 1 < nchar(id)){
            nid<- nchar(id)
            ##  need to remove suffix IF seqIds("Rv3648c-3653", tags=mtlocus) ELSE 3653 = Rv33653!
            if(!grepl("[0-9]$", id)) nid <- nid-1
            stop <-  paste(substr(id, 1, nid - nchar(stop)), stop, sep="")
         }
      }
   }
   if(missing(stop)){      # single id
      id
   }else if(missing(tags)){
     seq2(id, stop)
   }else{
      
      n1 <- matchTag(id, tags)
      n2 <- matchTag(stop, tags)
      if (length(n1) != 1) {
         print(paste("Warning: Using integer sequence, no match to", id))
         seq2(id, stop)  
      }else if(length(n2) != 1){
         print(paste("Warning: Using integer sequence, no match to", stop))
         seq2(id, stop)  
      }else{
        tags[n1:n2]
      }
   }
}

