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

global common_vars var104C var105_inj var105_imp var108A var112A var121A var124_0 var124_moreOp var124A_toomuch var124A_justright var125_impt var125_notImpt var126_attitudePos var126_attitudeNeg var114A_hassle var114A_nohassle var114B_moralwrong var114B_notwrong var114C_notwork var114C_work var114D_womendecision var114D_mendecision var112B_early var112B_middle var112B_end var112C var112D var112E_1to2y var112E_2to3y var112E_morethan3yr var113A_gainweight var113A_nogainweight var113B_FPchangeMenstrual var113B_FPnotchangeMC var113C_pregAbaffected var113C_pregAbNotaff

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

* 4) Variable 4 - 111D
sum CLIN_111D PHO_108A HOM_108A
	gen var108A = CLIN_111D 
	replace var108A = HOM_108A if mi(var108A)
	replace var108A = PHO_108A if mi(var108A)
	label var var108A "Feel supported in using FP"

* 5) Variable 5 - 122A
sum CLIN_122A PHO_112A HOM_112A 
	gen var112A = CLIN_122A
	replace var112A = HOM_112A if mi(var112A)
	replace var112A = PHO_112A if mi(var112A)
	label var var112A "Pregnancy likelihood"

* 6) Variable 6 - 112A
sum CLIN_112A PHO_121A HOM_121A
	gen var121A = CLIN_112A
	replace var121A = HOM_121A if mi(var121A)
	replace var121A = PHO_121A if mi(var121A)
	label var var121A "Husband attitude toward FP"

* 7) Variable 7 - 124_0 
replace PHO_124_0 ="" if PHO_124_0 == "---"
destring PHO_124_0, replace
recode PHO_124_0 (99=.)
sum CLIN_115_0 HOM_124_0 PHO_124_0
	gen var124_0 = CLIN_115_0
	replace var124_0 = HOM_124_0 if mi(var124_0)
	replace var124_0 = PHO_124_0 if mi(var124_0)
	label var var124_0 "Satisfaction with counseling"

* 8) Variable 8 - 124
replace PHO_124 = "" if PHO_124 == "---"
replace HOME_124 = "" if HOME_124 == "---"
destring PHO_124 HOME_124, replace
recode PHO_124 HOME_124 (9=.)(88=.)
sum CLIN_115 PHO_124 HOME_124
	gen var124 = CLIN_115
	replace var124 = HOME_124 if mi(var124)
	replace var124 = PHO_124 if mi(var124)
	gen var124_moreOp = (var124 == 1) if !mi(var124)
	label var var124 "Change in options"
	label var var124_moreOp "More options"
	
* 9) Variable 9 - 124A
replace HOM_124A = "" if HOM_124A == "---"
replace PHO_124A = "" if PHO_124A == "---"
destring HOM_124A PHO_124A, replace
recode PHO_124A HOM_124A (9=.)
sum CLIN_115A HOM_124A PHO_124A
	gen var124A = CLIN_115A
	replace var124A = HOM_124A if mi(var124A)
	replace var124A = PHO_124A if mi(var124A)
	gen var124A_toomuch = (var124A == 1) if !mi(var124A)
	gen var124A_justright = (var124A == 2) if !mi(var124A)
	label var var124A "Amount of information"
	label var var124A_toomuch "Too much information"
	label var var124A_justright "Just right"

* 10) Variable 10 - 125
replace PHO_125 = "" if PHO_125 =="---"
replace HOME_125 = "" if HOME_125 == "---"
destring PHO_125 HOME_125, replace
recode PHO_125 HOME_125 (9=.)
sum CLIN_116 PHO_125 HOME_125
	gen var125 = CLIN_116
	replace var125 = HOME_125 if mi(var125)
	replace var125 = PHO_125 if mi(var125)
	gen var125_impt = (var125 <= 2) if !mi(var125)
	gen var125_notImpt = (var125 >=4) if !mi(var125)
	label var var125_impt "Counseling is important"
	label var var125_notImpt "Counseling is not important"

* 11) Variable 11 - 126
replace PHO_126 = "" if PHO_126 =="---"
replace HOME_126 = "" if HOME_126 == "---"
destring PHO_126 HOME_126, replace
recode PHO_126 HOME_126 (9=.)
sum CLIN_117 PHO_126 HOME_126
	gen var126 = CLIN_117
	replace var126 = HOME_126 if mi(var126)
	replace var126 = PHO_126 if mi(var126)
	gen var126_attitudePos = (var126 <= 2) if !mi(var126)
	gen var126_attitudeNeg = (var126 >=4) if !mi(var126)
	label var var126_attitudePos "Positively affected attitude"
	label var var126_attitudeNeg "Negatively affected attitude"

* 12) Variable 12 - 114A
sum CLIN_123D PHO_114A HOM_114A
	gen var114A = CLIN_123D
	replace var114A = HOM_114A if mi(var114A)
	replace var114A = PHO_114A if mi(var114A)
	gen var114A_hassle = (var114A <= 2) if !mi(var114A)
	gen var114A_nohassle = (var114A >= 4) if !mi(var114A)
	label var var114A_hassle "Too much of a hassle"
	label var var114A_nohassle "Not too much of a hassle"
	
