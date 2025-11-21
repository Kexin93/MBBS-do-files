***MALAWI Behavioral Biases Study
***DO FILE 2: TABLE A3
***DISTRIBUTION OF TOP ATTRIBUTE DESIRED BY WOMEN IN A CONTRACEPTIVE METHOD AT BASELINE

***KEXIN ZHANG
***NOVEMBER 21, 2025

version 13

clear all

use "$data\MBBS_Analysis_data.dta"

global top_attributes  w1_w03_attribute_11 w1_w03_attribute_17 w1_w03_attribute_14 w1_w03_attribute_15 w1_w03_attribute_16 w1_w03_attribute_115  w1_w03_attribute_112 w1_w03_attribute_111 w1_w03_attribute_113 w1_w03_attribute_13 w1_w03_attribute_114 w1_w03_attribute_120 w1_w03_attribute_110 w1_w03_attribute_19 w1_w03_attribute_117 w1_w03_attribute_18 w1_w03_attribute_121 w1_w03_attribute_119 w1_w03_attribute_12 w1_w03_attribute_196
						  
* ====================================================================================
* ======================= TABLE A3: Top Method Attribute Distribution ===============================
* ====================================================================================
eststo top_attribute: estpost summarize $top_attributes

esttab top_attribute using "$output\top_attribute_distribution_table.tex", booktabs fragment ///
label cells("mean(pattern(1) fmt(2))") ///
replace collabels(none) compress style(tab) nomtitles ///
prehead("\begin{table}\begin{center} \caption{Distribution of Top Attribute Desired in a Contraceptive Method at Baseline}\label{tab: topattribute}\tabcolsep=0.3cm\begin{tabular}{lc}\toprule") ///
postfoot("\bottomrule\end{tabular}\end{center}\footnotesize{Notes:  The distribution presented in Column (1) is based on women's responses to the question: ``In choosing a contraceptive method, what feature(s) would be most important to you?''. Column (2) presents the colored flipchart that women who were assigned to the short counseling session received based on their reported top attribute.}\end{table}")
