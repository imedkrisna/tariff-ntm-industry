// regressing coverage ratio and
do coveragereg
set more off
clear all
cd "C:/paper2/final2015"
use tfpfinalen,clear

// preparations
drop if bc==0
gen ltfpoa=log(tfpoa)
gen ltfpoab=log(tfpoab)
sum tfpoa tfpoab lval
gen ldasing=log(dasing+1)
gen asing=0
replace asing=1 if dsta==2
// replace ldpemda=dpemda
// replace ldpusat=dpusat
gen LT=log(T+1)
foreach v in a b c e f h p {
	gen LC`v'=log(1+C`v')
	gen iLC`v'=llab*LC`v'
}
gen iLT=LT*llab

save tfptrade,replace

// use ulti trade
clear all
use final,clear
merge m:1 psid year using tfptrade, keepusing(ltfpoa ltfpoab lval) generate(tfpmerge)
gen lmt=log(1+mt)
foreach v in a b c e f h p {
	gen lntm`v'=log(1+ntm`v')
}
// replace imu=imu/1000000
// replace gdp_o=gdp_o/1000000
// replace gdp_d=gdp_d/1000000
gen lgdp_o=log(gdp_o)
gen lgdp_d=log(gdp_d)
gen ldistw=log(distw)
gen llmt=lmt*llab
gen tlmt=lmt*ltfpoa
gen tblmt=lmt*ltfpoab
gen tvlmt=lmt*lval
foreach v in a b c e f h p {
	gen llntm`v'=lntm`v'*llab
	gen tlntm`v'=lntm`v'*ltfpoa
	gen tblntm`v'=lntm`v'*ltfpoab
	gen tvlntm`v'=lntm`v'*lval
}
save finaltrade,replace

// setting up macros for regression
clear all
use finaltrade,clear
foreach t in 08 09 10 11 12 {
	gen y`t'=0
	replace y`t'=1 if year==20`t'
}
egen isicgroup=group(ddisic2)
su isicgroup,meanonly
forvalues x = 1/`r(max)' {
	gen i`x'=0
	replace i`x'=1 if isicgroup==`x'
}
egen psidgroup=group(psid)
su psidgroup,meanonly
forvalues u = 1/`r(max)' {
	gen z`u'=0
	replace z`u'=1 if psidgroup==`u'
}
order *,sequential
save finaltradedummy, replace
local ydum y08 y09 y10 y11 y12
local lntm lntma lntmb lntmc lntme lntmf lntmh lntmp
local llntm llntma llntmb llntmc llntme llntmf llntmh llntmp
local tlntm tlntma tlntmb tlntmc tlntme tlntmf tlntmh tlntmp
local tbntm tbntma tbntmb tbntmc tbntme tbntmf tbntmh tbntmp
local tvntm tvntma tvntmb tvntmc tvntme tvntmf tvntmh tvntmp
local grav lgdp_o lgdp_d ldistw fta_wto contig comlang_off tdiff gsp_o_d entry_cost_o entry_cost_d
local idum i1-i28
local zdum z1-z2173

// 10 digit
//regressions
egen id=group(psid hs10 country)
drop if country==""
xtset id year

////////////////// VANILLA //////////////////////////////////
// Vanilla
ppml imu ltfpoa lmt `lntm' `grav' if lkap!=0 & len!=0
estimates store a01
ppml imu ltfpoab lmt `lntm' `grav' if lkap!=0 & len!=0
estimates store a02
ppml imu lval lmt `lntm' `grav'
estimates store a03
ppml imu lval lmt `lntm' `grav' if lkap!=0 & len!=0
estimates store a04

// Vanilla, with year fixed effect
ppml imu ltfpoa lmt `lntm' `grav' `ydum' if lkap!=0 & len!=0
estimates store ay1
ppml imu ltfpoab lmt `lntm' `grav' `ydum' if lkap!=0 & len!=0
estimates store ay2
ppml imu lval lmt `lntm' `grav' `ydum'
estimates store ay3
ppml imu lval lmt `lntm' `grav' `ydum' if lkap!=0 & len!=0
estimates store ay4

// Vanilla, with year and industry fixed effect
ppml imu ltfpoa lmt `lntm' `grav' `ydum' `idum' if lkap!=0 & len!=0
estimates store ai1
ppml imu ltfpoab lmt `lntm' `grav' `ydum' `idum' if lkap!=0 & len!=0
estimates store ai2
ppml imu lval lmt `lntm' `grav' `ydum' `idum' 
estimates store ai3
ppml imu lval lmt `lntm' `grav' `ydum' `idum' if lkap!=0 & len!=0
estimates store ai4

// Vanilla EXCEL output
outreg2 [a01 a02 a03 a04 ay1 ay2 ay3 ay4 ai1 ai2 ai3 ai4] using tradevanilla.xls, replace se bdec(3) tdec(3)  excel

