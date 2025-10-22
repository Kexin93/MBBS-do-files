***MALAWI Behavioral Biases Study
***DO FILE 3: TABLE 3 (Heterogeity analyses for Tailored Counseling)

***KEXIN ZHANG
***June 3, 2025

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

	**# Revised 2: resulting COUN_3081, FUP ideal method, FUP current method are in the tailored list
	eststo clear
foreach var of varlist prior_knowledge_bi number_attributes_bi attribute_wgt_var_bi method_attribute_con2 method_attribute_con1  method_attribute_con3 method_attribute_con5 women_satisfaction{
preserve
eststo `var'_Y1: reg method_inlist_95 SHORT_T `var' c.SHORT_T#c.`var' $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize method_inlist_95 if SHORT_T == 0 & COUN__FV_1 == 1 
estadd scalar ymean = r(mean)
	
eststo `var'_Y2: reg method_inlist_96 SHORT_T `var' c.SHORT_T#c.`var' $balance_covariates, vce(robust) 
summarize method_inlist_96 if SHORT_T == 0 
estadd scalar ymean = r(mean)

eststo `var'_Y3: reg method_inlist_97 SHORT_T `var' c.SHORT_T#c.`var' $balance_covariates, vce(robust) 
summarize method_inlist_97 if SHORT_T == 0
estadd scalar ymean = r(mean)

eststo `var'_Y4: reg method_inlist_98 SHORT_T `var' c.SHORT_T#c.`var' $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize method_inlist_98 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
restore
}

label var SHORT_T "Tailored counseling"

