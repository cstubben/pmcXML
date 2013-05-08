

caption<-function(x, ...){

 y<-attr(x, "caption")
 if(is.null(y)){ 
     print("No table caption")
 }else{ 
    strwrap2(y, ...)
 }
}


