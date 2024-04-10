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

esttab allsample attrited nonattrited difference using "$output\attritors_nonattritors_summstats.tex",  booktabs fragment ///
label cells("mean(pattern(1 1 1 0) fmt(2)) b(star pattern(0 0 0 1) fmt(2))") ///
replace collabels(none) compress style(tab) mtitles("All Women" "Non-Attritors" "Attritors" "Difference")  ///
prehead("\begin{table}\begin{center}\caption{Summary Statistics between Attritors and Non-Attritors}\label{tab: attritornonattritorcomp}\tabcolsep=0.2cm\scalebox{0.88}{\begin{tabular}{lcccc}\toprule") ///
posthead("\midrule\\ [-1ex]") nogaps ///
postfoot("\bottomrule\end{tabular}}\end{center}\footnotesize{Notes: Among 782 women who were interviewed at the baseline, 107 women attrited from the sample either at counseling or at the follow-up (through phone surveys, home surveys, or clinic visit surveys). Currently working refers to women’s work status at the baseline. First cohabitation age is the age at which women started to live with her (first) husband. Current FP method: Injectables / Implants represents the proportion of women who were using injectables / Implants at baseline among all current users of contraception. Weight to top attribute refers to the number of counters (out of 20 counters) the woman assigned to their top method attribute. Intention to switch methods is woman’s answer to the question: if you had the choice to switch to another method, would you like to switch? Husband support FP is defined from the question: on a scale of 1 to 5, with 1 being strongly supportive and 5 being strongly opposed, how do you believe your husband feels towards using family planning methods? This variable takes 1 if her husband was strongly supportive or supportive of contraceptive use, and 0 otherwise. Column (1) shows the summary statistics for all 782 women, column (2) for the 675 non-attritors in the final sample, column (3) for the 107 attritors from baseline during subsequent stages, and column (4) displays the difference between column (2) and column (3). *** 1\%, ** 5\%, * 10\%.}\end{table}") nogaps
