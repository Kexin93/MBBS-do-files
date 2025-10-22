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

**# Revised version
	eststo clear
foreach var of varlist prior_knowledge number_attributes attribute_wgt_variation inj_3_months deferral method_attribute_con2 method_attribute_con1 method_attribute_con3 method_attribute_con5 women_satisfaction{
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

eststo `var'_Y3: reg intertemperal_concordance SHORT_T `var' c.SHORT_T#c.`var' $balance_covariates, vce(robust) 
summarize intertemperal_concordance if SHORT_T == 0
estadd scalar ymean = r(mean)
test _b[SHORT_T] + _b[c.SHORT_T#c.`var'] = 0
estadd scalar pvalue1 = r(p)

eststo `var'_Y4: reg contemp_concordance SHORT_T `var' c.SHORT_T#c.`var' $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize contemp_concordance if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
test _b[SHORT_T] + _b[c.SHORT_T#c.`var'] = 0
estadd scalar pvalue1 = r(p)
restore
}

label var SHORT_T "Tailored counseling (TC)"

esttab method_attribute_con2_Y1 method_attribute_con2_Y2 method_attribute_con2_Y3 method_attribute_con2_Y4 using "$output\tailored_counseling_interaction_test1.tex", replace fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T c.SHORT_T#c.method_attribute_con2) ///
prehead("\begin{table}\begin{center}\caption{Heterogeneity in the Treatment Effect of Tailored Counseling}\label{tab: tailoredbygroup}\tabcolsep=0.3cm\scalebox{0.65}{\begin{tabular}{lcccc}\toprule") coeflabel(method_attribute_con2 "\makecell[l]{Method use \\ in tailored list}" c.SHORT_T#c.method_attribute_con2 "\makecell[l]{TC $\times$ Method use in tailored list}") posthead("\midrule" ) ///
stats(N pvalue1, labels("N" "\makecell[l]{TC + TC $\times$ Method use in tailored list = 0}") fmt(%9.0f %9.3f))  ///
mtitles("\makecell{Change in \\ Stated Preferred Method}" "\makecell{Change in \\ Method Use}" "\makecell{Intertemporal \\ Concordance}" "\makecell{Contemporaneous \\ Concordance}") collabels(none) postfoot("\cdashline{1-5}")

esttab method_attribute_con1_Y1 method_attribute_con1_Y2 method_attribute_con1_Y3 method_attribute_con1_Y4 using "$output\tailored_counseling_interaction_test1.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T c.SHORT_T#c.method_attribute_con1) ///
stats(N pvalue1, labels("N" "\makecell[l]{TC + TC $\times$ Pre-counseling stated preferred method in \\ taiored list = 0}") fmt(%9.0f %9.3f))  ///
coeflabel(method_attribute_con1 "\makecell[l]{Stated preferred method \\ in tailored list}" c.SHORT_T#c.method_attribute_con1 "\makecell[l]{TC $\times$ Stated preferred method in tailored list}") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab method_attribute_con3_Y1 method_attribute_con3_Y2 method_attribute_con3_Y3 method_attribute_con3_Y4 using "$output\tailored_counseling_interaction_test1.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T c.SHORT_T#c.method_attribute_con3) ///
stats(N pvalue1, labels("N" "\makecell[l]{TC + TC $\times$ Stated preferred method = method use \\ in taiored list = 0}") fmt(%9.0f %9.3f))  ///
coeflabel(method_attribute_con3 "\makecell[l]{Stated preferred method \\ = method use \\ in tailored list}" c.SHORT_T#c.method_attribute_con3 "TC $\times$ Stated preferred method = method use in tailored list") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab prior_knowledge_Y1 prior_knowledge_Y2 prior_knowledge_Y3 prior_knowledge_Y4 using "$output\tailored_counseling_interaction_test1.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T c.SHORT_T#c.prior_knowledge) ///
stats(N pvalue1, labels("N" "\makecell[l]{TC + TC $\times$ Prior knowledge = 0}") fmt(%9.0f %9.3f))  ///
coeflabel(prior_knowledge "\makecell[l]{Stated preferred method \\ = Prior knowledge}" c.SHORT_T#c.prior_knowledge "TC $\times$ Prior knowledge") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab number_attributes_Y1 number_attributes_Y2 number_attributes_Y3 number_attributes_Y4 using "$output\tailored_counseling_interaction_test1.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T c.SHORT_T#c.number_attributes) ///
stats(N pvalue1, labels("N" "\makecell[l]{TC + TC $\times$ Number of attributes = 0}") fmt(%9.0f %9.3f))  ///
coeflabel(number_attributes "\makecell[l]{Number of attributes}" c.SHORT_T#c.number_attributes "TC $\times$ Number of attributes") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab attribute_wgt_variation_Y1 attribute_wgt_variation_Y2 attribute_wgt_variation_Y3 attribute_wgt_variation_Y4 using "$output\tailored_counseling_interaction_test1.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T c.SHORT_T#c.attribute_wgt_variation) ///
stats(N pvalue1, labels("N" "\makecell[l]{TC + TC $\times$ Weight variation = 0}") fmt(%9.0f %9.3f))  ///
coeflabel(attribute_wgt_variation "\makecell[l]{Stated preferred method \\ = Weight variation}" c.SHORT_T#c.attribute_wgt_variation "TC $\times$ Weight variation") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

// esttab deferral_Y1 deferral_Y2 deferral_Y3 deferral_Y4 using "$output\tailored_counseling_interaction_test1.tex", append fragment label nolines ///
// cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T c.SHORT_T#c.deferral) ///
// stats(N pvalue1, labels("N" "\makecell[l]{TC + TC $\times$ Stated preferred method = decision deferral \\ in the last 12 months = 0}") fmt(%9.0f %9.3f))  ///
// coeflabel(deferral "\makecell[l]{Stated preferred method \\ = decision deferral \\ in the last 12 months }" c.SHORT_T#c.deferral "TC $\times$ decision deferral \\ in the last 12 months") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")
//
// esttab inj_3_months_Y1 inj_3_months_Y2 inj_3_months_Y3 inj_3_months_Y4 using "$output\tailored_counseling_interaction_test1.tex", append fragment label nolines ///
// cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T c.SHORT_T#c.inj_3_months) ///
// stats(N pvalue1, labels("N" "\makecell[l]{TC + TC $\times$ Received injectables within 3 months = 0}") fmt(%9.0f %9.3f))  ///
// coeflabel(inj_3_months "\makecell[l]{Received injectables within 3 months}" c.SHORT_T#c.inj_3_months "TC $\times$ Received injectables within 3 months") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab method_attribute_con5_Y1 method_attribute_con5_Y2 method_attribute_con5_Y3 method_attribute_con5_Y4 using "$output\tailored_counseling_interaction_test1.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T c.SHORT_T#c.method_attribute_con5) ///
stats(N pvalue1, labels("N" "\makecell[l]{TC + TC $\times$ Stated preferred method $\ne$ method use \\ in taiored list = 0}") fmt(%9.0f %9.3f))  ///
coeflabel(method_attribute_con5 "\makecell[l]{Stated preferred method $\ne$ method use \\ in tailored list}" c.SHORT_T#c.method_attribute_con5 "TC $\times$ Stated preferred method $\ne$ method use in tailored list") nomtitles collabels(none) nonumbers postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Variable definitions are presented in Table \ref{tab: variable_descriptions}. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps

/*esttab women_satisfaction_Y1 women_satisfaction_Y2 women_satisfaction_Y3 women_satisfaction_Y4 using "$output\tailored_counseling_interaction_test1.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T c.SHORT_T#c.women_satisfaction) ///
stats(N pvalue1, labels("N" "TC + TC $\times$ Woman satisfied with their BL method = 0") fmt(%9.0f %9.3f))  ///
coeflabel(women_satisfaction "\makecell[l]{Women satisfied with \\ their BL Method}" c.SHORT_T#c.women_satisfaction "TC $\times$ Women satisfied with their BL method") nomtitles collabels(none) nonumbers postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Variable definitions are presented in Table \ref{tab: variable_descriptions}. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps
*/