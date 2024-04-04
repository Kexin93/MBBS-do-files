***MALAWI Behavioral Biases Study
***DO FILE 9: TABLE J1-J2
***TREATMENT EFFECTS OF PARTNER INVITATION, BY WOMEN'S INTENTION TO SWITCH METHOD USE AT BASELINE

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

keep if w1_mergeRand == 3

	keep if COUN__FV_1 == 1

* consent
	keep if PHO_REC_4 == 1 | HOME_REV_20 == 1 | mergeCLI == 3 //675

********************************************************************************************************************
* ============================== Want to Switch Method Use ================================
preserve
keep if w1_w03_w331 == 1
	eststo clear
* Column 1
eststo: reg diff_method_2 HUSB_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_2 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 2
eststo: reg diff_method_8 HUSB_T $covariates1 if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust) 
summarize diff_method_8 if HUSB_T == 0  & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)

* Column 3
eststo: reg diff_method_21 HUSB_T $covariates1, vce(robust) 
summarize diff_method_21 if HUSB_T == 0 
estadd scalar ymean = r(mean)

* Column 4
eststo: reg diff_method_18 HUSB_T $covariates1, vce(robust) 
summarize diff_method_18 if HUSB_T == 0 
estadd scalar ymean = r(mean)

* Column 5
eststo: reg diff_method_20 HUSB_T $covariates1, vce(robust) 
summarize diff_method_20 if HUSB_T == 0 
estadd scalar ymean = r(mean)

* Panel B
* Column 1
eststo: reg diff_method_9 HUSB_T $covariates1, vce(robust) 
summarize diff_method_9 if HUSB_T == 0
estadd scalar ymean = r(mean)

* Column 2
eststo: reg diff_method_5 HUSB_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_5 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 3
eststo: reg diff_method_16 HUSB_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_16 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 4
eststo: reg diff_method_12 HUSB_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_12 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

esttab est1 est2 est3 est4 est5 using  "$output\allwomen_husband_ITT_Switch.tex", replace fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Pre-Counseling and \\ Post-Counseling}" "\makecell{Counseling and \\ Follow-Up}" "\makecell{Counseling and \\ Follow-Up \\ (Adoption)}" "\makecell{Counseling and \\ Follow-Up \\ (Switching)}" "\makecell{Counseling and \\ Follow-Up \\ (Discontinuation)}") ///
mgroups("\makecell{Change to Stated Ideal Method \\ Between...}" "\makecell{Change in Method Use \\ Between...}", pattern(1 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\begin{table}\begin{center}\caption{Treatment Effect of the Partner Invitation Intervention, among Women who had an Intention to Switch Method Use at Baseline}\label{tab: allwomenhusbandITTSwitch}\tabcolsep=0.1cm\scalebox{0.72}{\begin{tabular}{lccccc}\toprule\multicolumn{6}{c}{\textbf{A. Stated Ideal Method and Method Use}}\\\midrule") ///
postfoot("\bottomrule") nogaps

esttab est6 est7 est8 est9 using  "$output\allwomen_husband_ITT_Switch.tex", append fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Stated Ideal Method \\after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}" "\makecell{Stated Ideal Method \\ after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}") ///
mgroups("\makecell{Whether Method Use at FUP \\ is Discordant with...}" "\makecell{Whether Method Use at Counseling \\ is Discordant with...}", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\multicolumn{6}{c}{\textbf{B. Discordance}}\\\midrule") ///
postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Other baseline covariates include: her total number of children, educational attainment (primary, secondary, higher), work status (1 = working), and ethnicity (1 = Chewa). Area fixed effects are included in all specifications. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps
restore

* ============================== Do not Want to Switch Method Use ================================
preserve
keep if w1_w03_w331 == 0 
	eststo clear
* Column 1
eststo: reg diff_method_2 HUSB_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_2 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 2
eststo: reg diff_method_8 HUSB_T $covariates1 if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust) 
summarize diff_method_8 if HUSB_T == 0  & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)

* Column 3
eststo: reg diff_method_21 HUSB_T $covariates1, vce(robust) 
summarize diff_method_21 if HUSB_T == 0 
estadd scalar ymean = r(mean)

* Column 4
eststo: reg diff_method_18 HUSB_T $covariates1, vce(robust) 
summarize diff_method_18 if HUSB_T == 0 
estadd scalar ymean = r(mean)

* Column 5
eststo: reg diff_method_20 HUSB_T $covariates1, vce(robust) 
summarize diff_method_20 if HUSB_T == 0 
estadd scalar ymean = r(mean)

* Panel B
* Column 1
eststo: reg diff_method_9 HUSB_T $covariates1, vce(robust) 
summarize diff_method_9 if HUSB_T == 0
estadd scalar ymean = r(mean)

* Column 2
eststo: reg diff_method_5 HUSB_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_5 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 3
eststo: reg diff_method_16 HUSB_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_16 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 4
eststo: reg diff_method_12 HUSB_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_12 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

esttab est1 est2 est3 est4 est5 using  "$output\allwomen_husband_ITTHusb_NotSwitch.tex", replace fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Pre-Counseling and \\ Post-Counseling}" "\makecell{Counseling and \\ Follow-Up}" "\makecell{Counseling and \\ Follow-Up \\ (Adoption)}" "\makecell{Counseling and \\ Follow-Up \\ (Switching)}" "\makecell{Counseling and \\ Follow-Up \\ (Discontinuation)}") ///
mgroups("\makecell{Change to Stated Ideal Method \\ Between...}" "\makecell{Change in Method Use \\ Between...}", pattern(1 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\begin{table}\begin{center}\caption{Treatment Effect of the Partner Invitation Intervention, among Women who did not Want to Switch Method Use at Baseline}\label{tab: allwomenhusbandITTNotSwitch}\tabcolsep=0.1cm\scalebox{0.72}{\begin{tabular}{lccccc}\toprule\multicolumn{6}{c}{\textbf{A. Stated Ideal Method and Method Use}}\\\midrule") ///
postfoot("\bottomrule") nogaps

esttab est6 est7 est8 est9 using  "$output\allwomen_husband_ITTHusb_NotSwitch.tex", append fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Stated Ideal Method \\after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}" "\makecell{Stated Ideal Method \\ after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}") ///
mgroups("\makecell{Whether Method Use at FUP \\ is Discordant with...}" "\makecell{Whether Method Use at Counseling \\ is Discordant with...}", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\multicolumn{6}{c}{\textbf{B. Discordance}}\\\midrule") ///
postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Other baseline covariates include: her total number of children, educational attainment (primary, secondary, higher), work status (1 = working), and ethnicity (1 = Chewa). Area fixed effects are included in all specifications. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps
restore
