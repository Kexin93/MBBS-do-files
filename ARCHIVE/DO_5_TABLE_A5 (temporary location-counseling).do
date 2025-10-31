***MALAWI Behavioral Biases Study
***DO FILE 2: TABLE A2

***KEXIN ZHANG
***NOVEMBER 15, 2023

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

******************************************************************************
***************** TABLE A2, COLUMN 1: Current Method *****************************************
************************************************************************		
		global coun_curr_methods coun_curr_method_None coun_curr_method_inj coun_curr_method_implants coun_curr_method_modern coun_curr_method_traditional
		
		sum $coun_curr_methods, separator(0)
		sum $coun_curr_methods, separator(0)
		
eststo coun_curr_methods: estpost summarize $coun_curr_methods

******************************************************************************
***************** TABLE A2, COLUMN 2 & 3: Counseling Ideal Method *****************************************
************************************************************************
global precoun_ideal_method COUN_129_None COUN_129_inj COUN_129_implants COUN_129_modern COUN_129_traditional

eststo precoun_ideal_method112: estpost summarize $precoun_ideal_method if COUN__husb_cons == 1

eststo precoun_ideal_method289: estpost summarize $precoun_ideal_method if (COUN__husb_cons == 0 | mi(COUN__husb_cons))

******************************************************************************
***************** TABLE A2, COLUMN 4 &5: Husband Ideal Method *****************************************
************************************************************************

global postcoun_ideal_method COUN_303_None COUN_303_inj COUN_303_implants COUN_303_modern COUN_303_traditional

eststo postcoun_ideal_method112: estpost summarize $postcoun_ideal_method if COUN__husb_cons == 1

eststo postcoun_ideal_method289: estpost summarize $postcoun_ideal_method if HUSB_T == 1 & (COUN__husb_cons == 0 | mi(COUN__husb_cons))

******************************************************************************
***************** TABLE A2, COLUMN 6: Husband Ideal Method *****************************************
************************************************************************	
eststo husb_ideal_method: estpost summarize COUN__HUSB_1210 COUN__HUSB_1214 COUN__HUSB_1215 husb_ideal_other_modern husb_ideal_traditional

esttab precoun_ideal_method112 precoun_ideal_method289  postcoun_ideal_method112 postcoun_ideal_method289 husb_ideal_method coun_curr_methods using "$output\counseling_curr_method.tex", booktabs fragment ///
label cells("mean(pattern(1) fmt(2))") ///
replace collabels(none) compress style(tab) ///
mgroups("\makecell{Pre-counseling \\ stated preferred method}" "\makecell{Post-counseling \\ stated preferred method }" "\makecell{During counseling}", pattern(1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
mtitles("Husband attended" "Husband did not attend" "Husband attended" "Husband did not attend" "Husband preferred" "Current use") ///
prehead("\begin{table}\begin{center} \caption{Distribution of Method Use and Stated Ideal Contraceptive Method at Counseling}\label{tab: CounselingCurrIdealhusbIdeal}\tabcolsep=0.1cm\scalebox{0.6}{\begin{tabular}{lcccccc}\toprule") ///
postfoot("\bottomrule\end{tabular}}\end{center}\footnotesize{Note: Column (1) shows women's pre-counseling stated preferred method among the 106 women who were prompted with the option to invite their male partner and whose partner attended counseling. Column (2) displays women's pre-counseling stated preferred method among the 262 women who were prompted with the option to invite their partner but whose partner did not participate. Column (3) presents women's post-counseling stated preferred method among the 106 women who were prompted with the option to invite their male partner and whose partner attended counseling. Column (4) presents the distribution of women's post-counseling stated preferred method among the 262 women who were prompted with the option to invite their male partner but whose partner did not participate. Column (5) presents the distribution of male partner's stated preferred contraceptive method among the 106 husbands who were present at the counseling session. Column (6) presents the distribution of women's current contraceptive use at the counseling session.}\end{table}")
