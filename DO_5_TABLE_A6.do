***MALAWI Behavioral Biases Study
***TABLE A6

***KEXIN ZHANG
***November 21, 2025

version 13
clear all

use "$data\MBBS_Analysis_data.dta"

global balance_covariates "age_binary cont_use1 eff_attribute"
		
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
eststo: reg diff_method_2 SHORT_T if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_2 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

eststo: reg diff_method_2 SHORT_T $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_2 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	
eststo: reg diff_method_22 SHORT_T if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_22 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	
eststo: reg diff_method_22 SHORT_T $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_22 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

eststo: reg diff_method_8 SHORT_T if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_8 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	
eststo: reg diff_method_8 SHORT_T $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_8 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Panel A: pre-counseling to Follow-up ideal methods
esttab est1 est2 est3 est4 est5 est6 using "$output\Table_A6.tex", replace fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean"))  ///
prehead("\begin{table}\begin{center}\caption{Treatment Effect of Tailored Counseling on Changes in Stated Preferred Method across Time}\label{tab: TCstatedpreferred}\tabcolsep=0.3cm\scalebox{0.85}{\begin{tabular}{lcccccc}\toprule") ///
posthead("\midrule") nogaps mgroups("\makecell[c]{Pre-counseling to \\ Post-counseling}" "\makecell[c]{Post-counseling to \\ Follow-up}" "\makecell[c]{Pre-counseling to \\ Follow-up}", pattern(1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) collabels(none) nomtitles ///
postfoot("\midrule Balancing controls & & x & & x & &x\\\bottomrule \end{tabular}}\end{center}\footnotesize{Notes: This table presents the treatment effects of tailored counseling intervention on changes in stated preferred methods between different stages. The outcome variable for columns (1) and (2) are changes in stated preferred method between pre-counseling and post-counseling stages. The outcome variable for columns (3) and (4) are changes in stated preferred method between post-counseling and follow-up stages. The outcome variable for columns (5) and (6) are changes in stated preferred method between pre-counseling and follow-up stages. Columns (2), (4), and (6) control for baseline level balancing variables that include a woman's age, her contraceptive use, and whether her most valued attribute was contraceptive effectiveness. Variable definitions are described in Section 3 and are defined in more detail in Appendix A1. Heteroskedastic-robust standard errors are presented in brackets. ***1\%, ** 5\%, * 10\%.} \end{table}") nogaps
