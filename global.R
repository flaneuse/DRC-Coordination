# DRC Partner Coordination tool
#
# GLOBAL FILE -------------------------------------------------------------
# • Installs and loads all R packages
# • Imports geographic shapefiles
# • Imports activity location data
# • Imports results data
# • Defines global aesthetic variables
#
# Laura Hughes, lhughes@usaid.gov, 5 December 2016
# copyright 2016 via MIT License

# Define directories where data is located --------------------------------
# Assumes all data is located in this folder:
data_dir = '~/Documents/USAID/DRC Coordination/data/'


# Import necessary R packages ---------------------------------------------
pkgs = c(
  # data import
  'readxl', 
  # data wrangling
  'dplyr', 
  # shiny
  'shiny', 
  'shinydashboard', 
  # plotting
  'ggplot2',
  'ggvis',
  'leaflet',
  'extrafont')


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
  library(pkgs[i], character.only = TRUE, quietly = TRUE, verbose = FALSE)
}

extrafont::loadfonts(quiet = TRUE)

# Clean up the workspace
rm('i', 'pkgs', 'toInstall', 'alreadyInstalled')

# import data -------------------------------------------------------------

# -- Geographic data --
load(paste0(data_dir, 'geodata.RData'))

# -- Partner locations --

# -- Results data --

# Set limits for bounding box ---------------------------------------------
spacer = 0.05

minLon = admin1@bbox['x', 'min'] * (1-spacer)
minLat = admin1@bbox['y', 'min'] * (1-spacer)
maxLon = admin1@bbox['x', 'max'] * (1+spacer)
maxLat = admin1@bbox['y', 'max'] * (1+spacer)


# Pull out choices for provinces, IPs, mechanisms -------------------------
provinces = unique(admin1$PrNam)

territories = unique(admin2$TCNam)

# mechanisms = sort(unique(df$mechanism))
# 
# subIRs = c('improved health practices (subpurpose 1)',
#            'vulnerable population protection (subpurpose 2)',
#            'improved nutrition (subpurpose 3)',
#            'CSO/GOR performance (subpurpose 4)')
# 
# ips = sort(unique(df$IP))

# -- refactorize results --
# -- refactorize districts --

# Define colors for maps --------------------------------------------------
grey70K = "#6d6e71"
baseColour = grey15K = "#DCDDDE"
labelColour = grey90K = "#414042"
strokeColour = grey90K

redAccent = '#e41a1c'
blueAccent = '#377eb8'
purpleAccent = '#984ea3'

colourProv = c('#e41a1c', '#377eb8', 
               '#4daf4a', '#984ea3', '#ff7f00')

categPal = colorFactor(palette = 'YlOrRd', domain = provinces)
contPal = colorNumeric(palette = 'YlGnBu', domain = 0:20)

# sizes -------------------------------------------------------------------
widthMap = '600px'
heightMap = '525px'
widthDot = '450px'
circleScaling = 1000
yAxis_pad = 2.25

# Source files ------------------------------------------------------------
