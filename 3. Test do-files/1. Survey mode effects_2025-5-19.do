***MALAWI Behavioral Biases Study
***DO FILE - DO RESPONSES DIFFER ACROSS SURVEY MODES?(R2-C6)

***KEXIN  ZHANG
***MAY 19, 2025

use "E:\5. Malawi Behavioral Biases Study\Archive\ANALYSIS_BASE_RAND_CVF_PHO_HOM_CLI_ANALYSIS.dta", replace

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

* Identify those who participated in more than to modes
	gen home_phone_both = (HOME_REV_20 == 1 & PHO_REC_4 == 1) //3
	gen home_cli_both = (HOME_REV_20 == 1 & mergeCLI == 3) //9
	gen pho_cli_both = (PHO_REC_4 == 1 & mergeCLI == 3) //13

global common_vars var104C var105_inj var105_imp

* 1) Variable 1 - 104
sum CLIN_104C HOME_104 PHO_104
	gen var104C = CLIN_104C
	replace var104C = HOME_104 if mi(var104C)
	replace var104C = PHO_104 if mi(var104C)
	label var var104C "Currently use of FP (1 = yes)"

* 2) Variable 2 - 105 - 4
sum CLIN_1054 HOME_1054 PHO_1054
	gen var105_inj = CLIN_1054 
	replace var105_inj = HOME_1054 if mi(var105_inj)
	replace var105_inj = PHO_1054  if mi(var105_inj)
	label var var105_inj "Current FP method: Injectables"

* 3) Variable 3 - 105 - 5
sum CLIN_1055 HOME_1055 PHO_1055
	gen var105_imp = CLIN_1055
	replace var105_imp = HOME_1055 if mi(var105_imp)
	replace var105_imp = PHO_1055 if mi(var105_imp)
	label var var105_imp "Current FP method: Implants"

* 4) Variable 4 - 
	
gen mergeCLI_neg = -mergeCLI
gen HOME_REV_20_neg = HOME_REV_20
	
eststo clinic: estpost summarize $common_vars if mergeCLI == 3
eststo home: estpost summarize $common_vars if HOME_REV_20 ==1 & mergeCLI == 1
eststo phone: estpost summarize $common_vars if PHO_REC_4 == 1 & mergeCLI == 1 & HOME_REV_20 == 0
eststo cli_home: estpost ttest $common_vars if mergeCLI == 3 | HOME_REV_20 == 1, by(mergeCLI_neg)
eststo cli_phone: estpost ttest $common_vars if mergeCLI == 3 | (PHO_REC_4 == 1 & HOME_REV_20 == 0), by(mergeCLI_neg)
eststo home_phone: estpost ttest $common_vars if (HOME_REV_20 == 1 & mergeCLI == 1) | (PHO_REC_4 == 1 & mergeCLI == 1), by(HOME_REV_20_neg)

esttab clinic home phone cli_home cli_phone home_phone using "$output\survey_mode_summary_stats.tex",  booktabs fragment ///
label cells("mean(pattern(1 1 1 0 0 0) fmt(2)) b(star pattern(0 0 0 1 1 1) fmt(2))") ///
nonumbers replace collabels(none) compress style(tab) ///
mtitles("(1) Clinic" "(2) Home" "(3) Phone" "(1)-(2)" "(1)-(3)" "(2)-(3)")  ///
prehead("\begin{table}\begin{center}\caption{Summary Statistics by Survey Mode}\label{tab: surveymodesummstats}\tabcolsep=0.2cm\scalebox{0.67}{\begin{tabular}{lcccccc}\toprule") ///
posthead("\midrule") nogaps ///
postfoot("\bottomrule\end{tabular}}\end{center}\footnotesize{Notes: The first three columns are women's responses to the same question through clinic visit, home visit, and phone surveys, respectively. Columns (4)-(6) are the differences across different survey modes. *** 1\%, ** 5\%, * 10\%.}\end{table}") nogaps