///////////////////// WITH SIZE ////////////////////////////////////////
// size 
ppml imu ltfpoa lmt  llmt `lntm' `llntm' `grav' if lkap!=0 & len!=0
estimates store b01
ppml imu ltfpoab lmt  llmt `lntm' `llntm' `grav' if lkap!=0 & len!=0
estimates store b02
ppml imu lval lmt llmt `lntm' `llntm' `grav'
estimates store b03
ppml imu lval lmt llmt `lntm' `llntm' `grav' if lkap!=0 & len!=0
estimates store b04
// size  with year dummy
ppml imu ltfpoa lmt  llmt `lntm' `llntm' `grav' `ydum' if lkap!=0 & len!=0
estimates store by1
ppml imu ltfpoab lmt  llmt `lntm' `llntm' `grav' `ydum' if lkap!=0 & len!=0
estimates store by2
ppml imu lval lmt llmt `lntm' `llntm' `grav' `ydum' 
estimates store by3
ppml imu lval lmt llmt `lntm' `llntm' `grav' `ydum' if lkap!=0 & len!=0
estimates store by4
// size  with year dummy and industry dummy
ppml imu ltfpoa lmt  llmt `lntm' `llntm' `grav' `ydum' `idum' if lkap!=0 & len!=0
estimates store bi1
ppml imu ltfpoab lmt  llmt `lntm' `llntm' `grav' `ydum' `idum' if lkap!=0 & len!=0
estimates store bi2
ppml imu lval lmt llmt `lntm' `llntm' `grav' `ydum' `idum'
estimates store bi3
ppml imu lval lmt llmt `lntm' `llntm' `grav' `ydum' `idum' if lkap!=0 & len!=0
estimates store bi4

// Size EXCEL output
outreg2 [b01 b02 b03 b04 by1 by2 by3 by4 bi1 bi2 bi3 bi4] using tradesize.xls, replace se bdec(3) tdec(3)  excel

/////////////////////// WITH TFP /////////////////////////////////////
// yes tfp
ppml imu ltfpoa lmt tlmt `lntm' `tlntm' `grav' if lkap!=0 & len!=0
estimates store c01
ppml imu ltfpoab lmt tblmt `lntm' `tlntm' `grav' if lkap!=0 & len!=0
estimates store c02
ppml imu lval lmt tvlmt `lntm' `tlntm' `grav'
estimates store c03
ppml imu lval lmt tvlmt `lntm' `tlntm' `grav' if lkap!=0 & len!=0
estimates store c04
// yes tfp with year dummy 
ppml imu ltfpoa lmt tlmt `lntm' `tlntm' `grav' `ydum' if lkap!=0 & len!=0
estimates store cy1
ppml imu ltfpoab lmt tblmt `lntm' `tlntm' `grav' `ydum' if lkap!=0 & len!=0
estimates store cy2
ppml imu lval lmt tvlmt `lntm' `tlntm' `grav' `ydum' 
estimates store cy3
ppml imu lval lmt tvlmt `lntm' `tlntm' `grav' `ydum' if lkap!=0 & len!=0
estimates store cy4
// yes tfp with year dummy 
ppml imu ltfpoa lmt tlmt `lntm' `tlntm' `grav' `ydum' `idum' if lkap!=0 & len!=0
estimates store ci1
ppml imu ltfpoab lmt tblmt `lntm' `tlntm' `grav' `ydum' `idum' if lkap!=0 & len!=0
estimates store ci2
ppml imu lval lmt tvlmt `lntm' `tlntm' `grav' `ydum' `idum' 
estimates store ci3
ppml imu lval lmt tvlmt `lntm' `tlntm' `grav' `ydum' `idum' if lkap!=0 & len!=0
estimates store ci4
// tfp EXCEL output
outreg2 [c01 c02 c03 c04 cy1 cy2 cy3 cy4 ci1 ci2 ci3 ci4] using tradetfp.xls, replace se bdec(3) tdec(3)  excel

// 6 digit

//regressions
egen pid=group(psid hs6 country)
duplicates drop pid year,force
xtset pid year

////////////////// VANILLA //////////////////////////////////
// Vanilla
ppml imu6 ltfpoa lmt `lntm' `grav' if lkap!=0 & len!=0
estimates store a016
ppml imu6 ltfpoab lmt `lntm' `grav' if lkap!=0 & len!=0
estimates store a026
ppml imu6 lval lmt `lntm' `grav'
estimates store a036
ppml imu6 lval lmt `lntm' `grav' if lkap!=0 & len!=0
estimates store a046

// Vanilla, with year fixed effect
ppml imu6 ltfpoa lmt `lntm' `grav' `ydum' if lkap!=0 & len!=0
estimates store ay16
ppml imu6 ltfpoab lmt `lntm' `grav' `ydum' if lkap!=0 & len!=0
estimates store ay26
ppml imu6 lval lmt `lntm' `grav' `ydum'
estimates store ay36
ppml imu6 lval lmt `lntm' `grav' `ydum' if lkap!=0 & len!=0
estimates store ay46

