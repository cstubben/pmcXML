
## requires pmcfiles data.frame with 
## pmcfiles <- read.delim( "ftp://ftp.ncbi.nlm.nih.gov/pub/pmc/file_list.txt" , skip=1, header=FALSE, stringsAsFactors=FALSE)
## names(pmcfiles)<-c("dir", "citation", "pmcid")


pmcFTP <- function(id, dir=".",  ...){
  # check for PMC prefix 
   if(!grepl("^PMC[0-9]+$", id))  stop("Please include a valid PMC id like PMC3443583")

   y <- subset(pmcfiles, pmcid==id)
   if(nrow(y)!= 1) stop("No match to ", id)
      
    # file names - 
   
    destfile <- paste(dir, gsub(".*/([^/]*)", "\\1", y$dir),  sep="/")
    ftpfile <- paste("ftp://ftp.ncbi.nlm.nih.gov/pub/pmc", y$dir, sep="/")
    localfile <- paste(dir, id, sep="/")

   #########################
   if(file.exists( localfile ) ){
      print("File exists")    
   }else{

      download.file( ftpfile,  destfile )

     ## untar uses Sys.getenv("TAR")  -C change to dir
      untar( destfile, compressed=TRUE, extras=paste("-C", dir) )
      print(paste("Saved to", localfile))   
     z <- file.remove(destfile)  
     z <- file.rename( gsub(".tar.gz$", "", destfile), localfile)
   }
}

