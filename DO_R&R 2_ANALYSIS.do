clear all

global data "E:\丢失文件\数据恢复\zkx\5. RUC\8. Spring 2024.2.19-7.30\1.1 MBBS\V2. Replication Package 2024.4.4\Archive"

global output "E:\丢失文件\数据恢复\zkx\5. RUC\8. Spring 2024.2.19-7.30\1.1 MBBS\Archive\Do-files by section\Results"

use "$data\ANALYSIS_BASE_RAND_CVF_PHO_HOM_CLI_ANALYSIS.dta"


**************************************************************
**# 1) DURATION - TIME SPAN
**************************************************************
* 1) BASELINE - FUP sessions
	tab dateofinterview
	
	/*Construct FUP dates*/
	format PHO_REC_DATE HOME_101A %20.0f //440 - at the very beginning, would record the date regardless of whether women consent or not
		capture drop PHO_interviewdate
	todate PHO_REC_DATE, gen(PHO_interviewdate) p(yyyymmdd) //440
		
		capture drop HOM_interviewdate
	todate HOME_101A, gen(HOM_interviewdate) p(yyyymmdd)

gen FUP_date_noCLI = PHO_interviewdate  //427 changed (out of 440)
		format FUP_date_noCLI %td //729
replace FUP_date_noCLI = HOM_interviewdate if (missing(FUP_date_noCLI) & !missing(HOM_interviewdate)) | (!missing(PHO_interviewdate) & !missing(HOM_interviewdate) & (HOM_interviewdate > PHO_interviewdate)) //244
	format FUP_date_noCLI

gen FUP_date = CLIN_start_date  //67
replace FUP_date = PHO_interviewdate if mi(FUP_date) & !mi(PHO_interviewdate) //427 changed (out of 440)
replace FUP_date = HOM_interviewdate if (missing(FUP_date) & !missing(HOM_interviewdate)) | (!missing(PHO_interviewdate) & !missing(HOM_interviewdate) & (HOM_interviewdate > PHO_interviewdate)) //244
	format FUP_date %td //729

* should not include clinic visits, which we cannot control
	capture drop base_fup_span
gen base_fup_span = FUP_date_noCLI - dateofinterview
	sum base_fup_span if base_fup_span > 0
		/*Check the single observation whose followup date is earlier than baseline date*/br dateofinterview FUP_date if base_fup_span < 0
		/*Correct the single followup date*/replace FUP_date_noCLI = date("12/3/19", "MDY", 2020) if year(FUP_date) == 2016
		/*0 respondent received both HOM and PHO and receive HOM first*/count if !missing(PHO_interviewdate) & !missing(HOM_interviewdate) & (HOM_interviewdate < PHO_interviewdate)
	capture drop base_fup_span
gen base_fup_span = FUP_date_noCLI - dateofinterview
	sum base_fup_span if base_fup_span > 0

// hist base_fup_span if base_fup_span >= 40, /*title("Average Time Span - Baseline and Endline")*/ xtitle("Number of Days") xlabel(60(30)249) fcolor(navy) graphregion(fcolor(white))
// 	graph export "baseline_fup_span.png", as(png) replace

		/*Correct the single followup date*/replace FUP_date = date("12/3/19", "MDY", 2020) if year(FUP_date) == 2016
gen base_fup_span_withCLIN = FUP_date - dateofinterview
	sum base_fup_span_withCLIN if base_fup_span_withCLIN > 0

* 2) Baseline - Counseling
	replace COUN__FV_DATE = subinstr(COUN__FV_DATE, "-", "",.)
	destring COUN__FV_DATE, replace
	format COUN__FV_DATE %20.0f
		capture drop COUN_interviewdate
	/*Generate Counseling date*/todate COUN__FV_DATE, gen(COUN_interviewdate) p(yyyymmdd)
	
	capture drop base_coun_span
gen base_coun_span = COUN_interviewdate - dateofinterview //769
	sum base_coun_span if COUN__FV_1==1 //700
	/*Check respondents whose duration between baseline and counseling is less than 2 months*/
// 	hist base_coun_span if COUN__FV_1 ==1, graphregion(fcolor(white)) xtitle("Number of Days") fcolor(navy)
// 		graph export "baseline_coun_span.png", as(png) replace
		
* 3) Counseling - Follow up
	capture drop coun_fup_span
gen coun_fup_span = FUP_date_noCLI - COUN_interviewdate
	sum coun_fup_span if COUN__FV_1 == 1 //679 - 59.31 (634 just for PHO and HOM)
	/*Check the negative number of counseling-fup span*/ br FUP_date COUN_interviewdate if coun_fup_span < 0
	/*Check observations with coun-fup span < 30, TWO people*/ br FUP_date coun_fup_span COUN_interviewdate mergeCLI CLIN_101A mergeHOM mergePHO COUN__FV_1 if coun_fup_span <= 30 & COUN__FV_1 == 1
		* one of the two persons whose duration between counseling and follow up sessions visited the clinic in one month
// hist coun_fup_span if COUN__FV_1 ==1 & (mergeHOM == 3 | mergePHO == 3) & mergeCLI == 1,  xtitle("Number of Days") fcolor(navy) xlabel(10(10)160) graphregion(fcolor(white))
// 	graph export "coun_fup_span.png", as(png) replace

	count if COUN__FV_1 ==1 
	*count if COUN__HOME_REV_20==1 | COUN__WOM_ONLY_CONS == 1 // check how many women consent to participate, all 704 who did not move consent to participate in the study
	
	//Clinic visit Date
		capture drop CLIN_interviewdate
	/*Generate Clinic date*/ todate CLIN_101A, gen(CLIN_interviewdate) p(yyyymmdd)

	*** use FUP date which prioritizes PHO_date, followed by later HOM_date, followed by CLIN_date who were not reached by phone/home visits
		capture drop coun_clin_span
	gen coun_clin_span = CLIN_interviewdate - COUN_interviewdate
		sum coun_clin_span

	replace coun_fup_span = coun_clin_span if mi(coun_fup_span) & !mi(coun_clin_span)
		sum coun_fup_span if COUN__FV_1 == 1 

	*** use FUP_date which prioritizes CLIN_date, followed by PHO_date, followed by later HOM_date to subtract COUN__FV_DATE
	gen coun_fup_span2 = FUP_date - COUN_interviewdate
		sum coun_fup_span2 if COUN__FV_1 == 1 

**# 2) Prior knowledge about contraception
sum w1_w03_w301*

egen prior_knowledge = rowtotal(w1_w03_w3011-w1_w03_w30116)

br w1_w03_w301* prior_knowledge if prior_knowledge != w1_w03_w3011 + w1_w03_w3012 + w1_w03_w3013 +w1_w03_w3014 +w1_w03_w3015 +w1_w03_w3016 +w1_w03_w3017 +w1_w03_w3018 +w1_w03_w3019 +w1_w03_w30110 +w1_w03_w30111 +w1_w03_w30112 +w1_w03_w30113 +w1_w03_w30114 +w1_w03_w30115 +w1_w03_w30116

sum prior_knowledge,d

	capture drop prior_knowledge_bi
gen prior_knowledge_bi = (prior_knowledge > 4) if !mi(prior_knowledge)
	ta prior_knowledge_bi
label var prior_knowledge "Prior knowledge about contraception"

global DESCVARS prior_knowledge

* Table 1
eststo allsample: quietly estpost summarize $DESCVARS 
eststo w_husb: quietly estpost summarize $DESCVARS if HUSB_T ==1
eststo wo_husb: quietly estpost summarize $DESCVARS if HUSB_T ==0
eststo husb_diff: quietly estpost ttest $DESCVARS, by(HUSB_T)

esttab allsample w_husb wo_husb husb_diff using "$output\summary_stats.tex",  booktabs fragment ///
label cells("mean(pattern(1 1 1 0) fmt(2)) b(star pattern(0 0 0 1) fmt(2))") ///
nonumbers replace collabels(none) compress style(tab) mtitles("All" "Yes" "No" "Difference")  ///
prehead("\begin{table}\begin{center}\caption{Summary Statistics}\label{tab: husbandsummstats}\tabcolsep=0.2cm\scalebox{0.75}{\begin{tabular}{lcccc}\toprule") ///
posthead("\midrule\textbf{A. Partner Invitation Group} \\\\[-1ex]") nogaps postfoot("\midrule")


* 0) SHORT ITT
eststo clear 
eststo allsample: quietly estpost summarize $DESCVARS 
eststo short_gp: quietly estpost summarize $DESCVARS if SHORT_T == 1 
eststo long_gp: quietly estpost summarize $DESCVARS if SHORT_T == 0 
eststo short_diff: quietly estpost ttest $DESCVARS, by(SHORT_T)

esttab allsample short_gp long_gp short_diff using "$output\summary_stats.tex",  booktabs fragment ///
label cells("mean(pattern(1 1 1 0) fmt(2)) b(star pattern(0 0 0 1) fmt(2))") nomtitles ///
nonumbers append collabels(none) compress style(tab) ///
posthead("\textbf{B. Short, Tailored Counseling Group} \\\\[-1ex]") nogaps ///
postfoot("\bottomrule\end{tabular}}\end{center}\footnotesize{Notes: Currently working refers to women's work status at the baseline. First cohabitation age is the age at which women started to live with her (first) husband. Current FP method: Injectables / Implants represents the proportion of women who were using injectables / Implants at baseline among all current users of contraception. Weight to top attribute refers to the number of counters (out of 20 counters) the woman assigned to their top method attribute. Intention to switch methods is woman's answer to the question: if you had the choice to switch to another method, would you like to switch? Husband support FP is defined from the question: on a scale of 1 to 5, with 1 being strongly supportive and 5 being strongly opposed, how do you believe your husband feels towards using family planning methods? This variable takes 1 if her husband was strongly supportive or supportive of contraceptive use, and 0 otherwise. *** 1\%, ** 5\%, * 10\%.}\end{table}") nogaps

global data "E:\丢失文件\数据恢复\zkx\5. RUC\8. Spring 2024.2.19-7.30\1.1 MBBS\V2. Replication Package 2024.4.4"

global output "E:\丢失文件\数据恢复\zkx\5. RUC\8. Spring 2024.2.19-7.30\1.1 MBBS\V2. Replication Package 2024.4.4\Results"
**# 3) Non-users in the short group less likely to take up methods due to constraint of information?
version 13

use "$data\MBBS_Analysis_data.dta"

global balance_covariates "age_binary cont_use1 eff_attribute"

global covariates "age_binary cont_use1 eff_attribute i.w1_area"

global covariates1 "age_binary cont_use1 eff_attribute i.w1_area tot_child wom_work i.wom_educ ethnicity_Chewa"

