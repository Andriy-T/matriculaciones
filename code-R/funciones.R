
# funciones personalizadas

func.factor.format <- function(data){
    
    if(is.data.table(data)){
        print("data_table")
    } else if (is.data.frame(data)) {
        print("data_frame")
    } else stop("Input tiene que ser data.frame o data.table")
    
}