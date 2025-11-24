***MALAWI Behavioral Biases Study
***TABLE A4
***IV REGRESSION RESULTS OF PARTNER INVITATION INTERVENTION

***KEXIN ZHANG
***November 21, 2025

version 13

clear all
timer on 7
use "$data\MBBS_Analysis_data.dta"

global balance_covariates "age_binary cont_use1 eff_attribute"

global covariates "age_binary cont_use1 eff_attribute i.w1_area"

*==============================================================================
*================== Keep the final analytical sample of 638 women ==============
*==============================================================================
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
eststo: ivregress 2sls diff_method_8 (COUN_207 = HUSB_T) if COUN__FV_1 == 1, vce(robust)
summarize diff_method_8 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
		estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

eststo: ivregress 2sls diff_method_8 (COUN_207 = HUSB_T) $balance_covariates if COUN__FV_1 == 1, vce(robust)
summarize diff_method_8 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

* Panel A: pre-counseling to Follow-up ideal methods
esttab est1 est2 using "$output\allwomen_partnerIV.tex", replace fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(COUN_207) ///
stats(N ymean fs, fmt(0 2) labels("N" "Control mean" "First Stage F"))  ///
prehead("\begin{table}\begin{center}\caption{Instrumental Variable (IV-2SLS) Results of Partner Invitation}\label{tab: allwomenhusbandIV}\tabcolsep=0.3cm\scalebox{0.88}{\begin{tabular}{lcc}\toprule") ///
posthead("\midrule \multicolumn{3}{c}{\textbf{A: Change in Stated Preferred Method}} \\\\[-1ex]") nogaps ///
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

*Panel B: Counseling current method and Follow-up current method
esttab est1 est2 using "$output\allwomen_partnerIV.tex", append fragment label nomtitles nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(COUN_207) collabels(none) ///
stats(N ymean fs, fmt(0 2) labels("N" "Control mean" "First Stage F")) ///
posthead("\midrule \multicolumn{3}{c}{\textbf{B: Change in Method Use}} \\\\[-1ex]") nogaps

******************* post-COUN ideal method and FUP current method**********************************************
	eststo clear
eststo: ivregress 2sls intertemperal_concordance (COUN_207 = HUSB_T), vce(robust)
summarize intertemperal_concordance if HUSB_T == 0
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

eststo: ivregress 2sls intertemperal_concordance (COUN_207 = HUSB_T) $balance_covariates, vce(robust)
summarize intertemperal_concordance if HUSB_T == 0
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]	

*Panel C: Counseling current method and Follow-up current method
esttab est1 est2 using "$output\allwomen_partnerIV.tex", append fragment label nomtitles nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(COUN_207) collabels(none) ///
stats(N ymean fs, fmt(0 2) labels("N" "Control mean" "First Stage F"))  ///
posthead("\midrule \multicolumn{3}{c}{\textbf{C: Intertemporal Concordance}} \\\\[-1ex]") nogaps

******************* FUP Ideal Method and FUP Current Method**********************************************
	eststo clear
eststo: ivregress 2sls contemp_concordance (COUN_207 = HUSB_T) if COUN__FV_1 == 1, vce(robust)
summarize contemp_concordance if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

eststo: ivregress 2sls contemp_concordance (COUN_207 = HUSB_T) $balance_covariates if COUN__FV_1 == 1, vce(robust)
summarize contemp_concordance if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

* Panel D: 
esttab est1 est2 using  "$output\allwomen_partnerIV.tex", append fragment label nomtitles nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(COUN_207) collabels(none) ///
stats(N ymean fs, fmt(0 2) labels("N" "Control mean" "First Stage F")) ///
posthead("\midrule \multicolumn{3}{c}{\textbf{D: Contemporaneous Concordance}} \\\\[-1ex]") ///
postfoot("\midrule Balancing controls & & x\\\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: Each panel presents regression results for the primary outcome that is specified. Columns (1) and (2) present results for the partner invitation intervention. Columns (2) controls for baseline level balancing variables that include a woman's age, her contraceptive use, and whether her most valued attribute was contraceptive effectiveness. Variable definitions are described in Section 3 and are defined in more detail in Appendix A1. Heteroskedastic-robust standard errors are presented in brackets. ***1\%, ** 5\%, * 10\%.} \end{table}") nogaps
timer off 7
timer list