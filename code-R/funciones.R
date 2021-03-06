
# funciones personalizadas

func.factor.format <- function(data){
    
    if(is.data.table(data)){
        print("data_table")
    } else if (is.data.frame(data)) {
        print("data_frame")
    } else stop("Input tiene que ser data.frame o data.table")
    
}

##### Manejo de objetos R #####

CTE_ToName_sep  <- "." # el separador por defecto de R es "." 
# lista con las subsituciones a efecturar para eliminar caracters raros
CTE_ToName  <- list(
  c("�","a"),c("�","e"),c("�","i"),c("�","o"),c("�","u")
  ,c("�","A"),c("�","E"),c("�","I"),c("�","O"),c("�","U")
  ,c(" ",CTE_ToName_sep),c("/",CTE_ToName_sep),c("-",CTE_ToName_sep),c("*",CTE_ToName_sep),c("+",CTE_ToName_sep)
  ,c("[",CTE_ToName_sep),c("]",CTE_ToName_sep),c("(",CTE_ToName_sep),c(")",CTE_ToName_sep),c(",",CTE_ToName_sep)
)

func.mygsub <- function(x, txt){
    gsub(txt[1],txt[2],x,fixed =TRUE)
}

# NOTA: esta funci?n es de manejo de strings habria que cambiarla de sitio
func.ElimDup <- function(txt, dup){
    dup2 <- paste(dup,dup, sep ="")  
    while (grepl(dup2,txt,fixed = TRUE))  {txt  <- gsub(dup2, dup,txt,fixed =TRUE)}
    ElimDup <- txt
}

#efectua las subsituciones marcadas por 'CTE_ToName'
func.ToName <- function (nom, tabNom = CTE_ToName, dup = CTE_ToName_sep){
    nom2 <- Reduce(func.mygsub,tabNom,init = nom)
    if (dup != "") ToNames <- apply(as.matrix(nom2), 1, func.ElimDup, dup = dup) else nom2
}

# primera letra mayuscula
func.simpleCap <- function(x) {
    gsub("(^|[[:space:]])([[:alpha:]])", "\\1\\U\\2", x, perl=TRUE)
}

##### Existen un objeto #####

# ¡¡¡ Ya existe una funcion: base::exists()

# Exist <- function (nom){
#     ( nom %in% ls(pattern = nom))
# }