# data aux

tmp_in <- read.xlsx(file.path(DirDat, "Coordenadas España", "prov v2.xlsx")
          , sheetIndex = 2, startRow = 2, colIndex = 2:6)
tmp_in$provincia <- as.character(tmp_in$provincia)
tmp_in$provincia <- as.character(matric_provincia_tot$provincia[-50])

tmp_coord <- tmp_in[,c(1,3,4)]

data_aux$COORDENADAS_PROV <- tmp_coord

saveRDS(data_aux, file.path(DirDat, fichAux))
