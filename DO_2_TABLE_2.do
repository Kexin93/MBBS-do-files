***MALAWI Behavioral Biases Study
***DO FILE 1-2: TABLE 2

***KEXIN ZHANG
***MAY 10, 2025

version 13
clear all

use "$data\MBBS_Analysis_data.dta"

global balance_covariates "age_binary cont_use1 eff_attribute"
		
********************************************************************************************************************
******************** Changing Ideal Methods from Counseling to Fup: which group is more likely afterwards? ***********************************
****************************************************************************************************************
keep if w1_mergeRand == 3
keep if COUN__FV_1 == 1

* consent
	keep if PHO_REC_4 == 1 | HOME_REV_20 == 1 | mergeCLI == 3 //675

* Drop pregnant women at counseling
	drop if COUN_118 == 1

* Drop pregnant women at FUP
	drop if PHO_103 == 1 | HOME_103 == 1 //638
	
******************* PANEL A. pre-COUN ideal method and FUP ideal method**********************************************
	eststo clear
eststo: reg diff_method_8 SHORT_T if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust) 
summarize diff_method_8 if SHORT_T == 0 & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)
	
eststo: reg diff_method_8 SHORT_T $balance_covariates if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust) 
summarize diff_method_8 if SHORT_T == 0 & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)
	
eststo: reg diff_method_8 HUSB_T if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust) 
summarize diff_method_8 if HUSB_T == 0 & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)

eststo: reg diff_method_8 HUSB_T $balance_covariates if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust) 
summarize diff_method_8 if HUSB_T == 0 & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)
	
* Panel A: pre-counseling to Follow-up ideal methods
esttab est1 est2 est3 est4 using "$output\main_itt_results.tex", replace fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean"))  ///
prehead("\begin{table}\begin{center}\caption{Treatment Effect of Tailored Counseling and Partner Invitations}\label{tab: allwomen}\tabcolsep=0.3cm\scalebox{0.85}{\begin{tabular}{lcccc}\toprule") ///
posthead("\midrule \multicolumn{5}{c}{\textbf{A: Change in Stated Preferred Method}} \\\\[-1ex]") nogaps ///
nomtitles collabels(none) 

******************* PANEL B. Counseling current method and FUP current method**********************************************	
	eststo clear
eststo: reg diff_method_3 SHORT_T, vce(robust) 
summarize diff_method_3 if SHORT_T == 0 
estadd scalar ymean = r(mean)
	
eststo: reg diff_method_3 SHORT_T $balance_covariates, vce(robust) 
summarize diff_method_3 if SHORT_T == 0 
estadd scalar ymean = r(mean)

eststo: reg diff_method_3 HUSB_T, vce(robust) 
summarize diff_method_3 if HUSB_T == 0
estadd scalar ymean = r(mean)

eststo: reg diff_method_3 HUSB_T $balance_covariates, vce(robust) 
summarize diff_method_3 if HUSB_T == 0
estadd scalar ymean = r(mean)

*Panel B: Counseling current method and Follow-up current method
esttab est1 est2 est3 est4 using "$output\main_itt_results.tex", append fragment label nomtitles nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
posthead("\midrule \multicolumn{5}{c}{\textbf{B: Change in Method Use}} \\\\[-1ex]") nogaps collabels(none)

******************* Panel C: post-COUN ideal method and FUP current method**********************************************
	eststo clear
eststo: reg diff_method_9 SHORT_T, vce(robust) 
summarize diff_method_9 if SHORT_T == 0
estadd scalar ymean = r(mean)

eststo: reg diff_method_9 SHORT_T $balance_covariates, vce(robust) 
summarize diff_method_9 if SHORT_T == 0
estadd scalar ymean = r(mean)

eststo: reg diff_method_9 HUSB_T, vce(robust) 
summarize diff_method_9 if HUSB_T == 0
estadd scalar ymean = r(mean)

eststo: reg diff_method_9 HUSB_T $balance_covariates, vce(robust) 
summarize diff_method_9 if HUSB_T == 0
estadd scalar ymean = r(mean)

*Panel C: Counseling current method and Follow-up current method
esttab est1 est2 est3 est4 using "$output\main_itt_results.tex", append fragment label nomtitles nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean"))  ///
posthead("\midrule \multicolumn{5}{c}{\textbf{C: Intertemporal Discordance}} \\\\[-1ex]") nogaps collabels(none)

******************* Panel D: FUP ideal method and FUP current method**********************************************
	eststo clear
eststo: reg diff_method_5 SHORT_T if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_5 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

eststo: reg diff_method_5 SHORT_T $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_5 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

eststo: reg diff_method_5 HUSB_T if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_5 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	
eststo: reg diff_method_5 HUSB_T $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_5 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Panel D: 
esttab est1 est2 est3 est4 using  "$output\main_itt_results.tex", append fragment label nomtitles nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T HUSB_T) collabels(none) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
posthead("\midrule \multicolumn{5}{c}{\textbf{D: Contemporaneous Discordance}} \\\\[-1ex]") ///
postfoot("\midrule Balancing controls & & x & & x \\\bottomrule \end{tabular}}\end{center}\footnotesize{Notes: Each panel presents regression results for the primary outcome that is specified. Columns (1) and (2) present results for the tailored counseling intervention, and columns (3) and (4) present results for the partner invitation intervention. Columns (2) and (4) control for baseline level balancing variables that include a woman's age, her contraceptive use, and whether her most valued attribute was contraceptive effectiveness. Variable definitions are described in Section 3 and are defined in more detail in Appendix A1. Heteroskedastic-robust standard errors are presented in brackets. ***1\%, ** 5\%, * 10\%.} \end{table}") nogaps
