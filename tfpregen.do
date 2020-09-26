do coverage
set more off
clear all
cd "C:/paper2/final2015"
use tfpsiap,clear

// generate value added per labor
gen val=vtlvcu/ltlnou
gen lval=log(val)

// remaking log input and adding rimvcu
drop lin linn
gen lin=log(1+rtlvcu)
gen lim=log(1+rimvcu)
gen lit=log(ti)
gen bc=0
replace bc=1 if T!=.

// prepping for xtset
xtset psid year
// estimate tfp for all
// IMPORTANT REMINDER: only one proxy variable can be used for revenue
levpet lout if lkap!=0 & len!=0, free(llab len) proxy(lin) capital(lkap) revenue // revenue nozero
 estimates store tfpoa
 predict tfpoa, omega
levpet lva if lkap!=0 & len!=0, free(llab len) proxy(lin lim) capital(lkap) valueadded // value added nozero
 estimates store tfpva
 predict tfpva, omega
levpet lout, free(llab len) proxy(lin) capital(lkap) revenue // revenue
 estimates store tfpoak
 predict tfpoak, omega
levpet lva, free(llab len) proxy(lin lim) capital(lkap) valueadded // value added
 estimates store tfpvak
 predict tfpvak , omega

// estimate tfp for non-customs
levpet lout if lkap!=0 & T==. & len!=0, free(llab len) proxy(lin) capital(lkap) revenue // revenue nozero
 estimates store tfpoan
 predict tfpoan, omega
levpet lva if lkap!=0 & T==. & len!=0, free(llab len) proxy(lin lim) capital(lkap) valueadded // value added nozero
 estimates store tfpvan
 predict tfpvan, omega
levpet lout if T==., free(llab len) proxy(lin) capital(lkap) revenue // revenue
 estimates store tfpoakn
 predict tfpoakn, omega
levpet lva if T==., free(llab len) proxy(lin lim) capital(lkap) valueadded // value added
 estimates store tfpvakn
 predict tfpvakn , omega

// estimate tfp for importers in customs, input use rimvcu
levpet lout if lkap!=0 & T!=. & len!=0, free(llab len) proxy(lin) capital(lkap) revenue // revenue nozero
 estimates store tfpoab
 predict tfpoab, omega
levpet lva if lkap!=0 & T!=. & len!=0, free(llab len) proxy(lin lim) capital(lkap) valueadded // value added nozero
 estimates store tfpvab
 predict tfpvab, omega
levpet lout if T!=., free(llab len) proxy(lin) capital(lkap) revenue // revenue
 estimates store tfpoakb
 predict tfpoakb, omega
levpet lva if T!=., free(llab len) proxy(lin lim) capital(lkap) valueadded // value added
 estimates store tfpvakb
 predict tfpvakb , omega

// estimate tfp for importers in customs, input use total import customs
levpet lout if lkap!=0 & T!=. & len!=0, free(llab len) proxy(lin) capital(lkap) revenue // revenue nozero
 estimates store tfpoabt
 predict tfpoabt, omega
levpet lva if lkap!=0 & T!=. & len!=0, free(llab len) proxy(lin lit) capital(lkap) valueadded // value added nozero
 estimates store tfpvabt
 predict tfpvabt, omega
levpet lout if T!=., free(llab len) proxy(lin) capital(lkap) revenue // revenue
 estimates store tfpoakbt
 predict tfpoakbt, omega
levpet lva if T!=., free(llab len) proxy(lin lit) capital(lkap) valueadded // value added
 estimates store tfpvakbt
 predict tfpvakbt, omega

outreg2 [tfpoa tfpva tfpoak tfpvak tfpoan tfpvan tfpoakn tfpvakn tfpoab tfpvab tfpoakb tfpvakb tfpoabt tfpvabt tfpoakbt tfpvakbt] using tfpregen.xls,  replace se bdec(3) tdec(3)  excel 
outreg2 [tfpoa tfpva tfpoak tfpvak tfpoan tfpvan tfpoakn tfpvakn tfpoab tfpvab tfpoakb tfpvakb tfpoabt tfpvabt tfpoakbt tfpvakbt] using tfpregnens.xls,  replace se bdec(3) tdec(3)  excel noaster

sum tfpoa tfpva tfpoak tfpvak tfpoan tfpvan tfpoakn tfpvakn tfpoab tfpvab tfpoakb tfpvakb tfpoabt tfpvabt tfpoakbt tfpvakbt lval
bys bc: sum tfpoa tfpva tfpoak tfpvak tfpoan tfpvan tfpoakn tfpvakn tfpoab tfpvab tfpoakb tfpvakb tfpoabt tfpvabt tfpoakbt tfpvakbt lval

// labeling some shit
la var	lin	"log reported material input (rtlvcu)"
la var	lim	"log reported imported input (rimvcu)"
la var	lit	"log customs imported input (ti)"
la var bc "1 if included in the customs data"
la	var	tfpoa	"revenue tfp of all observation exclude zero lkap"
la	var	tfpva	"value added tfp of all observation exclude zero lkap"
la	var	tfpoak	"revenue tfp of all observation include zero lkap"
la	var	tfpvak	"value added tfp of all observation include zero lkap"
la	var	tfpoan	"revenue tfp of non bc observation exclude zero lkap"
la	var	tfpvan	"value added tfp of non bc observation exclude zero lkap"
la	var	tfpoakn	"revenue tfp of non bc observation include zero lkap"
la	var	tfpvakn	"value added tfp of non bc observation include zero lkap"
la	var	tfpoab	"revenue tfp of bc observation exclude zero lkap"
la	var	tfpvab	"value added tfp of bc observation exclude zero lkap"
la	var	tfpoakb	"revenue tfp of bc observation include zero lkap"
la	var	tfpvakb	"value added tfp of bc observation include zero lkap"
la	var	tfpoabt	"final revenue tfp"
la	var	tfpvabt	"final value added tfp"
la	var	tfpoakbt	"final revenue tfp with zero lkap"
la	var	tfpvakbt	"final revenue tfp with zero lkap"
la	var	lval	"log of value added per labour"

save tfpfinalen,replace

/*
DARI MBAK UMI
reg $dvar1 $ivar2 [w=femweight], r
outreg2 using myall1.xls,  replace se bdec(3) tdec(3)  excel 
reg $dvar2 $ivar2 [w=femweight], r
outreg2 using myall1.xls,  append se bdec(3) tdec(3)  excel 
reg $dvar3 $ivar2 [w=femweight], r
outreg2 using myall1.xls,  append se bdec(3) tdec(3)  excel
*/