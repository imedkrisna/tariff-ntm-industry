clear all
set more off
cd "C:/paper2/final2015"
use "paper2si.dta"

// labeling my variable

la var	dprovi	"Province"
la var	dkabup	"Regency/Municipality"
la var	dkecam	"Sub-regency"
la var	ddesa	"Village"
la var	dsta	"Ownership" // 1=PMDN 2=PMA 3=Non-fasilitas
la var	loca	"Industrial Zone" // 1=inside 2=outside 0=ngatau .=ngatau
la var	disic5	""
la var	disic4	""
la var	disic3	""
la var	disic2	""
la var	dpusat	"Ownership by central government (%)"
la var	dpemda	"Ownership by local government (%)"
la var	ddmstk	"Ownership by private domestic (%)"
la var	dasing	"Ownership by private foreign (%)"
la var	ceksum	"Ownership total (%)"
la var	ltlnou	"Number of workers"
la var	zpdvcu	"Total wage of production workers (IDR)"
la var	zndvcu	"Total wage of non-production workers (IDR)"
la var	it1vcu	"Total other expenses (including tax) (current IDR)"
la var	oelkhu	"Electricity sold (KwH)"
la var	yelvcu	"Electricity sold (IDR)"
la var	eplkhu	"Electricity bought from PLN (KwH)"
la var	eplvcu	"Electricity bought from PLN (IDR)"
la var	enpkhu	"Electricity bought from non-PLN (KwH)"
la var	enpvcu	"Electricity bought from non-PLN (IDR)"
la var	esgkhu	"Self-Generated electricity (KwH)"
la var	efuvce	"Self-Generated electricity (IDR)"
la var	efuvcu	"Total Energy-related materials including for input (IDR)"
la var	rdnvcu	"Domestic input (IDR)"
la var	rimvcu	"Imported input (IDR)"
la var	rtlvcu	"total input (IDR)"
la var	yprvcu	"Total sales / Revenue (IDR)"
la var	prprca	"Utilization rate (%)"
la var	yisvcu	"Income from industrial service (Makloon) (IDR)"
la var	yrnvcu	"Other income (IDR)"
la var	ytivcu	"Makloon+other income (IDR)"
la var	v1101	"Fixed asset: Land (IDR)"
la var	v1103	"Fixed asset: Building (IDR)"
la var	v1106	"Fixed asset: Machinery (IDR)"
la var	v1109	"Fixed asset: Vehicles (IDR)"
la var	v1112	"Fixed asset: Others (IDR)"
la var	v1115	"Total fixed asset (IDR)"
la var	ctttcu	"Asset purchased (IDR)"
la var	ctsacu	"Asset sold (IDR)"
la var	ctdacu	"Depreciation (IDR)"
la var	iinput	"Total expenses / input (IDR)"
la var	output	"Total output / sales (IDR)"
la var	vtlvcu	"Total Value Added (IDR)"
la var	prprex	"Fraction of exported output %)"

// global chr "dprovi dsta loca disic5 dpusat dpemda ddmstk dasing"
// some notes on characteristics:
	// dprovi is province location code.
	// dsta 1=domestic investment, 2=foreign investment, 3=non facility
	// loca 1=inside industrial area, 2=outside
	// disic5 is isic 5 digit
	// dpusat pemda ddmstk dasing are ownership in percent. total of the four is 100

// psid 60409 has efuvcu=-1 which is stupid
replace efuvcu=0 if efuvcu==-1

// important variable
gen energy=eplkhu+enpkhu+esgkhu-oelkhu
gen venergy=eplvcu+enpvcu+efuvce-yelvcu
la var energy "Net electricity (KwH)"
la var venergy "Net electricity (IDR)"

//aggregate isic
gen isic5=string(disic5)
gen isic2=substr(isic5,1,2)
destring isic2,generate(ddisic2)

