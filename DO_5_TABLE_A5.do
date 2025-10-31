***MALAWI Behavioral Biases Study
***DO FILE 5: TABLE A5

***KEXIN ZHANG

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
***************** TABLE A2, COLUMN 1, 4, 6: Baseline Stated Preferred Method *****************************************
************************************************************************		
global baseline_ideal_method BL_Ideal_Method0 BL_Ideal_Method4 BL_Ideal_Method5 modern_methods_BLideal traditional_methods_BLideal							

eststo baseline_ideal_method112: estpost summarize $baseline_ideal_method if COUN__husb_cons == 1 //112

eststo baseline_ideal_method251: estpost summarize $baseline_ideal_method if HUSB_T == 1 & (COUN__husb_cons == 0 | mi(COUN__husb_cons))

eststo baseline_ideal_methodHusb0: estpost summarize $baseline_ideal_method if HUSB_T == 0 

******************************************************************************
***************** TABLE A2, COLUMN 2,5,7: Post-counseling stated preferred method ******************************
************************************************************************
global postcoun_ideal_method COUN_303_None COUN_303_inj COUN_303_implants COUN_303_modern COUN_303_traditional

eststo postcoun_ideal_method112: estpost summarize $postcoun_ideal_method if COUN__husb_cons == 1 //112

eststo postcoun_ideal_method251: estpost summarize $postcoun_ideal_method if HUSB_T == 1 & (COUN__husb_cons == 0 | mi(COUN__husb_cons))

eststo postcoun_ideal_methodHusb0: estpost summarize $postcoun_ideal_method if HUSB_T == 0 

******************************************************************************
***************** TABLE A2, COLUMN 3: Husband Ideal Method *****************************************
************************************************************************	
eststo husb_ideal_method: estpost summarize COUN__HUSB_1210 COUN__HUSB_1214 COUN__HUSB_1215 husb_ideal_other_modern husb_ideal_traditional 

******************************************************************************
***************** TABLE A2, COLUMN 8, 9, 10, 11: p-values *****************************************
************************************************************************	
eststo pvalue1: estpost ttest $baseline_ideal_method if HUSB_T == 1, by(HUSB_T_comp)

eststo pvalue2: estpost ttest $postcoun_ideal_method if HUSB_T == 1, by(HUSB_T_comp)

eststo pvalue3: estpost ttest $baseline_ideal_method if HUSB_T ==0 | (HUSB_T == 1 & HUSB_T_comp == 1), by(HUSB_T)

eststo pvalue4: estpost ttest $postcoun_ideal_method if HUSB_T == 0 | (HUSB_T == 1 & HUSB_T_comp == 1), by(HUSB_T)