esttab method_attribute_con2_Y1 method_attribute_con2_Y2 method_attribute_con2_Y3 method_attribute_con2_Y4 using "$output\tailored_counseling_interaction_revised2.tex", replace fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T method_attribute_con2 c.SHORT_T#c.method_attribute_con2) ///
prehead("\begin{table}\begin{center}\caption{Heterogeneity in the Treatment Effect of Tailored Counseling}\label{tab: tailoredbygroupConcise}\tabcolsep=0.3cm\scalebox{0.55}{\begin{tabular}{lcccc}\toprule") coeflabel(method_attribute_con2 "\makecell[l]{Method use \\ in tailored list}" c.SHORT_T#c.method_attribute_con2 "Interaction") posthead("\midrule" ) ///
stats(N, fmt(0) labels("N"))  ///
mtitles("\makecell{Post-Counseling \\ Stated Preferred Method \\ in Tailored list}" "\makecell{FUP \\ Method Use \\ in Tailored list}" "\makecell{FUP Stated \\ Preferred Method \\ in Tailored List}" "\makecell{Post-Counseling Ideal \\ and FUP Method Use \\ in Tailored List}") collabels(none) postfoot("\cdashline{1-5}")

esttab method_attribute_con1_Y1 method_attribute_con1_Y2 method_attribute_con1_Y3 method_attribute_con1_Y4 using "$output\tailored_counseling_interaction_revised2.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T method_attribute_con1 c.SHORT_T#c.method_attribute_con1) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(method_attribute_con1 "\makecell[l]{Stated preferred method \\ in tailored list}" c.SHORT_T#c.method_attribute_con1 "Interaction") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab method_attribute_con3_Y1 method_attribute_con3_Y2 method_attribute_con3_Y3 method_attribute_con3_Y4 using "$output\tailored_counseling_interaction_revised2.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T method_attribute_con3 c.SHORT_T#c.method_attribute_con3) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(method_attribute_con3 "\makecell[l]{Stated preferred method \\ = method use \\ in tailored list}" c.SHORT_T#c.method_attribute_con3 "Interaction") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab method_attribute_con5_Y1 method_attribute_con5_Y2 method_attribute_con5_Y3 method_attribute_con5_Y4 using "$output\tailored_counseling_interaction_revised2.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T method_attribute_con5 c.SHORT_T#c.method_attribute_con5) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(method_attribute_con5 "\makecell[l]{Stated preferred method \\ and method use \\ in tailored list}" c.SHORT_T#c.method_attribute_con5 "Interaction") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab women_satisfaction_Y1 women_satisfaction_Y2 women_satisfaction_Y3 women_satisfaction_Y4 using "$output\tailored_counseling_interaction_revised2.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T women_satisfaction c.SHORT_T#c.women_satisfaction) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(women_satisfaction "\makecell[l]{Women satisfied with \\ their BL Method}" c.SHORT_T#c.women_satisfaction "Interaction") nomtitles collabels(none) nonumbers postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Variable definitions are presented in Table \ref{tab: variable_descriptions}. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps

**# Revised 3: resulting COUN_3081 + FUP method use, FUP ideal method + FUP method use, COUN_3081 = FUP method use, FUP ideal method = FUP method use, are in the tailored list
	eststo clear
foreach var of varlist prior_knowledge_bi number_attributes_bi attribute_wgt_var_bi method_attribute_con2 method_attribute_con1  method_attribute_con3 method_attribute_con5 women_satisfaction{
preserve
eststo `var'_Y1: reg method_inlist_98 SHORT_T `var' c.SHORT_T#c.`var' $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize method_inlist_98 if SHORT_T == 0 & COUN__FV_1 == 1 
estadd scalar ymean = r(mean)
	
eststo `var'_Y2: reg method_inlist_99 SHORT_T `var' c.SHORT_T#c.`var' $balance_covariates, vce(robust) 
summarize method_inlist_99 if SHORT_T == 0 
estadd scalar ymean = r(mean)

eststo `var'_Y3: reg method_inlist_100 SHORT_T `var' c.SHORT_T#c.`var' $balance_covariates, vce(robust) 
summarize method_inlist_100 if SHORT_T == 0
estadd scalar ymean = r(mean)

eststo `var'_Y4: reg method_inlist_101 SHORT_T `var' c.SHORT_T#c.`var' $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize method_inlist_101 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
restore
}

label var SHORT_T "Tailored counseling"

esttab method_attribute_con2_Y1 method_attribute_con2_Y2 method_attribute_con2_Y3 method_attribute_con2_Y4 using "$output\tailored_counseling_interaction_revised3.tex", replace fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T method_attribute_con2 c.SHORT_T#c.method_attribute_con2) ///
prehead("\begin{table}\begin{center}\caption{Heterogeneity in the Treatment Effect of Tailored Counseling}\label{tab: tailoredbygroupConcise}\tabcolsep=0.3cm\scalebox{0.55}{\begin{tabular}{lcccc}\toprule") coeflabel(method_attribute_con2 "\makecell[l]{Method use \\ in tailored list}" c.SHORT_T#c.method_attribute_con2 "Interaction") posthead("\midrule" ) ///
stats(N, fmt(0) labels("N"))  ///
mtitles("\makecell{Post-Counseling Ideal \\ and FUP Method Use \\ in Tailored List}" "\makecell{FUP Stated Preferred \\ and FUP Method Use \\ in Tailored list}" "\makecell{Post-Counseling Ideal \\ = FUP Method Use \\ in Tailored List}" "\makecell{FUP Ideal Method \\ = FUP Method Use \\ in Tailored List}") collabels(none) postfoot("\cdashline{1-5}")

esttab method_attribute_con1_Y1 method_attribute_con1_Y2 method_attribute_con1_Y3 method_attribute_con1_Y4 using "$output\tailored_counseling_interaction_revised3.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T method_attribute_con1 c.SHORT_T#c.method_attribute_con1) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(method_attribute_con1 "\makecell[l]{Stated preferred method \\ in tailored list}" c.SHORT_T#c.method_attribute_con1 "Interaction") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab method_attribute_con3_Y1 method_attribute_con3_Y2 method_attribute_con3_Y3 method_attribute_con3_Y4 using "$output\tailored_counseling_interaction_revised3.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T method_attribute_con3 c.SHORT_T#c.method_attribute_con3) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(method_attribute_con3 "\makecell[l]{Stated preferred method \\ = method use \\ in tailored list}" c.SHORT_T#c.method_attribute_con3 "Interaction") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab method_attribute_con5_Y1 method_attribute_con5_Y2 method_attribute_con5_Y3 method_attribute_con5_Y4 using "$output\tailored_counseling_interaction_revised3.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T method_attribute_con5 c.SHORT_T#c.method_attribute_con5) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(method_attribute_con5 "\makecell[l]{Stated preferred method \\ and method use \\ in tailored list}" c.SHORT_T#c.method_attribute_con5 "Interaction") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab women_satisfaction_Y1 women_satisfaction_Y2 women_satisfaction_Y3 women_satisfaction_Y4 using "$output\tailored_counseling_interaction_revised3.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T women_satisfaction c.SHORT_T#c.women_satisfaction) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(women_satisfaction "\makecell[l]{Women satisfied with \\ their BL Method}" c.SHORT_T#c.women_satisfaction "Interaction") nomtitles collabels(none) nonumbers postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Variable definitions are presented in Table \ref{tab: variable_descriptions}. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps

**# Revised 4: Main results for the outcomes

******************* PANEL A. pre-COUN ideal method and FUP ideal method**********************************************
	eststo clear
eststo: reg method_inlist_95 SHORT_T if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust) 
summarize method_inlist_95 if SHORT_T == 0 & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)
	
