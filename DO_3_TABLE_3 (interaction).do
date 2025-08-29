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

	eststo clear
foreach var of varlist inj_3_months want_switch_adopt told_side_effects deferral access_choice women_satisfaction women_dissatisfaction{
preserve
eststo `var'_Y1: reg diff_method_8 SHORT_T `var' c.SHORT_T#c.`var' $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_8 if SHORT_T == 0 & COUN__FV_1 == 1 
estadd scalar ymean = r(mean)
	
eststo `var'_Y2: reg diff_method_3 SHORT_T `var' c.SHORT_T#c.`var' $balance_covariates, vce(robust) 
summarize diff_method_3 if SHORT_T == 0 
estadd scalar ymean = r(mean)

eststo `var'_Y3: reg diff_method_9 SHORT_T `var' c.SHORT_T#c.`var' $balance_covariates, vce(robust) 
summarize diff_method_9 if SHORT_T == 0
estadd scalar ymean = r(mean)

eststo `var'_Y4: reg diff_method_5 SHORT_T `var' c.SHORT_T#c.`var' $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_5 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
restore
}

label var SHORT_T "Tailored counseling"

esttab inj_3_months_Y1 inj_3_months_Y2 inj_3_months_Y3 inj_3_months_Y4 using "$output\tailored_counseling_interaction.tex", replace fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T inj_3_months c.SHORT_T#c.inj_3_months) ///
prehead("\begin{table}\begin{center}\caption{Heterogeneity in the Treatment Effect of Tailored Counseling}\label{tab: tailoredbygroup}\tabcolsep=0.3cm\scalebox{0.65}{\begin{tabular}{lcccc}\toprule") coeflabel(inj_3_months "\makecell[l]{Recently received \\injectable (<3 months)}" c.SHORT_T#c.inj_3_months "Interaction") posthead("\midrule" ) ///
stats(N, fmt(0) labels("N"))  ///
mtitles("\makecell{Change in \\ Stated Preferred Method}" "\makecell{Change in \\ Method Use}" "\makecell{Intertemporal \\ Discordance}" "\makecell{Contemporaneous \\ Discordance}") collabels(none) postfoot("\cdashline{1-5}")

esttab want_switch_adopt_Y1 want_switch_adopt_Y2 want_switch_adopt_Y3 want_switch_adopt_Y4 using "$output\tailored_counseling_interaction.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T want_switch_adopt c.SHORT_T#c.want_switch_adopt) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(want_switch_adopt "Wants to switch or adopt" c.SHORT_T#c.want_switch_adopt "Interaction") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab told_side_effects_Y1 told_side_effects_Y2 told_side_effects_Y3 told_side_effects_Y4 using "$output\tailored_counseling_interaction.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T told_side_effects c.SHORT_T#c.told_side_effects) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(told_side_effects "\makecell[l]{Told about side effects}" c.SHORT_T#c.told_side_effects "Interaction") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab deferral_Y1 deferral_Y2 deferral_Y3 deferral_Y4 using "$output\tailored_counseling_interaction.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T deferral c.SHORT_T#c.deferral) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(deferral "\makecell[l]{Defer or delay care-seeking}" c.SHORT_T#c.deferral "Interaction") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab access_choice_Y1 access_choice_Y2 access_choice_Y3 access_choice_Y4 using "$output\tailored_counseling_interaction.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T access_choice c.SHORT_T#c.access_choice) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(access_choice "\makecell[l]{Had access and choice}" c.SHORT_T#c.access_choice "Interaction") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab women_satisfaction_Y1 women_satisfaction_Y2 women_satisfaction_Y3 women_satisfaction_Y4 using "$output\tailored_counseling_interaction.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T women_satisfaction c.SHORT_T#c.women_satisfaction) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(women_satisfaction "\makecell[l]{Women satisfied with \\ their BL Method}" c.SHORT_T#c.women_satisfaction "Interaction") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab women_dissatisfaction_Y1 women_dissatisfaction_Y2 women_dissatisfaction_Y3 women_dissatisfaction_Y4 using "$output\tailored_counseling_interaction.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T women_dissatisfaction c.SHORT_T#c.women_dissatisfaction) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(women_dissatisfaction "\makecell[l]{Women dissatisfied with \\ their BL Method}" c.SHORT_T#c.women_dissatisfaction "Interaction") nomtitles collabels(none) nonumbers postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Variable definitions are presented in Table \ref{tab: variable_descriptions}. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps

**# Revised version
	eststo clear
foreach var of varlist prior_knowledge_bi number_attributes_bi attribute_wgt_var_bi method_attribute_con2 method_attribute_con1  method_attribute_con3 method_attribute_con5 women_satisfaction{
preserve
eststo `var'_Y1: reg diff_method_8 SHORT_T `var' c.SHORT_T#c.`var' $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_8 if SHORT_T == 0 & COUN__FV_1 == 1 
estadd scalar ymean = r(mean)
	
eststo `var'_Y2: reg diff_method_3 SHORT_T `var' c.SHORT_T#c.`var' $balance_covariates, vce(robust) 
summarize diff_method_3 if SHORT_T == 0 
estadd scalar ymean = r(mean)

eststo `var'_Y3: reg diff_method_9 SHORT_T `var' c.SHORT_T#c.`var' $balance_covariates, vce(robust) 
summarize diff_method_9 if SHORT_T == 0
estadd scalar ymean = r(mean)

eststo `var'_Y4: reg diff_method_5 SHORT_T `var' c.SHORT_T#c.`var' $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_5 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
restore
}

label var SHORT_T "Tailored counseling"

esttab prior_knowledge_bi_Y1 prior_knowledge_bi_Y2 prior_knowledge_bi_Y3 prior_knowledge_bi_Y4 using "$output\tailored_counseling_interaction_revised.tex", replace fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T prior_knowledge_bi c.SHORT_T#c.prior_knowledge_bi) ///
prehead("\begin{table}\begin{center}\caption{Heterogeneity in the Treatment Effect of Tailored Counseling}\label{tab: tailoredbygroup}\tabcolsep=0.3cm\scalebox{0.65}{\begin{tabular}{lcccc}\toprule") coeflabel(prior_knowledge_bi "\makecell[l]{Prior knowledge \\ about Contraception (> 4)}" c.SHORT_T#c.prior_knowledge_bi "Interaction") posthead("\midrule" ) ///
stats(N, fmt(0) labels("N"))  ///
mtitles("\makecell{Change in \\ Stated Preferred Method}" "\makecell{Change in \\ Method Use}" "\makecell{Intertemporal \\ Discordance}" "\makecell{Contemporaneous \\ Discordance}") collabels(none) postfoot("\cdashline{1-5}")

esttab number_attributes_bi_Y1 number_attributes_bi_Y2 number_attributes_bi_Y3 number_attributes_bi_Y4 using "$output\tailored_counseling_interaction_revised.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T number_attributes_bi c.SHORT_T#c.number_attributes_bi) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(number_attributes_bi "Number of attributes (>1)" c.SHORT_T#c.number_attributes_bi "Interaction") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab attribute_wgt_var_bi_Y1 attribute_wgt_var_bi_Y2 attribute_wgt_var_bi_Y3 attribute_wgt_var_bi_Y4 using "$output\tailored_counseling_interaction_revised.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T attribute_wgt_var_bi c.SHORT_T#c.attribute_wgt_var_bi) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(attribute_wgt_var_bi "\makecell[l]{Weight variation}" c.SHORT_T#c.attribute_wgt_var_bi "Interaction") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab method_attribute_con2_Y1 method_attribute_con2_Y2 method_attribute_con2_Y3 method_attribute_con2_Y4 using "$output\tailored_counseling_interaction_revised.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T method_attribute_con2 c.SHORT_T#c.method_attribute_con2) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(method_attribute_con2 "\makecell[l]{Method use \\ in tailored list}" c.SHORT_T#c.method_attribute_con2 "Interaction") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab method_attribute_con1_Y1 method_attribute_con1_Y2 method_attribute_con1_Y3 method_attribute_con1_Y4 using "$output\tailored_counseling_interaction_revised.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T method_attribute_con1 c.SHORT_T#c.method_attribute_con1) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(method_attribute_con1 "\makecell[l]{Stated preferred method \\ in tailored list}" c.SHORT_T#c.method_attribute_con1 "Interaction") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab method_attribute_con3_Y1 method_attribute_con3_Y2 method_attribute_con3_Y3 method_attribute_con3_Y4 using "$output\tailored_counseling_interaction_revised.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T method_attribute_con3 c.SHORT_T#c.method_attribute_con3) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(method_attribute_con3 "\makecell[l]{Stated preferred method \\ = method use \\ in tailored list}" c.SHORT_T#c.method_attribute_con3 "Interaction") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab method_attribute_con5_Y1 method_attribute_con5_Y2 method_attribute_con5_Y3 method_attribute_con5_Y4 using "$output\tailored_counseling_interaction_revised.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T method_attribute_con5 c.SHORT_T#c.method_attribute_con5) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(method_attribute_con5 "\makecell[l]{Stated preferred method \\ and method use \\ in tailored list}" c.SHORT_T#c.method_attribute_con5 "Interaction") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab women_satisfaction_Y1 women_satisfaction_Y2 women_satisfaction_Y3 women_satisfaction_Y4 using "$output\tailored_counseling_interaction_revised.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T women_satisfaction c.SHORT_T#c.women_satisfaction) ///
stats(N, fmt(0) labels("N"))  ///
coeflabel(women_satisfaction "\makecell[l]{Women satisfied with \\ their BL Method}" c.SHORT_T#c.women_satisfaction "Interaction") nomtitles collabels(none) nonumbers postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Variable definitions are presented in Table \ref{tab: variable_descriptions}. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps

/*Revised version 2 (concise)*/
	eststo clear
foreach var of varlist prior_knowledge_bi number_attributes_bi attribute_wgt_var_bi method_attribute_con2 method_attribute_con1  method_attribute_con3 method_attribute_con5 women_satisfaction{
preserve
eststo `var'_Y1: reg diff_method_8 SHORT_T `var' c.SHORT_T#c.`var' $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_8 if SHORT_T == 0 & COUN__FV_1 == 1 
estadd scalar ymean = r(mean)
test _b[SHORT_T] + _b[c.SHORT_T#c.`var'] = 0
estadd scalar pvalue1 = r(p)

eststo `var'_Y2: reg diff_method_3 SHORT_T `var' c.SHORT_T#c.`var' $balance_covariates, vce(robust) 
summarize diff_method_3 if SHORT_T == 0 
estadd scalar ymean = r(mean)
test _b[SHORT_T] + _b[c.SHORT_T#c.`var'] = 0
estadd scalar pvalue1 = r(p)

eststo `var'_Y3: reg diff_method_9 SHORT_T `var' c.SHORT_T#c.`var' $balance_covariates, vce(robust) 
summarize diff_method_9 if SHORT_T == 0
estadd scalar ymean = r(mean)
test _b[SHORT_T] + _b[c.SHORT_T#c.`var'] = 0
estadd scalar pvalue1 = r(p)

eststo `var'_Y4: reg diff_method_5 SHORT_T `var' c.SHORT_T#c.`var' $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_5 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
test _b[SHORT_T] + _b[c.SHORT_T#c.`var'] = 0
estadd scalar pvalue1 = r(p)
restore
}

label var SHORT_T "Tailored counseling"

esttab method_attribute_con2_Y1 method_attribute_con2_Y2 method_attribute_con2_Y3 method_attribute_con2_Y4 using "$output\tailored_counseling_interaction_revised1.tex", replace fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T c.SHORT_T#c.method_attribute_con2) ///
prehead("\begin{table}\begin{center}\caption{Heterogeneity in the Treatment Effect of Tailored Counseling}\label{tab: tailoredbygroupConcise}\tabcolsep=0.3cm\scalebox{0.65}{\begin{tabular}{lcccc}\toprule") coeflabel(method_attribute_con2 "\makecell[l]{Method use \\ in tailored list}" /*c.SHORT_T#c.method_attribute_con2 "Interaction"*/) posthead("\midrule" ) ///
stats(N pvalue1, labels("N" "Tailored + Tailored $\times$ Interaction = 0") fmt(%9.0f %9.3f))  ///
mtitles("\makecell{Change in \\ Stated Preferred Method}" "\makecell{Change in \\ Method Use}" "\makecell{Intertemporal \\ Discordance}" "\makecell{Contemporaneous \\ Discordance}") collabels(none) postfoot("\cdashline{1-5}")

esttab method_attribute_con1_Y1 method_attribute_con1_Y2 method_attribute_con1_Y3 method_attribute_con1_Y4 using "$output\tailored_counseling_interaction_revised1.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T c.SHORT_T#c.method_attribute_con1) ///
stats(N pvalue1, labels("N" "Tailored + Tailored $\times$ Interaction = 0") fmt(%9.0f %9.3f))  ///
coeflabel(method_attribute_con1 "\makecell[l]{Stated preferred method \\ in tailored list}" /*c.SHORT_T#c.method_attribute_con1 "Interaction"*/) nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab method_attribute_con3_Y1 method_attribute_con3_Y2 method_attribute_con3_Y3 method_attribute_con3_Y4 using "$output\tailored_counseling_interaction_revised1.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T c.SHORT_T#c.method_attribute_con3) ///
stats(N pvalue1, labels("N" "Tailored + Tailored $\times$ Interaction = 0") fmt(%9.0f %9.3f))  ///
coeflabel(method_attribute_con3 "\makecell[l]{Stated preferred method \\ = method use \\ in tailored list}" /*c.SHORT_T#c.method_attribute_con3 "Interaction"*/) nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab method_attribute_con5_Y1 method_attribute_con5_Y2 method_attribute_con5_Y3 method_attribute_con5_Y4 using "$output\tailored_counseling_interaction_revised1.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T c.SHORT_T#c.method_attribute_con5) ///
stats(N pvalue1, labels("N" "Tailored + Tailored $\times$ Interaction = 0") fmt(%9.0f %9.3f))  ///
coeflabel(method_attribute_con5 "\makecell[l]{Stated preferred method \\ and method use \\ in tailored list}" /*c.SHORT_T#c.method_attribute_con5 "Interaction"*/) nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab women_satisfaction_Y1 women_satisfaction_Y2 women_satisfaction_Y3 women_satisfaction_Y4 using "$output\tailored_counseling_interaction_revised1.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T c.SHORT_T#c.women_satisfaction) ///
stats(N pvalue1, labels("N" "Tailored + Tailored $\times$ Interaction = 0") fmt(%9.0f %9.3f))  ///
coeflabel(women_satisfaction "\makecell[l]{Women satisfied with \\ their BL Method}" /*c.SHORT_T#c.women_satisfaction "Interaction"*/) nomtitles collabels(none) nonumbers postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Variable definitions are presented in Table \ref{tab: variable_descriptions}. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps
