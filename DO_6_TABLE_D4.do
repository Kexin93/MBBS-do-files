***MALAWI Behavioral Biases Study
***DO FILE 6: TABLE G4
***ATTRITORS BY TRATMENT STATUS

***KEXIN ZHANG
***NOVEMBER 15, 2023

version 13

clear all

use "$data\MBBS_Analysis_data.dta"

keep if w1_mergeRand == 3

* attritors from 782 to 675 - 107
keep if !(PHO_REC_4 == 1 | HOME_REV_20 == 1 | mergeCLI == 3) | COUN__FV_1 != 1

global DESCVARS age tot_child wom_des_fam_size preprimary educ_primary ///
educ_second educ_higher wom_work cohab_age curr_use baseline_inj ///
baseline_implants top_attribute top_attribute_wgt want_to_switch husband_support

******************** FUP CURRENT METHOD *****************************************
* 0) HUSBAND ITT
eststo allsample: quietly estpost summarize $DESCVARS 
eststo w_husb: quietly estpost summarize $DESCVARS if HUSB_T ==1
eststo wo_husb: quietly estpost summarize $DESCVARS if HUSB_T ==0
eststo husb_diff: quietly estpost ttest $DESCVARS, by(HUSB_T)

esttab allsample w_husb wo_husb husb_diff using "$output\attritors_summstats.tex",  booktabs fragment ///
label cells("mean(pattern(1 1 1 0) fmt(2)) b(star pattern(0 0 0 1) fmt(2))") ///
nonumbers replace collabels(none) compress style(tab) mtitles("All" "Yes" "No" "Difference")  ///
prehead("\begin{table}\begin{center}\caption{Summary Statistics of Attritors by Intervention Arms}\label{tab: attritorsselection}\tabcolsep=0.2cm\scalebox{0.72}{\begin{tabular}{lcccc}\toprule") ///
posthead("\midrule\textbf{A. Partner Invitation Group} \\\\[-1ex]") nogaps postfoot("\midrule")


* 0) SHORT ITT
eststo clear 
eststo allsample: quietly estpost summarize $DESCVARS 
eststo short_gp: quietly estpost summarize $DESCVARS if SHORT_T == 1 
eststo long_gp: quietly estpost summarize $DESCVARS if SHORT_T == 0 
eststo short_diff: quietly estpost ttest $DESCVARS, by(SHORT_T)

esttab allsample short_gp long_gp short_diff using "$output\attritors_summstats.tex",  booktabs fragment ///
label cells("mean(pattern(1 1 1 0) fmt(2)) b(star pattern(0 0 0 1) fmt(2))") nomtitles ///
nonumbers append collabels(none) compress style(tab) ///
posthead("\textbf{B. Short, Tailored Counseling Group} \\\\[-1ex]") nogaps ///
postfoot("\bottomrule\end{tabular}}\end{center}\footnotesize{Notes: Among 782 women who were interviewed at the baseline, 107 women attrited from the sample either at counseling or at the follow-up (through phone surveys, home surveys, or clinic visit surveys). Variable definitions are presented in Table \ref{tab: variable_descriptions}. *** 1\%, ** 5\%, * 10\%.}\end{table}") nogaps
