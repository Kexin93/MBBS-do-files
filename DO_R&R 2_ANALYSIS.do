clear all

global data "E:\丢失文件\数据恢复\zkx\5. RUC\8. Spring 2024.2.19-7.30\1.1 MBBS\V2. Replication Package 2024.4.4\Archive"

global output "E:\丢失文件\数据恢复\zkx\5. RUC\8. Spring 2024.2.19-7.30\1.1 MBBS\Do-files by section\Results"

use "$data\ANALYSIS_BASE_RAND_CVF_PHO_HOM_CLI_ANALYSIS.dta"


********************************************************************************
**# DURATION - TIME SPAN
********************************************************************************
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
	count if COUN__HOME_REV_20==1 | COUN__WOM_ONLY_CONS == 1 // check how many women consent to participate, all 704 who did not move consent to participate in the study
	
	//Clinic visit Date
		capture drop CLIN_interviewdate
	/*Generate Clinic date*/ todate CLIN_101A, gen(CLIN_interviewdate) p(yyyymmdd)

		capture drop coun_clin_span
	gen coun_clin_span = CLIN_interviewdate - COUN_interviewdate
		sum coun_clin_span

	replace coun_fup_span = coun_clin_span if mi(coun_fup_span) & !mi(coun_clin_span)
		sum coun_fup_span if COUN__FV_1 == 1 

	* use FUP_date to subtract COUN__FV_DATE
	gen coun_fup_span2 = FUP_date - COUN_interviewdate
		sum coun_fup_span2 if COUN__FV_1 == 1 
