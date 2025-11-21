***MALAWI Behavioral Biases Study
***TABLE A5
***KEXIN ZHANG
***November 21, 2025

version 13
clear all

use "$data\MBBS_Analysis_data.dta"

global balance_covariates "age_binary cont_use1 eff_attribute"
		
*==============================================================================
*================== Keep the final analytical sample of 638 women ==============
*==============================================================================
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


esttab baseline_ideal_method112 postcoun_ideal_method112 husb_ideal_method baseline_ideal_method251 postcoun_ideal_method251 baseline_ideal_methodHusb0 postcoun_ideal_methodHusb0 pvalue1 pvalue2 pvalue3 pvalue4 using "$output\method_mix_comparison_Preferred.tex", booktabs fragment ///
label cells("mean(pattern(1 1 1 1 1 1 1 0 0 0 0) fmt(2))  p(pattern(0 0 0 0 0 0 0 1 1 1 1) fmt(2))") ///
replace collabels(none) compress style(tab) ///
mgroups("\makecell{Among women \\ who had their \\ husband participlate}" "\makecell{Among women \\ who were prompted \\ but whose husband did not attend}" "\makecell{Among women \\ who were not prompted}" "\makecell{p-values}", pattern(1 0 0 1 0 1 0 1 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
posthead("\midrule") ///
mtitles("BL preferred" "\makecell{Post-counseling \\ preferred}" "Husband preferred" "BL preferred" "\makecell{Post-counseling \\ preferred}" "BL preferred" "\makecell{Post-counseling \\ preferred}" "(1)-(4)" "(2)-(5)" "(1)-(6)" "(2)-(7)") ///
prehead("\begin{table}\begin{center} \caption{Distribution of Method Use and Stated Preferred Contraceptive Method }\label{tab: MethodMix}\tabcolsep=0.1cm\scalebox{0.57}{\begin{tabular}{lccccccccccc}\toprule") ///
postfoot("\bottomrule\end{tabular}}\end{center}\footnotesize{Note: Column (1) shows women's baseline stated preferred method among the 106 women who were prompted with the option to invite their male partner and who had their partner participate; column (2) displays women's post-counseling stated preferred method among the 106 women; column (3) presents the distribution of male partner's stated preferred contraceptive method; column (4) presents women's stated preferred method among the 262 women who were prompted with the option to invite their partner but whose partner did not participate; column (5) presents women's post-counseling stated preferred method among the 262 women; column (6) presents the distribution of women's stated preferred method at the baseline among the 270 women who were not prompted with the option to invite their male partner to counseling; column (7) presents the distribution of women's post-counseling stated preferrd method among the 270 women; columns (8)-(11) display the p-values for the differences between the columns that are specified in the column titles. "}\end{table}) 