# DRC-Coordination
Tool for partner coordination in DRC

## To run a local copy:
* Change the file path in global.R to where the data are stored.
* Set the working directory in R to be where global.R, ui.R, server.R are saved.
* Run `shiny::runApp()` in the R console.

## File structure
* **global.R**: file to define global variables in Shiny app
* **ui.R**: file controlling the user interface
* **server.R**: file controlling the dynamic behavior of the app

## Data manipulation notes
* shapefiles were first simplified using [mapshaper](mapshaper.org): 10% simplification, avoid removing shapes.
* imported and saved as an R object in 01_importGeo.R
