//showing how problematic the capital variable in SI is
set more off
clear all
cd "C:/paper2/ultimate"
use tfpsiap,clear
gen bc=0
replace bc=1 if T!=.
/// all observation
twoway  (scatter lout lkap, xtitle("log of total fixed asset") ytitle("log of output") msize(tiny)) ///
		(lfit lout lkap if lkap>0, lw(medthick)) ///
		(lfit lout lkap, lpattern(dash) lw(medthick)) ///
		, legend(order(2 3) label(2 "Exclude zero asset") label(3 "Include zero asset") row(1))
graph save "Graph" kapital,replace
/// only bc=1
twoway  (scatter lout lkap if bc==1, xtitle("log of total fixed asset") ytitle("log of output") msize(tiny)) ///
		(lfit lout lkap if lkap>0 & bc==1, lw(medthick)) ///
		(lfit lout lkap if bc==1, lpattern(dash) lw(medthick)) ///
		, legend(order(2 3) label(2 "Exclude zero asset") label(3 "Include zero asset") row(1))
graph save "Graph" kapitalbc,replace		

graph combine kapital.gph kapitalbc.gph,iscale(.5)
graph save "Graph" kapbc, replace
graph export kapbc.png , as(png) name("Graph") replace

// showing how problematic the energy variable is in SI
/// all obs
twoway  (scatter lout len, xtitle("log of energy consumption") ytitle("log of output") msize(tiny)) ///
		(lfit lout len if len>0, lw(medthick)) ///
		(lfit lout len, lpattern(dash) lw(medthick)) ///
		, legend(order(2 3) label(2 "Exclude zero energy") label(3 "Include zero energy") row(1))
graph save "Graph" energi, replace
/// only bc=1
twoway  (scatter lout len if bc==1, xtitle("log of energy consumption") ytitle("log of output") msize(tiny)) ///
		(lfit lout len if len>0, lw(medthick)) ///
		(lfit lout len, lpattern(dash) lw(medthick)) ///
		, legend(order(2 3) label(2 "Exclude zero energy") label(3 "Include zero energy") row(1))
graph save "Graph" energibc, replace

graph combine energi.gph energibc.gph, iscale(.5)
graph save "Graph" enbc, replace
graph export enbc.png, as(png) name("Graph") replace

graph combine kapital.gph kapitalbc.gph energi.gph energibc.gph, iscale(.5)
graph save "Graph" kapenbc,replace
graph export kapenbc.png, as(png) name("Graph") replace