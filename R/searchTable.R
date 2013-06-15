# search table for locus tag or other pattern - used by pmcLoop

searchTable<-function(x, prefix ){
  any(grepl(prefix , x, ignore.case = TRUE))
}

