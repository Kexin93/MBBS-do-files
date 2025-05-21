***MALAWI Behavioral Biases Study
***DO FILE - DO RESPONSES DIFFER ACROSS SURVEY MODES?(R2-C6)

***KEXIN  ZHANG
***MAY 21, 2025

clear all

use "$data\MBBS_Analysis_data.dta"

* Analytical sample of 638 observations
keep if w1_mergeRand == 3
keep if COUN__FV_1 == 1

* consent
	keep if PHO_REC_4 == 1 | HOME_REV_20 == 1 | mergeCLI == 3 //675

* Drop pregnant women at counseling
	drop if COUN_118 == 1

* Drop pregnant women at FUP
	drop if PHO_103 == 1 | HOME_103 == 1 //638

* ===========================================================
replace HOME_REV_20 = 0 if mi(HOME_REV_20)
replace PHO_REC_4 = 0 if mi(PHO_REC_4)

* Table 1 variables
global DESCVARS age tot_child wom_des_fam_size preprimary educ_primary educ_second educ_higher wom_work cohab_age curr_use baseline_inj baseline_implants top_attribute top_attribute_wgt want_to_switch husband_support prior_knowledge base_fup_span2

* Selection variables
global DESCVARS1 $DESCVARS BL_long_acting_method husb_satisfied

eststo clear 
eststo PI0_clinic: quietly estpost summarize $DESCVARS1 if mergeCLI == 3 & HUSB_T == 0
eststo PI0_home: quietly estpost summarize $DESCVARS1 if HOME_REV_20 ==1 & mergeCLI == 1 & HUSB_T == 0
eststo PI0_phone: quietly estpost summarize $DESCVARS1 if PHO_REC_4 == 1 & mergeCLI == 1 & HOME_REV_20 == 0 & HUSB_T == 0
eststo PI1_clinic: quietly estpost summarize $DESCVARS1 if mergeCLI == 3 & HUSB_T == 1
eststo PI1_home: quietly estpost summarize $DESCVARS1 if HOME_REV_20 ==1 & mergeCLI == 1 & HUSB_T == 1
eststo PI1_phone: quietly estpost summarize $DESCVARS1 if PHO_REC_4 == 1 & mergeCLI == 1 & HOME_REV_20 == 0 & HUSB_T == 1
eststo PI_clinic_diff: estpost ttest $DESCVARS1 if mergeCLI == 3, by(HUSB_T)
eststo PI_home_diff: estpost ttest $DESCVARS1 if HOME_REV_20 ==1 & mergeCLI == 1, by(HUSB_T)
eststo PI_phone_diff: estpost ttest $DESCVARS1 if PHO_REC_4 == 1 & mergeCLI == 1 & HOME_REV_20 == 0, by(HUSB_T)

esttab PI0_clinic PI0_home PI0_phone PI1_clinic PI1_home PI1_phone PI_clinic_diff PI_home_diff PI_phone_diff using "$output\survey_mode_by_arms.tex",  booktabs fragment ///
label cells("mean(pattern(1 1 1 1 1 1 0 0 0) fmt(2)) b(star pattern(0 0 0 0 0 0 1 1 1) fmt(2))") ///
nonumbers replace collabels(none) compress style(tab) ///
mgroups("Partner Invitation = 0" "Partner Invitation = 1" "Difference", pattern(1 0 0 1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
mtitles("Clinic" "Home" "Phone" "Clinic" "Home" "Phone" "(1)-(4)" "(2)-(5)" "(3)-(6)")  ///
prehead("\begin{table}\begin{center}\caption{Summary Statistics across Survey Modes by Treatment Arms}\label{tab: surveymodesummstatsarms}\tabcolsep=0.2cm\scalebox{0.67}{\begin{tabular}{lccccccccc}\toprule") ///
posthead("\midrule &\multicolumn{9}{c}{\textbf{Partner Invitations}}\\") nogaps postfoot("\midrule")

eststo TC0_clinic: quietly estpost summarize $DESCVARS1 if mergeCLI == 3 & SHORT_T == 0
eststo TC0_home: quietly estpost summarize $DESCVARS1 if HOME_REV_20 ==1 & mergeCLI == 1 & SHORT_T == 0
eststo TC0_phone: quietly estpost summarize $DESCVARS1 if PHO_REC_4 == 1 & mergeCLI == 1 & HOME_REV_20 == 0 & SHORT_T == 0
eststo TC1_clinic: quietly estpost summarize $DESCVARS1 if mergeCLI == 3 & SHORT_T == 1
eststo TC1_home: quietly estpost summarize $DESCVARS1 if HOME_REV_20 ==1 & mergeCLI == 1 & SHORT_T == 1
eststo TC1_phone: quietly estpost summarize $DESCVARS1 if PHO_REC_4 == 1 & mergeCLI == 1 & HOME_REV_20 == 0 & SHORT_T == 1
eststo TC_clinic_diff: estpost ttest $DESCVARS1 if mergeCLI == 3, by(SHORT_T)
eststo TC_home_diff: estpost ttest $DESCVARS1 if HOME_REV_20 ==1 & mergeCLI == 1, by(SHORT_T)
eststo TC_phone_diff: estpost ttest $DESCVARS1 if PHO_REC_4 == 1 & mergeCLI == 1 & HOME_REV_20 == 0, by(SHORT_T)

esttab TC0_clinic TC0_home TC0_phone TC1_clinic TC1_home TC1_phone TC_clinic_diff TC_home_diff TC_phone_diff using "$output\survey_mode_by_arms.tex",  booktabs fragment ///
label cells("mean(pattern(1 1 1 1 1 1 0 0 0) fmt(2)) b(star pattern(0 0 0 0 0 0 1 1 1) fmt(2))") ///
nonumbers append collabels(none) compress style(tab) ///
mgroups("Tailored Counseling = 0" "Tailored Counseling = 1" "Difference", pattern(1 0 0 1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
mtitles("Clinic" "Home" "Phone" "Clinic" "Home" "Phone" "(1)-(4)" "(2)-(5)" "(3)-(6)")  ///
posthead("\midrule &\multicolumn{9}{c}{\textbf{Tailored Counseling}}\\") nogaps ///
postfoot("\bottomrule\end{tabular}}\end{center}\footnotesize{Notes: Panel A displays the summary statistics of variables across the three survey modes by the intervention of partner invitations. Panel B displays the summary statistics of the same variables across survey modes by the intervention of tailored counseling. *** 1\%, ** 5\%, * 10\%.}\end{table}") nogaps

