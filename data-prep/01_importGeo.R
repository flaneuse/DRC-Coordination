# DRC Partner Coordination tool
# -- Import and save shapefiles --
#
# Laura Hughes, lhughes@usaid.gov, 5 December 2016
# copyright 2016 via MIT License


# define location of shapefiles -------------------------------------------
# Outer working directory where shapefiles are located
geo_wd = '~/Documents/USAID/DRC Coordination/simpl_geo/'

# filenames for the admin1 and admin2 files
admin1_file = 'DecPr06'
admin2_file = 'TerCitP'

# load libraries ----------------------------------------------------------

pkgs = c(
  'ggplot2',
  'rgdal',
  'maptools',
  'dplyr'
)


# Figure out which of the necessary packages are installed
alreadyInstalled = installed.packages()[, "Package"]

toInstall = pkgs[!pkgs %in% alreadyInstalled]

# Install anything that isn't already installed.
if (length(toInstall > 0)) {
  print(paste0("Installing these packages: ", paste0(toInstall, collapse = ", ")))
  
  install.packages(toInstall)
}


# Load packages
for (i in seq_along(pkgs)) {
  library(pkgs[i], character.only = TRUE, quietly = TRUE)
}



# functions to read and convert shapefile to lat/lon ----------------------

# Reads shapefile into R environment.
read_shp = function(baseDir = getwd(),
         folderName = NULL,
         layerName) {
  # Check that the layerName doesn't contain any extensions
  # Check that layerName exists within the wd
  
  # Log the current working directory, to change back at the end.
  currentDir = getwd()
  
  # Change directory to the file folder containing the shape file
  setwd(paste0(baseDir, folderName))
  
  # the dsn argument of '.' says to look for the layer in the current directory.
  rawShp = rgdal::readOGR(dsn = ".", layer = layerName)
  
  setwd(currentDir)
  
  return(rawShp)
}

# Converts a shapefile into a dataframe w/ lat/lon coordinates.
shp2df = function(baseDir = getwd(),
         folderName = NULL,
         layerName,
         exportData = TRUE,
         fileName = layerName,
         getCentroids = TRUE,
         labelVar = NA,
         reproject = TRUE, projection = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0") {
  
  # Check that the layerName doesn't contain any extensions
  # Check that layerName exists within the wd
  
  # Log the current working directory, to change back at the end.
  currentDir = getwd()
  
  # Read in the raw shapefile
  rawShp = read_shp(baseDir = baseDir, folderName = folderName, layerName = layerName)
  
  if (reproject == TRUE) {
    # reproject the data
    projectedShp = sp::spTransform(rawShp, sp::CRS(projection))
  } else {
    projectedShp = rawShp
  }
  # pull out the row names from the data and save it as a new column called 'id'
  projectedShp@data$id = rownames(projectedShp@data)
  
  # Convert the shape polygons into a series of lat/lon coordinates.
  poly_points = ggplot2::fortify(projectedShp, region = "id")
  
  # Merge the polygon lat/lon points with the original data
  df = dplyr::left_join(poly_points, projectedShp@data, by = "id")
  
  if (getCentroids == TRUE){
    # Pull out the centroids and the associated names.
    centroids = data.frame(coordinates(projectedShp)) %>% rename(long = X1, lat = X2)
    
    if (!is.na(labelVar)) {
      if (labelVar %in% colnames(projectedShp@data)) {
        # Merge the names with the centroids
        centroids = cbind(centroids, projectedShp@data[labelVar]) %>% rename_(label = labelVar)  # rename the column
      } else {
        warning("label variable for the centroids is not in the raw shapefile")
      }
    }
    
    # if the 'exportData' option is selected, save the lat/lon coordinates as a .csv
    if (exportData == TRUE) {
      write.csv(df, paste0(baseDir, "/", fileName, ".csv"))
      write.csv(centroids, paste0(baseDir, "/", fileName, "_centroids.csv"))
    }
    
    
    # Return the dataframe containing the coordinates and the centroids
    return(list(df = df, centroids = centroids))
  } else {
    # if the 'exportData' option is selected, save the lat/lon coordinates as a .csv
    if (exportData == TRUE) {
      write.csv(df, paste0(baseDir, "/", fileName, ".csv"))
    }
    
    # Reset the working directory
    setwd(currentDir)
    
    # Return the dataframe containing the coordinates and the centroids
    return(df)
  }
}

# Import DRC shapefiles into an R object. ---------------------------------
# Keeping the data projected in WGS 1984, since needs to be in lat/lon for leaflet.
admin1 = shp2df(baseDir = geo_wd, layerName = admin1_file)

admin2 = shp2df(baseDir = geo_wd, layerName = admin2_file)

# pull out the data, centroids
admin1_centroids = admin1$centroids
admin1 = admin1$df

admin2_centroids = admin2$centroids
admin2 = admin2$df

# export data -------------------------------------------------------------
save(list = c('admin1', 'admin2', 'admin1_centroids', 'admin2_centroids'), file = '~/Documents/USAID/DRC Coordination/data/geodata.RData')

