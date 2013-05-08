is.xml<-function(doc){
   ifelse( class(doc)[1] == "XMLInternalDocument", TRUE, FALSE)
}

# is.html?