* Drop pregnant women at counseling
	drop if COUN_118 == 1

* Drop pregnant women at FUP
	drop if PHO_103 == 1 | HOME_103 == 1 //638

********************************************************************************************************************
******************** Changing Ideal Methods from Counseling to Fup: which group is more likely afterwards? ***********************************
keep if w1_mergeRand == 3

	keep if COUN__FV_1 == 1

* consent
	keep if PHO_REC_4 == 1 | HOME_REV_20 == 1 | mergeCLI == 3 //675

	eststo clear
*=================================================================================
*===================================== TABLE 4 ===================================
*=================================================================================
preserve
keep if coun_curr_method == 0 
eststo clear
* Panel A
* Column 1
eststo: reg diff_method_2 SHORT_T prior_knowledge_bi c.SHORT_T#c.prior_knowledge_bi $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_2 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 2
eststo: reg diff_method_8 SHORT_T prior_knowledge_bi c.SHORT_T#c.prior_knowledge_bi $covariates1 if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust) 
summarize diff_method_8 if SHORT_T == 0  & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)

* Column 3
eststo: reg diff_method_17 SHORT_T prior_knowledge_bi c.SHORT_T#c.prior_knowledge_bi $covariates1, vce(robust) 
summarize diff_method_17 if SHORT_T == 0 
estadd scalar ymean = r(mean)

* Panel B
* Column 1
eststo: reg diff_method_9 SHORT_T prior_knowledge_bi c.SHORT_T#c.prior_knowledge_bi $covariates1, vce(robust) 
summarize diff_method_9 if SHORT_T == 0
estadd scalar ymean = r(mean)

* Column 2
eststo: reg diff_method_5 SHORT_T prior_knowledge_bi c.SHORT_T#c.prior_knowledge_bi $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_5 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 3
eststo: reg diff_method_16 SHORT_T prior_knowledge_bi c.SHORT_T#c.prior_knowledge_bi $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_16 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 4
eststo: reg diff_method_12 SHORT_T prior_knowledge_bi c.SHORT_T#c.prior_knowledge_bi $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_12 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

