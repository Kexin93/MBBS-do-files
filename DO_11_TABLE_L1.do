***MALAWI Behavioral Biases Study
***DO FILE 11: TABLE L1
***INTERACTION EFFECTS OF SHORT, TAILORED COUNSELING AND PARTNER INVITATION INTERVENTIONS

***KEXIN ZHANG
***NOVEMBER 15, 2023

version 13

clear all

use "$data\MBBS_Analysis_data.dta"

global balance_covariates "age_binary cont_use1 eff_attribute"

global covariates "age_binary cont_use1 eff_attribute i.w1_area"

global covariates1 "age_binary cont_use1 eff_attribute i.w1_area tot_child wom_work i.wom_educ ethnicity_Chewa"

keep if w1_mergeRand == 3

tab COUN__FV_1

	keep if COUN__FV_1 == 1

* consent
	keep if PHO_REC_4 == 1 | HOME_REV_20 == 1 | mergeCLI == 3 //675

* Drop pregnant women at counseling
	drop if COUN_118 == 1

* Drop pregnant women at FUP
	drop if PHO_103 == 1 | HOME_103 == 1 //638

******************* PANEL A. pre-COUN ideal method and FUP ideal method**********************************************
	eststo clear
eststo: reg diff_method_8 SHORT_T HUSB_T c.SHORT_T#c.HUSB_T if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_8 
estadd scalar ymean = r(mean)
	
eststo: reg diff_method_8 SHORT_T HUSB_T c.SHORT_T#c.HUSB_T $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_8 
estadd scalar ymean = r(mean)
	
eststo: reg diff_method_8 SHORT_T HUSB_T c.SHORT_T#c.HUSB_T $covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_8 
estadd scalar ymean = r(mean)

eststo: reg diff_method_8 SHORT_T HUSB_T c.SHORT_T#c.HUSB_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_8
estadd scalar ymean = r(mean)

* Panel A: pre-counseling to Follow-up ideal methods
esttab est1 est2 est3 est4 using "$output\interaction_short_husband_4col.tex", replace fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T HUSB_T c.SHORT_T#c.HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Dep. mean"))  ///
prehead("\begin{table}\begin{center}\caption{Interaction Effects of Short Tailored Counseling and Partner Invitation Interventions}\label{tab: allwomeninteraction}\tabcolsep=0.3cm\scalebox{0.65}{\begin{tabular}{lcccc}\toprule") ///
posthead("\midrule \multicolumn{5}{c}{\textbf{A: Change in Stated Ideal Method from Counseling to Follow-up}} \\\\[-1ex]") nogaps ///
nomtitles collabels(none) 
	
******************* PANEL B. Counseling current method and FUP current method**********************************************	
	eststo clear
eststo: reg diff_method_3 SHORT_T HUSB_T c.SHORT_T#c.HUSB_T, vce(robust) 
summarize diff_method_3
estadd scalar ymean = r(mean)
	
eststo: reg diff_method_3 SHORT_T HUSB_T c.SHORT_T#c.HUSB_T $balance_covariates, vce(robust) 
summarize diff_method_3 
estadd scalar ymean = r(mean)

eststo: reg diff_method_3 SHORT_T HUSB_T c.SHORT_T#c.HUSB_T $covariates, vce(robust) 
summarize diff_method_3 
estadd scalar ymean = r(mean)

eststo: reg diff_method_3 SHORT_T HUSB_T c.SHORT_T#c.HUSB_T $covariates1, vce(robust) 
summarize diff_method_3 
estadd scalar ymean = r(mean)

*Panel B: Counseling current method and Follow-up current method
esttab est1 est2 est3 est4 using "$output\interaction_short_husband_4col.tex", append fragment label nomtitles nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T HUSB_T c.SHORT_T#c.HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Dep. mean")) ///
posthead("\midrule \multicolumn{5}{c}{\textbf{B: Change in Method Use from Counseling to Follow-up}} \\\\[-1ex]") nogaps


******************* Panel C: post-COUN ideal method and FUP current method**********************************************
	eststo clear
eststo: reg diff_method_9 SHORT_T HUSB_T c.SHORT_T#c.HUSB_T, vce(robust) 
summarize diff_method_9
estadd scalar ymean = r(mean)

eststo: reg diff_method_9 SHORT_T HUSB_T c.SHORT_T#c.HUSB_T $balance_covariates, vce(robust) 
summarize diff_method_9 
estadd scalar ymean = r(mean)

eststo: reg diff_method_9 SHORT_T HUSB_T c.SHORT_T#c.HUSB_T $covariates, vce(robust) 
summarize diff_method_9 
estadd scalar ymean = r(mean)

eststo: reg diff_method_9 SHORT_T HUSB_T c.SHORT_T#c.HUSB_T $covariates1, vce(robust) 
summarize diff_method_9 
estadd scalar ymean = r(mean)

*Panel C: Counseling current method and Follow-up current method
esttab est1 est2 est3 est4 using "$output\interaction_short_husband_4col.tex", append fragment label nomtitles nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T HUSB_T c.SHORT_T#c.HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Dep. mean"))  ///
posthead("\midrule \multicolumn{5}{c}{\textbf{C: Discordance: Post-Counseling Stated Ideal Method and Follow-up Method Use}} \\\\[-1ex]") nogaps
	
******************* Panel D: FUP ideal method and FUP current method**********************************************
	eststo clear
eststo: reg diff_method_5 SHORT_T HUSB_T c.SHORT_T#c.HUSB_T if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_5 
estadd scalar ymean = r(mean)

eststo: reg diff_method_5 SHORT_T HUSB_T c.SHORT_T#c.HUSB_T $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_5 
estadd scalar ymean = r(mean)

eststo: reg diff_method_5 SHORT_T HUSB_T c.SHORT_T#c.HUSB_T $covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_5 
estadd scalar ymean = r(mean)

eststo: reg diff_method_5 SHORT_T HUSB_T c.SHORT_T#c.HUSB_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_5 
estadd scalar ymean = r(mean)

* Panel D: 
esttab est1 est2 est3 est4 using  "$output\interaction_short_husband_4col.tex", append fragment label nomtitles nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T HUSB_T c.SHORT_T#c.HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Dep. mean")) ///
posthead("\midrule \multicolumn{5}{c}{\textbf{D: Discordance: Stated Ideal Method and Method Use at Follow-up}} \\\\[-1ex]") ///
postfoot("\midrule Balancing controls & & x & x & x \\ Area FE & & & x & x \\ Other BL covariates & & & & x  \\\bottomrule \end{tabular}}\end{center}\footnotesize{Notes: In Panel A, the dependent variable is a binary variable that indicates whether a woman's stated ideal method at counseling differs from her stated ideal method at follow-up. In Panel B, the dependent variable is a binary variable that indicates if the woman's method use at counseling differs from her method use at follow-up. In Panel C, the dependent variable is a binary variable that indicates if the woman's stated ideal method at counseling differs from her method use at follow-up. In Panel D, the dependent variable is a binary variable that indicates if the woman's method use differs from her stated ideal method at follow-up. Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Other baseline covariates include: her total number of children, educational attainment (primary, secondary, higher), work status (1 = working), and ethnicity (1 = Chewa). Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps
