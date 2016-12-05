# DRC Partner Coordination tool
# -- Import and save shapefiles --
#
# Laura Hughes, lhughes@usaid.gov, 5 December 2016
# copyright 2016 via MIT License


# define location of shapefiles -------------------------------------------
# Outer working directory where shapefiles are located
data_dir = '~/Documents/USAID/DRC Coordination/'


# load libraries ----------------------------------------------------------

pkgs = c(
  'readxl',
  'tidyr',
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




# read in activity/indicator matrix ---------------------------------------
im_list = read_excel(paste0(data_dir, 'IM List.xlsx'), sheet = 1)
indic = read_excel(paste0(data_dir, 'Indicators Vs Contributing IMs.xlsx'), sheet = 3)
indic_code = read_excel(paste0(data_dir, 'Indicators Vs Contributing IMs.xlsx'), sheet = 7)


# prelim data clean -------------------------------------------------------

# rename columns so they're a bit friendlier.
# Necessary b/c Sub-IR column name is repeated.
colnames(indic) = c("id",
                    "PIRS_num",
                    "indicator",              
                    "DO_TO",
                    "IR_num",
                    "IR_descrip",         
                    "subIR_num",
                    "subIR_descrip",
                    "indicator_type",      
                    "level",
                    "PPR",
                    "data_source",            
                    "HREJA",                   "BBM",                     "CD",                     
                    "CENI",                    "IGA",                     "MSDP",                   
                    "Tomikotisa", "ASILI SEZ",               "Cassava Activity",       
                    "RMT",                     "GDA",                     "KVC",                    
                    "PSR",                     "AIRS 206",                "ELIKIA",                 
                    "E2A/FP",                  "FANTA III",               "Fistula Care",           
                    "GTBC",                    "GFF/WB",                  "GHSC/TA",                
                    "HFG",                     "IHP+ (PROSANI)/Mega IHP", "LINKAGES",               
                    "Malaria Care",            "MCSP",                    "MEASURE Eval",           
                    "PMI-EP",                  "Project Cure",            "PROVIC+ / Int. HIV/AIDS",
                    "SIFPO",                   "UNICEF MCH Grant",        "4Children",              
                    "A!1",                     "A!4",                     "Eagle",                  
                    "Child Protection",        "Community WASH",          "DCEC",                   
                    "DFAPs",                   "EFSP",                    "Emergency Food Asst.",  
                    "HESN",                    "New SGBV",                "OFDA logistic support",  
                    "SAFE",                    "SPR",                     "USHINDI",                
                    "SSU",                     "SO 200661 (FFP)",         "PRRO -- 200832 (FFP)",   
                    "WFP",                     "blank" ) 

indic = indic %>% 
  select(-blank) # remove extra column that came along for the ride


indic_code = indic_code %>% 
  # rename columns 
  select(-Comment,
         IM =`Activity Accronym`,
         ActivityCode = `Activity Code`) %>% 
  # remove DFAPs
  filter(IM != 'DFAPs') %>% 
  # convert data to numeric codes
  mutate(ActivityCode = as.numeric(ActivityCode)) %>% 
  # add back in DFAPs-- two codes
  bind_rows(data.frame(IM = c('DFAPs', 'DFAPs'), ActivityCode = c(345, 346)))


# tidy indicator data -----------------------------------------------------
indic = indic %>% 
  # transpose data to a long, tidy dataset.
  gather(IM, reports, -id, -PIRS_num, -indicator, -DO_TO,
         -IR_num, -IR_descrip, -subIR_num, -subIR_descrip, 
         -indicator_type, -level, -PPR, -data_source) 

if(is.character(indic$reports)) {
  
indic = indic %>% 
# remove any weird values; ? is being converted to NA
  mutate(reports = ifelse(reports %in% c('0', '1'), reports, NA),
         reports = as.numeric(reports))
}


# merge indicator code to number to full name -----------------------------

# convert from IM text code to numeric code...
indic = left_join(indic, indic_code, by = 'IM')

# ... and from numeric code to name

indic = left_join(indic, im_list, by = 'ActivityCode')