esttab est1 est2 est3 using  "$output\allwomen_short_ITT_nonusersByPK.tex", replace fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T c.SHORT_T#c.prior_knowledge_bi) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Pre-Counseling and \\ Post-Counseling}" "\makecell{Counseling and \\ Follow-Up}" "\makecell{Counseling and \\ Follow-Up (Adoption)}" "") ///
mgroups("\makecell{Change to Stated Ideal Method \\ Between...}" "\makecell{Change in Method Use \\ Between...}", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\begin{table}\begin{center}\caption{Treatment Effect of the Short Counseling Intervention by Prior Knowledge, among Non-Users of Contraception}\label{tab: allwomenshortITTnonusersbyPK}\tabcolsep=0.1cm\scalebox{0.77}{\begin{tabular}{lcccc}\toprule\multicolumn{5}{c}{\textbf{A. Stated Ideal Method and Method Use}}\\\midrule") ///
postfoot("\bottomrule") nogaps

esttab est4 est5 est6 est7 using  "$output\allwomen_short_ITT_nonusersByPK.tex", append fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T c.SHORT_T#c.prior_knowledge_bi) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Stated Ideal Method \\after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}" "\makecell{Stated Ideal Method \\ after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}") ///
mgroups("\makecell{Whether Method Use at FUP \\ is Discordant with...}" "\makecell{Whether Method Use at Counseling \\ is Discordant with...}", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\multicolumn{5}{c}{\textbf{B. Discordance}}\\\midrule ") ///
postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Other baseline covariates include: her total number of children, educational attainment (primary, secondary, higher), work status (1 = working), and ethnicity (1 = Chewa). Area fixed effects are included in all specifications. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps
restore

*=================================================================================
*===================================== TABLE 5 ===================================
*=================================================================================

preserve
keep if coun_curr_method > 0 & !mi(coun_curr_method)
	eststo clear
* Panel A
* Column 1
eststo: reg diff_method_2 SHORT_T prior_knowledge_bi c.SHORT_T#c.prior_knowledge_bi $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_2 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 2
eststo: reg diff_method_8 SHORT_T prior_knowledge_bi c.SHORT_T#c.prior_knowledge_bi $covariates1 if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust) 
summarize diff_method_8 if SHORT_T == 0  & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)

* Column 3
eststo: reg diff_method_18 SHORT_T prior_knowledge_bi c.SHORT_T#c.prior_knowledge_bi $covariates1, vce(robust) 
summarize diff_method_18 if SHORT_T == 0 
estadd scalar ymean = r(mean)

* Column 4
eststo: reg diff_method_20 SHORT_T prior_knowledge_bi c.SHORT_T#c.prior_knowledge_bi $covariates1, vce(robust) 
summarize diff_method_20 if SHORT_T == 0 
estadd scalar ymean = r(mean)

* Panel B
* Column 1
eststo: reg diff_method_9 SHORT_T prior_knowledge_bi c.SHORT_T#c.prior_knowledge_bi $covariates1, vce(robust) 
summarize diff_method_9 if SHORT_T == 0
estadd scalar ymean = r(mean)

* Column 2
eststo: reg diff_method_5 SHORT_T prior_knowledge_bi c.SHORT_T#c.prior_knowledge_bi $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_5 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 3
eststo: reg diff_method_16 SHORT_T prior_knowledge_bi c.SHORT_T#c.prior_knowledge_bi $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_16 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 4
eststo: reg diff_method_12 SHORT_T prior_knowledge_bi c.SHORT_T#c.prior_knowledge_bi $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_12 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

esttab est1 est2 est3 est4 using  "$output\allwomen_short_ITT_currentusers.tex", replace fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Pre-Counseling and \\ Post-Counseling}" "\makecell{Counseling and \\ Follow-Up}" "\makecell{Counseling and \\ Follow-Up \\ (Switching)}" "\makecell{Counseling and \\ Follow-Up \\ (Discontinuation)}") ///
mgroups("\makecell{Change to Stated Ideal Method \\ Between...}" "\makecell{Change in Method Use \\ Between...}", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\begin{table}\begin{center}\caption{Treatment Effect of the Short Counseling Intervention, among Current Users of Contraception}\label{tab: allwomenshortITTusers}\tabcolsep=0.1cm\scalebox{0.77}{\begin{tabular}{lcccc}\toprule\multicolumn{5}{c}{\textbf{A. Stated Ideal Method and Method Use}}\\\midrule") ///
postfoot("\bottomrule") nogaps

esttab est5 est6 est7 est8 using  "$output\allwomen_short_ITT_currentusers.tex", append fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Stated Ideal Method \\after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}" "\makecell{Stated Ideal Method \\ after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}") ///
mgroups("\makecell{Whether Method Use at FUP \\ is Discordant with...}" "\makecell{Whether Method Use at Counseling \\ is Discordant with...}", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\multicolumn{5}{c}{\textbf{B. Discordance}}\\\midrule ") ///
postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Other baseline covariates include: her total number of children, educational attainment (primary, secondary, higher), work status (1 = working), and ethnicity (1 = Chewa). Area fixed effects are included in all specifications. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps
restore

global data "E:\丢失文件\数据恢复\zkx\5. RUC\8. Spring 2024.2.19-7.30\1.1 MBBS\V2. Replication Package 2024.4.4"

global output "E:\丢失文件\数据恢复\zkx\5. RUC\8. Spring 2024.2.19-7.30\1.1 MBBS\V2. Replication Package 2024.4.4\Results"

**# 4) Heterogeneity of the tailored counseling, by prior knowledge
version 13

use "$data\MBBS_Analysis_data.dta", replace

global balance_covariates "age_binary cont_use1 eff_attribute"

global covariates "age_binary cont_use1 eff_attribute i.w1_area"

global covariates1 "age_binary cont_use1 eff_attribute i.w1_area tot_child wom_work i.wom_educ ethnicity_Chewa"

* Drop pregnant women at counseling
	drop if COUN_118 == 1

* Drop pregnant women at FUP
	drop if PHO_103 == 1 | HOME_103 == 1 //638

keep if w1_mergeRand == 3

	keep if COUN__FV_1 == 1

* consent
	keep if PHO_REC_4 == 1 | HOME_REV_20 == 1 | mergeCLI == 3 //675

	eststo clear
	
* Column 1
eststo: reg diff_method_2 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_2 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 2
eststo: reg diff_method_8 SHORT_T $covariates1 if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust) 
summarize diff_method_8 if SHORT_T == 0  & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)

* Column 3
eststo: reg diff_method_21 SHORT_T $covariates1, vce(robust) 
summarize diff_method_21 if SHORT_T == 0 
estadd scalar ymean = r(mean)

* Column 4
eststo: reg diff_method_18 SHORT_T $covariates1, vce(robust) 
summarize diff_method_18 if SHORT_T == 0 
estadd scalar ymean = r(mean)

* Column 5
eststo: reg diff_method_20 SHORT_T $covariates1, vce(robust) 
summarize diff_method_20 if SHORT_T == 0 
estadd scalar ymean = r(mean)

* Panel B
* Column 1
eststo: reg diff_method_9 SHORT_T $covariates1, vce(robust) 
summarize diff_method_9 if SHORT_T == 0
estadd scalar ymean = r(mean)

* Column 2
eststo: reg diff_method_5 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_5 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 3
eststo: reg diff_method_16 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_16 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 4
eststo: reg diff_method_12 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_12 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

gen fup_ideal_inCoun = inlist(FUP_ideal_method, method1, method2, method3, method4, method5, method6, method7, method8, method9, method10, method11, method12) if !mi(FUP_ideal_method)
gen coun_use_inCoun = inlist(coun_curr_method, method1, method2, method3, method4, method5, method6, method7, method8, method9, method10, method11, method12) if !mi(coun_curr_method)
gen fup_use_inCoun = inlist(FUP_curr_method, method1, method2, method3, method4, method5, method6, method7, method8, method9, method10, method11, method12) if !mi(FUP_curr_method)
gen precoun_inCoun = inlist(COUN_129, method1, method2, method3, method4, method5, method6, method7, method8, method9, method10, method11, method12) if !mi(COUN_129)
gen postcoun_inCoun = inlist(COUN_3081, method1, method2, method3, method4, method5, method6, method7, method8, method9, method10, method11, method12) if !mi(COUN_3081)

reg fup_ideal_inCoun SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
reg coun_use_inCoun SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
reg fup_use_inCoun SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
reg precoun_inCoun SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
reg postcoun_inCoun SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 

gen fup_ideal_inPK = inlist(FUP_ideal_method, w1_w03_w3011, w1_w03_w3012, w1_w03_w3013, w1_w03_w3014, w1_w03_w3015, w1_w03_w3016, w1_w03_w3017, w1_w03_w3018, w1_w03_w3019, w1_w03_w30110, w1_w03_w30111, w1_w03_w30112, w1_w03_w30113, w1_w03_w30114, w1_w03_w30115, w1_w03_w30116) if !mi(FUP_ideal_method)
gen coun_use_inPK = inlist(coun_curr_method, w1_w03_w3011, w1_w03_w3012, w1_w03_w3013, w1_w03_w3014, w1_w03_w3015, w1_w03_w3016, w1_w03_w3017, w1_w03_w3018, w1_w03_w3019, w1_w03_w30110, w1_w03_w30111, w1_w03_w30112, w1_w03_w30113, w1_w03_w30114, w1_w03_w30115, w1_w03_w30116) if !mi(coun_curr_method)
gen fup_use_inPK = inlist(FUP_curr_method, w1_w03_w3011, w1_w03_w3012, w1_w03_w3013, w1_w03_w3014, w1_w03_w3015, w1_w03_w3016, w1_w03_w3017, w1_w03_w3018, w1_w03_w3019, w1_w03_w30110, w1_w03_w30111, w1_w03_w30112, w1_w03_w30113, w1_w03_w30114, w1_w03_w30115, w1_w03_w30116) if !mi(FUP_curr_method)
gen precoun_inPK = inlist(COUN_129, w1_w03_w3011, w1_w03_w3012, w1_w03_w3013, w1_w03_w3014, w1_w03_w3015, w1_w03_w3016, w1_w03_w3017, w1_w03_w3018, w1_w03_w3019, w1_w03_w30110, w1_w03_w30111, w1_w03_w30112, w1_w03_w30113, w1_w03_w30114, w1_w03_w30115, w1_w03_w30116) if !mi(COUN_129)
gen postcoun_inPK = inlist(COUN_3081, w1_w03_w3011, w1_w03_w3012, w1_w03_w3013, w1_w03_w3014, w1_w03_w3015, w1_w03_w3016, w1_w03_w3017, w1_w03_w3018, w1_w03_w3019, w1_w03_w30110, w1_w03_w30111, w1_w03_w30112, w1_w03_w30113, w1_w03_w30114, w1_w03_w30115, w1_w03_w30116) if !mi(COUN_3081)

reg fup_ideal_inPK SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
reg coun_use_inPK SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
reg fup_use_inPK SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
reg precoun_inPK SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
reg postcoun_inPK SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 

esttab est1 est2 est3 est4 est5 using  "$output\allwomen_short_ITT_lessPK.tex", replace fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T ) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Pre-Counseling and \\ Post-Counseling}" "\makecell{Counseling and \\ Follow-Up}" "\makecell{Counseling and \\ Follow-Up \\ (Adoption)}" "\makecell{Counseling and \\ Follow-Up \\ (Switching)}" "\makecell{Counseling and \\ Follow-Up \\ (Discontinuation)}") ///
mgroups("\makecell{Change to Stated Ideal Method \\ Between...}" "\makecell{Change in Method Use \\ Between...}", pattern(1 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\begin{table}\begin{center}\caption{Treatment effect of the Short Counseling Intervention, among Women who had Less Prior Knowledge about Contraception}\label{tab: allwomenshortITTLessPK}\tabcolsep=0.1cm\scalebox{0.68}{\begin{tabular}{lccccc}\toprule \multicolumn{6}{c}{\textbf{A. Stated Ideal Method and Method Use}}\\\midrule") ///
postfoot("\bottomrule") nogaps

esttab est6 est7 est8 est9 using  "$output\allwomen_short_ITT_lessPK.tex", append fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T ) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Stated Ideal Method \\after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}" "\makecell{Stated Ideal Method \\ after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}") ///
mgroups("\makecell{Whether Method Use at FUP \\ is Discordant with...}" "\makecell{Whether Method Use at Counseling \\ is Discordant with...}", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\multicolumn{6}{c}{\textbf{B. Discordance}}\\\midrule") ///
postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: The analysis is conducted among women who heard of no more than 4 contraceptive methods at baseline. Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Other baseline covariates include: her total number of children, educational attainment (primary, secondary, higher), work status (1 = working), and ethnicity (1 = Chewa). Area fixed effects are included in all specifications. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps

	
* ============================== Less Prior Knowledge ================================
preserve
keep if prior_knowledge_bi == 0
	eststo clear
* Column 1
eststo: reg diff_method_2 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_2 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 2
eststo: reg diff_method_8 SHORT_T $covariates1 if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust) 
summarize diff_method_8 if SHORT_T == 0  & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)