* 13) Variable 13 - 114B
sum CLIN_123E HOM_114B PHO_114B
	gen var114B = CLIN_123E
	replace var114B = HOM_114B if mi(var114B)
	replace var114B = PHO_114B if mi(var114B)
	gen var114B_moralwrong = (var114B <= 2) if !mi(var114B)
	gen var114B_notwrong = (var114B >= 4) if !mi(var114B)
	label var var114B_moralwrong "Morally wrong"
	label var var114B_notwrong "Not morally wrong"
	
* 14) Variable 14 - 114C
sum CLIN_123F HOM_114C PHO_114C
	gen var114C = CLIN_123F
	replace var114C = HOM_114C if mi(var114C)
	replace var114C = PHO_114C if mi(var114C)
	gen var114C_notwork = (var114C <= 2) if !mi(var114C)
	gen var114C_work = (var114C >= 4) if !mi(var114C)
	label var var114C_notwork "FP does not work"
	label var var114C_work "FP works"

* 15) Variable 15 - 114D
sum CLIN_123G HOM_114D PHO_114D
	gen var114D = CLIN_123G
	replace var114D = HOM_114D if mi(var114D)
	replace var114D = PHO_114D if mi(var114D)
	gen var114D_womendecision = (var114D <= 2) if !mi(var114D)
	gen var114D_mendecision = (var114D >= 4) if !mi(var114D)
	label var var114D_womendecision "FP is women's decision"
	label var var114D_mendecision "FP is men's decision'"

* 16) Variable 16 - 112B
sum CLIN_122B HOM_112B PHO_112B
	gen var112B = CLIN_122B
	replace var112B = HOM_112B if mi(var112B)
	replace var112B = PHO_112B if mi(var112B)
	gen var112B_early = (var112B <= 2) if !mi(var112B)
	gen var112B_middle = (var112B == 3) if !mi(var112B)
	gen var112B_end = (var112B == 4) if !mi(var112B)
	label var var112B_early "Early in her period"
	label var var112B_middle "Middle of her period"
	label var var112B_end "End of her period"

* 17) Variable 17 - 112C
sum CLIN_122C HOM_112C PHO_112C
	gen var112C = CLIN_122C
	replace var112C = HOM_112C if mi(var112C)
	replace var112C = PHO_112C if mi(var112C)
	label var var112C "Breastfeeding not pregnant"
	
* 18) Variable 18 - 112D
sum CLIN_122D HOM_112D PHO_112D
	gen var112D = CLIN_122D
	replace var112D = HOM_112D if mi(var112D)
	replace var112D = PHO_112D if mi(var112D)
	label var var112D "#Months breastfeedin prevents pregnancy"

* 19) Variable 19 - 112E
sum CLIN_122E PHO_112E_1 HOM_112E_1 
	gen var112E_1 = CLIN_122E
	replace var112E_1 = HOM_112E_1 if mi(var112E_1)
	replace var112E_1 = PHO_112E_1 if mi(var112E_1)
	gen var112E_1to2y = (var112E_1 == 13) if !mi(var112E_1)
	gen var112E_2to3y = (var112E_1 == 14) if !mi(var112E_1)
	gen var112E_morethan3yr = (var112E_1 == 15) if !mi(var112E_1)
	label var var112E_1to2y "Spacing: 1-2 years"
	label var var112E_2to3y "Spacing: 2-3 years"
	label var var112E_morethan3yr "Spacing: 3+ years"
	
* 20) Variable 20 - 113A
sum CLIN_123A HOM_113A PHO_113A
	gen var113A = CLIN_123A
	replace var113A = HOM_113A if mi(var113A)
	replace var113A = PHO_113A if mi(var113A)
	gen var113A_gainweight = (var113A >= 4) if !mi(var113A)
	gen var113A_nogainweight = (var114A <= 2) if !mi(var113A)
	label var var113A_gainweight "Gain weight from FP"
	label var var113A_nogainweight "Won't gain weight from FP'"
	
* 21) Variable 21 - 113B
sum CLIN_123B HOM_113B PHO_113B
	gen var113B = CLIN_123B
	replace var113B = HOM_113B if mi(var113B)
	replace var113B = PHO_113B if mi(var113B)
	gen var113B_FPchangeMenstrual = (var113B >= 4) if !mi(var113B)
	gen var113B_FPnotchangeMC = (var113B <= 2) if !mi(var113B)
	label var var113B_FPchangeMenstrual "FP changed menstrual cycle"
	label var var113B_FPnotchangeMC "FP won't change menstrual cycle'"
	
* 22) Variable 22 - 113C
sum CLIN_123C HOM_113C PHO_113C 
	gen var113C = CLIN_123C
	replace var113C = HOM_113C if mi(var113C)
	replace var113C = PHO_113C if mi(var113C)
	gen var113C_pregAbaffected = (var113C >= 4) if !mi(var113C)
	gen var113C_pregAbNotaff = (var113C <= 2) if !mi(var113C)
	label var var113C_pregAbaffected "FP affected pregnancy ability"
	label var var113C_pregAbNotaff "FP won't affect pregnancy ability'"
	
gen mergeCLI_neg = -mergeCLI
gen HOME_REV_20_neg = -HOME_REV_20
	
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

