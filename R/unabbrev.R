unabbrev <-function(species){

   x<-unique(species) 
   n<-grepl("^[A-Z]\\.", x )
   x1<- x[n]
   if(length(x1)==0) {
      species
   }else{

   x2 <- x[!n]
   x3 <- unique(genus(x2))

   for( i in 1:length(x1)){
      ## match species
      n <- match( x1[i],  abbrev(x2))
      if(is.na(n)){
         # match genus 
         n <-  match( substr(x1[i],1,1),  substr(x3,1,1) )
         if(is.na(n)){
             print(paste("Unknown genus for", x1[i]))
          }else{
            #check if two or more possible matches?  Use first genus or most common (usually the same)
            if( sum( substr(x3,1,1) %in% substr(x1[i],1,1) ) > 1 ){
               print("WARNING: matches two or more genera - using first genus in list") 
            }
            newsp <- paste(x3[n], substring(x1[i],4))
            print(paste("Changing", x1[i], "to possible", newsp))
            species <- gsub(x1[i], newsp, species )
         }
      }else{
         print(paste("Matching", x1[i], "to", x2[n]))
         species <- gsub(x1[i], x2[n], species)
      }
   }
   species
   }
}
