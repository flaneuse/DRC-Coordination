Things to do

- [ ] Wireframe project
- [ ] Organize data


### Questions for Winock
- [ ] Problems matching Territory / Province Name?
z = im %>% group_by(Province, TerritoryName) %>% summarise(n = n())
merged = left_join(z, admin2@data, by = c('TerritoryName' = 'TCNam'))
merged %>% mutate(pr_match = Province == PrNam, ds_match = Province == DsNam) %>% select(Province, TerritoryName, TCType, DsNam, PrNam, pr_match, ds_match) %>% filter(ds_match==FALSE)
* 26 non-matches on DSNam
* 94 non-matches on PrNam
- [ ] 9999/9998 in ActivCode?
- [ ] rows in IM by Prov with no activity info?

### Main map:
- [ ] basemap + choro
- [ ] check for nat'l pgrms

### Aesthetics:
- [ ] load custom font

### Deployment:
- [ ] add Google Analytics to track
- [ ] deploy on server
- [ ] write instructions for changing/updating files
