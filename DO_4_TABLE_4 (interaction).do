***MALAWI Behavioral Biases Study
***DO FILE 4: TABLE 4 (Heterogeity analyses for Partner Invitation)

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

	eststo clear
foreach var of varlist discuss_kids_husb cont_wom_decide husb_supports_fp husb_sat{
preserve
eststo `var'_Y1: reg diff_method_8 HUSB_T `var' c.HUSB_T#c.`var' $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_8 if HUSB_T == 0 & COUN__FV_1 == 1 
estadd scalar ymean = r(mean)
test _b[HUSB_T] + _b[c.HUSB_T#c.`var'] = 0
estadd scalar pvalue1 = r(p)

eststo `var'_Y2: reg diff_method_3 HUSB_T `var' c.HUSB_T#c.`var' $balance_covariates, vce(robust) 
summarize diff_method_3 if HUSB_T == 0 
estadd scalar ymean = r(mean)
test _b[HUSB_T] + _b[c.HUSB_T#c.`var'] = 0
estadd scalar pvalue1 = r(p)

eststo `var'_Y3: reg intertemperal_concordance HUSB_T `var' c.HUSB_T#c.`var' $balance_covariates, vce(robust) 
summarize intertemperal_concordance if HUSB_T == 0
estadd scalar ymean = r(mean)
test _b[HUSB_T] + _b[c.HUSB_T#c.`var'] = 0
estadd scalar pvalue1 = r(p)

eststo `var'_Y4: reg contemp_concordance HUSB_T `var' c.HUSB_T#c.`var' $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize contemp_concordance if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
test _b[HUSB_T] + _b[c.HUSB_T#c.`var'] = 0
estadd scalar pvalue1 = r(p)
restore
}

label var HUSB_T "Partner invitation (PI)"

esttab discuss_kids_husb_Y1 discuss_kids_husb_Y2 discuss_kids_husb_Y3 discuss_kids_husb_Y4 using "$output\partner_subgroups_interaction.tex", replace fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T c.HUSB_T#c.discuss_kids_husb) ///
prehead("\begin{table}\begin{center}\caption{Heterogeneity in the Treatment Effect of Partner Invitation}\label{tab: partnerbygroup}\tabcolsep=0.3cm\scalebox{0.8}{\begin{tabular}{lcccc}\toprule") coeflabel(discuss_kids_husb "\makecell[l]{Discussed no. of children \\ with husband}" c.HUSB_T#c.discuss_kids_husb "PI $\times$ Discussed no. of children") posthead("\midrule" ) ///
stats(N pvalue1, fmt(%9.0f %9.3f) labels("N" "\makecell[l]{PI + PI $\times$ Discussed \\ no. of children = 0}"))  ///
mtitles("\makecell{Change in \\ Stated Preferred Method}" "\makecell{Change in \\ Method Use}" "\makecell{Intertemporal \\ Concordance}" "\makecell{Contemporaneous \\ Concordance}") collabels(none) postfoot("\cdashline{1-5}")

esttab cont_wom_decide_Y1 cont_wom_decide_Y2 cont_wom_decide_Y3 cont_wom_decide_Y4 using "$output\partner_subgroups_interaction.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T c.HUSB_T#c.cont_wom_decide) ///
stats(N pvalue1, fmt(%9.0f %9.3f) labels("N" "\makecell[l]{PI + PI $\times$ Women \\ decide contraception}"))  ///
coeflabel(cont_wom_decide "\makecell[l]{Woman decides \\ FP use/non-use}" c.HUSB_T#c.cont_wom_decide "PI $\times$ Women decide contraception") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab husb_supports_fp_Y1 husb_supports_fp_Y2 husb_supports_fp_Y3 husb_supports_fp_Y4 using "$output\partner_subgroups_interaction.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T c.HUSB_T#c.husb_supports_fp) ///
stats(N pvalue1, fmt(%9.0f %9.3f) labels("N" "\makecell[l]{PI + PI $\times$ Husband \\ supports FP = 0}"))  ///
coeflabel(husb_supports_fp "Husband supports FP" c.HUSB_T#c.husb_supports_fp "PI $\times$ Husband supports FP") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab husb_sat_Y1 husb_sat_Y2 husb_sat_Y3 husb_sat_Y4 using "$output\partner_subgroups_interaction.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T c.HUSB_T#c.husb_sat) ///
stats(N pvalue1, fmt(%9.0f %9.3f) labels("N" "\makecell[l]{PI + PI $\times$ Husband \\ satisfied with women's FP use  = 0}"))  ///
coeflabel(husb_sat "\makecell[l]{Husband satisfied \\ with FP method use}" c.HUSB_T#c.husb_sat "\makecell[l]{PI $\times$ Husband satisfied with \\ women's FP use}") nomtitles collabels(none) nonumbers postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Variable definitions are presented in Table \ref{tab: variable_descriptions}. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps


