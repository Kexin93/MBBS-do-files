***MALAWI Behavioral Biases Study
***DO FILE 6: TABLE 6 (change within SARCs)

***KEXIN ZHANG
***June 4, 2025

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

	eststo clear
******************* PANEL A. pre-COUN ideal method and FUP ideal method**********************************************
eststo: reg diff_method_SARC_ideal SHORT_T, vce(robust) 
summarize diff_method_SARC_ideal if SHORT_T == 0  
estadd scalar ymean = r(mean)
	
eststo: reg diff_method_SARC_ideal SHORT_T $balance_covariates, vce(robust) 
summarize diff_method_SARC_ideal if SHORT_T == 0  
estadd scalar ymean = r(mean)
	
eststo: reg diff_method_SARC_ideal HUSB_T, vce(robust) 
summarize diff_method_SARC_ideal if HUSB_T == 0  
estadd scalar ymean = r(mean)

eststo: reg diff_method_SARC_ideal HUSB_T $balance_covariates, vce(robust) 
summarize diff_method_SARC_ideal if HUSB_T == 0  
estadd scalar ymean = r(mean)
	
* Panel A: pre-counseling to Follow-up ideal methods
esttab est1 est2 est3 est4 using "$output\SARC_results.tex", replace fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean"))  ///
prehead("\begin{table}\begin{center}\caption{Treatment Effect of Tailored Counseling and Partner invitations (for SARCs only)}\label{tab: allwomenSARCs}\tabcolsep=0.3cm\scalebox{0.85}{\begin{tabular}{lcccc}\toprule") ///
posthead("\midrule \multicolumn{5}{c}{\textbf{A: Change in Stated Ideal Method}} \\\\[-1ex]") nogaps ///
nomtitles collabels(none) 

******************* PANEL B. Counseling current method and FUP current method**********************************************	
	eststo clear
eststo: reg diff_method_SARC_use SHORT_T, vce(robust) 
summarize diff_method_SARC_use if SHORT_T == 0 
estadd scalar ymean = r(mean)
	
eststo: reg diff_method_SARC_use SHORT_T $balance_covariates, vce(robust) 
summarize diff_method_SARC_use if SHORT_T == 0 
estadd scalar ymean = r(mean)

eststo: reg diff_method_SARC_use HUSB_T, vce(robust) 
summarize diff_method_SARC_use if HUSB_T == 0
estadd scalar ymean = r(mean)

eststo: reg diff_method_SARC_use HUSB_T $balance_covariates, vce(robust) 
summarize diff_method_SARC_use if HUSB_T == 0
estadd scalar ymean = r(mean)

*Panel B: Counseling current method and Follow-up current method
esttab est1 est2 est3 est4 using "$output\SARC_results.tex", append fragment label nomtitles nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
posthead("\midrule \multicolumn{5}{c}{\textbf{B: Change in Method Use}} \\\\[-1ex]") nogaps collabels(none) 

******************* Panel C: post-COUN ideal method and FUP current method**********************************************
	eststo clear
eststo: reg diff_SARC_ID SHORT_T, vce(robust) 
summarize diff_SARC_ID if SHORT_T == 0
estadd scalar ymean = r(mean)

eststo: reg diff_SARC_ID SHORT_T $balance_covariates, vce(robust) 
summarize diff_SARC_ID if SHORT_T == 0
estadd scalar ymean = r(mean)

eststo: reg diff_SARC_ID HUSB_T, vce(robust) 
summarize diff_SARC_ID if HUSB_T == 0
estadd scalar ymean = r(mean)

eststo: reg diff_SARC_ID HUSB_T $balance_covariates, vce(robust) 
summarize diff_SARC_ID if HUSB_T == 0
estadd scalar ymean = r(mean)

*Panel C: Counseling current method and Follow-up current method
esttab est1 est2 est3 est4 using "$output\SARC_results.tex", append fragment label nomtitles nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean"))  ///
posthead("\midrule \multicolumn{5}{c}{\textbf{C: Intertemporal Discordance}} \\\\[-1ex]") nogaps collabels(none) 

******************* Panel D: FUP ideal method and FUP current method**********************************************
	eststo clear
eststo: reg diff_SARC_CD SHORT_T , vce(robust) 
summarize diff_SARC_CD if SHORT_T == 0 
estadd scalar ymean = r(mean)

eststo: reg diff_SARC_CD SHORT_T $balance_covariates , vce(robust) 
summarize diff_SARC_CD if SHORT_T == 0 
estadd scalar ymean = r(mean)

eststo: reg diff_SARC_CD HUSB_T , vce(robust) 
summarize diff_SARC_CD if HUSB_T == 0 
estadd scalar ymean = r(mean)
	
eststo: reg diff_SARC_CD HUSB_T $balance_covariates , vce(robust) 
summarize diff_SARC_CD if HUSB_T == 0 
estadd scalar ymean = r(mean)

* Panel D: 
esttab est1 est2 est3 est4 using  "$output\SARC_results.tex", append fragment label nomtitles nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T HUSB_T) collabels(none)  ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
posthead("\midrule \multicolumn{5}{c}{\textbf{D: Contemporaneous Discordance}} \\\\[-1ex]") ///
postfoot("\midrule Balancing controls & & x & & x \\\bottomrule \end{tabular}}\end{center}\footnotesize{Notes: In Panel A, the dependent variable is a binary variable that indicates whether a woman's stated ideal method at counseling differs from her stated ideal method at follow-up. In Panel B, the dependent variable is a binary variable that indicates if the woman's method use at counseling differs from her method use at follow-up. In Panel C, the dependent variable is a binary variable that indicates if the woman's stated ideal method at counseling differs from her method use at follow-up. In Panel D, the dependent variable is a binary variable that indicates if a woman's method use differs from her stated ideal method at follow-up. Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps
