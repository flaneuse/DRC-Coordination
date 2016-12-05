# DRC Partner Coordination tool
#
# SERVER FILE -------------------------------------------------------------
#
# Laura Hughes, lhughes@usaid.gov, 5 December 2016
# copyright 2016 via MIT License

shinyServer(
  function(input, output, session) {
    # filter data based on user inputs ----------------------------------------
    filter_data = reactive({
      
      # -- filter and collapse down activities --
      filtered_im = im %>% 
        filter(TechnicalTeamName %in% input$selected_tech) %>% 
        # group_by(Province) %>% 
        group_by(Province, TerritoryName) %>% 
        summarise(n = n())
      
      
      # -- merge to geodata --
      filtered_geo = admin2
      filtered_geo@data = left_join(filtered_geo@data, filtered_im, by = c('PrNam' = 'Province',
                                                                           'TCNam' = 'TerritoryName'))
      # filtered_geo@data = left_join(filtered_geo@data, filtered_im, by = c('PrNam' = 'Province'))
      
      View(filtered_geo)
      return(filtered_geo)
    })
    
    
    # main map of locations by territory ------------------------------------------------------------
    
    output$main = renderLeaflet({
      
      filtered_df = filter_data()
      
      
      # -- Pull out the centroids --
      
      
      # -- Info popup box -- 
      info_popup <- paste0("<strong>Province: </strong>", 
                           filtered_df$PrNam,
                           filtered_df$TCNam,
                           "<br><strong>mechanisms: </strong> <br>",
                           filtered_df$n)
      
      # info_popup_circles <- paste0("<strong>District: </strong>", 
      #                              rw_centroids$District,
      #                              "<br><strong>mechanisms: </strong> <br>",
      #                              rw_centroids$ips)
      
      # -- leaflet map --
      leaflet(data = filtered_df) %>%
        addProviderTiles("Esri.WorldGrayCanvas",
                         options = tileOptions(minZoom = 5, maxZoom  = 11, opacity = 0.8)) %>%
        # addProviderTiles("Stamen.TonerHybrid",
        # options = providerTileOptions(opacity = 0.35)) %>%
        # addProviderTiles("CartoDB.DarkMatter",
        #                  options = tileOptions(minZoom = 5, maxZoom  = 11)) %>%
        setMaxBounds(minLon, minLat, maxLon, maxLat) %>%
        
        
        
        addPolygons(fillColor = ~contPal(n),
                    fillOpacity = 0.85,
                    color = grey70K,
                    weight = 1,
                    popup = info_popup) %>% 
        addLegend("bottomleft", pal = contPal, values = ~n,
                  title = "number of activities",
                  opacity = 1
        )
      # addMarkers(data = rw_centroids, lng = ~Lon, lat = ~Lat,
      #            label = ~as.character(num),
      #            icon = makeIcon(
      #              iconUrl = "img/footer_Rw.png",
      #              iconWidth = 1, iconHeight = 1,
      #              iconAnchorX = 0, iconAnchorY = 0),
      #            labelOptions = lapply(1:nrow(rw_centroids),
      #                                  function(x) {
      #                                    labelOptions(opacity = 1, noHide = TRUE,
      #                                                 direction = 'auto',
      #                                                 offset = c(-10, -12))
      #                                  })
      # # )%>%
      # addCircles(data = rw_centroids, lat = ~Lat, lng = ~Lon,
      #            radius = ~num * circleScaling,
      #            color = strokeColour, weight = 0.5,
      #            popup = info_popup_circles,
      #            fillColor = ~categPal(Province), fillOpacity = 0.25) 
    })
    
    mtcars %>%
      ggvis(~wt, ~mpg) %>%
      layer_points() %>%
      # layer_smooths(span = input_slider(0, 1)) %>%
      bind_shiny("numByProv")
    
    # footer image ------------------------------------------------------------
    
    # output$footer = renderImage({
    #   return(list(
    #     src = "img/footer_Rw.png",
    #     width = '100%',
    #     filetype = "image/png",
    #     alt = "Plots from USAID's GeoCenter"
    #   ))
    # }, deleteFile = FALSE)
    
  })