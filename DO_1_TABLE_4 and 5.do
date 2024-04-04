***MALAWI Behavioral Biases Study
***DO FILE 1-4 & 1-5: TABLE 4 and TABLE 5

***KEXIN ZHANG
***NOVEMBER 15, 2023

version 13

clear all

use "$data\MBBS_Analysis_data.dta"

global balance_covariates "age_binary cont_use1 eff_attribute"

global covariates "age_binary cont_use1 eff_attribute i.w1_area"

global covariates1 "age_binary cont_use1 eff_attribute i.w1_area tot_child wom_work i.wom_educ ethnicity_Chewa"

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

	eststo clear
*=================================================================================
*===================================== TABLE 4 ===================================
*=================================================================================
preserve
keep if coun_curr_method == 0 
eststo clear
* Panel A
* Column 1
eststo: reg diff_method_2 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_2 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 2
eststo: reg diff_method_8 SHORT_T $covariates1 if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust) 
summarize diff_method_8 if SHORT_T == 0  & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)

* Column 3
eststo: reg diff_method_17 SHORT_T $covariates1, vce(robust) 
summarize diff_method_17 if SHORT_T == 0 
estadd scalar ymean = r(mean)

* Panel B
* Column 1
eststo: reg diff_method_9 SHORT_T $covariates1, vce(robust) 
summarize diff_method_9 if SHORT_T == 0
estadd scalar ymean = r(mean)

* Column 2
eststo: reg diff_method_5 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_5 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 3
eststo: reg diff_method_16 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_16 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 4
eststo: reg diff_method_12 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_12 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

esttab est1 est2 est3 using  "$output\allwomen_short_ITT_nonusers.tex", replace fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Pre-Counseling and \\ Post-Counseling}" "\makecell{Counseling and \\ Follow-Up}" "\makecell{Counseling and \\ Follow-Up (Adoption)}" "") ///
mgroups("\makecell{Change to Stated Ideal Method \\ Between...}" "\makecell{Change in Method Use \\ Between...}", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\begin{table}\begin{center}\caption{Treatment Effect of the Short Counseling Intervention, among Non-Users of Contraception}\label{tab: allwomenshortITTnonusers}\tabcolsep=0.1cm\scalebox{0.77}{\begin{tabular}{lcccc}\toprule\multicolumn{5}{c}{\textbf{A. Stated Ideal Method and Method Use}}\\\midrule") ///
postfoot("\bottomrule") nogaps

esttab est4 est5 est6 est7 using  "$output\allwomen_short_ITT_nonusers.tex", append fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Stated Ideal Method \\after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}" "\makecell{Stated Ideal Method \\ after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}") ///
mgroups("\makecell{Whether Method Use at FUP \\ is Discordant with...}" "\makecell{Whether Method Use at Counseling \\ is Discordant with...}", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\multicolumn{5}{c}{\textbf{B. Discordance}}\\\midrule ") ///
postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Other baseline covariates include: her total number of children, educational attainment (primary, secondary, higher), work status (1 = working), and ethnicity (1 = Chewa). Area fixed effects are included in all specifications. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps
restore

*=================================================================================
*===================================== TABLE 5 ===================================
*=================================================================================

preserve
keep if coun_curr_method > 0 & !mi(coun_curr_method)
	eststo clear
* Panel A
* Column 1
eststo: reg diff_method_2 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_2 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 2
eststo: reg diff_method_8 SHORT_T $covariates1 if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust) 
summarize diff_method_8 if SHORT_T == 0  & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)

* Column 3
eststo: reg diff_method_18 SHORT_T $covariates1, vce(robust) 
summarize diff_method_18 if SHORT_T == 0 
estadd scalar ymean = r(mean)

* Column 4
eststo: reg diff_method_20 SHORT_T $covariates1, vce(robust) 
summarize diff_method_20 if SHORT_T == 0 
estadd scalar ymean = r(mean)

* Panel B
* Column 1
eststo: reg diff_method_9 SHORT_T $covariates1, vce(robust) 
summarize diff_method_9 if SHORT_T == 0
estadd scalar ymean = r(mean)

* Column 2
eststo: reg diff_method_5 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_5 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 3
eststo: reg diff_method_16 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_16 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 4
eststo: reg diff_method_12 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_12 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

esttab est1 est2 est3 est4 using  "$output\allwomen_short_ITT_currentusers.tex", replace fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Pre-Counseling and \\ Post-Counseling}" "\makecell{Counseling and \\ Follow-Up}" "\makecell{Counseling and \\ Follow-Up \\ (Switching)}" "\makecell{Counseling and \\ Follow-Up \\ (Discontinuation)}") ///
mgroups("\makecell{Change to Stated Ideal Method \\ Between...}" "\makecell{Change in Method Use \\ Between...}", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\begin{table}\begin{center}\caption{Treatment Effect of the Short Counseling Intervention, among Current Users of Contraception}\label{tab: allwomenshortITTusers}\tabcolsep=0.1cm\scalebox{0.77}{\begin{tabular}{lcccc}\toprule\multicolumn{5}{c}{\textbf{A. Stated Ideal Method and Method Use}}\\\midrule") ///
postfoot("\bottomrule") nogaps

esttab est5 est6 est7 est8 using  "$output\allwomen_short_ITT_currentusers.tex", append fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Stated Ideal Method \\after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}" "\makecell{Stated Ideal Method \\ after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}") ///
mgroups("\makecell{Whether Method Use at FUP \\ is Discordant with...}" "\makecell{Whether Method Use at Counseling \\ is Discordant with...}", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\multicolumn{5}{c}{\textbf{B. Discordance}}\\\midrule ") ///
postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Other baseline covariates include: her total number of children, educational attainment (primary, secondary, higher), work status (1 = working), and ethnicity (1 = Chewa). Area fixed effects are included in all specifications. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps
restore
