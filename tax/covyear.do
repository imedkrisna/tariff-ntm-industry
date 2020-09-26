// copast the stuff to data editor, then do all of these shit
/* eradicate duplicates and merge 2018 & 2019

destring hs10, replace
egen id = group(hs10 destination)
duplicates tag id,generate(dup)
duplicates drop id, force

append using cov2019
save covyear,replace
 */
gen tax=0
gen export=0
gen import=0

replace tax=1 if hs10==	30049030
replace tax=1 if hs10==	38089410
replace tax=1 if hs10==	38089420
replace tax=1 if hs10==	38089490
replace tax=1 if hs10==	38085960
replace tax=1 if hs10==	34011140
replace tax=1 if hs10==	34011150
replace tax=1 if hs10==	34013000
replace tax=1 if hs10==	30021500
replace tax=1 if hs10==	38220010
replace tax=1 if hs10==	38220020
replace tax=1 if hs10==	38220090
replace tax=1 if hs10==	90278030
replace tax=1 if hs10==	38210010
replace tax=1 if hs10==	38210090
replace tax=1 if hs10==	29242930
replace tax=1 if hs10==	29242990
replace tax=1 if hs10==	29334990
replace tax=1 if hs10==	29339990
replace tax=1 if hs10==	29419000
replace tax=1 if hs10==	29419000
replace tax=1 if hs10==	30032000
replace tax=1 if hs10==	30036000
replace tax=1 if hs10==	30042091
replace tax=1 if hs10==	30042099
replace tax=1 if hs10==	30045010
replace tax=1 if hs10==	30045021
replace tax=1 if hs10==	30045029
replace tax=1 if hs10==	30045091
replace tax=1 if hs10==	30046020
replace tax=1 if hs10==	30049051
replace tax=1 if hs10==	30049069
replace tax=1 if hs10==	30049089
replace tax=1 if hs10==	90251919
replace tax=1 if hs10==	90192000
replace tax=1 if hs10==	30059090
replace tax=1 if hs10==	90189090
replace tax=1 if hs10==	90275010
replace tax=1 if hs10==	90278030
replace tax=1 if hs10==	90278040
replace tax=1 if hs10==	90183110
replace tax=1 if hs10==	90183190
replace tax=1 if hs10==	90189030
replace tax=1 if hs10==	90192000
replace tax=1 if hs10==	90189030
replace tax=1 if hs10==	90200000
replace tax=1 if hs10==	90192000
replace tax=1 if hs10==	90192000
replace tax=1 if hs10==	90192000
replace tax=1 if hs10==	90192000
replace tax=1 if hs10==	90189030
replace tax=1 if hs10==	90189030
replace tax=1 if hs10==	63079040
replace tax=1 if hs10==	63079090
replace tax=1 if hs10==	90200000
replace tax=1 if hs10==	62101019
replace tax=1 if hs10==	62101011
replace tax=1 if hs10==	62101019
replace tax=1 if hs10==	62102030
replace tax=1 if hs10==	62102040
replace tax=1 if hs10==	62103030
replace tax=1 if hs10==	62103040
replace tax=1 if hs10==	62104020
replace tax=1 if hs10==	62104090
replace tax=1 if hs10==	62105020
replace tax=1 if hs10==	62105090
replace tax=1 if hs10==	62114310
replace tax=1 if hs10==	40151100
replace tax=1 if hs10==	40151900
replace tax=1 if hs10==	64069091
replace tax=1 if hs10==	39269049
replace tax=1 if hs10==	90049090
replace tax=1 if hs10==	65050020

replace export=1 if hs10==	62101019
replace export=1 if hs10==	62114310
replace export=1 if hs10==	62114390
replace export=1 if hs10==	63079040
replace export=1 if hs10==	63079090
replace export=1 if hs10==	22071000
replace export=1 if hs10==	22072011
replace export=1 if hs10==	22072019
replace export=1 if hs10==	22072090
replace export=1 if hs10==	30049030
replace export=1 if hs10==	38089410
replace export=1 if hs10==	38089420
replace export=1 if hs10==	38089490
replace export=1 if hs10==	56031100
replace export=1 if hs10==	56039100

replace import=1 if hs10==	62101019
replace import=1 if hs10==	62114310
replace import=1 if hs10==	62114390
replace import=1 if hs10==	63079040
replace import=1 if hs10==	63079090
replace import=1 if hs10==	7031019
replace import=1 if hs10==	7032090
replace import=1 if hs10==	33074910
replace import=1 if hs10==	33079030
replace import=1 if hs10==	34013000
replace import=1 if hs10==	61151010
replace import=1 if hs10==	62102030
replace import=1 if hs10==	62103030
replace import=1 if hs10==	62104020
replace import=1 if hs10==	62105020
replace import=1 if hs10==	62113330
replace import=1 if hs10==	62113930
replace import=1 if hs10==	85437090
replace import=1 if hs10==	96190019