* Column 3
eststo: reg diff_method_21 SHORT_T $covariates1, vce(robust) 
summarize diff_method_21 if SHORT_T == 0 
estadd scalar ymean = r(mean)

* Column 4
eststo: reg diff_method_18 SHORT_T $covariates1, vce(robust) 
summarize diff_method_18 if SHORT_T == 0 
estadd scalar ymean = r(mean)

* Column 5
eststo: reg diff_method_20 SHORT_T $covariates1, vce(robust) 
summarize diff_method_20 if SHORT_T == 0 
estadd scalar ymean = r(mean)

* Panel B
* Column 1
eststo: reg diff_method_9 SHORT_T $covariates1, vce(robust) 
summarize diff_method_9 if SHORT_T == 0
estadd scalar ymean = r(mean)

* Column 2
eststo: reg diff_method_5 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_5 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 3
eststo: reg diff_method_16 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_16 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 4
eststo: reg diff_method_12 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_12 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

gen fup_ideal_inCoun = inlist(FUP_ideal_method, method1, method2, method3, method4, method5, method6, method7, method8, method9, method10, method11, method12)
gen coun_use_inCoun = inlist(coun_curr_method, method1, method2, method3, method4, method5, method6, method7, method8, method9, method10, method11, method12)
gen fup_use_inCoun = inlist(FUP_curr_method, method1, method2, method3, method4, method5, method6, method7, method8, method9, method10, method11, method12)
gen precoun_inCoun = inlist(COUN_129, method1, method2, method3, method4, method5, method6, method7, method8, method9, method10, method11, method12)
gen postcoun_inCoun = inlist(COUN_3081, method1, method2, method3, method4, method5, method6, method7, method8, method9, method10, method11, method12)

