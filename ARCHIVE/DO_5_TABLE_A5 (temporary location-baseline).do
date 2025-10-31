***MALAWI Behavioral Biases Study
***DO FILE 5: TABLE A5

***KEXIN ZHANG
***OCTOBER 31, 2025

version 13

clear all

use "$data\MBBS_Analysis_data.dta"

******************************************************************************
***************** TABLE A2, COLUMN 1: Current Method *****************************************
************************************************************************		
		global baseline_curr_methods w1_w03_w3040 w1_w03_w3044 w1_w03_w3045 modern_methods304 traditional_methods304
		
		sum $baseline_curr_methods, separator(0)
		sum $baseline_curr_methods if w1_w03_w303 == 1, separator(0)
		
eststo baseline_curr_method: estpost summarize $baseline_curr_methods

******************************************************************************
***************** TABLE A2, COLUMN 2 & 3: Baseline Ideal Method *****************************************
************************************************************************
global baseline_ideal_method BL_Ideal_Method0 BL_Ideal_Method4 BL_Ideal_Method5 modern_methods_BLideal traditional_methods_BLideal							
eststo baseline_ideal_method: estpost summarize $baseline_ideal_method

eststo baseline_ideal_method112: estpost summarize $baseline_ideal_method if !mi(COUN__HUSB_1210)

******************************************************************************
***************** TABLE A2, COLUMN 4: Husband Ideal Method *****************************************
************************************************************************	
eststo husb_ideal_method: estpost summarize COUN__HUSB_1210 COUN__HUSB_1214 COUN__HUSB_1215 husb_ideal_other_modern husb_ideal_traditional

******************************************************************************
***************** TABLE A2, COLUMN 5: Husband Ideal Method *****************************************
************************************************************************

eststo BL_ideal_method_husbNo: estpost summarize $baseline_ideal_method if HUSB_T == 1 & (COUN__husb_cons == 0 | mi(COUN__husb_cons))

esttab baseline_curr_method baseline_ideal_method baseline_ideal_method112 husb_ideal_method baseline_ideal_method_husbNo using "$output\baseline_curr_method.tex", booktabs fragment ///
label cells("mean(pattern(1) fmt(2))") ///
replace collabels(none) compress style(tab) ///
mgroups("\makecell{Among all women}" "\makecell{Among women whose male partner \\ participated in the counseling session}" "\makecell{Among women shoe partner \\ did not participate}", pattern(1 0 1 0 1) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
mtitles("Current Method" "Woman Ideal" "Woman Ideal" "Husband Ideal" "Woman Ideal") ///
prehead("\begin{table}\begin{center} \caption{Distribution of Method Use and Stated Ideal Contraceptive Method at Baseline}\label{tab: baselineCurrIdealhusbIdeal}\tabcolsep=0.1cm\scalebox{0.8}{\begin{tabular}{lccccc}\toprule") ///
postfoot("\bottomrule\end{tabular}}\end{center}\footnotesize{Note: Column (1) shows the current method use at baseline among 777 women (679 current users + 98 non-users). Column (2) displays women's ideal method at baseline among 773 women (679 current users + 88 non-users who will pick up a method in the future + 6 non-users who will not pick up any method in the future). Column (3) presents the distribution of women's reported ideal contraceptive method among the 112 women whose husband participated in the counseling session. Column (4) presents the distribution of male partner's reported ideal contraceptive method among the 112 husbands who were present at the counseling session. Column (5) presents the distribution of male partner's reported ideal contraceptive method among the 289 husbands who were invited but who did not attend the counseling session.}\end{table}")
