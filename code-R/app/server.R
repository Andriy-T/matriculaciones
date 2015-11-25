require(shiny)
require(shinydashboard)

shinyServer(
    function(input, output) {
        
        # Hoja resumen ------------------------------------------------------
        
        output$res_matric_mes <- renderValueBox({
            valueBox(
                format(matric_tot_mes[.N, matric], big.mark = "."
                       , decimal.mark = ",")
                , "Total matriculaciones", icon = icon("check-circle-o"),
                color = "blue"
                , width = 12
                , href = "http://www.dgt.es/es/explora/en-cifras/matriculaciones.shtml"
            )
        })
        output$resumen_text_1 <- renderText({
            paste0("El volúmen de matriculaciones en el período ha sido"
                   , " de ", format(matric_tot_mes[.N, matric], big.mark = "."
                                    , decimal.mark = ","))
        })
        output$resumen_text_2 <- renderText({
            paste0("Más texto... Pendiente de introducir texto con tags")
        })
        output$resumen_text_3 <- renderText({
            paste0("Sustituir top marcas por totales del período por segmento")
        })
        
        # Hoja indicadores ------------------------------------------------------
        
#         output$ind_btn_tot <- renderUI({
#             actionButton("ind_btn_tot", "Total")
#         })
#         
#         output$ind_sel_marca <- renderUI({
#             selectInput("ind_sel_marca", label = "", 
#                         choices = as.character(matric_Marca$Marca))
#         })
        
        output$graf.dsc.prop <- renderChart2({
            
            graf.dsc.prop
            
        }
        )        
        output$graf.ind_rad <- renderChart2({
            
            out <- switch(input$ind_rad_btn,
                   Cilindrada = graf.dsc.cilin,
                   Potencia = graf.dsc.cv
            )
            return(out)
            
        }
        )        
        
        
        # Hoja Mapa
        
#         points <- eventReactive(input$recalc, {
#             print(cbind(rnorm(40) * 2 + 13, rnorm(40) + 48))
#             cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
#             cbind(c(-5.99864, -2.9265), c(37.387191, 43.2629))
#             
#         }, ignoreNULL = FALSE)
        points <- reactive({
            cbind(c(-5.99864, -2.9265), c(37.387191, 43.2629))
            
        })
       
        output$map <- renderLeaflet({
            leaflet() %>%
                # http://leaflet-extras.github.io/leaflet-providers/preview/
                addProviderTiles("CartoDB.Positron",
                                 options = providerTileOptions(noWrap = TRUE)
                ) %>%
                addCircles(data = points(), opacity = 1, radius = 100)
        })
        
        output$tabla_mapa <- renderDataTable({
            print(points())
            datatable(data.frame(Ciudad = c("SEVILLA", "BILBAO"),
                                 lng = points()[,1],
                                 lat = points()[,2]),
                      extensions = list('TableTools', "Scroller"), options = list(
                          dom = 'T<"clear">lfrtip',
                          tableTools = list(sSwfPath = copySWF())
                          ,   deferRender = TRUE,
                          dom = "frtiS",
                          scrollY = 200,
                          scrollCollapse = TRUE
                      )
            )
        })
        
        # ---------------------
        
        output$selector_fechas <- renderUI({
            selectInput(inputId = "selector_fechas", label = "Período"
                        , choices = matric_tot_mes[anio==2015, mes]
                        , selected = matric_tot_mes[.N, mes]
            )
        })
        #         output$selector_fechas <- renderUI({
        #             dateRangeInput(inputId = "selector_fechas", label = "Período"
        #                            , start = fechEnd-30
        #                            , end = fechEnd, min = fechIni, max = fechEnd
        #                            , format = "dd/mm/yyyy", startview = "month"
        #                            , weekstart = 0, language = "es", separator = " - ")
        #         })
        output$selector_area <- renderUI({
            selectInput("selector_area", label = "Seleccionar área", 
                        choices = list("Madrid" = 1, "Cataluña" = 2, "Andalucía" = 3), 
                        selected = 1)
        })
        output$selector_tienda <- renderUI({
            selectInput("selector_tienda", label = "Seleccionar tienda", 
                        choices = list("Tienda 1" = 1, "Tienda 2" = 2), 
                        multiple = T, selected = list(1, 2))
        })
        
        # Hoja Dashboard -------------
        
        output$selector_kpi_1 <- renderUI({
            selectInput("selector_kpi_1", label = "Seleccionar métrica", 
                        choices = names(data_kpi)[-c(1:2)], 
                        selected = 1)
        })
        
        datasetInput <- reactive({
            
            data_set <- data_kpi[,c("Date", "Tipo.de.trafico", input$selector_kpi_1)]
            
            names(data_set) <- c("Date", "variable", "value")
            
            data_transform(data_set, "Date")
            
        })
        
        output$selector_kpi_2 <- renderUI({
            selectInput("selector_kpi_2", label = "Seleccionar canales", 
                        choices = unique(datasetInput()$variable), 
                        selected = unique(datasetInput()$variable)[1]
                        , multiple = T)
        })
        
        datasetInput_2 <- reactive({
            
            datasetInput()[datasetInput()$variable %in% input$selector_kpi_2,]
            
        })
        
        output$my.hChart <- renderChart2({
            
            my.hPlot <- hPlot(x = "date", y = "value", group = 'variable', 
                              data = datasetInput_2()
                              , type = 'line')
            my.hPlot$xAxis(type = "datetime")
            my.hPlot$chart(zoomType = "x")
            my.hPlot$addParams(width = '100%')
            my.hPlot$plotOptions(line = list(marker = list(enabled = F)))
            return(my.hPlot)
        }
        )
        output$graf.ts_matric <- renderChart2({
            
            graf.ts_matric
            
        }
        )
        output$graf.topMarca <- renderChart2({
            
            graf.topMarca
            
        }
        )
        
        # Hoja tablas
        
        output$selector_tabla <- renderUI({
            selectInput("selector_tabla", label = "Seleccionar tabla", 
                        choices = list("KPI", "TV"), 
                        selected = 1)
        })
        
        data_export <- reactive({
            switch(input$selector_tabla,
                   "KPI" = data_kpi,
                   "TV" = data_tv)
        })
        
        output$tabla <- renderDataTable({
            datatable(data_export(),
                      extensions = list('TableTools', "Scroller"), options = list(
                          dom = 'T<"clear">lfrtip',
                          tableTools = list(sSwfPath = copySWF())
                          ,   deferRender = TRUE,
                          dom = "frtiS",
                          scrollY = 200,
                          scrollCollapse = TRUE
                      )
            )
        })
        
        output$downloadData <- downloadHandler(
            
            filename = function() {
                paste("data ", input$selector_tabla, ".csv", sep = "")
            },
            
            content = function(file) {
                write.table(data_export(), file, sep = ",",
                            row.names = FALSE)
            }
        )
        
        
    }
)