eststo: reg method_inlist_95 SHORT_T $balance_covariates if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust) 
summarize method_inlist_95 if SHORT_T == 0 & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)
	
eststo: reg method_inlist_95 HUSB_T if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust) 
summarize method_inlist_95 if HUSB_T == 0 & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)

eststo: reg method_inlist_95 HUSB_T $balance_covariates if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust) 
summarize method_inlist_95 if HUSB_T == 0 & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)
	
* Panel A: pre-counseling to Follow-up ideal methods
esttab est1 est2 est3 est4 using "$output\main_itt_results_resultingOutcomes.tex", replace fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean"))  ///
prehead("\begin{table}\begin{center}\caption{Treatment Effect of Tailored Counseling and Partner Invitations}\label{tab: allwomen}\tabcolsep=0.3cm\scalebox{0.85}{\begin{tabular}{lcccc}\toprule") ///
posthead("\midrule \multicolumn{5}{c}{\textbf{A: Post-counseling stated preferred method in tailored list}} \\\\[-1ex]") nogaps ///
nomtitles collabels(none) 

******************* PANEL B. Counseling current method and FUP current method**********************************************	
	eststo clear
eststo: reg method_inlist_96 SHORT_T, vce(robust) 
summarize method_inlist_96 if SHORT_T == 0 
estadd scalar ymean = r(mean)
	
eststo: reg method_inlist_96 SHORT_T $balance_covariates, vce(robust) 
summarize method_inlist_96 if SHORT_T == 0 
estadd scalar ymean = r(mean)

eststo: reg method_inlist_96 HUSB_T, vce(robust) 
summarize method_inlist_96 if HUSB_T == 0
estadd scalar ymean = r(mean)

eststo: reg method_inlist_96 HUSB_T $balance_covariates, vce(robust) 
summarize method_inlist_96 if HUSB_T == 0
estadd scalar ymean = r(mean)

*Panel B: Counseling current method and Follow-up current method
esttab est1 est2 est3 est4 using "$output\main_itt_results_resultingOutcomes.tex", append fragment label nomtitles nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
posthead("\midrule \multicolumn{5}{c}{\textbf{B: Follow-up method use in tailored list}} \\\\[-1ex]") nogaps collabels(none)

******************* Panel C: post-COUN ideal method and FUP current method**********************************************
	eststo clear
eststo: reg method_inlist_97 SHORT_T, vce(robust) 
summarize method_inlist_97 if SHORT_T == 0
estadd scalar ymean = r(mean)

