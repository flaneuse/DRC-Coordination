# GLOBAL FILE -------------------------------------------------------------
# • Installs and loads all R packages
# • Imports geographic shapefiles
# • Imports activity location data
# • Imports results data
# • Defines global aesthetic variables


# Define directories where data is located --------------------------------
# Assumes all data is located in this folder:
data_dir = '~/Documents/USAID/DRC Coordination/data/'


# Import necessary R packages ---------------------------------------------
pkgs = c(
  # data import
  'readxl', 
  '', 
  # data wrangling
  'dplyr', 
  # shiny
  'shiny', 
  'shinydashboard', 
  # plotting
  'ggplot2', 
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