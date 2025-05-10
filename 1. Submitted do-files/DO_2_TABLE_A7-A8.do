***MALAWI Behavioral Biases Study
***DO FILE 2: TABLE A7-A8
***IV REGRESSION RESULTS OF PARTNER INVITATION INTERVENTION, BY PARTNER'S SATISFACTION WITH WOMEN'S CONTRACEPTIVE METHOD

***KEXIN ZHANG
***NOVEMBER 15, 2023

clear all
version 13

use "$data\MBBS_Analysis_data.dta"

global balance_covariates "age_binary cont_use1 eff_attribute"

global covariates "age_binary cont_use1 eff_attribute i.w1_area"

* Drop pregnant women at counseling
	drop if COUN_118 == 1

* Drop pregnant women at FUP
	drop if PHO_103 == 1 | HOME_103 == 1 //638

keep if w1_mergeRand == 3

	keep if COUN__FV_1 == 1

* consent
	keep if PHO_REC_4 == 1 | HOME_REV_20 == 1 | mergeCLI == 3 //675

********************************************************************************************************************
******************** Changing Ideal Methods from Counseling to Fup: which group is more likely afterwards? ***********************************
* ============================== Husband Satisfied ================================
preserve
keep if w1_w07_w724d == 1 | w1_w07_w724d == 2 //satisfied husband
	eststo clear
* Column 1
eststo: ivregress 2sls diff_method_2 (COUN_207 = HUSB_T) $covariates if COUN__FV_1 == 1, vce(robust)
summarize diff_method_2 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

* Column 2
eststo: ivregress 2sls diff_method_8 (COUN_207 = HUSB_T) $covariates if COUN__FV_1 == 1, vce(robust)
summarize diff_method_8 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

* Column 3
eststo: ivregress 2sls diff_method_21 (COUN_207 = HUSB_T) $covariates if COUN__FV_1 == 1, vce(robust)
summarize diff_method_21 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

* Column 4
eststo: ivregress 2sls diff_method_18 (COUN_207 = HUSB_T) $covariates if COUN__FV_1 == 1, vce(robust)
summarize diff_method_18 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

* Column 5
eststo: ivregress 2sls diff_method_20 (COUN_207 = HUSB_T) $covariates if COUN__FV_1 == 1, vce(robust)
summarize diff_method_20 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

* Panel B
* Column 1
eststo: ivregress 2sls diff_method_9 (COUN_207 = HUSB_T) $covariates if COUN__FV_1 == 1, vce(robust)
summarize diff_method_9 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

* Column 2
eststo: ivregress 2sls diff_method_5 (COUN_207 = HUSB_T) $covariates if COUN__FV_1 == 1, vce(robust)
summarize diff_method_5 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

* Column 3
eststo: ivregress 2sls diff_method_16 (COUN_207 = HUSB_T) $covariates if COUN__FV_1 == 1, vce(robust)
summarize diff_method_16 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

* Column 4
eststo: ivregress 2sls diff_method_12 (COUN_207 = HUSB_T) $covariates if COUN__FV_1 == 1, vce(robust)
summarize diff_method_12 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

