***MALAWI Behavioral Biases Study
***DO FILE 6: TABLE G1-G3
***SELECTION OF WOMEN

***KEXIN ZHANG
***NOVEMBER 15, 2023

version 13

clear all

use "$data\MBBS_Analysis_data.dta"

keep if w1_mergeRand == 3
	
global DESCVARS age tot_child wom_des_fam_size preprimary educ_primary educ_second educ_higher wom_work cohab_age curr_use baseline_inj baseline_implants top_attribute top_attribute_wgt want_to_switch husband_support

****** Selection between those who used long-lasting methods (IUD, Implants, Injectables) and those who were not
*global DESCVARS1 $DESCVARS BL_long_acting_method husb_satisfied

* TABLE D1 - Selection between women who were reached for Counseling and those who were lost for counseling
************************************************************************************
eststo clear 
eststo all: quietly estpost summarize $DESCVARS if !mi(COUN_available)
eststo counselled: quietly estpost summarize $DESCVARS if COUN_available == 1 
eststo not_counselled: quietly estpost summarize $DESCVARS if COUN_available == 0
eststo counselled_diff: quietly estpost ttest $DESCVARS if !mi(COUN_available), by(COUN_available)
eststo coun_diff_p: quietly estpost ttest $DESCVARS if !mi(COUN_available), by(COUN_available)

* Adding scalars of F-Test of join significance. 
eststo F_coun: reg COUN_available $DESCVARS if !mi(COUN_available)
estadd scalar F_Obs = `e(N)': coun_diff_p
testparm $DESCVARS
estadd scalar F_pvalue = r(p): coun_diff_p

esttab all counselled not_counselled counselled_diff coun_diff_p using "$output\counseling_reached.tex", booktabs fragment ///
label cells("mean(pattern(1 1 1 0 0) fmt(2)) b(star pattern(0 0 0 1 0) fmt(2)) p(pattern(0 0 0 0 1) fmt(2))") ///
mtitles("All" "Counselled" "Not Counselled" "Difference" "p-value") ///
nonumbers replace collabels(none) compress style(tab) starlevels(* 0.1 ** 0.05 *** 0.01) ///
stats(F_pvalue F_Obs, label("F-test of joint significance: p-value" "F-test: Number of observations" ) fmt( %9.3f  %9.0f )) ///
prehead("\begin{table}\begin{center}\caption{Who were Available for the Counseling Session?}\label{tab: counselingreached}\tabcolsep=0.2cm\scalebox{0.85}{\begin{tabular}{lccccc}\toprule") ///
postfoot("\bottomrule\end{tabular}}\end{center}\footnotesize{Notes: During the counseling session, 770 women who were interviewed at the baseline were asked if they were available for counseling, among whom 701 women were available for counseling and 69 women did not receive the counseling session. Variable definitions are presented in Table \ref{tab: variable_descriptions}. *** 1\%, ** 5\%, * 10\%.}\end{table}")

* TABLE D2 -Selection between women who invited husband and those who did not
************************************************************************************
// COMPARE between Compliers and non-compliers in the HUSB_T intervention group
************************************************************************************
replace COUN_207 = 0 if COUN__husb_cons == 0
eststo clear 
eststo husb_t: quietly estpost summarize $DESCVARS if HUSB_T ==1 & !mi(COUN_207) & COUN__FV_1 == 1
eststo husb_t_take: quietly estpost summarize $DESCVARS if HUSB_T == 1 & COUN_207 == 1 & COUN__FV_1 == 1
eststo husb_t_ntake: quietly estpost summarize $DESCVARS if HUSB_T == 1 & COUN_207 == 0 & COUN__FV_1 == 1
eststo husb_itt: quietly estpost ttest $DESCVARS if HUSB_T == 1 & COUN__FV_1 == 1, by(COUN_207)
eststo coun207_diff_p: quietly estpost ttest $DESCVARS if HUSB_T == 1 & COUN__FV_1 == 1, by(COUN_207)

* Adding scalars of F-Test of join significance. 
eststo F_coun: reg COUN_207 $DESCVARS if HUSB_T ==1 & !mi(COUN_207) & COUN__FV_1 == 1
estadd scalar F_Obs = `e(N)': coun207_diff_p
testparm $DESCVARS
estadd scalar F_pvalue = r(p): coun207_diff_p

esttab husb_t husb_t_take husb_t_ntake husb_itt coun207_diff_p using "$output\husband_compliers639.tex", booktabs fragment ///
label cells("mean(pattern(1 1 1 0 0) fmt(2)) b(star pattern(0 0 0 1 0) fmt(2)) p(pattern(0 0 0 0 1) fmt(2))") ///
mtitles("All" "Compliers" "Non-Compliers" "Difference" "p-value") ///
nonumbers replace collabels(none) compress style(tab) starlevels(* 0.1 ** 0.05 *** 0.01) ///
stats(F_pvalue F_Obs, label("F-test of joint significance: p-value" "F-test: Number of observations" ) fmt( %9.3f  %9.0f )) ///
prehead("\begin{table}\begin{center} \caption{Partner Invitation Compliers}\label{tab: husbandcompliers}\tabcolsep=0.07cm\begin{tabular}{lccccc}\toprule") ///
postfoot("\bottomrule\end{tabular}\end{center}\footnotesize{Notes: Among 701 women who received a counseling session, 401 women were assigned to the partner invitation group, among which 112 male partners participated. Variable definitions are presented in Table \ref{tab: variable_descriptions}. *** 1\%, ** 5\%, * 10\%.}\end{table}")

