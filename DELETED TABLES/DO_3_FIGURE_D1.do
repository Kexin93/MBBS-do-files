***MALAWI Behavioral Biases Study
***DO FILE 3: FIGURE D1
***ACTUAL BIRTHS AND DESIRED BIRTHS

***KEXIN ZHANG
***NOVEMBER 15, 2023

version 13

clear all

use "$data\MBBS_Analysis_data.dta"
* ====================================================================================
* ======================= Fig 4: Actual Births and Desired Births ===============================
* ====================================================================================
label variable w1_tot_child "Total No. of Children at BL"
label variable wom_des_fam_size "Desired number of children"

bysort w1_tot_child wom_des_fam_size: gen number_women = _N

twoway(scatter w1_tot_child wom_des_fam_size [weight = number_women ], msymbol(oh) ) ///
(line wom_des_fam_size wom_des_fam_size, lp(dash)), xlabel(0(1)8, grid) ///
xtitle("Desired Births") ytitle("Actual Births") legend(off)  graphregion(fcolor(white)) ylabel(0(1)8, angle(0) grid)

graph export "$output\fig4_actual_desired_births.png", as(png) replace

drop number_women