// Vanilla, with year and industry fixed effect
ppml imu6 ltfpoa lmt `lntm' `grav' `ydum' `idum' if lkap!=0 & len!=0
estimates store ai16
ppml imu6 ltfpoab lmt `lntm' `grav' `ydum' `idum' if lkap!=0 & len!=0
estimates store ai26
ppml imu6 lval lmt `lntm' `grav' `ydum' `idum' 
estimates store ai36
ppml imu6 lval lmt `lntm' `grav' `ydum' `idum' if lkap!=0 & len!=0
estimates store ai46

// Vanilla EXCEL output
outreg2 [a016 a026 a036 a046 ay16 ay26 ay36 ay46 ai16 ai26 ai36 ai46] using tradevanilla6.xls, replace se bdec(3) tdec(3)  excel

///////////////////// WITH SIZE ////////////////////////////////////////
// size 
ppml imu6 ltfpoa lmt  llmt `lntm' `llntm' `grav' if lkap!=0 & len!=0
estimates store b016
ppml imu6 ltfpoab lmt  llmt `lntm' `llntm' `grav' if lkap!=0 & len!=0
estimates store b026
ppml imu6 lval lmt llmt `lntm' `llntm' `grav'
estimates store b036
ppml imu6 lval lmt llmt `lntm' `llntm' `grav' if lkap!=0 & len!=0
estimates store b046
// size  with year dummy
ppml imu6 ltfpoa lmt  llmt `lntm' `llntm' `grav' `ydum' if lkap!=0 & len!=0
estimates store by16
ppml imu6 ltfpoab lmt  llmt `lntm' `llntm' `grav' `ydum' if lkap!=0 & len!=0
estimates store by26
ppml imu6 lval lmt llmt `lntm' `llntm' `grav' `ydum' 
estimates store by36
ppml imu6 lval lmt llmt `lntm' `llntm' `grav' `ydum' if lkap!=0 & len!=0
estimates store by46
// size  with year dummy and industry dummy
ppml imu6 ltfpoa lmt  llmt `lntm' `llntm' `grav' `ydum' `idum' if lkap!=0 & len!=0
estimates store bi16
ppml imu6 ltfpoab lmt  llmt `lntm' `llntm' `grav' `ydum' `idum' if lkap!=0 & len!=0
estimates store bi26
ppml imu6 lval lmt llmt `lntm' `llntm' `grav' `ydum' `idum'
estimates store bi36
ppml imu6 lval lmt llmt `lntm' `llntm' `grav' `ydum' `idum' if lkap!=0 & len!=0
estimates store bi46

// Size EXCEL output
outreg2 [b016 b026 b036 b046 by16 by26 by36 by46 bi16 bi26 bi36 bi46] using tradesize6.xls, replace se bdec(3) tdec(3)  excel

/////////////////////// WITH TFP /////////////////////////////////////
// yes tfp
ppml imu6 ltfpoa lmt tlmt `lntm' `tlntm' `grav' if lkap!=0 & len!=0
estimates store c016
ppml imu6 ltfpoab lmt tblmt `lntm' `tlntm' `grav' if lkap!=0 & len!=0
estimates store c026
ppml imu6 lval lmt tvlmt `lntm' `tlntm' `grav'
estimates store c036
ppml imu6 lval lmt tvlmt `lntm' `tlntm' `grav' if lkap!=0 & len!=0
estimates store c046
// yes tfp with year dummy 
ppml imu6 ltfpoa lmt tlmt `lntm' `tlntm' `grav' `ydum' if lkap!=0 & len!=0
estimates store cy16
ppml imu6 ltfpoab lmt tblmt `lntm' `tlntm' `grav' `ydum' if lkap!=0 & len!=0
estimates store cy26
ppml imu6 lval lmt tvlmt `lntm' `tlntm' `grav' `ydum' 
estimates store cy36
ppml imu6 lval lmt tvlmt `lntm' `tlntm' `grav' `ydum' if lkap!=0 & len!=0
estimates store cy46
// yes tfp with year dummy 
ppml imu6 ltfpoa lmt tlmt `lntm' `tlntm' `grav' `ydum' `idum' if lkap!=0 & len!=0
estimates store ci16
ppml imu6 ltfpoab lmt tblmt `lntm' `tlntm' `grav' `ydum' `idum' if lkap!=0 & len!=0
estimates store ci26
ppml imu6 lval lmt tvlmt `lntm' `tlntm' `grav' `ydum' `idum' 
estimates store ci36
ppml imu6 lval lmt tvlmt `lntm' `tlntm' `grav' `ydum' `idum' if lkap!=0 & len!=0
estimates store ci46
// tfp EXCEL output
outreg2 [c016 c026 c036 c046 cy16 cy26 cy36 cy46 ci16 ci26 ci36 ci46] using tradetfp6.xls, replace se bdec(3) tdec(3)  excel

