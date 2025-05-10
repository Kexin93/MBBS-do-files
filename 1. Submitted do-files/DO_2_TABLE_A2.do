***MALAWI Behavioral Biases Study
***DO FILE 2: TABLE A2

***KEXIN ZHANG
***NOVEMBER 15, 2023

version 13

clear all

use "$data\MBBS_Analysis_data.dta"

******************************************************************************
***************** TABLE A2, COLUMN 1: Current Method *****************************************
************************************************************************		
		global baseline_curr_methods w1_w03_w3040 w1_w03_w3043 w1_w03_w3044 w1_w03_w3045 w1_w03_w3046 w1_w03_w3047 w1_w03_w30411 w1_w03_w30414 w1_w03_w30416
		
		sum $baseline_curr_methods, separator(0)
		sum $baseline_curr_methods if w1_w03_w303 == 1, separator(0)
		
eststo baseline_curr_method: estpost summarize $baseline_curr_methods

******************************************************************************
***************** TABLE A2, COLUMN 2 & 3: Baseline Ideal Method *****************************************
************************************************************************
global baseline_ideal_method BL_Ideal_Method0 BL_Ideal_Method1 BL_Ideal_Method3 BL_Ideal_Method4 ///
							BL_Ideal_Method5 BL_Ideal_Method6 BL_Ideal_Method7 BL_Ideal_Method11 ///
							BL_Ideal_Method14 BL_Ideal_Method15 BL_Ideal_Method16
							
eststo baseline_ideal_method: estpost summarize $baseline_ideal_method

eststo baseline_ideal_method112: estpost summarize $baseline_ideal_method if !mi(COUN__HUSB_1210)

******************************************************************************
***************** TABLE A2, COLUMN 4: Husband Ideal Method *****************************************
************************************************************************	
eststo husb_ideal_method: estpost summarize COUN__HUSB_1210 COUN__HUSB_1211 COUN__HUSB_1212 COUN__HUSB_1213 ///
				COUN__HUSB_1214 COUN__HUSB_1215 COUN__HUSB_1216 COUN__HUSB_1217 ///
				COUN__HUSB_12113 COUN__HUSB_12114 COUN__HUSB_12115 ///
				COUN__HUSB_12116

esttab baseline_curr_method baseline_ideal_method baseline_ideal_method112 husb_ideal_method using "$output\baseline_curr_method.tex", booktabs fragment ///
label cells("mean(pattern(1) fmt(2))") ///
replace collabels(none) compress style(tab) ///
mgroups("\makecell{Among all women}" "\makecell{Among women whose male partner \\ participated in the counseling session}", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
mtitles("Current Method" "Woman Ideal" "Woman Ideal" "Husband Ideal") ///
prehead("\begin{table}\begin{center} \caption{Distribution of Method Use and Stated Ideal Contraceptive Method at Baseline}\label{tab: baselineCurrIdealhusbIdeal}\tabcolsep=0.1cm\begin{tabular}{lcccc}\toprule") ///
postfoot("\bottomrule\end{tabular}\end{center}\footnotesize{Note: Column (1) shows the current method use at baseline among 777 women (679 current users + 98 non-users). Column (2) displays women's ideal method at baseline among 773 women (679 current users + 88 non-users who will pick up a method in the future + 6 non-users who will not pick up any method in the future). Column (3) presents the distribution of women's reported ideal contraceptive method among the 112 women whose husband participated in the counseling session. Column (4) presents the distribution of male partner's reported ideal contraceptive method among the 112 husbands who were present at the counseling session.}\end{table}")
