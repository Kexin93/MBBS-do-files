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
foreach var of varlist discuss_kids_husb husb_supports_fp  cont_wom_decide husb_sat women_satisfaction{
preserve
eststo `var'_Y1: reg diff_method_8 HUSB_T `var' c.HUSB_T#c.`var' $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_8 if HUSB_T == 0 & COUN__FV_1 == 1 
estadd scalar ymean = r(mean)
	
eststo `var'_Y2: reg diff_method_3 HUSB_T `var' c.HUSB_T#c.`var' $balance_covariates, vce(robust) 
summarize diff_method_3 if HUSB_T == 0 
estadd scalar ymean = r(mean)

eststo `var'_Y3: reg diff_method_9 HUSB_T `var' c.HUSB_T#c.`var' $balance_covariates, vce(robust) 
summarize diff_method_9 if HUSB_T == 0
estadd scalar ymean = r(mean)

eststo `var'_Y4: reg diff_method_5 HUSB_T `var' c.HUSB_T#c.`var' $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_5 if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
restore
}

label var HUSB_T "Partner engagement"

esttab discuss_kids_husb_Y1 discuss_kids_husb_Y2 discuss_kids_husb_Y3 discuss_kids_husb_Y4 using "$output\partner_subgroups_interaction.tex", replace fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T discuss_kids_husb c.HUSB_T#c.discuss_kids_husb) ///
prehead("\begin{table}\begin{center}\caption{Heterogeneity in the Treatment Effect of Partner Invitation}\label{tab: partnerbygroup}\tabcolsep=0.3cm\scalebox{0.8}{\begin{tabular}{lcccc}\toprule") coeflabel(discuss_kids_husb "\makecell[l]{Discussed no. of children \\ with husband}" c.HUSB_T#c.discuss_kids_husb "Interaction") posthead("\midrule" ) ///
stats(N, fmt(0) labels("N"))  ///
mtitles("\makecell{Change in \\ Stated Preferred Method}" "\makecell{Change in \\ Method Use}" "\makecell{Intertemporal \\ Discordance}" "\makecell{Contemporaneous \\ Discordance}") collabels(none) postfoot("\cdashline{1-5}")

esttab husb_supports_fp_Y1 husb_supports_fp_Y2 husb_supports_fp_Y3 husb_supports_fp_Y4 using "$output\partner_subgroups_interaction.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T husb_supports_fp c.HUSB_T#c.husb_supports_fp) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(husb_supports_fp "Husband supports FP" c.HUSB_T#c.husb_supports_fp "Interaction") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab cont_wom_decide_Y1 cont_wom_decide_Y2 cont_wom_decide_Y3 cont_wom_decide_Y4 using "$output\partner_subgroups_interaction.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T cont_wom_decide c.HUSB_T#c.cont_wom_decide) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(cont_wom_decide "\makecell[l]{Woman decides \\ FP use/non-use}" c.HUSB_T#c.cont_wom_decide "Interaction") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab husb_sat_Y1 husb_sat_Y2 husb_sat_Y3 husb_sat_Y4 using "$output\partner_subgroups_interaction.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T husb_sat c.HUSB_T#c.husb_sat) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(husb_sat "\makecell[l]{Husband satisfied \\ with FP method use}" c.HUSB_T#c.husb_sat "Interaction") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab women_satisfaction_Y1 women_satisfaction_Y2 women_satisfaction_Y3 women_satisfaction_Y4 using "$output\partner_subgroups_interaction.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T women_satisfaction c.HUSB_T#c.women_satisfaction) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(women_satisfaction "\makecell[l]{Women satisfied with \\ their BL Method}" c.HUSB_T#c.women_satisfaction "Interaction") nomtitles collabels(none) nonumbers postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Variable definitions are presented in Table \ref{tab: variable_descriptions}. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps


