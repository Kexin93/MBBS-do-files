***MALAWI Behavioral Biases Study
***DO FILE 6: TABLE G5
***COMPARISON BETWEEN ATTRITORS AND NON-ATTRITORS

***KEXIN ZHANG
***NOVEMBER 15, 2023

version 13

clear all

use "$data\MBBS_Analysis_data.dta"

keep if w1_mergeRand == 3

global DESCVARS age tot_child wom_des_fam_size preprimary educ_primary ///
educ_second educ_higher wom_work cohab_age curr_use baseline_inj ///
baseline_implants top_attribute top_attribute_wgt want_to_switch husband_support

* 0) Attritors ITT - 107
eststo clear 
eststo allsample: quietly estpost summarize $DESCVARS 
eststo attrited: quietly estpost summarize $DESCVARS if attrited == 0
eststo nonattrited: quietly estpost summarize $DESCVARS if attrited == 1
eststo difference: quietly estpost ttest $DESCVARS, by(attrited)
eststo attrited_diff_p: quietly estpost ttest $DESCVARS, by(attrited)

	* Adding scalars of F-Test of join significance. 
	eststo F_coun: reg attrited $DESCVARS
	estadd scalar F_Obs = `e(N)': attrited_diff_p
	testparm $DESCVARS
	estadd scalar F_pvalue = r(p): attrited_diff_p

esttab allsample attrited nonattrited difference attrited_diff_p using "$output\attritors_nonattritors_summstats.tex",  booktabs fragment ///
label cells("mean(pattern(1 1 1 0 0) fmt(2)) b(star pattern(0 0 0 1 0) fmt(2)) p(pattern(0 0 0 0 1) fmt(2))") ///
replace collabels(none) compress style(tab) mtitles("All Women" "Non-Attritors" "Attritors" "Difference" "p-value")  ///
prehead("\begin{table}\begin{center}\caption{Summary Statistics between Attritors and Non-Attritors}\label{tab: attritornonattritorcomp}\tabcolsep=0.2cm\scalebox{0.88}{\begin{tabular}{lccccc}\toprule") ///
posthead("\midrule\\ [-1ex]") nogaps starlevels(* 0.1 ** 0.05 *** 0.01) ///
stats(F_pvalue F_Obs, label("F-test of joint significance: p-value" "F-test: Number of observations" ) fmt( %9.3f  %9.0f )) ///
postfoot("\bottomrule\end{tabular}}\end{center}\footnotesize{Notes: Among 782 women who were interviewed at the baseline, 107 women attrited from the sample either at counseling or at the follow-up (through phone surveys, home surveys, or clinic visit surveys). Column (1) shows the summary statistics for all 782 women, column (2) for the 675 non-attritors in the final sample, column (3) for the 107 attritors from baseline during subsequent stages, and column (4) displays the difference between column (2) and column (3). Variable definitions are presented in Table \ref{tab: variable_descriptions}. *** 1\%, ** 5\%, * 10\%.}\end{table}") nogaps
