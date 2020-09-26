do ntm2015
set more off
clear all
cd "C:/paper2/final2015/"
// log using mergeultimate, replace
use "C:/paper2/ntm/imntm.dta",clear
merge m:1 hs10 year using "C:/paper2/tax/importax", generate(gabung)
drop if psid==.
rename source country
save imporultnosi,replace
merge m:1 country using countrycode,generate(gbg)
drop if psid==.
save imporultnosi,replace

// BE CAREFUL WITH iso3_o=="" cuz we don't know what country are they

// combine gravity
clear all
use "C:\paper2\other\gravdata.dta",clear
keep if iso3_d=="IDN"
cd "C:\paper2\final2015"
save grav,replace
clear all
use imporultnosi,clear
merge m:1 iso3_o year using grav, generate(iso)
drop if psid==.

// fix 2012 problem coming from new use of HS fuck this
quietly do fix2012

save imporultnosi,replace

merge m:1 psid year using sibener,generate(mergetfp)
keep if mergetfp==3
save imporultimate,replace

// check average tariff before and after
gen oldmt=mt
 quietly do ijepado
 quietly do koreado
 quietly do cinado
 quietly do asean
 quietly do nzdo
 quietly do ausdo
 quietly do indiado

save fta,replace
// fixing wrong ASEAN tariff
replace mt=0 if mt==.
// fixing kg tariff
gen mts=mt
replace mt=mts*imk6 if mts>=400
gen ttttt=mt+imu6 if mts>=400
replace mt=mt/ttttt if mts>=400

save final, replace