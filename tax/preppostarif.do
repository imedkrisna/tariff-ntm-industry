// install the package first. Comment if already installed
// ssc install egenmore
// ssc install ereplace
clear all
cd "C:/paper2/postarif"
use postarif,clear
egen hs10=sieve(PosTarif), keep(numeric)
destring hs10, replace

keep if hs10>=100000000
drop if hs10==.