reg fup_ideal_inCoun SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
reg coun_use_inCoun SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
reg fup_use_inCoun SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
reg precoun_inCoun SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
reg postcoun_inCoun SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 

esttab est1 est2 est3 est4 est5 using  "$output\allwomen_short_ITT_lessPK.tex", replace fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T ) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Pre-Counseling and \\ Post-Counseling}" "\makecell{Counseling and \\ Follow-Up}" "\makecell{Counseling and \\ Follow-Up \\ (Adoption)}" "\makecell{Counseling and \\ Follow-Up \\ (Switching)}" "\makecell{Counseling and \\ Follow-Up \\ (Discontinuation)}") ///
mgroups("\makecell{Change to Stated Ideal Method \\ Between...}" "\makecell{Change in Method Use \\ Between...}", pattern(1 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\begin{table}\begin{center}\caption{Treatment effect of the Short Counseling Intervention, among Women who had Less Prior Knowledge about Contraception}\label{tab: allwomenshortITTLessPK}\tabcolsep=0.1cm\scalebox{0.68}{\begin{tabular}{lccccc}\toprule \multicolumn{6}{c}{\textbf{A. Stated Ideal Method and Method Use}}\\\midrule") ///
postfoot("\bottomrule") nogaps

esttab est6 est7 est8 est9 using  "$output\allwomen_short_ITT_lessPK.tex", append fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T ) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Stated Ideal Method \\after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}" "\makecell{Stated Ideal Method \\ after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}") ///
mgroups("\makecell{Whether Method Use at FUP \\ is Discordant with...}" "\makecell{Whether Method Use at Counseling \\ is Discordant with...}", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\multicolumn{6}{c}{\textbf{B. Discordance}}\\\midrule") ///
postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: The analysis is conducted among women who heard of no more than 4 contraceptive methods at baseline. Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Other baseline covariates include: her total number of children, educational attainment (primary, secondary, higher), work status (1 = working), and ethnicity (1 = Chewa). Area fixed effects are included in all specifications. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps
restore

* ============================== More Prior Knowledge ================================
preserve
keep if prior_knowledge_bi == 1
	eststo clear
* Column 1
eststo: reg diff_method_2 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_2 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 2
eststo: reg diff_method_8 SHORT_T $covariates1 if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust) 
summarize diff_method_8 if SHORT_T == 0  & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)

* Column 3
eststo: reg diff_method_21 SHORT_T $covariates1, vce(robust) 
summarize diff_method_21 if SHORT_T == 0 
estadd scalar ymean = r(mean)

* Column 4
eststo: reg diff_method_18 SHORT_T $covariates1, vce(robust) 
summarize diff_method_18 if SHORT_T == 0 
estadd scalar ymean = r(mean)

* Column 5
eststo: reg diff_method_20 SHORT_T $covariates1, vce(robust) 
summarize diff_method_20 if SHORT_T == 0 
estadd scalar ymean = r(mean)

* Panel B
* Column 1
eststo: reg diff_method_9 SHORT_T $covariates1, vce(robust) 
summarize diff_method_9 if SHORT_T == 0
estadd scalar ymean = r(mean)

* Column 2
eststo: reg diff_method_5 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_5 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 3
eststo: reg diff_method_16 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_16 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 4
eststo: reg diff_method_12 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_12 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

gen fup_ideal_inCoun = inlist(FUP_ideal_method, method1, method2, method3, method4, method5, method6, method7, method8, method9, method10, method11, method12)
gen coun_use_inCoun = inlist(coun_curr_method, method1, method2, method3, method4, method5, method6, method7, method8, method9, method10, method11, method12)
gen fup_use_inCoun = inlist(FUP_curr_method, method1, method2, method3, method4, method5, method6, method7, method8, method9, method10, method11, method12)
gen precoun_inCoun = inlist(COUN_129, method1, method2, method3, method4, method5, method6, method7, method8, method9, method10, method11, method12)
gen postcoun_inCoun = inlist(COUN_3081, method1, method2, method3, method4, method5, method6, method7, method8, method9, method10, method11, method12)

reg fup_ideal_inCoun SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
reg coun_use_inCoun SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
reg fup_use_inCoun SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
reg precoun_inCoun SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
reg postcoun_inCoun SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 