eststo: reg method_inlist_97 SHORT_T $balance_covariates, vce(robust) 
summarize method_inlist_97 if SHORT_T == 0
estadd scalar ymean = r(mean)

eststo: reg method_inlist_97 HUSB_T, vce(robust) 
summarize method_inlist_97 if HUSB_T == 0
estadd scalar ymean = r(mean)

eststo: reg method_inlist_97 HUSB_T $balance_covariates, vce(robust) 
summarize method_inlist_97 if HUSB_T == 0
estadd scalar ymean = r(mean)

*Panel C: Counseling current method and Follow-up current method
esttab est1 est2 est3 est4 using "$output\main_itt_results_resultingOutcomes.tex", append fragment label nomtitles nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean"))  ///
posthead("\midrule \multicolumn{5}{c}{\textbf{C: Follow-up stated preferred method in tailored list}} \\\\[-1ex]") nogaps collabels(none)

******************* Panel D: FUP ideal method and FUP current method**********************************************
	eststo clear
eststo: reg method_inlist_98 SHORT_T if COUN__FV_1 == 1, vce(robust) 
summarize method_inlist_98 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

eststo: reg method_inlist_98 SHORT_T $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize method_inlist_98 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

eststo: reg method_inlist_98 HUSB_T if COUN__FV_1 == 1, vce(robust) 
summarize method_inlist_98 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	
eststo: reg method_inlist_98 HUSB_T $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize method_inlist_98 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Panel D: 
esttab est1 est2 est3 est4 using  "$output\main_itt_results_resultingOutcomes.tex", append fragment label nomtitles nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T HUSB_T) collabels(none) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
posthead("\midrule \multicolumn{5}{c}{\textbf{D: Post-counseling stated preferred method and method use in tailored list}} \\\\[-1ex]") ///
postfoot("\midrule Balancing controls & & x & & x \\\bottomrule \end{tabular}}\end{center}\footnotesize{Notes: Each panel presents regression results for the primary outcome that is specified. Columns (1) and (2) present results for the tailored counseling intervention, and columns (3) and (4) present results for the partner invitation intervention. Columns (2) and (4) control for baseline level balancing variables that include a woman's age, her contraceptive use, and whether her most valued attribute was contraceptive effectiveness. Variable definitions are described in Section 3 and are defined in more detail in Appendix A1. Heteroskedastic-robust standard errors are presented in brackets. ***1\%, ** 5\%, * 10\%.} \end{table}") nogaps

**# Revised 5: Main results for the outcomes-2

******************* PANEL A. pre-COUN ideal method and FUP ideal method**********************************************
	eststo clear
eststo: reg method_inlist_98 SHORT_T if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust) 
summarize method_inlist_98 if SHORT_T == 0 & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)
	
eststo: reg method_inlist_98 SHORT_T $balance_covariates if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust) 
summarize method_inlist_98 if SHORT_T == 0 & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)
	
eststo: reg method_inlist_98 HUSB_T if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust) 
summarize method_inlist_98 if HUSB_T == 0 & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)

eststo: reg method_inlist_98 HUSB_T $balance_covariates if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust) 
summarize method_inlist_98 if HUSB_T == 0 & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)
	
* Panel A: pre-counseling to Follow-up ideal methods
esttab est1 est2 est3 est4 using "$output\main_itt_results_resultingOutcomes2.tex", replace fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean"))  ///
prehead("\begin{table}\begin{center}\caption{Treatment Effect of Tailored Counseling and Partner Invitations}\label{tab: allwomen}\tabcolsep=0.3cm\scalebox{0.85}{\begin{tabular}{lcccc}\toprule") ///
posthead("\midrule \multicolumn{5}{c}{\textbf{A: Post-counseling stated preferred method and method use in tailored list}} \\\\[-1ex]") nogaps ///
nomtitles collabels(none) 

