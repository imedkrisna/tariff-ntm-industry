do prepsi
clear all
set more off
cd "C:/paper2/bc"

// importing data
foreach v in 08 09 10 11 12 {
	import dbase "miede`v'.dbf", clear
    save "miede`v'.dta", replace
	use "miede`v'.dta", clear
	generate year = 20`v'
//	generate export = 1
	save "miede`v'.dta", replace
  } 

  foreach v in 08 09 10 11 12 {
	import dbase "miidi`v'.dbf", clear
    save "miidi`v'.dta", replace
	use "miidi`v'.dta", clear
	generate year = 20`v'
//	generate export = 0
	save "miidi`v'.dta", replace
  } 

// Making the import data suitable for paper2. Steps are:
	// dropping importing countries
		//cancel dropping importing countries cuz apparently it is indeed important
	// creating hs6 and destring them
	// aggregating import by hs6 instead of hs10
foreach v in 08 09 10 11 12 {
    use "miidi`v'.dta",clear
	rename NEGARAIM source // it used to be dropping it, now rename
	rename PSID psid
	gen hs6=substr(HS2012,1,6)
	destring hs6, replace
	bys psid hs6: egen imu6=total(NILAI__U)
	bys psid hs6: egen imk6=total(BERAT__K)
	rename NILAI__U imu
	rename BERAT__K imk
	destring HS2012,generate(hs10)
	drop DESHS12
	duplicates drop
	save "C:/paper2/ntm/impor`v'.dta", replace
}  
  
// Likewise but for export data
foreach v in 08 09 10 11 12 {
    use "miede`v'.dta",clear
	drop DESTCTRY
	rename PSID psid
	gen hs6=substr(HSXCODE,1,6)
	destring hs6, replace
	bys psid hs6: egen exu6=total(FOBHSUSD)
	bys psid hs6: egen exk6=total(NETWTHS)
	rename NETWTHS exu
	drop FOBHSUSD exk
	destring HSXCODE,generate(hs10)
	drop DESHS12
	duplicates drop
	save "C:/paper2/ntm/expor`v'.dta", replace
}  
  
 /* //appending data
  
use "miede08.dta", clear

foreach v in 09 10 11 12 {
append using "miede`v'.dta"
}
save "miede.dta", replace
use "miidi08.dta", clear
foreach v in 09 10 11 12 {
append using "miidi`v'.dta"
}

save "miidi.dta", replace

// making unique identifier for HS Code and Destination countries

use "miede.dta", clear
egen hs=group(HSXCODE)
egen dest=group(DESTCTRY)
egen id=group(PSID)
gen psid=PSID
gen hs6=substr(HSXCODE,1,6)
save "miede.dta", replace

use "miidi.dta", clear
egen HS=group(HS2012)
egen ORIG=group(NEGARAIM)
egen id=group(PSID)
gen psid=PSID
gen hs6=substr(HS2012,1,6)
save "miidi.dta", replace
*/
// Fixing NTM

// save UNCTAD TRAINS for Indonesia only
clear all

foreach v in 08 09 10 11 12 {
    cd "C:/paper2/trains"
	use "NTM_hs6_2010_2018 v.12.dta", clear
	keep if reporter=="IDN"
	keep if partner=="WLD"
	keep if Year==2015
	rename ntm_1_digit ntm1
	destring hs6, replace
	sort hs6 ntmcode StartDate
	keep if StartDate<=20`v'
	//duplicates drop hs6 ntmcode, force
	//bys hs6: egen ntmi=total(nbr)
	bys hs6: egen ntmaa=total(nbr) if ntm1=="A"
	bys hs6: egen ntmbb=total(nbr) if ntm1=="B"
	bys hs6: egen ntmcc=total(nbr) if ntm1=="C"
	bys hs6: egen ntmee=total(nbr) if ntm1=="E"
	bys hs6: egen ntmff=total(nbr) if ntm1=="F"
	bys hs6: egen ntmhh=total(nbr) if ntm1=="H"
	bys hs6: egen ntmpp=total(nbr) if ntm1=="P"
	replace ntmaa=0 if ntmaa==.
	replace ntmbb=0 if ntmbb==.
	replace ntmcc=0 if ntmcc==.
	replace ntmee=0 if ntmee==.
	replace ntmff=0 if ntmff==.
	replace ntmhh=0 if ntmhh==.
	replace ntmpp=0 if ntmpp==.
	bys hs6: egen ntma=max(ntmaa)
	bys hs6: egen ntmb=max(ntmbb)
	bys hs6: egen ntmc=max(ntmcc)
	bys hs6: egen ntme=max(ntmee)
	bys hs6: egen ntmf=max(ntmff)
	bys hs6: egen ntmh=max(ntmhh)
	bys hs6: egen ntmp=max(ntmpp)
	drop ntmaa ntmbb ntmcc ntmee ntmff ntmhh ntmpp
	sort ntma ntmb ntmc ntme ntmf ntmh ntmp
	duplicates drop hs6 ntma ntmb ntmc ntme ntmf ntmh ntmp, force
	//duplicates drop hs6 ntma , force
	//duplicates drop hs6 ntmb , force
	//duplicates drop hs6 ntmc , force
	//duplicates drop hs6 ntme , force
	//duplicates drop hs6 ntmf , force
	//duplicates drop hs6 ntmh , force
	//duplicates drop hs6 ntmp , force
	drop ntmcode reporter Reporter_ISO_N partner nbr Year ///
	NTMNomenclature NomenCode Dataset_id Partner_ISO_N
	gen year=20`v'
	save "C:/paper2/ntm/ntm`v'.dta", replace
}  

// merge import, export and ntm data
foreach v in 08 09 10 11 12 {
clear all
cd "C:/paper2/ntm/"
use "impor`v'.dta", clear
//merge 1:1 psid hs6 using "expor`v'.dta"
merge m:1 hs6 using "ntm`v'.dta"
//replace ntmi=0 if _merge==1
replace ntma=0 if ntma==.
replace ntmb=0 if ntmb==.
replace ntmc=0 if ntmc==.
replace ntme=0 if ntme==.
replace ntmf=0 if ntmf==.
replace ntmh=0 if ntmh==.
replace ntmp=0 if ntmp==.
drop if psid==.
//replace StartDate=0 if _merge==1
//replace EndDate=0 if _merge==1
//drop if _merge==2
save "imntm`v'.dta",replace
}

use "imntm08.dta", clear

foreach v in 09 10 11 12 {
append using "imntm`v'.dta"
}
save "imntm.dta", replace

//        IMPORTANT NOTE              //
// in 2012, there are 23,929 obs matched out of (42,269+23,929-1,002)
// meaning, in 2012, 36.7% of import by firms are covered by NTM

/*
// merge the data with NTM UNCTAD
use "miidi.dta",clear
merge m:m hs6 using ntm_id
// dropping NTM which is not covered in data BC
drop if year==.
save "impor.dta", replace

use "impor.dta",clear

/*
gen ntmi=0
replace ntmi=1 if StartDate<=2008 & year==2008
replace ntmi=1 if StartDate==2009 & year==2009
replace ntmi=1 if StartDate==2010 & year==2010
replace ntmi=1 if StartDate==2911 & year==2011
replace ntmi=1 if StartDate==2012 & year==2012
*/
gen ntmii=0
replace ntmii=1 if StartDate<=2008 & year==2008
replace ntmii=1 if StartDate<=2009 & year==2009
replace ntmii=1 if StartDate<=2010 & year==2010
replace ntmii=1 if StartDate<=2911 & year==2011
replace ntmii=1 if StartDate<=2012 & year==2012
save "impor.dta", replace
*/