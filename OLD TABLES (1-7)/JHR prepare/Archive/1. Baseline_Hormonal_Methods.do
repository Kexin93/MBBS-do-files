***MALAWI Behavioral Biases Study
***DO FILE (NOT TO BE SUBMITTED): ONLY KEEP THE VARIABLES THAT ARE NEEDED
***INPUTS: ANALYSIS_BASE_RAND_CVF_PHO_HOM_CLI_ANALYSIS.dta
***OUTPUTS: MBBS_Analysis_data.dta

***KEXIN ZHANG
***NOVEMBER 15, 2023

clear all

version 13
clear all

global data "E:\5. Malawi Behavioral Biases Study"
global output "$data\Results"

use "$data\Archive\ANALYSIS_BASE_RAND_CVF_PHO_HOM_CLI_ANALYSIS.dta"

keep if w1_mergeRand == 3
drop *_form_number
drop *_formid

***MALAWI Behavioral Biases Study
***DO FILE 1-4 & 1-5: TABLE 4 and TABLE 5

***KEXIN ZHANG
***NOVEMBER 15, 2023

version 13

clear all

use "$data\MBBS_Analysis_data.dta"

global balance_covariates "age_binary cont_use1 eff_attribute"

global covariates "age_binary cont_use1 eff_attribute i.w1_area"

* Drop pregnant women at counseling
	drop if COUN_118 == 1

* Drop pregnant women at FUP
	drop if PHO_103 == 1 | HOME_103 == 1 //638

********************************************************************************************************************
******************** Changing Ideal Methods from Counseling to Fup: which group is more likely afterwards? ***********************************
keep if w1_mergeRand == 3

	keep if COUN__FV_1 == 1

* consent
	keep if PHO_REC_4 == 1 | HOME_REV_20 == 1 | mergeCLI == 3 //675

* Baseline hormonal methods
	gen baseline_hormonal = (baseline_inj == 1 | baseline_implants == 1) if !mi(w1_w03_w303)
	
	eststo clear
*=================================================================================
*===================================== TABLE 4 ===================================
*=================================================================================
preserve
keep if baseline_hormonal == 1 
eststo clear
* Panel A
* Column 1
eststo: reg diff_method_2 SHORT_T $covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_2 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 2
eststo: reg diff_method_8 SHORT_T $covariates if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust) 
summarize diff_method_8 if SHORT_T == 0  & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)

* Column 3
eststo: reg diff_method_17 SHORT_T $covariates, vce(robust) 
summarize diff_method_17 if SHORT_T == 0 
estadd scalar ymean = r(mean)

* Panel B
* Column 1
eststo: reg diff_method_9 SHORT_T $covariates, vce(robust) 
summarize diff_method_9 if SHORT_T == 0
estadd scalar ymean = r(mean)

* Column 2
eststo: reg diff_method_5 SHORT_T $covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_5 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 3
eststo: reg diff_method_16 SHORT_T $covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_16 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 4
eststo: reg diff_method_12 SHORT_T $covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_12 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

esttab est1 est2 est3 using  "$output\allwomen_short_ITT_BL_hormonal.tex", replace fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Pre-Counseling and \\ Post-Counseling}" "\makecell{Counseling and \\ Follow-Up}" "\makecell{Counseling and \\ Follow-Up (Adoption)}" "") ///
mgroups("\makecell{Change to Stated Ideal Method \\ Between...}" "\makecell{Change in Method Use \\ Between...}", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\begin{table}\begin{center}\caption{Treatment Effect of Short Counseling, among Injectable or Implants Users at Baseline}\label{tab: allwomenshortITTnonusers}\tabcolsep=0.1cm\scalebox{0.77}{\begin{tabular}{lcccc}\toprule\multicolumn{5}{c}{\textbf{A. Stated Ideal Method and Method Use}}\\\midrule") ///
postfoot("\bottomrule") nogaps

esttab est4 est5 est6 est7 using  "$output\allwomen_short_ITT_BL_hormonal.tex", append fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Stated Ideal Method \\after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}" "\makecell{Stated Ideal Method \\ after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}") ///
mgroups("\makecell{Whether Method Use at FUP \\ is Discordant with...}" "\makecell{Whether Method Use at Counseling \\ is Discordant with...}", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\multicolumn{5}{c}{\textbf{B. Discordance}}\\\midrule ") ///
postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: The analytical sample consists of women who were using injectables or implants at baseline. Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Area fixed effects are included in all specifications. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps
restore

*=================================================================================
*===================================== TABLE 5 ===================================
*=================================================================================

preserve
keep if baseline_hormonal == 0
	eststo clear
* Panel A
* Column 1
eststo: reg diff_method_2 SHORT_T $covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_2 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 2
eststo: reg diff_method_8 SHORT_T $covariates if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust) 
summarize diff_method_8 if SHORT_T == 0  & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)

* Column 3
eststo: reg diff_method_18 SHORT_T $covariates, vce(robust) 
summarize diff_method_18 if SHORT_T == 0 
estadd scalar ymean = r(mean)

* Column 4
eststo: reg diff_method_20 SHORT_T $covariates, vce(robust) 
summarize diff_method_20 if SHORT_T == 0 
estadd scalar ymean = r(mean)

* Panel B
* Column 1
eststo: reg diff_method_9 SHORT_T $covariates, vce(robust) 
summarize diff_method_9 if SHORT_T == 0
estadd scalar ymean = r(mean)

* Column 2
eststo: reg diff_method_5 SHORT_T $covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_5 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 3
eststo: reg diff_method_16 SHORT_T $covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_16 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 4
eststo: reg diff_method_12 SHORT_T $covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_12 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

esttab est1 est2 est3 est4 using  "$output\allwomen_short_ITT_non_hormonal_users.tex", replace fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Pre-Counseling and \\ Post-Counseling}" "\makecell{Counseling and \\ Follow-Up}" "\makecell{Counseling and \\ Follow-Up \\ (Switching)}" "\makecell{Counseling and \\ Follow-Up \\ (Discontinuation)}") ///
mgroups("\makecell{Change to Stated Ideal Method \\ Between...}" "\makecell{Change in Method Use \\ Between...}", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\begin{table}\begin{center}\caption{Treatment Effect of Short Counseling, among Users of Non-hormonal Methods at Baseline}\label{tab: allwomenshortITTnonhormonal}\tabcolsep=0.1cm\scalebox{0.77}{\begin{tabular}{lcccc}\toprule\multicolumn{5}{c}{\textbf{A. Stated Ideal Method and Method Use}}\\\midrule") ///
postfoot("\bottomrule") nogaps

esttab est5 est6 est7 est8 using  "$output\allwomen_short_ITT_non_hormonal_users.tex", append fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Stated Ideal Method \\after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}" "\makecell{Stated Ideal Method \\ after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}") ///
mgroups("\makecell{Whether Method Use at FUP \\ is Discordant with...}" "\makecell{Whether Method Use at Counseling \\ is Discordant with...}", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\multicolumn{5}{c}{\textbf{B. Discordance}}\\\midrule ") ///
postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: The analytical sample consists of women who were not using injectables or implants. Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Area fixed effects are included in all specifications. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps
restore

