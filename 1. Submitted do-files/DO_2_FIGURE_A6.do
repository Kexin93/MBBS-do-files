***MALAWI Behavioral Biases Study
***DO FILE 2: FIGURE A7

***KEXIN ZHANG
***NOVEMBER 15, 2023

version 13

clear all

use "$data\MBBS_Analysis_data.dta"

keep if w1_mergeRand == 3
global balance_covariates "age_binary cont_use1 eff_attribute"

global covariates "age_binary cont_use1 eff_attribute i.w1_area"

global covariates1 "age_binary cont_use1 eff_attribute i.w1_area w1_tot_child wom_work i.wom_educ ethnicity_Chewa cohab_age"
		
********************************************************************************************************************
******************** Changing Ideal Methods from Counseling to Fup: which group is more likely afterwards? ***********************************
****************************************************************************************************************
	label var SHORT_T "Short, Tailored Counseling"
	label var HUSB_T "Partner Invitation"

	catplot COUN__HUSB_1221, percent var1opts(lab(labsize(vsmall))) graphregion(fcolor(white)) ///
	/*note("Note: 112 husbands answered this question.", size(vsmall))*/ intens(50)  ///
	l1title("Husband's most valued attribute of a method", size(small)) b1title("") ///
	blabel(bar, format(%4.1f))  

	graph export "$output\husb_attribute.png", as(png) replace
