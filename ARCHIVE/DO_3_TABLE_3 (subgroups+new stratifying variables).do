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

/*inj_3_months want_switch_adopt told_side_effects deferral access_choice women_satisfaction women_dissatisfaction*/

	eststo clear
foreach var of varlist prior_knowledge_bi number_attributes_bi attribute_wgt_variation_bi method_attribute_concordance2 method_attribute_concordance1 women_satisfaction method_attribute_concordance3 method_attribute_concordance5{
reg diff_method_8 SHORT_T `var' c.SHORT#c.`var' $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_8 if SHORT_T == 0 & COUN__FV_1 == 1 
estadd scalar ymean = r(mean)
	
reg diff_method_3 SHORT_T `var' c.SHORT#c.`var' $balance_covariates, vce(robust) 
summarize diff_method_3 if SHORT_T == 0 
estadd scalar ymean = r(mean)

reg diff_method_9 SHORT_T `var' c.SHORT#c.`var' $balance_covariates, vce(robust) 
summarize diff_method_9 if SHORT_T == 0
estadd scalar ymean = r(mean)

reg diff_method_5 SHORT_T `var' c.SHORT#c.`var' $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_5 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
}

reg diff_method_8 SHORT_T method_attribute_concordance1 method_attribute_concordance2 c.SHORT#c.method_attribute_concordance1 c.SHORT#c.method_attribute_concordance2 c.method_attribute_concordance1#c.method_attribute_concordance2 c.SHORT_T#c.method_attribute_concordance1#c.method_attribute_concordance2 $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_8 if SHORT_T == 0 & COUN__FV_1 == 1 
estadd scalar ymean = r(mean)
	
reg diff_method_3 SHORT_T method_attribute_concordance1 method_attribute_concordance2 c.SHORT#c.method_attribute_concordance1 c.SHORT#c.method_attribute_concordance2 c.method_attribute_concordance1#c.method_attribute_concordance2 c.SHORT_T#c.method_attribute_concordance1#c.method_attribute_concordance2 $balance_covariates, vce(robust) 
summarize diff_method_3 if SHORT_T == 0 
estadd scalar ymean = r(mean)

reg diff_method_9 SHORT_T method_attribute_concordance1 method_attribute_concordance2 c.SHORT#c.method_attribute_concordance1 c.SHORT#c.method_attribute_concordance2 c.method_attribute_concordance1#c.method_attribute_concordance2 c.SHORT_T#c.method_attribute_concordance1#c.method_attribute_concordance2 $balance_covariates, vce(robust) 
summarize diff_method_9 if SHORT_T == 0
estadd scalar ymean = r(mean)

reg diff_method_5 SHORT_T method_attribute_concordance1 method_attribute_concordance2 c.SHORT#c.method_attribute_concordance1 c.SHORT#c.method_attribute_concordance2 c.method_attribute_concordance1#c.method_attribute_concordance2 c.SHORT_T#c.method_attribute_concordance1#c.method_attribute_concordance2 $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_5 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)


esttab inj_3_months_Y1 inj_3_months_Y2 inj_3_months_Y3 inj_3_months_Y4 using "$output\tailored_subgroups.tex", replace fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T) ///
prehead("\begin{table}\begin{center}\caption{Heterogeneity in the Treatment Effect of Tailored Counseling}\label{tab: tailoredbygroup}\tabcolsep=0.3cm\scalebox{0.8}{\begin{tabular}{lcccc}\toprule") coeflabel(SHORT_T "\makecell[l]{Recently received \\injectable (<3 months)}") posthead("\midrule" ) ///
stats(N, fmt(0) labels("N"))  ///
mtitles("\makecell{Change in \\ Stated Preferred Method}" "\makecell{Change in \\ Method Use}" "\makecell{Intertemporal \\ Discordance}" "\makecell{Contemporaneous \\ Discordance}") collabels(none) postfoot("\cdashline{1-5}")

esttab inj_3_months_N1 inj_3_months_N2 inj_3_months_N3 inj_3_months_N4 using "$output\tailored_subgroups.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(SHORT_T "\makecell[l]{Did not recently \\ receive injectable}") nomtitles collabels(none) nonumbers postfoot("\midrule")

esttab want_switch_adopt_Y1 want_switch_adopt_Y2 want_switch_adopt_Y3 want_switch_adopt_Y4 using "$output\tailored_subgroups.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(SHORT_T "Wants to switch or adopt") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab want_switch_adopt_N1 want_switch_adopt_N2 want_switch_adopt_N3 want_switch_adopt_N4 using "$output\tailored_subgroups.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(SHORT_T "Does not want to switch or adopt") nomtitles collabels(none) nonumbers postfoot("\midrule")

esttab told_side_effects_Y1 told_side_effects_Y2 told_side_effects_Y3 told_side_effects_Y4 using "$output\tailored_subgroups.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(SHORT_T "Told about side effects") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab told_side_effects_N1 told_side_effects_N2 told_side_effects_N3 told_side_effects_N4 using "$output\tailored_subgroups.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(SHORT_T "Not told about side effects") nomtitles collabels(none) nonumbers postfoot("\midrule")

esttab deferral_Y1 deferral_Y2 deferral_Y3 deferral_Y4 using "$output\tailored_subgroups.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(SHORT_T "Defer or delay care-seeking") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab deferral_N1 deferral_N2 deferral_N3 deferral_N4 using "$output\tailored_subgroups.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(SHORT_T "\makecell[l]{Does not defer or \\ delay care-seeking}") nomtitles collabels(none) nonumbers postfoot("\midrule")

esttab access_choice_Y1 access_choice_Y2 access_choice_Y3 access_choice_Y4 using "$output\tailored_subgroups.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(SHORT_T "Had access and choice") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab access_choice_N1 access_choice_N2 access_choice_N3 access_choice_N4 using "$output\tailored_subgroups.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(SHORT_T "Did not have access or choice") nomtitles collabels(none) nonumbers postfoot("\midrule")

esttab women_satisfaction_Y1 women_satisfaction_Y2 women_satisfaction_Y3 women_satisfaction_Y4 using "$output\tailored_subgroups.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(SHORT_T "\makecell[l]{Women satisfied with \\ their BL Method}") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab women_dissatisfaction_Y1 women_dissatisfaction_Y2 women_dissatisfaction_Y3 women_dissatisfaction_Y4 using "$output\tailored_subgroups.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T) ///
coeflabel(SHORT_T "\makecell[l]{Women dissatisfied with \\ their BL Method}") nomtitles collabels(none) nonumbers ///
stats(N, fmt(0) labels("N"))  ///
postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: We control for baseline level balancing variables that include a woman's age, her contraceptive use, and whether her most valued attribute was contraceptive effectiveness. Variable definitions are presented in Table \ref{tab: variable_descriptions}. Heteroskedastic-robust standard errors are presented in brackets. ***1\%, ** 5\%, * 10\%} \end{table}") nogaps


