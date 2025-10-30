***MALAWI Behavioral Biases Study
***DO FILE 1-1: TABLE 1

***KEXIN ZHANG
***NOVEMBER 15, 2023

clear all

use "$data\MBBS_Analysis_data.dta"

keep if w1_mergeRand == 3

global DESCVARS age tot_child wom_des_fam_size preprimary educ_primary educ_second educ_higher wom_work cohab_age curr_use baseline_inj baseline_implants top_attribute top_attribute_wgt want_to_switch husband_support prior_knowledge base_fup_span2

* Keep the 675 women that were available at follow-up
keep if w1_mergeRand == 3
keep if COUN__FV_1 == 1

* consent
	keep if PHO_REC_4 == 1 | HOME_REV_20 == 1 | mergeCLI == 3 //675

*==============================================================================
*=============================== TABLE 1 =======================================
*==============================================================================

* 1) Summary Statistics (Overall)
* 0) HUSBAND ITT
eststo allsample: quietly estpost summarize $DESCVARS 
eststo w_husb: quietly estpost summarize $DESCVARS if HUSB_T ==1
eststo wo_husb: quietly estpost summarize $DESCVARS if HUSB_T ==0
eststo husb_diff: quietly estpost ttest $DESCVARS, by(HUSB_T)
eststo husb_diff_p: quietly estpost ttest $DESCVARS, by(HUSB_T)

* Adding scalars of F-Test of join significance. 
eststo F_husb: reg HUSB_T $DESCVARS
estadd scalar F_Obs = r(N): allsample
testparm $DESCVARS
estadd scalar F_pvalue = r(p): husb_diff_p

esttab allsample w_husb wo_husb husb_diff husb_diff_p using "$output\summary_stats.tex",  booktabs fragment ///
label cells("mean(pattern(1 1 1 0 0) fmt(2)) b(star pattern(0 0 0 1 0) fmt(2)) p(pattern(0 0 0 0 1) fmt(2))") ///
stats(F_pvalue N, label("F-test of joint significance: p-value" "F-test: Number of observations" ) fmt( %9.3f  %9.0f )) ///
nonumbers replace collabels(none) compress style(tab) mtitles("All" "Yes" "No" "Difference" "p-value")  ///
prehead("\begin{table}[h!]\begin{center}\caption{Summary Statistics}\label{tab: husbandsummstats}\tabcolsep=0.2cm\scalebox{0.67}{\begin{tabular}{lccccc}\toprule") ///
posthead("\midrule\textbf{A. Partner Invitation Group} \\\\[-1ex]") nogaps postfoot("\midrule")


* 0) SHORT ITT
eststo clear 
eststo allsample: quietly estpost summarize $DESCVARS 
eststo short_gp: quietly estpost summarize $DESCVARS if SHORT_T == 1 
eststo long_gp: quietly estpost summarize $DESCVARS if SHORT_T == 0 
eststo short_diff: quietly estpost ttest $DESCVARS, by(SHORT_T)
eststo short_diff_p: quietly estpost ttest $DESCVARS, by(SHORT_T)

eststo F_short: reg SHORT_T $DESCVARS
estadd scalar F_Obs = r(N): allsample
testparm $DESCVARS
estadd scalar F_pvalue = r(p): short_diff_p

esttab allsample short_gp long_gp short_diff short_diff_p using "$output\summary_stats.tex",  booktabs fragment ///
label cells("mean(pattern(1 1 1 0 0) fmt(2)) b(star pattern(0 0 0 1 0) fmt(2)) p(pattern(0 0 0 0 1) fmt(2))") ///") nomtitles ///
stats(F_pvalue N, label("F-test of joint significance: p-value" "F-test: Number of observations" ) fmt( %9.3f  %9.0f )) ///
nonumbers append collabels(none) compress style(tab) ///
posthead("\textbf{B. Short, Tailored Counseling Group} \\\\[-1ex]") nogaps ///
postfoot("\bottomrule\end{tabular}}\end{center}\footnotesize{Notes: Variable definitions are presented in Table \ref{variable\_descriptions}. *** 1\%, ** 5\%, * 10\%.}\end{table}") nogaps
