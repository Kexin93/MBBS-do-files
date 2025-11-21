***MALAWI Behavioral Biases Study
***DO FILE: TABLE A3

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
eststo: reg diff_method_8 /*treatment0*/ treatment1 treatment2 treatment3 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_8 if treatment0 == 1 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	
eststo: reg diff_method_8 /*treatment0*/ treatment1 treatment2 treatment3 $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_8 if treatment0 == 1 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
		
* Panel A: pre-counseling to Follow-up ideal methods
esttab est1 est2 using "$output\results_4_treatment_arms.tex", replace fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(treatment*) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean"))  ///
coeflabel(treatment0 "\makecell[l]{T0: Standard Counseling, \\ No Partner Invitations}" treatment1 "\makecell[l]{T1: Standard Counseling, \\ Partner Invitations}" treatment2 "\makecell[l]{T2: Tailored Counseling, \\ No Partner Invitations}" treatment3 "\makecell[l]{T3: Tailored Counseling, \\ Partner Invitations}") ///
prehead("\begin{table}\begin{center}\caption{Treatment Effect of the Four Treatment Arms}\label{tab: allwomen4arms}\tabcolsep=0.3cm\scalebox{0.64}{\begin{tabular}{lcc}\toprule") ///
posthead("\midrule \multicolumn{3}{c}{\textbf{A: Change in Stated Preferred Method}} \\\\[-1ex]") nogaps ///
nomtitles collabels(none) 

******************* PANEL B. Counseling current method and FUP current method**********************************************	
	eststo clear
eststo: reg diff_method_3 /*treatment0*/  treatment1 treatment2 treatment3, vce(robust) 
summarize diff_method_3 if treatment0 == 1
estadd scalar ymean = r(mean)
	
eststo: reg diff_method_3 /*treatment0*/  treatment1 treatment2 treatment3 $balance_covariates, vce(robust) 
summarize diff_method_3 if treatment0 == 1
estadd scalar ymean = r(mean)

*Panel B: Counseling current method and Follow-up current method
esttab est1 est2 using "$output\results_4_treatment_arms.tex", append fragment label nomtitles nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(treatment*) ///
coeflabel(treatment0 "\makecell[l]{T0: Standard Counseling, \\ No Partner Invitations}" treatment1 "\makecell[l]{T1: Standard Counseling, \\ Partner Invitations}" treatment2 "\makecell[l]{T2: Tailored Counseling, \\ No Partner Invitations}" treatment3 "\makecell[l]{T3: Tailored Counseling, \\ Partner Invitations}") ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
posthead("\midrule \multicolumn{3}{c}{\textbf{B: Change in Method Use}} \\\\[-1ex]") nogaps collabels(none)

******************* Panel C: post-COUN ideal method and FUP current method**********************************************
	eststo clear
eststo: reg intertemperal_concordance /*treatment0*/  treatment1 treatment2 treatment3, vce(robust) 
summarize intertemperal_concordance if treatment0 == 1
estadd scalar ymean = r(mean)

eststo: reg intertemperal_concordance /*treatment0*/  treatment1 treatment2 treatment3 $balance_covariates, vce(robust) 
summarize intertemperal_concordance if treatment0 == 1
estadd scalar ymean = r(mean)

*Panel C: Counseling current method and Follow-up current method
esttab est1 est2 using "$output\results_4_treatment_arms.tex", append fragment label nomtitles nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(treatment*) ///
coeflabel(treatment0 "\makecell[l]{T0: Standard Counseling, \\ No Partner Invitations}" treatment1 "\makecell[l]{T1: Standard Counseling, \\ Partner Invitations}" treatment2 "\makecell[l]{T2: Tailored Counseling, \\ No Partner Invitations}" treatment3 "\makecell[l]{T3: Tailored Counseling, \\ Partner Invitations}") ///
stats(N ymean, fmt(0 2) labels("N" "Control mean"))  ///
posthead("\midrule \multicolumn{3}{c}{\textbf{C: Intertemporal Concordance}} \\\\[-1ex]") nogaps collabels(none)

******************* Panel D: FUP ideal method and FUP current method**********************************************
	eststo clear
eststo: reg contemp_concordance /*treatment0*/  treatment1 treatment2 treatment3 if COUN__FV_1 == 1, vce(robust) 
summarize contemp_concordance if treatment0 == 1 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

eststo: reg contemp_concordance /*treatment0*/  treatment1 treatment2 treatment3 $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize contemp_concordance if treatment0 == 1 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Panel D: 
esttab est1 est2 using  "$output\results_4_treatment_arms.tex", append fragment label nomtitles nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(treatment*) collabels(none) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
coeflabel(treatment0 "\makecell[l]{T0: Standard Counseling, \\ No Partner Invitations}" treatment1 "\makecell[l]{T1: Standard Counseling, \\ Partner Invitations}" treatment2 "\makecell[l]{T2: Tailored Counseling, \\ No Partner Invitations}" treatment3 "\makecell[l]{T3: Tailored Counseling, \\ Partner Invitations}") ///
posthead("\midrule \multicolumn{3}{c}{\textbf{D: Contemporaneous Concordance}} \\\\[-1ex]") ///
postfoot("\midrule Balancing controls & & x \\\bottomrule \end{tabular}}\end{center}\footnotesize{Notes: Each panel presents regression results for the primary outcome that is specified. Columns (1) presents results for the four treatment arms: T0, T1, T2, T3, and Column (2) controls for baseline level balancing variables that include a woman's age, her contraceptive use, and whether her most valued attribute was contraceptive effectiveness. In each column, the control group (standard counseling without partner invitations) is used as the reference group and is omitted. Variable definitions are described in Section 3 and are defined in more detail in Appendix A1. Heteroskedastic-robust standard errors are presented in brackets. ***1\%, ** 5\%, * 10\%.} \end{table}") nogaps
