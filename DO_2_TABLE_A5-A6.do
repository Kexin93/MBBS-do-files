***MALAWI Behavioral Biases Study
***DO FILE 2: TABLE A5-A6
***IV REGRESSION RESULTS OF PARTNER INVITATION INTERVENTION, BY CONTRACEPTIVE USE

***KEXIN ZHANG
***NOVEMBER 15, 2023

version 13

clear all

use "$data\MBBS_Analysis_data.dta"

global balance_covariates "age_binary cont_use1 eff_attribute"

global covariates "age_binary cont_use1 eff_attribute i.w1_area"

******************** Changing Ideal Methods from Counseling to Fup: which group is more likely afterwards? ***********************************
keep if w1_mergeRand == 3

tab COUN__FV_1

	keep if COUN__FV_1 == 1

* consent
	keep if PHO_REC_4 == 1 | HOME_REV_20 == 1 | mergeCLI == 3 //675

preserve
keep if coun_curr_method == 0 
keep if !mi(FUP_curr_method)
eststo clear
* Panel A
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
eststo: ivregress 2sls diff_method_17 (COUN_207 = HUSB_T) $covariates if COUN__FV_1 == 1, vce(robust)
summarize diff_method_17 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

* Panel B
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

esttab est1 est2 est3 using  "$output\allwomen_husband_IV_nonusers.tex", replace fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(COUN_207) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Pre-Counseling and \\ Post-Counseling}" "\makecell{Counseling and \\ Follow-Up}" "\makecell{Counseling and \\ Follow-Up (Adoption)}" "") ///
mgroups("\makecell{Change to Stated Ideal Method \\ Between...}" "\makecell{Change in Method Use \\ Between...}", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\begin{table}\begin{center}\caption{Instrumental Variable (IV-2SLS) Regression Results of Partner Invitation Intervention, among Non-Users of Contraception}\label{tab: allwomenhusbandIVnonusers}\tabcolsep=0.1cm\scalebox{0.8}{\begin{tabular}{lcccc}\toprule\multicolumn{5}{c}{\textbf{A. Stated Ideal Method and Method Use}}\\\midrule") ///
postfoot("\bottomrule") nogaps

esttab est4 est5 est6 est7 using  "$output\allwomen_husband_IV_nonusers.tex", append fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(COUN_207) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Stated Ideal Method \\after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}" "\makecell{Stated Ideal Method \\ after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}") ///
mgroups("\makecell{Whether Method Use at FUP \\ is Discordant with...}" "\makecell{Whether Method Use at Counseling \\ is Discordant with...}", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\multicolumn{5}{c}{\textbf{B. Discordance}}\\\midrule") ///
postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Area fixed effects are included in all specifications. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps
restore

preserve
keep if coun_curr_method > 0 & !mi(coun_curr_method)
keep if !mi(FUP_curr_method)
	eststo clear
* Panel A
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
eststo: ivregress 2sls diff_method_18 (COUN_207 = HUSB_T) $covariates if COUN__FV_1 == 1, vce(robust)
summarize diff_method_18 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
	estat firststage
	matrix FS = r(singleresults)
	estadd scalar fs = FS[1, 4]

* Column 4
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

esttab est1 est2 est3 est4 using  "$output\allwomen_husband_IV_currentusers.tex", replace fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(COUN_207) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Pre-Counseling and \\ Post-Counseling}" "\makecell{Counseling and \\ Follow-Up}" "\makecell{Counseling and \\ Follow-Up \\ (Switching)}" "\makecell{Counseling and \\ Follow-Up \\ (Discontinuation)}") ///
mgroups("\makecell{Change to Stated Ideal Method \\ Between...}" "\makecell{Change in Method Use \\ Between...}", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\begin{table}\begin{center}\caption{Instrumental Variable (IV-2SLS) Regression Results of Partner Invitation Intervention, among Current Users of Contraception}\label{tab: allwomenhusbandIVusers}\tabcolsep=0.1cm\scalebox{0.8}{\begin{tabular}{lcccc}\toprule\multicolumn{5}{c}{\textbf{A. Stated Ideal Method and Method Use}}\\\midrule") ///
postfoot("\bottomrule") nogaps

esttab est5 est6 est7 est8 using  "$output\allwomen_husband_IV_currentusers.tex", append fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(COUN_207) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Stated Ideal Method \\after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}" "\makecell{Stated Ideal Method \\ after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}") ///
mgroups("\makecell{Whether Method Use at FUP \\ is Discordant with...}" "\makecell{Whether Method Use at Counseling \\ is Discordant with...}", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\multicolumn{5}{c}{\textbf{B. Discordance}}\\\midrule") ///
postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Area fixed effects are included in all specifications. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps
restore
