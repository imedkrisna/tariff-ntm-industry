// regressing coverage ratio and
do tfpregen
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

//regressions
xtset psid year

// not controlling for size, no dummies
xtreg ltfpoa LT LCa LCb LCc LCe LCf LCh LCp asing ldasing if lkap!=0 & len!=0 , r
estimates store a1
xtreg ltfpoab LT LCa LCb LCc LCe LCf LCh LCp asing ldasing if lkap!=0 & len!=0, r
estimates store a2
xtreg lval LT LCa LCb LCc LCe LCf LCh LCp asing ldasing , r
estimates store a3
xtreg lval LT LCa LCb LCc LCe LCf LCh LCp asing ldasing if lkap!=0 & len!=0 , r
estimates store a4

// not controlling for size, with dummies & FE
xtreg ltfpoa LT LCa LCb LCc LCe LCf LCh LCp asing ldasing i.ddisic2 i.year if lkap!=0 & len!=0 , fe
estimates store a5
xtreg ltfpoab LT LCa LCb LCc LCe LCf LCh LCp asing ldasing i.ddisic2 i.year if lkap!=0 & len!=0, fe
estimates store a6
xtreg lval LT LCa LCb LCc LCe LCf LCh LCp asing ldasing i.ddisic2 i.year, fe
estimates store a7
xtreg lval LT LCa LCb LCc LCe LCf LCh LCp asing ldasing i.year i.ddisic2 if lkap!=0 & len!=0 , fe
estimates store a8

// controlling for size, no dummies
xtreg ltfpoa LT iLT LCa LCb LCc LCe LCf LCh LCp iLCa iLCb iLCc iLCe iLCf iLCh iLCp asing ldasing if lkap!=0 & len!=0 , r
estimates store b1
xtreg ltfpoab LT iLT LCa LCb LCc LCe LCf LCh LCp iLCa iLCb iLCc iLCe iLCf iLCh iLCp asing ldasing if lkap!=0 & len!=0, r
estimates store b2
xtreg lval LT iLT LCa LCb LCc LCe LCf LCh LCp iLCa iLCb iLCc iLCe iLCf iLCh iLCp asing ldasing , r
estimates store b3
xtreg lval LT iLT LCa LCb LCc LCe LCf LCh LCp iLCa iLCb iLCc iLCe iLCf iLCh iLCp asing ldasing if lkap!=0 & len!=0 ,r
estimates store b4

// controlling for size, with dummies & FE
xtreg ltfpoa LT iLT LCa LCb LCc LCe LCf LCh LCp iLCa iLCb iLCc iLCe iLCf iLCh iLCp asing ldasing i.ddisic2 i.year if lkap!=0 & len!=0 , fe
estimates store b5
xtreg ltfpoab LT iLT LCa LCb LCc LCe LCf LCh LCp iLCa iLCb iLCc iLCe iLCf iLCh iLCp asing ldasing i.ddisic2 i.year if lkap!=0 & len!=0, fe
estimates store b6
xtreg lval LT iLT LCa LCb LCc LCe LCf LCh LCp iLCa iLCb iLCc iLCe iLCf iLCh iLCp asing ldasing i.ddisic2 i.year, fe
estimates store b7
xtreg lval LT iLT LCa LCb LCc LCe LCf LCh LCp iLCa iLCb iLCc iLCe iLCf iLCh iLCp asing ldasing i.year i.ddisic2 if lkap!=0 & len!=0 , fe
estimates store b8

outreg2 [a1 a2 a3 a4 a5 a6 a7 a8 b1 b2 b3 b4 b5 b6 b7 b8] using coveragereg.xls, replace se bdec(3) tdec(3)  excel 