***MALAWI Behavioral Biases Study
***TABLE F1
***INTERACTION EFFECTS OF SHORT, TAILORED COUNSELING AND PARTNER INVITATION INTERVENTIONS
***KEXIN ZHANG
***November 21, 2025

version 13

clear all

use "$data\MBBS_Analysis_data.dta"

global balance_covariates "age_binary cont_use1 eff_attribute"

global covariates "age_binary cont_use1 eff_attribute i.w1_area"

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

* Panel A: pre-counseling to Follow-up ideal methods
esttab est1 est2 using "$output\interaction_short_husband_4col.tex", replace fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T HUSB_T c.SHORT_T#c.HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Dep. mean"))  ///
prehead("\begin{table}\begin{center}\caption{Interaction Effects of Short Counseling and Partner Invitation Interventions}\label{tab: allwomeninteraction}\tabcolsep=1cm\scalebox{0.8}{\begin{tabular}{1cc}\toprule") ///
posthead("\midrule \multicolumn{3}{c}{\textbf{A: Change in Stated Preferred Method}} \\\\[-1ex]") nogaps ///
nomtitles collabels(none) 
	
******************* PANEL B. Counseling current method and FUP current method**********************************************	
	eststo clear
eststo: reg diff_method_3 SHORT_T HUSB_T c.SHORT_T#c.HUSB_T, vce(robust) 
summarize diff_method_3
estadd scalar ymean = r(mean)
	
eststo: reg diff_method_3 SHORT_T HUSB_T c.SHORT_T#c.HUSB_T $balance_covariates, vce(robust) 
summarize diff_method_3 
estadd scalar ymean = r(mean)

*Panel B: Counseling current method and Follow-up current method
esttab est1 est2 using "$output\interaction_short_husband_4col.tex", append fragment label nomtitles nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T HUSB_T c.SHORT_T#c.HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Dep. mean")) ///
posthead("\midrule \multicolumn{3}{c}{\textbf{B: Change in Method Use}} \\\\[-1ex]") nogaps collabels(none) 


******************* Panel C: post-COUN ideal method and FUP current method**********************************************
	eststo clear
eststo: reg intertemperal_concordance SHORT_T HUSB_T c.SHORT_T#c.HUSB_T, vce(robust) 
summarize intertemperal_concordance
estadd scalar ymean = r(mean)

eststo: reg intertemperal_concordance SHORT_T HUSB_T c.SHORT_T#c.HUSB_T $balance_covariates, vce(robust) 
summarize intertemperal_concordance 
estadd scalar ymean = r(mean)

*Panel C: Counseling current method and Follow-up current method
esttab est1 est2 using "$output\interaction_short_husband_4col.tex", append fragment label nomtitles nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T HUSB_T c.SHORT_T#c.HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Dep. mean"))  ///
posthead("\midrule \multicolumn{3}{c}{\textbf{C: Intertemporal Concordance}} \\\\[-1ex]") nogaps collabels(none) 
	
******************* Panel D: FUP ideal method and FUP current method**********************************************
	eststo clear
eststo: reg contemp_concordance SHORT_T HUSB_T c.SHORT_T#c.HUSB_T if COUN__FV_1 == 1, vce(robust) 
summarize contemp_concordance 
estadd scalar ymean = r(mean)

eststo: reg contemp_concordance SHORT_T HUSB_T c.SHORT_T#c.HUSB_T $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize contemp_concordance 
estadd scalar ymean = r(mean)

* Panel D: 
esttab est1 est2 using  "$output\interaction_short_husband_4col.tex", append fragment label nomtitles nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T HUSB_T c.SHORT_T#c.HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Dep. mean")) ///
posthead("\midrule \multicolumn{3}{c}{\textbf{D: Contemporaneous Concordance}} \\\\[-1ex]") ///
postfoot("\midrule Balancing controls & & x \\\bottomrule \end{tabular}}\end{center}\footnotesize{Notes: Each panel presents regression results for the primary outcome that is specified. Columns (1) presents the baseline estimation results for the interaction effects between tailored counseling and partner invitations. Column (2) controls for baseline level balancing variables that include a woman's age, her contraceptive use, and whether her most valued attribute was contraceptive effectiveness. Variable definitions are described in Section 3 and are defined in more detail in Table \ref{tab: variable_descriptions}. Heteroskedastic-robust standard errors are presented in brackets. ***1\%, ** 5\%, * 10\%.} \end{table}") nogaps collabels(none) 
