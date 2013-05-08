

footnotes<-function(x, ...){

 y<-attr(x, "footnotes")
 if(is.null(y)){ 
     print("No table footnotes")
 }else{ 
    strwrap2(y, ...)
 }
}


