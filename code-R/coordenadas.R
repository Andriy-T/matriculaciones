tabMunCoo0 <- read.csv2(file.path(DirDat, "Coordenadas Espa??a", "ES.txt"), sep= "\t", header = F)
setDT(tabMunCoo0)
names(tabMunCoo0) <- 
  c("geonameid","name","asciiname","alternatenames","latitude","longitude","featureclass","featurecode","countrycode","cc2","admin1code"
    ,"admin2code","admin3code","admin4code","population","elevation","dem","timezone","modificationdate")


#### listado de municipios
tabMunCoo0$latitude <-  as.numeric(as.character(tabMunCoo0$latitude))
tabMunCoo0$longitude <-  as.numeric(as.character(tabMunCoo0$longitude))
tabMunCoo0$featurecode <- as.character(tabMunCoo0$featurecode)
tabMunCoo0$asciiname <- as.character(tabMunCoo0$asciiname)
tabMunCoo0$asciiname <-  toupper(tabMunCoo0$asciiname)

tabMunCoo <- copy(tabMunCoo0)

tabMunCoo <- tabMunCoo[tabMunCoo$population >0]
tabMunCoo <- tabMunCoo[substr(tabMunCoo$featurecode,1,2)=="PP"]

# Separamos lo que est?? m??s de una vez
tabMunCoo[, n:=NULL]
tabMunCoo[, n:=.N, by = "asciiname,admin2code"]
tabMunCooRep <- tabMunCoo[tabMunCoo$n>1]
tabMunCooNo  <- tabMunCoo[tabMunCoo$n==1]


# tabMunCoo[, latitude_med:=mean(latitude), by = "asciiname"]
# tabMunCoo[, longitude_med:=mean(longitude), by = "asciiname"]



#### listado de municipios de vehiculos
COD_PROVINCIA_VEH

data_all$MUNICIPIO <- gsub("^\\s+|\\s+$", "",as.character(data_all$MUNICIPIO))
data_all$COD_PROVINCIA_VEH <- gsub("^\\s+|\\s+$", "",as.character(data_all$COD_PROVINCIA_VEH))
tabMunVeh <- data_all[,n:=.N, by= "MUNICIPIO,COD_PROVINCIA_VEH"]
setkeyv(tabMunVeh,c("MUNICIPIO","COD_PROVINCIA_VEH","n"))
tabMunVeh <- unique(tabMunVeh)
#limpiar basura
tabMunVeh <- tabMunVeh[,c("MUNICIPIO","COD_PROVINCIA_VEH","n"),with =F]
tabMunVeh <- tabMunVeh[tabMunVeh$MUNICIPIO != ""]
tabMunVeh <- tabMunVeh[tabMunVeh$MUNICIPIO != "----"]
tabMunVeh <- tabMunVeh[tabMunVeh$COD_PROVINCIA_VEH != "?"]
tabMunVeh <- tabMunVeh[tabMunVeh$COD_PROVINCIA_VEH != ""]


# kk <- tabMunVeh[tabMunVeh$MUNICIPIO == "MADRID"]
# kk <- tabMunCoo[tabMunCoo$asciiname >= "M"]
# kk <- kk[kk$asciiname <= "MZ"]
# paste(",",tabMunVeh$COD_PROVINCIA_VEH[1],",")

#### Mezcla

kk3 <- merge(tabMunVeh, tabMunCooNo, all.x = F,by.x = c("MUNICIPIO","COD_PROVINCIA_VEH"), by.y = c("asciiname","admin2code"))
sum(kk3$n.x)

kk3 <- merge(tabMunVeh, tabMunCooRep, all.x = F,by.x = c("MUNICIPIO","COD_PROVINCIA_VEH"), by.y = c("asciiname","admin2code"))
sum(kk3$n.x)


kk2 <- kk[kk$n>1]
setkey(kk2,"asciiname")
table (kk$featurecode)