//                 IMPORTANT ON ENERGY                    //
//if i dont drop energy ==0 and just drop len==0,
//I get 73265 observations
/*
                      (1)             (2)   
                     lout            lout   
--------------------------------------------
lkap               0.0251***        0.187***
                   (8.03)         (14.14)   

llab                0.505***        0.306***
                  (63.48)         (58.27)   

len                 0.398***        0.115***
                 (168.89)         (47.93)   

linn                                0.344***
                                  (12.06)   

_cons               8.492***                
                 (154.95)                   
--------------------------------------------
N                   73265           73265   
adj. R-sq           0.210                   
*/
// len gave me better estimators (ie lower st error, higher stars)
//           MORE IMPORTANTLY ON ENERGY
// using KwH can be problematic because venergy/energy which
// is just per unit cost of electricity gives us very strange electricity price
// also, there are many negatives. doesnt make sense at all
// moreover, it is possible for efuvcu=0 when energy is non-zero
// drop if energy<0  //<-- therefore i can comment out this one
drop if v1115==.
// total semua buat ngecek
gen netiv=ctttcu-ctsacu-ctdacu

// Merging deflator
merge m:1 year using "deflator.dta"

// generating important variables
gen llab=log(1+ltlnou)
gen lnetiv=log(1+netiv/defkap)
gen lkap=log(1+v1115/defkap)
//gen lqen=log(1+energy)
//gen lven=log(1+venergy/deflistrik)
gen len=log(1+efuvcu/deflistrik)
gen linn=log(1+rtlvcu/definput)
gen lin=log(1+iinput/definput)
gen lout=log(1+output/defoutput)
gen lva=log(1+vtlvcu/defoutput)

//global penting "lout lva lin llab linn lqen len lven lkap"
// Check balances

bys psid: gen nyear=[_N]
save sibener,replace
/*
data dwi dan skubun
    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
        llab |    120,458    4.187582    1.171095   3.044523   10.62135
        lkap |    117,587     9.30401    6.818993          0   30.37845
        lqen |    120,458    9.735744    3.759804          0   22.86582
        lven |    120,445    10.08724    3.845784          0   22.09964
         len |    120,458     10.3678    3.738017          0   22.69046
-------------+---------------------------------------------------------
        linn |    120,458    14.04497    3.851168          0   25.13797
         lin |    120,458    14.90849    2.360538          0   25.13839
        lout |    120,458    15.56097    2.127951   8.149757   25.63915
         lva |    120,458    14.58158    2.070921   6.893503   24.86186

	//drop if lkap len = 0	 

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
        llab |     76,111     4.11012    1.129081   3.044523   10.55435
        lkap |     73,263    13.99549    2.157698    .698185   30.37845
        lqen |     76,111    9.525285    3.581855          0   22.86582
        lven |     76,102     9.84605     3.65074          0   22.09964
         len |     76,111    10.97988     2.33587   .6931472   22.69046
-------------+---------------------------------------------------------
        linn |     76,111    13.95067    3.529047          0   25.13797
         lin |     76,111    14.68401    2.243349   5.734671   25.13839
        lout |     76,111    15.30695    2.075274   8.497372   25.21573
         lva |     76,111    14.29873    2.014129   6.893503   24.60324

// drop lqen lven 

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
        llab |     72,101    4.123859    1.134386   3.044523   10.55435
        lkap |     69,253     14.0387    2.134072    .698185   30.37845
        lqen |     72,101    10.05491    2.866667   .6931472   22.86582
        lven |     72,092    10.37099    2.930559   1.053895   22.09964
         len |     72,101     10.9907    2.327036   .6931472   22.69046
-------------+---------------------------------------------------------
        linn |     72,101    13.98375     3.53176          0   25.13797
         lin |     72,101    14.72565     2.21696   5.734671   25.13839
        lout |     72,101    15.34465     2.05281   8.497372   25.21573
         lva |     72,101    14.33336    1.995462   6.893503   24.60324

		 
// data deasy
    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
        llab |    111,958    4.156192    1.182714   2.995732   10.62133
        lkap |    111,958    9.275741    6.803831          0   30.37845
         len |    111,958    9.585265    4.112162          0   22.08956
        linn |    111,958    14.02155    3.840039          0   25.13797
       loutt |    111,958    15.59165    2.143556          0    25.6391
		 
drop capital and energy
    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
        llab |     68,555    4.064666    1.131157   2.995732   10.55433
        lkap |     68,555     13.9363    2.119709    .698185   27.55379
         len |     68,555    10.09417    2.935321   1.053895   22.08956
        linn |     68,555    13.80418    3.598598          0   25.13797
       loutt |     68,555    15.28296    2.020225   8.497372   25.21642
		 
		 */
sum 