* TABLE D3 -Selection between clinic visitors and non-clinic-visitors
************************************************************************************
eststo clear 
eststo all: quietly estpost summarize $DESCVARS if COUN__FV_1 == 1
eststo clinic_yes: quietly estpost summarize $DESCVARS if mergeCLI == 3 & COUN__FV_1 == 1
eststo clinic_no: quietly estpost summarize $DESCVARS if mergeCLI != 3 & COUN__FV_1 == 1
eststo clinic_diff: quietly estpost ttest $DESCVARS if COUN__FV_1 == 1, by(mergeCLI)
eststo coun207_diff_p: quietly estpost ttest $DESCVARS if COUN__FV_1 == 1, by(mergeCLI)

* Adding scalars of F-Test of join significance. 
eststo F_coun: reg mergeCLI $DESCVARS if COUN__FV_1 == 1
estadd scalar F_Obs = `e(N)': coun207_diff_p
testparm $DESCVARS
estadd scalar F_pvalue = r(p): coun207_diff_p

esttab all clinic_yes clinic_no clinic_diff coun207_diff_p using "$output\visit_clinic639.tex", booktabs fragment ///
label cells("mean(pattern(1 1 1 0 0) fmt(2)) b(star pattern(0 0 0 1 0) fmt(2)) p(pattern(0 0 0 0 1) fmt(2))") ///
mtitles("All" "Visited" "Did not visit" "Difference" "p-value") starlevels(* 0.1 ** 0.05 *** 0.01) ///
nonumbers replace collabels(none) compress style(tab) ///
stats(F_pvalue F_Obs, label("F-test of joint significance: p-value" "F-test: Number of observations" ) fmt( %9.3f  %9.0f )) ///
prehead("\begin{table}\begin{center}\caption{Who Visited the Clinic?}\label{tab: visitclinic}\tabcolsep=0.2cm\scalebox{0.75}{\begin{tabular}{lccccc}\toprule") ///
posthead("\midrule\textbf{Visited the Good Health Kauma Clinic?} \\\\[-1ex]") nogaps postfoot("\midrule")

	*========================= Any Clinc ==========================================
	eststo clear 
	eststo all: quietly estpost summarize $DESCVARS if (PHO_REC_1 == 1 | HOM_REC_1 == 1 | mergeCLI == 3) &  COUN__FV_1 == 1
	eststo any_clinic: quietly estpost summarize $DESCVARS if (PHO_REC_1 == 1 | HOM_REC_1 == 1 | mergeCLI == 3) &  COUN__FV_1 == 1 & anyClinic == 1
	eststo no_clinic: quietly estpost summarize $DESCVARS if (PHO_REC_1 == 1 | HOM_REC_1 == 1 | mergeCLI == 3) &  COUN__FV_1 == 1 & anyClinic == 0 
	eststo any_clinic_diff: quietly estpost ttest $DESCVARS if (PHO_REC_1 == 1 | HOM_REC_1 == 1 | mergeCLI == 3) &  COUN__FV_1 == 1, by(anyClinic)
	eststo anyClinic_diff_p: quietly estpost ttest $DESCVARS if (PHO_REC_1 == 1 | HOM_REC_1 == 1 | mergeCLI == 3) &  COUN__FV_1 == 1, by(anyClinic)

	* Adding scalars of F-Test of join significance. 
	eststo F_coun: reg anyClinic $DESCVARS if (PHO_REC_1 == 1 | HOM_REC_1 == 1 | mergeCLI == 3) &  COUN__FV_1 == 1
	estadd scalar F_Obs = `e(N)': anyClinic_diff_p
	testparm $DESCVARS
	estadd scalar F_pvalue = r(p): anyClinic_diff_p

	esttab all any_clinic no_clinic any_clinic_diff anyClinic_diff_p using "$output\visit_clinic639.tex", booktabs fragment ///
	label cells("mean(pattern(1 1 1 0 0) fmt(2)) b(star pattern(0 0 0 1 0) fmt(2)) p(pattern(0 0 0 0 1) fmt(2))") nomtitles ///
	nonumbers append collabels(none) compress style(tab) starlevels(* 0.1 ** 0.05 *** 0.01) ///
	stats(F_pvalue F_Obs, label("F-test of joint significance: p-value" "F-test: Number of observations" ) fmt( %9.3f  %9.0f )) ///
	posthead("\textbf{Visited Any Clinic?} \\\\[-1ex]") nogaps ///
	postfoot("\bottomrule\end{tabular}}\end{center}\footnotesize{Notes: Among the 782 women who were interviewed at the baseline, 701 women attended a counseling session, among whom 682 women received a follow-up interview either through phone surveys, home visit surveys, or clinic visit surveys. Variable definitions are presented in Table \ref{tab: variable_descriptions}. *** 1\%, ** 5\%, * 10\%.}\end{table}") nogaps

