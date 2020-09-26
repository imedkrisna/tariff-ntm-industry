clear all
set more off
cd "C:/paper2/tax"
//use mt12gj,clear
use tax08,clear
rename general mt
gen year=2008
drop hsdigitfilter
merge 1:1 hs10 using mt12gj,keepusing(t12)
replace year=2008
replace mt=t12 if mt==.
// update BTKI 2007
do mt2008
replace cept=mt if cept==.
replace vat=0 if vat==.
//drop lux
//do cept2008
//do vat2008
//do lux2008
//drop t12

// update PMK 179 2007
replace mt=0 if hs10==8905200000
// update PMK 110 2007 Starting september 2007
replace mt=5 if hs10==	4811601000
replace mt=0 if hs10==	4811609000
replace mt=5 if hs10==	7213910010
replace mt=5 if hs10==	7213910091
replace mt=10	if hs10==7213910099
replace mt=5 if hs10==	7213990010
replace mt=5	if hs10==7213990091
replace mt=10	if hs10==7213990099
replace mt=5	if hs10==7217102210
replace mt=10	if hs10==7217102290
replace mt=5	if hs10==7606123910
replace mt=5	if hs10==7606123920
replace mt=40	if hs10==8702102200

// update PMK 1 & 5 2008 starting 1st january 2008
replace mt=0 if hs10==1201009000
replace mt=0 if hs10==1101001000

// update with PMK 70 2008 starting may 2008
do pmk70a

// update with PMK 127 2008 starting september 2008
replace cept=(0+cept)/2 if hs10==3909500000

// update with PMK 128 2008 starting september 2008
replace mt=(mt+	40	)/2	if hs10==	2402100000
replace mt=(mt+	40	)/2	if hs10==	2402201000
replace mt=(mt+	40	)/2	if hs10==	2402209010
replace mt=(mt+	40	)/2	if hs10==	2402209090
replace mt=(mt+	40	)/2	if hs10==	2402901000
replace mt=(mt+	40	)/2	if hs10==	2402902000
replace mt=(mt+	40	)/2	if hs10==	2403101100
replace mt=(mt+	40	)/2	if hs10==	2403101900
save mt08,replace
// cept //
replace cept=mt if cept==.
//              2009                            //
replace year=2009

replace cept=0 if hs10==3909500000
replace mt=	40	if hs10==	2402100000
replace mt=	40	if hs10==	2402201000
replace mt=	40	if hs10==	2402209010
replace mt=	40	if hs10==	2402209090
replace mt=	40	if hs10==	2402901000
replace mt=	40	if hs10==	2402902000
replace mt=	40	if hs10==	2403101100
replace mt=	40	if hs10==	2403101900

do pmk70

do pmk19

// update pmk 223 2008
replace mt= 0 if hs10== 4106409000

// update pmk 101 2009 starting may 2009 produk susu
replace mt=(mt+	5	)/2	if hs10==	402103000
replace mt=(mt+	5	)/2	if hs10==	402109000
replace mt=(mt+	5	)/2	if hs10==	402212000
replace mt=(mt+	5	)/2	if hs10==	402219000
replace mt=(mt+	5	)/2	if hs10==	402299000
replace mt=(mt+	5	)/2	if hs10==	402910000
replace mt=(mt+	5	)/2	if hs10==	403901000


///////////////////////////////////////////////////////////////////////////////


//update pmk 150 2009 starting september 2009 kg
///////////////////// WARNING THIS IS KG ////////////////////////////////
///////////////////////////////////////////////////////////////////////////

gen mtk=0,a(mt)
replace mt=	150	if hs10==	1701110010
replace mt=	400	if hs10==	1701110090
replace mt=	400	if hs10==	1701120000
replace mt=	400	if hs10==	1701910000
replace mt=	400	if hs10==	1701991100
replace mt=	400	if hs10==	1701991900
replace mt=	400	if hs10==	1701999000

///////////////////////////////////////////////////////////////////////////////
replace cept=mt if cept==.
replace cept=mt if cept>mt
save mt09,replace

//                2010                       //
replace year=2010
// update pmk101 2009 starting 2010 produk susu
replace mt=	5	if hs10==	402103000
replace mt=	5	if hs10==	402109000
replace mt=	5	if hs10==	402212000
replace mt=	5	if hs10==	402219000
replace mt=	5	if hs10==	402299000
replace mt=	5	if hs10==	402910000
replace mt=	5	if hs10==	403901000
// update pmk 88 2010
replace mt=	7.5	if hs10==	9801101000
replace mt=	7.5	if hs10==	9801102000
replace mt=	7.5	if hs10==	9801103000
replace mt=	7.5	if hs10==	9801201000
replace mt=	0	if hs10==	9801202000
replace mt=	0	if hs10==	9801203000
replace mt=	7.5	if hs10==	9801301000
replace mt=	0	if hs10==	9801302000
replace mt=	0	if hs10==	9801303000
replace mt=	2.5	if hs10==	9802100000
replace mt=	2.5	if hs10==	9802200000
replace mt=	2.5	if hs10==	9802300000
replace mt=	5	if hs10==	9803000000

//update pmk 82 2010 MINUMAN BERALKOHOL LITER
///////////////////// WARNING THIS IS KG ////////////////////////////////
///////////////////////////////////////////////////////////////////////////
do pmk82  // minuman beralkohol LITER///////////////////////////
///////////////////////////////////////////////////////////////////////////////
do cept
replace cept=mt if cept>mt
save mt10,replace

//                2011                      //
replace year=2011

// update pmk 241 2010 starting 1 jan 2011
do pmk241
do pmk13
// update pmk 65 2011 ASLINYA KG
replace mt=450 if hs10== 1006100000
replace mt=450 if hs10== 1006201000
replace mt=450 if hs10== 1006209000
replace mt=450 if hs10== 1006301500
replace mt=450 if hs10== 1006301900
replace mt=450 if hs10== 1006302000
replace mt=450 if hs10== 1006303000
replace mt=225 if hs10== 1006309000
replace mt=450 if hs10== 1006400000
replace mt=450 if hs10== 1102900010
// update pmk 80 2011
do pmk80
replace cept=mt if cept>mt
save mt11,replace
// 2012 //
replace year=2012
do btki2012
replace cept=mt if cept>mt
save mt12,replace
//                 GABUNG                         //
clear all
use mt08,clear
append using mt09 mt10 mt11 mt12
replace cept=mt if cept==. & year<=2009
replace cept=mt if mt>1000
save importax,replace