******************* PANEL B. Counseling current method and FUP current method**********************************************	
	eststo clear
eststo: reg method_inlist_99 SHORT_T, vce(robust) 
summarize method_inlist_99 if SHORT_T == 0 
estadd scalar ymean = r(mean)
	
eststo: reg method_inlist_99 SHORT_T $balance_covariates, vce(robust) 
summarize method_inlist_99 if SHORT_T == 0 
estadd scalar ymean = r(mean)

eststo: reg method_inlist_99 HUSB_T, vce(robust) 
summarize method_inlist_99 if HUSB_T == 0
estadd scalar ymean = r(mean)

eststo: reg method_inlist_99 HUSB_T $balance_covariates, vce(robust) 
summarize method_inlist_99 if HUSB_T == 0
estadd scalar ymean = r(mean)

*Panel B: Counseling current method and Follow-up current method
esttab est1 est2 est3 est4 using "$output\main_itt_results_resultingOutcomes2.tex", append fragment label nomtitles nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
posthead("\midrule \multicolumn{5}{c}{\textbf{B: Follow-up stated preferred method and follow-up method use in tailored list}} \\\\[-1ex]") nogaps collabels(none)

******************* Panel C: post-COUN ideal method and FUP current method**********************************************
	eststo clear
eststo: reg method_inlist_100 SHORT_T, vce(robust) 
summarize method_inlist_100 if SHORT_T == 0
estadd scalar ymean = r(mean)

eststo: reg method_inlist_100 SHORT_T $balance_covariates, vce(robust) 
summarize method_inlist_100 if SHORT_T == 0
estadd scalar ymean = r(mean)

eststo: reg method_inlist_100 HUSB_T, vce(robust) 
summarize method_inlist_100 if HUSB_T == 0
estadd scalar ymean = r(mean)

eststo: reg method_inlist_100 HUSB_T $balance_covariates, vce(robust) 
summarize method_inlist_100 if HUSB_T == 0
estadd scalar ymean = r(mean)

*Panel C: Counseling current method and Follow-up current method
esttab est1 est2 est3 est4 using "$output\main_itt_results_resultingOutcomes2.tex", append fragment label nomtitles nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean"))  ///
posthead("\midrule \multicolumn{5}{c}{\textbf{C: Post-counseling stated preferred method = FUP method use in tailored list}} \\\\[-1ex]") nogaps collabels(none)

******************* Panel D: FUP ideal method and FUP current method**********************************************
	eststo clear
eststo: reg method_inlist_101 SHORT_T if COUN__FV_1 == 1, vce(robust) 
summarize method_inlist_101 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

eststo: reg method_inlist_101 SHORT_T $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize method_inlist_101 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

eststo: reg method_inlist_101 HUSB_T if COUN__FV_1 == 1, vce(robust) 
summarize method_inlist_101 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	
eststo: reg method_inlist_101 HUSB_T $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize method_inlist_101 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Panel D: 
esttab est1 est2 est3 est4 using  "$output\main_itt_results_resultingOutcomes2.tex", append fragment label nomtitles nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T HUSB_T) collabels(none) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
posthead("\midrule \multicolumn{5}{c}{\textbf{D: Follow-up stated preferred method = Follow-up method use in tailored list}} \\\\[-1ex]") ///
postfoot("\midrule Balancing controls & & x & & x \\\bottomrule \end{tabular}}\end{center}\footnotesize{Notes: Each panel presents regression results for the primary outcome that is specified. Columns (1) and (2) present results for the tailored counseling intervention, and columns (3) and (4) present results for the partner invitation intervention. Columns (2) and (4) control for baseline level balancing variables that include a woman's age, her contraceptive use, and whether her most valued attribute was contraceptive effectiveness. Variable definitions are described in Section 3 and are defined in more detail in Appendix A1. Heteroskedastic-robust standard errors are presented in brackets. ***1\%, ** 5\%, * 10\%.} \end{table}") nogaps
