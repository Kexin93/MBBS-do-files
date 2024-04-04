clear all

global data "E:\丢失文件\数据恢复\zkx\5. RUC\8. Spring 2024.2.19-7.30\1.1 MBBS\V2. Replication Package 2024.4.4\Archive"

global output "E:\丢失文件\数据恢复\zkx\5. RUC\8. Spring 2024.2.19-7.30\1.1 MBBS\Archive\Do-files by section\Results"

use "$data\ANALYSIS_BASE_RAND_CVF_PHO_HOM_CLI_ANALYSIS.dta"


**************************************************************
**# DURATION - TIME SPAN
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

**# 3) 112 women and partners - preferences