esttab est1 est2 est3 est4 est5 using  "$output\allwomen_short_ITT_MorePK.tex", replace fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T ) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Pre-Counseling and \\ Post-Counseling}" "\makecell{Counseling and \\ Follow-Up}" "\makecell{Counseling and \\ Follow-Up \\ (Adoption)}" "\makecell{Counseling and \\ Follow-Up \\ (Switching)}" "\makecell{Counseling and \\ Follow-Up \\ (Discontinuation)}") ///
mgroups("\makecell{Change to Stated Ideal Method \\ Between...}" "\makecell{Change in Method Use \\ Between...}", pattern(1 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\begin{table}\begin{center}\caption{Treatment effect of the Short Counseling Intervention, among Women who had More Prior Knowledge about Contraception}\label{tab: allwomenshortITTMorePK}\tabcolsep=0.1cm\scalebox{0.68}{\begin{tabular}{lccccc}\toprule\multicolumn{6}{c}{\textbf{A. Stated Ideal Method and Method Use}}\\\midrule") ///
postfoot("\bottomrule") nogaps

esttab est6 est7 est8 est9 using  "$output\allwomen_short_ITT_MorePK.tex", append fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T ) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Stated Ideal Method \\after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}" "\makecell{Stated Ideal Method \\ after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}") ///
mgroups("\makecell{Whether Method Use at FUP \\ is Discordant with...}" "\makecell{Whether Method Use at Counseling \\ is Discordant with...}", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\multicolumn{6}{c}{\textbf{B. Discordance}}\\\midrule") ///
postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: The analysis is conducted among women who heard of more than 4 contraceptive methods at baseline. Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Other baseline covariates include: her total number of children, educational attainment (primary, secondary, higher), work status (1 = working), and ethnicity (1 = Chewa). Area fixed effects are included in all specifications. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps
restore

**# 5) The Impact of Short Counseling by Number of Attributes
use "$data\MBBS_Analysis_data.dta", replace

global balance_covariates "age_binary cont_use1 eff_attribute"

global covariates "age_binary cont_use1 eff_attribute i.w1_area"

global covariates1 "age_binary cont_use1 eff_attribute i.w1_area tot_child wom_work i.wom_educ ethnicity_Chewa"

* Drop pregnant women at counseling
	drop if COUN_118 == 1

* Drop pregnant women at FUP
	drop if PHO_103 == 1 | HOME_103 == 1 //638

********************************************************************************************************************
******************** Changing Ideal Methods from Counseling to Fup: which group is more likely afterwards? ***********************************
********************************************************************************************************************
* Drop pregnant women at counseling
	drop if COUN_118 == 1

* Drop pregnant women at FUP
	drop if PHO_103 == 1 | HOME_103 == 1 //638

********************************************************************************************************************
******************** Changing Ideal Methods from Counseling to Fup: which group is more likely afterwards? ***********************************
	keep if w1_mergeRand == 3

	keep if COUN__FV_1 == 1

* consent
	keep if PHO_REC_4 == 1 | HOME_REV_20 == 1 | mergeCLI == 3 //675

ta top_attribute_wgt
* ============================== Woman Concordance between Methods and Top Attribute ================================
preserve
keep if top_attribute_wgt == 20
	eststo clear
* Column 1
eststo: reg diff_method_2 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_2 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 2
eststo: reg diff_method_8 SHORT_T $covariates1 if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust) 
summarize diff_method_8 if SHORT_T == 0  & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)

* Column 3
eststo: reg diff_method_21 SHORT_T $covariates1, vce(robust) 
summarize diff_method_21 if SHORT_T == 0 
estadd scalar ymean = r(mean)

* Column 4
eststo: reg diff_method_18 SHORT_T $covariates1, vce(robust) 
summarize diff_method_18 if SHORT_T == 0 
estadd scalar ymean = r(mean)

* Column 5
eststo: reg diff_method_20 SHORT_T $covariates1, vce(robust) 
summarize diff_method_20 if SHORT_T == 0 
estadd scalar ymean = r(mean)

* Panel B
* Column 1
eststo: reg diff_method_9 SHORT_T $covariates1, vce(robust) 
summarize diff_method_9 if SHORT_T == 0
estadd scalar ymean = r(mean)

* Column 2
eststo: reg diff_method_5 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_5 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 3
eststo: reg diff_method_16 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_16 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 4
eststo: reg diff_method_12 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_12 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

