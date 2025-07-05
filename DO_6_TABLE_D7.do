***MALAWI Behavioral Biases Study
***DO FILE 6: TABLE G6
***COMPARISON BETWEEN PARTNER INVITATION GROUP, PARTNER INVITATION COMPLIERS, AND PARTNER PRESENCE group 

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

* Adoption
eststo: reg diff_method_21 SHORT_T $covariates1, vce(robust) 
summarize diff_method_21 if SHORT_T == 0 
estadd scalar ymean = r(mean)
label var diff_method_21 "Adoption of Methods"

* Switching
eststo: reg diff_method_18 SHORT_T $covariates1, vce(robust) 
summarize diff_method_18 if SHORT_T == 0 
estadd scalar ymean = r(mean)
label var diff_method_3 "Switching of Methods"

* Discontinuation
eststo: reg diff_method_20 SHORT_T $covariates1, vce(robust) 
summarize diff_method_20 if SHORT_T == 0 
estadd scalar ymean = r(mean)
label var diff_method_20 "Discontinuation of Methods"

****** Selection between those who used long-lasting methods (IUD, Implants, Injectables) and those who were not
global DESCVARS1 $DESCVARS BL_long_acting_method husb_satisfied

global DESCVARS2 $DESCVARS1 diff_method_21 diff_method_18 diff_method_20 
* Selection between women [1] the entire sampe, [2] who were assigned to the partner invitation intervention, [3] who actually accepts the invitation, [4] who were present during counseling
eststo clear 
eststo all: quietly estpost summarize $DESCVARS
eststo HUSBT: quietly estpost summarize $DESCVARS if HUSB_T == 1 
eststo HUSB_invitation: quietly estpost summarize $DESCVARS if COUN_207 == 1
eststo HUSB_presence: quietly estpost summarize $DESCVARS if COUN_311 == 1
esttab all HUSBT HUSB_invitation HUSB_presence using "$output\partner_invitation_adoption.tex", booktabs fragment ///
label cells("mean(pattern(1 1 1 1) fmt(2)) b(star pattern(0 0 0 0) fmt(2))") ///
mtitles("All" "\makecell{Partner \\ Invitation}" "\makecell{Partner Invitation \\ Compliers}" "\makecell{Partner \\ Presence}") ///
nonumbers replace collabels(none) compress style(tab) ///
prehead("\begin{table}\begin{center}\caption{Group Comparisons by Level of Compliance with Partner Invitation}\label{tab: partnerAdoption}\tabcolsep=0.2cm\scalebox{0.85}{\begin{tabular}{lcccc}\toprule") ///
postfoot("\bottomrule\end{tabular}}\end{center}\footnotesize{Notes: During the counseling session, 770 women who were interviewed at the baseline were asked if they were available for counseling, among whom 701 women were available for counseling and 69 women did not receive the counseling session. Variable definitions are presented in Table \ref{tab: variable_descriptions}. *** 1\%, ** 5\%, * 10\%.}\end{table}")