esttab est1 est2 est3 est4 est5 using  "$output\allwomen_husband_IVHusb_Satisfied.tex", replace fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(COUN_207) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Pre-Counseling and \\ Post-Counseling}" "\makecell{Counseling and \\ Follow-Up}" "\makecell{Counseling and \\ Follow-Up \\ (Adoption)}" "\makecell{Counseling and \\ Follow-Up \\ (Switching)}" "\makecell{Counseling and \\ Follow-Up \\ (Discontinuation)}") ///
mgroups("\makecell{Change to Stated Ideal Method \\ Between...}" "\makecell{Change in Method Use \\ Between...}", pattern(1 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\begin{table}\begin{center}\caption{Instrumental Variable (IV-2SLS) Results of Partner Invitation, among Women whose Partners are Satisfied with Baseline Method}\label{tab: allwomenhusbandIVSatisfiedHusb}\tabcolsep=0.1cm\scalebox{0.73}{\begin{tabular}{lccccc}\toprule\multicolumn{6}{c}{\textbf{A. Stated Ideal Method and Method Use}}\\\midrule") ///
postfoot("\bottomrule") nogaps

esttab est6 est7 est8 est9 using  "$output\allwomen_husband_IVHusb_Satisfied.tex", append fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(COUN_207) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Stated Ideal Method \\after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}" "\makecell{Stated Ideal Method \\ after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}") ///
mgroups("\makecell{Whether Method Use at FUP \\ is Discordant with...}" "\makecell{Whether Method Use at Counseling \\ is Discordant with...}", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\multicolumn{5}{c}{\textbf{B. Discordance}}\\\midrule") ///
postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Area fixed effects are included in all specifications. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps
restore

* ============================== Husband Unsatisfied ================================
preserve
keep if w1_w07_w724d == 4 | w1_w07_w724d == 5 //Dissatisfied husband
	eststo clear
* Column 1
eststo: ivregress 2sls diff_method_2 (COUN_207 = HUSB_T) $covariates if COUN__FV_1 == 1, vce(robust)
summarize diff_method_2 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

* Column 2
eststo: ivregress 2sls diff_method_8 (COUN_207 = HUSB_T) $covariates if COUN__FV_1 == 1, vce(robust)
summarize diff_method_8 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

* Column 3
eststo: ivregress 2sls diff_method_21 (COUN_207 = HUSB_T) $covariates if COUN__FV_1 == 1, vce(robust)
summarize diff_method_21 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

* Column 4
eststo: ivregress 2sls diff_method_18 (COUN_207 = HUSB_T) $covariates if COUN__FV_1 == 1, vce(robust)
summarize diff_method_18 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

* Column 5
eststo: ivregress 2sls diff_method_20 (COUN_207 = HUSB_T) $covariates if COUN__FV_1 == 1, vce(robust)
summarize diff_method_20 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

* Panel B
* Column 1
eststo: ivregress 2sls diff_method_9 (COUN_207 = HUSB_T) $covariates if COUN__FV_1 == 1, vce(robust)
summarize diff_method_9 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

* Column 2
eststo: ivregress 2sls diff_method_5 (COUN_207 = HUSB_T) $covariates if COUN__FV_1 == 1, vce(robust)
summarize diff_method_5 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

* Column 3
eststo: ivregress 2sls diff_method_16 (COUN_207 = HUSB_T) $covariates if COUN__FV_1 == 1, vce(robust)
summarize diff_method_16 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

* Column 4
eststo: ivregress 2sls diff_method_12 (COUN_207 = HUSB_T) $covariates if COUN__FV_1 == 1, vce(robust)
summarize diff_method_12 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

esttab est1 est2 est3 est4 est5 using  "$output\allwomen_husband_IVHusb_Dissatisfied.tex", replace fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(COUN_207) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Pre-Counseling and \\ Post-Counseling}" "\makecell{Counseling and \\ Follow-Up}" "\makecell{Counseling and \\ Follow-Up \\ (Adoption)}" "\makecell{Counseling and \\ Follow-Up \\ (Switching)}" "\makecell{Counseling and \\ Follow-Up \\ (Discontinuation)}") ///
mgroups("\makecell{Change to Stated Ideal Method \\ Between...}" "\makecell{Change in Method Use \\ Between...}", pattern(1 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\begin{table}\begin{center}\caption{Instrumental Variable (IV-2SLS) Results of Partner Invitation, among Women whose Partners are Not Satisfied with Baseline Method}\label{tab: allwomenhusbandIVDissatisfied}\tabcolsep=0.1cm\scalebox{0.73}{\begin{tabular}{lccccc}\toprule\multicolumn{6}{c}{\textbf{A. Stated Ideal Method and Method Use}}\\\midrule") ///
postfoot("\bottomrule") nogaps

esttab est6 est7 est8 est9 using  "$output\allwomen_husband_IVHusb_Dissatisfied.tex", append fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(COUN_207) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Stated Ideal Method \\after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}" "\makecell{Stated Ideal Method \\ after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}") ///
mgroups("\makecell{Whether Method Use at FUP \\ is Discordant with...}" "\makecell{Whether Method Use at Counseling \\ is Discordant with...}", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\multicolumn{5}{c}{\textbf{B. Discordance}}\\\midrule") ///
postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Area fixed effects are included in all specifications. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps
restore
