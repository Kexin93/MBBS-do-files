***MALAWI Behavioral Biases Study
***DO FILE 2: TABLE A4
***IV REGRESSION RESULTS OF PARTNER INVITATION INTERVENTION

***KEXIN ZHANG
***NOVEMBER 15, 2023

version 13

clear all

use "$data\MBBS_Analysis_data.dta"

global balance_covariates "age_binary cont_use1 eff_attribute"

global covariates "age_binary cont_use1 eff_attribute i.w1_area"

********************************************************************************************************************
******************** Changing Ideal Methods from Counseling to Fup: which group is more likely afterwards? ***********************************
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
eststo: ivregress 2sls diff_method_8 (COUN_207 = HUSB_T) if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust)
summarize diff_method_8 if HUSB_T == 0 & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)
		estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

eststo: ivregress 2sls diff_method_8 (COUN_207 = HUSB_T) $balance_covariates if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust)
summarize diff_method_8 if HUSB_T == 0 & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

eststo: ivregress 2sls diff_method_8 (COUN_207 = HUSB_T) $covariates if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust)
summarize diff_method_8 if HUSB_T == 0 & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

* Panel A: pre-counseling to Follow-up ideal methods
esttab est1 est2 est3 using "$output\allwomen_husband_toIV_IV.tex", replace fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(COUN_207) ///
stats(N ymean fs, fmt(0 2) labels("N" "Control mean" "First Stage F"))  ///
prehead("\begin{table}\begin{center}\caption{Instrumental Variable (IV-2SLS) Results of Partner Invitation}\label{tab: allwomenhusbandIV}\tabcolsep=0.1cm\scalebox{0.88}{\begin{tabular}{lccc}\toprule") ///
posthead("\midrule \multicolumn{4}{c}{\textbf{A: Change in Stated Ideal Method from Counseling to Follow-up}} \\\\[-1ex]") nogaps ///
collabels(none) nomtitles

******************* Panel B: Counseling Current Method and FUP Current Method**********************************************
	eststo clear
eststo: ivregress 2sls diff_method_3 (COUN_207 = HUSB_T), vce(robust)
summarize diff_method_3 if HUSB_T == 0
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

eststo: ivregress 2sls diff_method_3 (COUN_207 = HUSB_T) $balance_covariates, vce(robust)
summarize diff_method_3 if HUSB_T == 0
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

eststo: ivregress 2sls diff_method_3 (COUN_207 = HUSB_T) $covariates, vce(robust)
summarize diff_method_3 if HUSB_T == 0
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

*Panel B: Counseling current method and Follow-up current method
esttab est1 est2 est3 using "$output\allwomen_husband_toIV_IV.tex", append fragment label nomtitles nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(COUN_207) ///
stats(N ymean fs, fmt(0 2) labels("N" "Control mean" "First Stage F")) ///
posthead("\midrule \multicolumn{4}{c}{\textbf{B: Change in Method Use from Counseling to Follow-up}} \\\\[-1ex]") nogaps

******************* post-COUN ideal method and FUP current method**********************************************
	eststo clear
eststo: ivregress 2sls diff_method_9 (COUN_207 = HUSB_T), vce(robust)
summarize diff_method_9 if HUSB_T == 0
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

eststo: ivregress 2sls diff_method_9 (COUN_207 = HUSB_T) $balance_covariates, vce(robust)
summarize diff_method_9 if HUSB_T == 0
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]	

eststo: ivregress 2sls diff_method_9 (COUN_207 = HUSB_T) $covariates, vce(robust)
summarize diff_method_9 if HUSB_T == 0
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

*Panel C: Counseling current method and Follow-up current method
esttab est1 est2 est3 using "$output\allwomen_husband_toIV_IV.tex", append fragment label nomtitles nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(COUN_207) ///
stats(N ymean fs, fmt(0 2) labels("N" "Control mean" "First Stage F"))  ///
posthead("\midrule \multicolumn{4}{c}{\textbf{C: Discordance: Post-Counseling Stated Ideal Method and Follow-up Method Use}} \\\\[-1ex]") nogaps

******************* FUP Ideal Method and FUP Current Method**********************************************
	eststo clear
eststo: ivregress 2sls diff_method_5 (COUN_207 = HUSB_T) if COUN__FV_1 == 1, vce(robust)
summarize diff_method_5 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

eststo: ivregress 2sls diff_method_5 (COUN_207 = HUSB_T) $balance_covariates if COUN__FV_1 == 1, vce(robust)
summarize diff_method_5 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

eststo: ivregress 2sls diff_method_5 (COUN_207 = HUSB_T) $covariates if COUN__FV_1 == 1, vce(robust)
summarize diff_method_5 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

* Panel D: 
esttab est1 est2 est3 using  "$output\allwomen_husband_toIV_IV.tex", append fragment label nomtitles nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(COUN_207) ///
stats(N ymean fs, fmt(0 2) labels("N" "Control mean" "First Stage F")) ///
posthead("\midrule \multicolumn{4}{c}{\textbf{D: Discordance: Stated Ideal Method and Method Use at Follow-up}} \\\\[-1ex]") ///
postfoot("\midrule Balancing controls & & x & x\\ Area FE & & & x \\\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: In Panel A, the dependent variable is a binary variable that indicates whether a woman's stated ideal method at counseling differs from her ideal method at follow-up. In Panel B, the dependent variable is a binary variable that indicates if the woman's method use at counseling differs from her method use at follow-up. In Panel C, the dependent variable is a binary variable that indicates if the woman's stated ideal method at counseling differs from her method use at follow-up. In Panel D, the dependent variable is a binary variable that indicates if a woman's method use differs from her stated ideal method at follow-up. Balancing control variables include a woman's age, contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps
