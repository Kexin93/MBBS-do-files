***MALAWI Behavioral Biases Study
***DO FILE 1-1: TABLE 1

***KEXIN ZHANG
***NOVEMBER 15, 2023

clear all

use "$data\MBBS_Analysis_data.dta"

keep if w1_mergeRand == 3

global DESCVARS age tot_child wom_des_fam_size preprimary educ_primary educ_second educ_higher wom_work cohab_age curr_use baseline_inj baseline_implants top_attribute top_attribute_wgt want_to_switch husband_support

*==============================================================================
*=============================== TABLE 1 =======================================
*==============================================================================

* 1) Summary Statistics (Overall)
* 0) HUSBAND ITT
eststo allsample: quietly estpost summarize $DESCVARS 
eststo w_husb: quietly estpost summarize $DESCVARS if HUSB_T ==1
eststo wo_husb: quietly estpost summarize $DESCVARS if HUSB_T ==0
eststo husb_diff: quietly estpost ttest $DESCVARS, by(HUSB_T)

esttab allsample w_husb wo_husb husb_diff using "$output\summary_stats.tex",  booktabs fragment ///
label cells("mean(pattern(1 1 1 0) fmt(2)) b(star pattern(0 0 0 1) fmt(2))") ///
nonumbers replace collabels(none) compress style(tab) mtitles("All" "Yes" "No" "Difference")  ///
prehead("\begin{table}\begin{center}\caption{Summary Statistics}\label{tab: husbandsummstats}\tabcolsep=0.2cm\scalebox{0.75}{\begin{tabular}{lcccc}\toprule") ///
posthead("\midrule\textbf{A. Partner Invitation Group} \\\\[-1ex]") nogaps postfoot("\midrule")


* 0) SHORT ITT
eststo clear 
eststo allsample: quietly estpost summarize $DESCVARS 
eststo short_gp: quietly estpost summarize $DESCVARS if SHORT_T == 1 
eststo long_gp: quietly estpost summarize $DESCVARS if SHORT_T == 0 
eststo short_diff: quietly estpost ttest $DESCVARS, by(SHORT_T)

esttab allsample short_gp long_gp short_diff using "$output\summary_stats.tex",  booktabs fragment ///
label cells("mean(pattern(1 1 1 0) fmt(2)) b(star pattern(0 0 0 1) fmt(2))") nomtitles ///
nonumbers append collabels(none) compress style(tab) ///
posthead("\textbf{B. Short, Tailored Counseling Group} \\\\[-1ex]") nogaps ///
postfoot("\bottomrule\end{tabular}}\end{center}\footnotesize{Notes: Currently working refers to women’s work status at the baseline. First cohabitation age is the age at which women started to live with her (first) husband. Current FP method: Injectables / Implants represents the proportion of women who were using injectables / Implants at baseline among all current users of contraception. Weight to top attribute refers to the number of counters (out of 20 counters) the woman assigned to their top method attribute. Intention to switch methods is woman’s answer to the question: if you had the choice to switch to another method, would you like to switch? Husband support FP is defined from the question: on a scale of 1 to 5, with 1 being strongly supportive and 5 being strongly opposed, how do you believe your husband feels towards using family planning methods? This variable takes 1 if her husband was strongly supportive or supportive of contraceptive use, and 0 otherwise. *** 1\%, ** 5\%, * 10\%.}\end{table}") nogaps
