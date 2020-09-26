do prepul
set more off
clear all
cd "C:/paper2/ultimate/"

// use final data to generate coverage ratio for tariff
use final,clear
gen TT=mt*imu6
bys psid year: egen TTT=total(TT)
bys psid year: egen ti=total(imu6)
gen T=TTT/ti

// generate coverage ratio for every NTM
foreach v in a b c e f h p {
	gen max`v'=ntm`v'*imu6
	bys psid year: egen tmax`v'=total(max`v')
	gen C`v'=tmax`v'/ti
}

save finalc,replace

// merge dengan data utk tfp estimation
duplicates drop psid year T,force

save coverage,replace
clear all

use sibener,clear
merge 1:1 psid year using coverage.dta, keepusing(T Ca Cb Cc Ce Cf Ch Cp ti) generate(lel)
save tfpsiap,replace