esttab baseline_ideal_method112 postcoun_ideal_method112 husb_ideal_method baseline_ideal_method251 postcoun_ideal_method251 baseline_ideal_methodHusb0 postcoun_ideal_methodHusb0 pvalue1 pvalue2 pvalue3 pvalue4 using "$output\method_mix_comparison.tex", booktabs fragment ///
label cells("mean(pattern(1 1 1 1 1 1 1 0 0 0 0) fmt(2))  p(pattern(0 0 0 0 0 0 0 1 1 1 1) fmt(2))") ///
replace collabels(none) compress style(tab) ///
mgroups("\makecell{Among women \\ who had their \\ husband participlate}" "\makecell{Among women \\ who were prompted \\ but whose husband did not attend}" "\makecell{Among women \\ who were not prompted}" "\makecell{p-values}", pattern(1 0 0 1 0 1 0 1 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
posthead("\midrule\textbf{A. Stated Preferred Method} \\\\[-1ex]") ///
mtitles("BL preferred" "\makecell{Post-counseling \\ preferred}" "Husband preferred" "BL preferred" "\makecell{Post-counseling \\ preferred}" "BL preferred" "\makecell{Post-counseling \\ preferred}" "(1)-(4)" "(2)-(5)" "(1)-(6)" "(2)-(7)") ///
prehead("\begin{table}\begin{center} \caption{Distribution of Method Use and Stated Preferred Contraceptive Method }\label{tab: MethodMix}\tabcolsep=0.1cm\scalebox{0.57}{\begin{tabular}{lccccccccccc}\toprule") ///
postfoot("\midrule")

*Panel B
******************************************************************************
***************** TABLE A2, PANEL B, COLUMN 1, 3, 5 *****************************************
************************************************************************	
global baseline_curr_methods w1_w03_w3040 w1_w03_w3044 w1_w03_w3045 modern_methods304 traditional_methods304
		
eststo baseline_curr_method112: estpost summarize $baseline_curr_methods if COUN__husb_cons == 1 //112

eststo baseline_curr_method251: estpost summarize $baseline_curr_methods if HUSB_T == 1 & (COUN__husb_cons == 0 | mi(COUN__husb_cons))

eststo baseline_curr_methodHusb0: estpost summarize $baseline_curr_methods if HUSB_T == 0 

******************************************************************************
***************** TABLE A2, PANEL B, COLUMN 2, 4, 6 *****************************************
************************************************************************	
global coun_curr_methods coun_curr_method_None coun_curr_method_inj coun_curr_method_implants coun_curr_method_modern coun_curr_method_traditional
		
eststo coun_curr_methods112: estpost summarize $coun_curr_methods if COUN__husb_cons == 1 //112

eststo coun_curr_methods251: estpost summarize $coun_curr_methods if HUSB_T == 1 & (COUN__husb_cons == 0 | mi(COUN__husb_cons))

eststo coun_curr_methodsHusb0: estpost summarize $coun_curr_methods if HUSB_T == 0 

******************************************************************************
***************** TABLE A2, PANEL B, COLUMN 7, 8, 9, 10: p-values *****************************************
************************************************************************	
eststo pvalue1: estpost ttest $baseline_curr_methods if HUSB_T == 1, by(HUSB_T_comp)

eststo pvalue2: estpost ttest $postcoun_ideal_method if HUSB_T == 1, by(HUSB_T_comp)

eststo pvalue3: estpost ttest $baseline_curr_methods if HUSB_T ==0 | (HUSB_T == 1 & HUSB_T_comp == 1), by(HUSB_T)

eststo pvalue4: estpost ttest $postcoun_ideal_method if HUSB_T == 0 | (HUSB_T == 1 & HUSB_T_comp == 1), by(HUSB_T)

esttab baseline_curr_method112 coun_curr_methods112 baseline_curr_method251 coun_curr_methods251 baseline_curr_methodHusb0 coun_curr_methodsHusb0 pvalue1 pvalue2 pvalue3 pvalue4 using "$output\method_mix_comparison.tex", booktabs fragment ///
label cells("mean(pattern(1 1 1 1 1 1 0 0 0 0) fmt(2))  p(pattern(0 0 0 0 0 0 1 1 1 1) fmt(2))") ///
append collabels(none) compress style(tab) ///
posthead("\midrule\textbf{B. Current Method Use} \\\\[-1ex]") ///
mgroups("\makecell{Among women \\ who had their \\ husband participlate}" "\makecell{Among women \\ who were prompted \\ but whose husband did not attend}" "\makecell{Among women \\ who were not prompted}" "\makecell{p-values}", pattern(1 0 1 0 1 0 1 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
mtitles("Baseline" "Counseling" "Baseline" "Counseling" "Baseline" "Counseling" "(1)-(3)" "(2)-(4)" "(1)-(5)" "(2)-(6)") ///
postfoot("\bottomrule\end{tabular}}\end{center}\footnotesize{Note: Panel A presents women's stated preferred method at baseline and post-counseling stages. Panel B presents women's contraceptive use at the two stages. In Panel A, column (1) shows women's baseline stated preferred method among the 106 women who were prompted with the option to invite their male partner and who had their partner participate; column (2) displays women's post-counseling stated preferred method among the 106 women; column (3) presents the distribution of male partner's stated preferred contraceptive method; column (4) presents women's stated preferred method among the 262 women who were prompted with the option to invite their partner but whose partner did not participate; column (5) presents women's post-counseling stated preferred method among the 262 women; column (6) presents the distribution of women's stated preferred method at the baseline among the 270 women who were not prompted with the option to invite their male partner to counseling; column (7) presents the distribution of women's post-counseling stated preferrd method among the 270 women; columns (8)-(11) display the p-values for the differences between the columns that are specified in the column titles. In Panel B, columns (1), (3), (5) present women's baseline contraceptive method use among women who had their male partner participate, women who were prompted with the option to invite their husband but their male partner did not participate, and among women who were not prompted with the option, respectively; columns (2), (4), (6) display women's contraceptive use at the counseling stage for the three types of women specified above; columns (7)-(10) present the p-values for the difference between the columns that are specified in the respective column titles.'"}\end{table}) 

