# DRC Partner Coordination tool
#
# SERVER FILE -------------------------------------------------------------
#
# Laura Hughes, lhughes@usaid.gov, 5 December 2016
# copyright 2016 via MIT License

shinyServer(
  function(input, output, session) {
    
    # main map of locations by territory ------------------------------------------------------------
    
    output$main = renderLeaflet({
      
      filteredDF = admin1
      
      
      
      # -- Pull out the centroids --
      
      
      # -- Info popup box -- 
      info_popup <- paste0("<strong>District: </strong>", 
                           admin1$PrNam,
                           "<br><strong>mechanisms: </strong> <br>",
                           admin1$OldPrNam)
      
      # info_popup_circles <- paste0("<strong>District: </strong>", 
      #                              rw_centroids$District,
      #                              "<br><strong>mechanisms: </strong> <br>",
      #                              rw_centroids$ips)
      
      # -- leaflet map --
      leaflet(data = admin2) %>%
        addProviderTiles("Esri.WorldShadedRelief",
                         options = tileOptions(minZoom = 5, maxZoom  = 11)) %>%
        addProviderTiles("Stamen.TonerHybrid",
                         options = providerTileOptions(opacity = 0.35)) %>%
        # addProviderTiles("CartoDB.DarkMatter",
        #                  options = tileOptions(minZoom = 5, maxZoom  = 11)) %>%
        setMaxBounds(minLon, minLat, maxLon, maxLat) %>%

        addPolygons(fillColor = ~categPal(PrNam),
                    fillOpacity = 0.3,
                    color = grey70K,
                    weight = 1,
                    popup = info_popup) 
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