esttab est1 est2 est3 est4 est5 using  "$output\allwomen_short_ITT_1attribute.tex", replace fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Pre-Counseling and \\ Post-Counseling}" "\makecell{Counseling and \\ Follow-Up}" "\makecell{Counseling and \\ Follow-Up \\ (Adoption)}" "\makecell{Counseling and \\ Follow-Up \\ (Switching)}" "\makecell{Counseling and \\ Follow-Up \\ (Discontinuation)}") ///
mgroups("\makecell{Change to Stated Ideal Method \\ Between...}" "\makecell{Change in Method Use \\ Between...}", pattern(1 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\begin{table}\begin{center}\caption{Treatment Effect of the Short Counseling Intervention, among Women who Allocated all Weights to the Top Method Attribute}\label{tab: allwomenshortITT1attribute}\tabcolsep=0.1cm\scalebox{0.68}{\begin{tabular}{lccccc}\toprule\multicolumn{6}{c}{\textbf{A. Stated Ideal Method and Method Use}}\\\midrule") ///
postfoot("\bottomrule") nogaps

esttab est6 est7 est8 est9 using  "$output\allwomen_short_ITT_1attribute.tex", append fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Stated Ideal Method \\after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}" "\makecell{Stated Ideal Method \\ after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}") ///
mgroups("\makecell{Whether Method Use at FUP \\ is Discordant with...}" "\makecell{Whether Method Use at Counseling \\ is Discordant with...}", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\multicolumn{6}{c}{\textbf{B. Discordance}}\\\midrule ") ///
postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Other baseline covariates include: her total number of children, educational attainment (primary, secondary, higher), work status (1 = working), and ethnicity (1 = Chewa). Area fixed effects are included in all specifications. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps
restore

* ============================== Woman did not Want to Switch ================================
preserve
keep if top_attribute_wgt < 20
	eststo clear
* Column 1
eststo: reg diff_method_2 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_2 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 2
eststo: reg diff_method_8 SHORT_T $covariates1 if COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/, vce(robust) 
summarize diff_method_8 if SHORT_T == 0  & COUN__FV_1 == 1 /*& !mi(FUP_curr_method)*/
estadd scalar ymean = r(mean)

* Column 3
eststo: reg diff_method_21 SHORT_T $covariates1, vce(robust) 
summarize diff_method_21 if SHORT_T == 0 
estadd scalar ymean = r(mean)

* Column 4
eststo: reg diff_method_18 SHORT_T $covariates1, vce(robust) 
summarize diff_method_18 if SHORT_T == 0 
estadd scalar ymean = r(mean)

* Column 5
eststo: reg diff_method_20 SHORT_T $covariates1, vce(robust) 
summarize diff_method_20 if SHORT_T == 0 
estadd scalar ymean = r(mean)

* Panel B
* Column 1
eststo: reg diff_method_9 SHORT_T $covariates1, vce(robust) 
summarize diff_method_9 if SHORT_T == 0
estadd scalar ymean = r(mean)

* Column 2
eststo: reg diff_method_5 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_5 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 3
eststo: reg diff_method_16 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_16 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

* Column 4
eststo: reg diff_method_12 SHORT_T $covariates1 if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_12 if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

esttab est1 est2 est3 est4 est5 using  "$output\allwomen_short_ITT_moreattributes.tex", replace fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Pre-Counseling and \\ Post-Counseling}" "\makecell{Counseling and \\ Follow-Up}" "\makecell{Counseling and \\ Follow-Up \\ (Adoption)}" "\makecell{Counseling and \\ Follow-Up \\ (Switching)}" "\makecell{Counseling and \\ Follow-Up \\ (Discontinuation)}") ///
mgroups("\makecell{Change to Stated Ideal Method \\ Between...}" "\makecell{Change in Method Use \\ Between...}", pattern(1 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\begin{table}\begin{center}\caption{Treatment Effect of the Short Counseling Intervention, among Women who Allocated Weights to More Than One Method Attribute}\label{tab: allwomenshortITTDiscordance}\tabcolsep=0.1cm\scalebox{0.68}{\begin{tabular}{lccccc}\toprule\multicolumn{6}{c}{\textbf{A. Stated Ideal Method and Method Use}}\\\midrule") ///
postfoot("\bottomrule") nogaps

esttab est6 est7 est8 est9 using  "$output\allwomen_short_ITT_moreattributes.tex", append fragment label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(SHORT_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean")) ///
mtitles("\makecell{Stated Ideal Method \\after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}" "\makecell{Stated Ideal Method \\ after Counseling}" "\makecell{Stated Ideal Method \\ at FUP}") ///
mgroups("\makecell{Whether Method Use at FUP \\ is Discordant with...}" "\makecell{Whether Method Use at Counseling \\ is Discordant with...}", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
prehead("\multicolumn{6}{c}{\textbf{B. Discordance}}\\\midrule ") ///
postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Other baseline covariates include: her total number of children, educational attainment (primary, secondary, higher), work status (1 = working), and ethnicity (1 = Chewa). Area fixed effects are included in all specifications. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps
restore

**# 6) Husband participation
use "$data\ANALYSIS_BASE_RAND_CVF_PHO_HOM_CLI_ANALYSIS.dta", clear
********************************************************************************************************************
******************** Changing Ideal Methods from Counseling to Fup: which group is more likely afterwards? ***********************************
	keep if w1_mergeRand == 3

	keep if COUN__FV_1 == 1

gen not_available = (COUN__HUSB_209N1 ==1 | COUN__HUSB_209N4 == 1 | strpos(COUN__HUSB_209N_O, "busy")> 0 | strpos(COUN__HUSB_209N_O, "at work") > 0 | strpos(COUN__HUSB_209N_O, "sundays") > 0 | strpos(COUN__HUSB_209N_O, "builder") > 0 | strpos(COUN__HUSB_209N_O, "Mechanic") > 0 | strpos(COUN__HUSB_209N_O, "businessman") > 0 | strpos(COUN__HUSB_209N_O, "driver") > 0 | strpos(COUN__HUSB_209N_O, "willing to participate") > 0 | strpos(COUN__HUSB_209N_O, "home") > 0 | strpos(COUN__HUSB_209N_O, "south africa") > 0 | strpos(COUN__HUSB_209N_O, "business") > 0 | strpos(COUN__HUSB_209N_O, "sleeping") > 0 | strpos(COUN__HUSB_209N_O, "asalers") > 0 | strpos(COUN__HUSB_209N_O, "kasungu") > 0  | strpos(COUN__HUSB_209N_O, "job") > 0) if !mi(COUN__HUSB_209N1)

ta COUN__HUSB_209N3