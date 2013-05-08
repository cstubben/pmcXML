# search table for locus tag or other pattern

searchTable<-function(x, prefix ){
  any(grepl(prefix , x, ignore.case = TRUE))
}

