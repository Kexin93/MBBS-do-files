***MALAWI Behavioral Biases Study
***DO FILE (NOT TO BE SUBMITTED): ONLY KEEP THE VARIABLES THAT ARE NEEDED
***INPUTS: ANALYSIS_BASE_RAND_CVF_PHO_HOM_CLI_ANALYSIS.dta
***OUTPUTS: MBBS_Analysis_data.dta

***KEXIN ZHANG
***NOVEMBER 15, 2023

clear all

version 13
clear all

if "`c(username)'"=="Kexin Zhang" {
global data "E:\5. Malawi Behavioral Biases Study"
global dofile "$data\GitHub\MBBS-do-files"
global output "$data\Results\2025-6-14"

use "$data\Archive\ANALYSIS_BASE_RAND_CVF_PHO_HOM_CLI_ANALYSIS.dta"
}

else if "`c(username)'"=="kexin" {
global data "C:\Users\kexin\Dropbox\MALAWI BEHAVIORAL BIASES STUDY\DATA"
global dofile "$data\DO FILES\ANALYSIS DO FILES\MBBS FORMAL DO FILES 6-15-25\MBBS-do-files"
global output "$data\RESULTS\6-15-25"

use "$data\MBBS FINAL DATA FOR ANALYSIS\DATA ALL STAGES\ANALYSIS_BASE_RAND_CVF_PHO_HOM_CLI_ANALYSIS.dta"
}

keep if w1_mergeRand == 3
drop *_form_number
drop *_formid

* Baseline-Follow-up time span creation
	tab dateofinterview
	format PHO_REC_DATE HOME_101A %20.0f //440 - at the very beginning, would record the date regardless of whether women consent or not
		capture drop PHO_interviewdate
	todate PHO_REC_DATE, gen(PHO_interviewdate) p(yyyymmdd) //440
		capture drop HOM_interviewdate
	todate HOME_101A, gen(HOM_interviewdate) p(yyyymmdd)

	capture drop FUP_date_noCLI 
gen FUP_date_noCLI = PHO_interviewdate  //427 changed (out of 440)
		format FUP_date_noCLI %td //729
replace FUP_date_noCLI = HOM_interviewdate if (missing(FUP_date_noCLI) & !missing(HOM_interviewdate)) | (!missing(PHO_interviewdate) & !missing(HOM_interviewdate) & (HOM_interviewdate > PHO_interviewdate)) //244
	format FUP_date_noCLI
	tab FUP_date_noCLI //684

gen FUP_date = CLIN_start_date  //67
replace FUP_date = PHO_interviewdate if mi(FUP_date) & !mi(PHO_interviewdate) //427 changed (out of 440)
replace FUP_date = HOM_interviewdate if (missing(FUP_date) & !missing(HOM_interviewdate)) | (!missing(PHO_interviewdate) & !missing(HOM_interviewdate) & (HOM_interviewdate > PHO_interviewdate)) //244
	format FUP_date %td //729
	tab FUP_date

* should not include clinic visits, which we cannot control
	capture drop base_fup_span
gen base_fup_span = FUP_date_noCLI - dateofinterview
	tab base_fup_span
	sum base_fup_span if base_fup_span > 0
		/*Check the single observation whose followup date is earlier than baseline date*/br dateofinterview FUP_date if base_fup_span < 0
		/*Correct the single followup date*/replace FUP_date_noCLI = date("12/3/19", "MDY", 2020) if year(FUP_date) == 2016
		/*0 respondent received both HOM and PHO and receive HOM first*/count if !missing(PHO_interviewdate) & !missing(HOM_interviewdate) & (HOM_interviewdate < PHO_interviewdate)
	capture drop base_fup_span
gen base_fup_span = FUP_date_noCLI - dateofinterview
	label var base_fup_span "\#Days b/w Baseline and Follow-up"
	tab base_fup_span
	sum base_fup_span
	
gen base_fup_span2 = FUP_date - dateofinterview
	label var base_fup_span2 "\#Days b/w Baseline and Follow-up"
	
	drop PHO_interviewdate HOM_interviewdate FUP_date_noCLI FUP_date

* Subgroup analysis variables
***INJECTABLE USE IN THE PAST 3 MONTHS - HETEROGENEITY FOR SHORT COUNSELING BY SHORT
gen inj_3_months = w1_w03_w308b < 4

***WANT TO SWITCH (USERS) OR ADOPT (NON-USERS) AT BASELINE - HETEROGENEITY FOR SHORT
gen want_switch_adopt = w1_w03_w331==1 | w1_w03_w338a==1

***TOLD ABOUT SIDE EFFECTS - HETEROGENEITY FOR SHORT
gen told_side_effects = w1_w03_w317==1 | w1_w03_w318==1

***DEFERRAL: DO NOT FOLLOW THROUGH WITH ADVICE
*gen deferral = w1_w10_w1012_1==1 | w1_w10_w1012_2==1 | w1_w10_w1012_3==1
gen deferral = w1_w10_w1012_3==1

***BASELINE ACCESS AND CHOICE: 325b-325d - MAJOR HETEROGENEITY HERE!!
gen access_choice = w1_w03_w325b==1 & w1_w03_w325c==1 & w1_w03_w325d==0

*** WOMEN's SATISFACTION WITH THEIR BL METHOD
gen women_satisfaction = w1_w07_w724c == 1 | w1_w07_w724c == 2

*** WOMEN's DISSATISFACTION WITH THEIR BL METHOD
gen women_dissatisfaction = w1_w07_w724c == 3 | w1_w07_w724c == 4 | w1_w07_w724c == 5

* Partner Invitation
**DISCUSSED WITH HUSBAND HOW MANY MORE CHILDREN YOU WANT
gen discuss_kids_husb = w1_w09_w916

**HUSBAND SUPPORTS FP
gen husb_supports_fp = w1_w09_w928==1

**WOMAN DECIDES CONTRACEPTIVE USE / NON-USE
gen cont_wom_decide = w1_w07_w718b < 3 | w1_w07_w718c < 3

** HUSBAND SATISFIED WITH BL CONTRACEPTIVE USE
gen husb_sat = w1_w07_w724d == 1 | w1_w07_w724d == 2

gen husb_dissat = w1_w07_w724d == 3 | w1_w07_w724d == 4 | w1_w07_w724d == 5

** Bargaining power
gen women_big_purchase = w1_w09_w901  == 1 | w1_w09_w901  == 2 if !mi(w1_w09_w901 )

gen women_child_edu = w1_w09_w902 == 1 | w1_w09_w902 ==2 if !mi(w1_w09_w902)

ta w1_w09_wom_work if mi(w1_w09_w903)
gen women_decide_her_m = w1_w09_w903 == 1 | w1_w09_w903 == 2 if !mi(w1_w09_w903)
replace women_decide_her_m = 0 if w1_w09_wom_work == 0
ta women_decide_her_m

ta w1_w09_wom_work if mi(w1_w09_w904)
gen women_earn_more = w1_w09_w904 == 1 | w1_w09_w904 == 3 if !mi(w1_w09_w904)
replace women_earn_more = 0 if w1_w09_wom_work == 0
ta women_earn_more

gen women_decide_husb_m = w1_w09_w905 == 1 | w1_w09_w905 == 2 if !mi(w1_w09_w905)

gen women_decide_health = w1_w09_w906 == 1 | w1_w09_w906 == 2 if !mi(w1_w09_w906)

gen women_decide_daily = w1_w09_w908 == 1 | w1_w09_w908 == 2 if !mi(w1_w09_w908)

gen women_decide_visits = w1_w09_w909 == 1 | w1_w09_w909 == 2 if !mi(w1_w09_w909)

gen women_own_money = w1_w09_w910a == 1 if !mi(w1_w09_w910a)

gen women_own_house_a =  w1_w09_w910b == 1 |  w1_w09_w910b == 3 if !mi(w1_w09_w910b)

gen women_own_land_a = w1_w09_w911 == 1 | w1_w09_w911 == 3 if !mi(w1_w09_w911)

* Disagreement with husband
* Husband wants more children
gen husb_want_more = w1_w07_w720  == 2 if !mi(w1_w07_w720)

* Discussed family planning
gen discussed_FP = w1_w09_w925 == 1 if !mi(w1_w09_w925)

* Registration
drop w1_reg_number w1_reg_fmid /*w1_reg_enumid_1*/ w1_reg_hhid_1

drop  w1_reg_hhid_6 w1_reg_hhid_conf_1 w1_reg_w_rec_1 w1_reg_w_rec_2 /// 
w1_reg_w_rec_conf1 w1_reg_w_rec_3 w1_reg_w_rec_4 w1_reg_w_consent_1 ///
w1_reg_w_consent_2 w1_reg_w_thumb_name w1_reg_w_thumb_pic w1_reg_w_thumb_dt ///
w1_reg_w_sign_name w1_reg_w_sign_sig w1_reg_w_sign_dt w1_reg_w_int_name ///
w1_reg_w_int_countersig w1_reg_w_int_dt w1_reg_hhid_7_2 w1_reg_hhid_7_3 ///
w1_reg_hhid_7_4 w1_reg_hhid_7_5 w1_reg_hhid_8 w1_reg_hhid_9latitudedegrees ///
w1_reg_hhid_9longitudedegrees w1_reg_hhid_9altitudemeters ///
w1_reg_hhid_9accuracymeters w1_reg_six_mths_ago w1_reg_sector w1_reg_enum_id ///
w1_reg_hhid_number w1_reg_cluster_number w1_reg_directions ///
w1_reg_close_case_condition w1_reg_area w1_reg_area_hh w1_reg_sector_hh ///
w1_reg_enum_name w1_reg_address w1_survey_id w1_reg_w_name w1_reg_completed_time ///
w1_reg_started_time w1_reg_username w1_reg_received_on w1_reg_form_link ///
 w1_reg_userid w1_reg_deviceid w1_reg_locationlatitudedegrees ///
 w1_reg_locationlongitudedegrees w1_reg_locationaltitudemeters ///
 w1_reg_locationaccuracymeters w1_reg_case_name w1_reg_dup

 
 * Household section HH1
drop  w1_hh1_number w1_hh1_survey_id_1 w1_hhsize num_guests w1_hh1_hr_3 w1_hh1_r_hr_1a_h ///
  w1_hh1_r_hr_1b_h w1_hh1_r_hr_1c_h w1_hh1_r_hr_2_h w1_head_gender head_reside ///
  w1_hh1_r_hr_6_h w1_hh1_r_hr_7a_1_h w1_hh1_r_hr_7a_2a_h w1_hh1_r_hr_7a_2b_y_h ///
  w1_hh1_r_hr_7a_2b_m_h head_marriage w1_hh1_wom_resp ever_attend ///
  head_edu head_edu_detail head_attend2 head_edu2 head_edu_detail2 ///
  w1_hh1_ew_hhh_conf_2 w1_hh1_r_hr_1a_w w1_hh1_r_hr_1b_w w1_hh1_r_hr_1c_w head_relation ///
  woman_reside w1_hh1_r_hr_6_w w1_hh1_r_hr_7a_1_w w1_hh1_r_hr_7a_2a_w ///
  w1_hh1_r_hr_7a_2b_y_w w1_hh1_r_hr_7a_2b_m_w w1_hh1_r_hr_7b_w woman_married ///
  woman_ever_attend woman_edu woman_edu_detail woman_attend2 woman_edu2 ///
  woman_edu_detail2 w1_hh1_ewh_hhh_conf w1_hh1_ewh_hhh_conf_2 w1_hh1_r_hr_1a_wh ///
  w1_hh1_r_hr_1b_wh head_relation_h husband_reside w1_hh1_r_hr_6_wh ///
  w1_hh1_r_hr_7a_1_wh w1_hh1_r_hr_7a_2a_wh w1_hh1_r_hr_7a_2b_y_wh w1_hh1_r_hr_7a_2b_m_wh ///
  w1_hh1_r_hr_7b_wh husband_ever_attend husband_edu husband_edu_detail husband_attend2 ///
  w1_hh1_counter_elig_wom_hhh w1_hh1_case_district w1_hh1_case_surveyid w1_hh1_case_surveywave ///
  w1_hh1_woman_marital_status w1_hh1_woman_husb_id w1_hh1_case_fmid ///
  w1_hh1_case_cluster_number w1_hh1_birth_year w1_hh1_ewh_id w1_hh1_woman_husb_name ///
  w1_hh1_woman_education_level w1_hh1_age_in_years_ew w1_hh1_age_in_years ///
  w1_hh1_woman_husb_household_role w1_hh1_hh_tot_no_hhh_ew  ///
  w1_hh1_hh_tot_no_hhh w1_hh1_woman_education_years w1_hh1_birth_month ///
  w1_hh1_woman_name w1_woman_lineno w1_woman_husb_education_level w1_hh1_case_enumid ///
  w1_hh1_hhh_lineno w1_hh1_hr_tot w1_hh1_calc_wom_elig_hhh w1_hh1_birth_year1 ///
  w1_hh1_birth_month1 w1_hh1_case_sector w1_hh1_ewh_full_name ///
  w1_hh1_woman_husb_lineno w1_hh1_ew_lineno w1_hh1_ew_full_name ///
  w1_hh1_case_area w1_hh1_woman_husb_marital_status w1_hh1_hhh_id w1_hh1_birth_month2 ///
  w1_hh1_birth_year2 w1_woman_husb_education_years w1_hh1_woman_household_role ///
  w1_hh1_hhh_full_name w1_hh1_ewh_lineno w1_hh1_woman_husb_age w1_woman_id w1_hh1_age_in_years_ewh ///
  w1_hh1_ew_id w1_hh1_case_hhid_number w1_hh1_completed_time w1_hh1_started_time ///
  w1_hh1_username w1_hh1_received_on w1_hh1_form_link w1_hh1_userid w1_hh1_deviceid ///
  w1_hh1_locationlatitudedegrees w1_hh1_locationlongitudedegrees w1_hh1_locationaltitudemeters ///
  w1_hh1_locationaccuracymeters w1_hh1_case_name male_over18 female_over18 ///
  female_under5 male_under5 male_6_17 female_6_17 w1_hh1_hr_mem_tot w1_hh1_cluster_caseid ///
  w1_hh1_wom_husb_caseid w1_hh1_dup w1_wom_merge_w1_hh1 w1_hh2_number water_source ///
  toilet w1_hh2_h108 w1_hh2_h109 electricity koloboyi other_paraffin_lamp radio ///
  television cellphone telephone_landline bed_mattress sofaset refrigerator dinnertable ///
  chairs cabinet_cupboard stove washing_machine fan_AC generator computer VCR ///
  CD_cassette_player camera fuel_source w1_hh2_h111_other cooking_place kitchen ///
  floor roof w1_hh2_h115_other walls rooms watch bicycle motorcycle oxcart ///
  car_truck boat_motor land_ownership land_q
 
 * Household section HH2
 drop  w1_hh2_h120_u w1_hh2_case_area w1_hh2_case_district w1_hh2_case_surveywave ///
 w1_hh2_case_surveyid w1_hh2_case_sector w1_hh2_case_cluster_number ///
 w1_hh2_completed_time w1_hh2_started_time w1_hh2_username w1_hh2_received_on ///
 w1_hh2_form_link w1_hh2_userid w1_hh2_deviceid w1_hh2_locationlatitudedegrees ///
 w1_hh2_locationlongitudedegrees w1_hh2_locationaltitudemeters ///
 w1_hh2_locationaccuracymeters w1_hh2_case_name w1_hh2_dup w1_wom_merge_w1_hh2

 * Section 1: w1_w01_*
  drop w1_w01_number w1_w01_wid_4 ///
  w1_w01_conf_wid1 w1_w01_wid_20a w1_w01_wid_21a w1_w01_wid_21a_no_a ///
  w1_w01_wid_21a_no_b w1_w01_wid_21a_no_c w1_w01_w_102_1 ///
  w1_w01_w_102_2 w1_w01_w_103 w1_w01_w106 English_lit ///
  Chichewa_lit Tumbuka_lit Yao_lit w1_w01_w_108_o w1_w01_w109 religion w1_w01_w113_o ///
  w1_w01_w114_o w1_w01_w115 w1_w01_w116 w1_w01_w_117 w1_w01_w_118 ///
  w1_w01_w_119 w1_w01_birth_year w1_w01_case_sector w1_w01_case_district ///
  w1_w01_case_hhid_no w1_w01_case_womanid ///
  w1_w01_case_woman_marital w1_w01_this_year w1_w01_woman_age_years ///
  w1_w01_case_woman_name w1_w01_at_least_18_yrs w1_w01_case_hh_address ///
  w1_w01_case_hhh_name w1_w01_case_cluster_number w1_w01_case_fmid ///
  w1_w01_at_most_35_yrs w1_w01_case_enumid w1_w01_wom_earn ///
  w1_w01_wom_birth_year w1_w01_case_hhh_lineno w1_w01_birth_month ///
  w1_w01_case_woman_lineno w1_w01_case_woman_hh_role w1_w01_case_woman_age ///
  w1_w01_case_survey_id w1_w01_case_hh_gps w1_w01_new_woman_name ///
  w1_w01_case_survey_wave w1_w01_completed_time w1_w01_started_time w1_w01_username ///
  w1_w01_received_on w1_w01_form_link w1_w01_userid w1_w01_deviceid ///
  w1_w01_locationlatitudedegrees w1_w01_locationlongitudedegrees ///
  w1_w01_locationaltitudemeters w1_w01_locationaccuracymeters w1_w01_case_name ///
  w1_w01_dup w1_wom_merge_w1_1
  
  * Section 2: w1_w02_*
  drop w1_w02_number w1_w02_w201 w1_w02_w209 w1_w02_w212_a w1_w02_w212_b ///
  w1_w02_w212_c yng_gender yng_twin w1_w02_w214_b w1_w02_w215_1 w1_w02_w215_2 ///
  w1_w02_w215_a w1_w02_w215_m w1_w02_w216 w1_w02_w217 w1_w02_w218 w1_w02_w218_b ///
  w1_w02_w220_n w1_w02_w220_u w1_w02_w223 w1_w02_w_224 w1_w02_w226 miscarriage ///
  w1_w02_method14 w1_w02_method13 w1_w02_method12 w1_w02_method11 w1_w02_method10 ///
  w1_w02_method9 w1_w02_method8 w1_w02_cc_bpt_check_1 w1_w02_method7 w1_w02_method6 ///
  w1_w02_method5 w1_w02_method4 w1_w02_method3 w1_w02_method2 w1_w02_method1 ///
  w1_w02_cc_bpt_check_2 w1_w02_last_year_mth w1_w02_age_1_under w1_w02_ccstring_bpt ///
  w1_w02_youngest_child_sex w1_w02_eligibility_validation w1_w02_historical_birth_number ///
  w1_w02_youngest_child_age w1_w02_w210_no_births w1_w02_youngest_child_alive ///
  w1_w02_youngest_birth_6_mths w1_w02_youngest_birth_last_yr w1_w02_last_6_mths_yr ///
  w1_w02_pregnancy_status w1_w02_mths_preg w1_w02_age_in_years w1_w02_child_anthro ///
  w1_w02_ccstring_bpt2 w1_w02_ccstring_bpt1 w1_w02_today w1_w02_youngest_child_id ///
  w1_w02_youngest_child_twin w1_w02_age_days_twin_adj w1_w02_age_in_days ///
  w1_w02_birth_date w1_w02_woman_age w1_w02_age_6_mths w1_w02_youngest_child_birthdate ///
  w1_w02_today_year w1_w02_age_5_under w1_w02_this_year w1_w02_woman_name ///
  w1_w02_youngest_child_lineno w1_w02_last_6_mths_mth w1_w02_w208_tot_births ///
  w1_w02_ast_year_date w1_w02_youngest_child_name w1_w02_completed_time ///
  w1_w02_started_time w1_w02_username w1_w02_received_on w1_w02_form_link ///
  w1_w02_userid w1_w02_deviceid w1_w02_locationlatitudedegrees w1_w02_locationlongitudedegrees ///
  w1_w02_locationaltitudemeters w1_w02_locationaccuracymeters w1_w02_case_name ///
  w1_w02_birth_year w1_w02_youngest_child_age_mths w1_w02_last_year_mth_calc ///
  w1_w02_age_in_months w1_w02_birth_month w1_w02_today_month w1_w02_last_year ///
  w1_w02_birth_date_calc w1_w02_today_month_calc w1_w02_last_6_mths_mth_calc ///
  w1_w02_w206 w1_w02_w207_m w1_w02_w207_f w1_w02_w215_p1 w1_w02_w215_p2 w1_w02_w231 ///
  w1_w02_last_6_mths_date w1_w02_alive_sons w1_w02_alive_daughters w1_w02_non_hom_sons ///
  w1_w02_non_hom_daughters w1_w02_dead_sons w1_w02_dead_daughters w1_w02_w221 ///
  w1_w02_dup w1_wom_merge_w1_2
  
	 *Prior knowledge about contraception
	sum w1_w03_w301*

	egen prior_knowledge = rowtotal(w1_w03_w3011-w1_w03_w30116)

	br w1_w03_w301* prior_knowledge if prior_knowledge != w1_w03_w3011 + w1_w03_w3012 + w1_w03_w3013 +w1_w03_w3014 +w1_w03_w3015 +w1_w03_w3016 +w1_w03_w3017 +w1_w03_w3018 +w1_w03_w3019 +w1_w03_w30110 +w1_w03_w30111 +w1_w03_w30112 +w1_w03_w30113 +w1_w03_w30114 +w1_w03_w30115 +w1_w03_w30116

	sum prior_knowledge,d

		capture drop prior_knowledge_bi
	gen prior_knowledge_bi = (prior_knowledge > 4) if !mi(prior_knowledge)
		ta prior_knowledge_bi
	label var prior_knowledge "Prior knowledge"
	label var prior_knowledge_bi "Prior knowledge (binary)"
	
  * Section 3: w1_w03_*
  drop  w1_w03_number /*w1_w03_w3011 w1_w03_w3012 w1_w03_w3013 w1_w03_w3014 ///
  w1_w03_w3015 w1_w03_w3016 w1_w03_w3017 w1_w03_w3018 w1_w03_w3019 w1_w03_w30110 ///
  w1_w03_w30111 w1_w03_w30112 w1_w03_w30113 w1_w03_w30114 w1_w03_w30115 w1_w03_w30116*/ ///
  w1_w03_w308a_m w1_w03_w308a_a ///
  w1_w03_w313_b4 w1_w03_w313_b5 w1_w03_w313_b6 ///
  w1_w03_w313_b7 w1_w03_w317 w1_w03_w318 w1_w03_w319 w1_w03_w320_1 w1_w03_w320_2 ///
  w1_w03_w321 w1_w03_w323 w1_w03_w323_o w1_w03_w323a w1_w03_w323b w1_w03_w323b_22 ///
  w1_w03_w323b_23 w1_w03_w323b_24 w1_w03_w323b_25 w1_w03_w323b_26 w1_w03_w323b_288 ///
  w1_w03_w323c w1_w03_w323d w1_w03_w324a w1_w03_w324b w1_w03_w324c w1_w03_w324d1 ///
  w1_w03_w324e1 w1_w03_w324e2 w1_w03_w324e3 w1_w03_w324e4 w1_w03_w324e5 w1_w03_w324e6 ///
  w1_w03_w324e7 w1_w03_w324e8 w1_w03_w324e11 w1_w03_w324e14 w1_w03_w324f w1_w03_w325a ///
  w1_w03_w325b w1_w03_w325c w1_w03_w325d w1_w03_w325e w1_w03_w326 w1_w03_w327 ///
  w1_w03_w328 w1_w03_w3301 w1_w03_w3302 w1_w03_w3303 w1_w03_w3304 w1_w03_w3305 ///
  w1_w03_w3306 w1_w03_w3307 w1_w03_w3308 w1_w03_w3309 w1_w03_w33010 w1_w03_w33011 ///
  w1_w03_w33012 w1_w03_w33013 w1_w03_w33014 w1_w03_w33015 w1_w03_w33016 ///
  w1_w03_w33017 w1_w03_w33018 w1_w03_w33019 w1_w03_w33020 w1_w03_w33021 ///
  w1_w03_w33096 w1_w03_w330_o ///
  w1_w03_w3331 w1_w03_w3333 w1_w03_w3334 w1_w03_w3335 w1_w03_w3336 w1_w03_w3337 ///
  w1_w03_w3338 w1_w03_w3339 w1_w03_w33310 w1_w03_w33311 w1_w03_w33312 w1_w03_w33313 ///
  w1_w03_w33314 w1_w03_w33315 w1_w03_w33316 w1_w03_w33317 w1_w03_w33318 ///
  w1_w03_w33319 w1_w03_w33320 w1_w03_w33321 w1_w03_w33396 w1_w03_w333_o ///
  w1_w03_w3342 w1_w03_w3343 w1_w03_w3345 w1_w03_w3346 w1_w03_w3349 w1_w03_w33410 ///
  w1_w03_w33411 w1_w03_w33413 w1_w03_w33414 w1_w03_w33415 w1_w03_w33416 w1_w03_w33417 ///
  w1_w03_w33418 w1_w03_w33419 w1_w03_w33420 w1_w03_w33421 w1_w03_w33422 w1_w03_w33423 ///
  w1_w03_w33424 w1_w03_w33426 w1_w03_w33427 w1_w03_w33496 w1_w03_w334_o ///
  w1_w03_w339 ///
  w1_w03_w340 w1_w03_w341 w1_w03_w342 w1_w03_w344 w1_w03_w345 w1_w03_w346 w1_w03_w347 ///
  w1_w03_w348 w1_w03_w349 w1_w03_w350 w1_w03_w3511 w1_w03_w3512 w1_w03_w3513 w1_w03_w3514 ///
  w1_w03_w3515 w1_w03_w3516 w1_w03_w3517 w1_w03_w35196 w1_w03_w35188 w1_w03_w351_o ///
  w1_w03_w3521 w1_w03_w3522 w1_w03_w3523 w1_w03_w3524 w1_w03_w3525 w1_w03_w3526 ///
  w1_w03_w3527 w1_w03_w3528 w1_w03_w3529 w1_w03_w35210 w1_w03_w35211 w1_w03_w35296 ///
  w1_w03_w35288 w1_w03_w352_o w1_w03_ideal_cont_method_calc w1_w03_current_method_date ///
  w1_w03_attribute_1_calc w1_w03_female_sterilized ///
  w1_w03_current_method_calc w1_w03_any_method ///
  w1_w03_male_sterilized w1_w03_tot_beans w1_w03_any_method_calc w1_w03_attribute_3_calc ///
  w1_w03_current_use_fp w1_w03_current_method w1_w03_this_year w1_w03_woman_name ///
  w1_w03_attribute_2_calc w1_w03_pregnancy_status w1_w03_completed_time w1_w03_started_time ///
  w1_w03_username w1_w03_received_on w1_w03_form_link w1_w03_deviceid ///
  w1_w03_locationlatitudedegrees w1_w03_locationlongitudedegrees w1_w03_locationaltitudemeters ///
  w1_w03_locationaccuracymeters w1_w03_case_name w1_w03_userid ///
  w1_w03_w343_m w1_w03_base_switch_method w1_w03_base_switch_cal ///
  w1_w03_w305 w1_w03_w305_a w1_w03_w306 w1_w03_dup w1_wom_merge_w1_3 ///
  w1_w03_w3361 w1_w03_w3362 w1_w03_w3363
  
  *Section CON & SND
  drop w1_con_number w1_con_method14 w1_con_method13 w1_con_method12 w1_con_method11 ///
  w1_con_method10 w1_con_method9 w1_con_method8 w1_con_cc_comb_check_1 w1_con_method7 ///
  w1_con_method6 w1_con_method5 w1_con_method4 w1_con_method3 w1_con_method2 ///
  w1_con_method1 w1_con_cc_comb_check_2 w1_con_cc_comb_check w1_con_ever_use_fp ///
  w1_con_current_use_fp w1_con_ccstring_bpt w1_con_current_method w1_con_cc_string_full ///
  w1_con_current_method_calc w1_con_ccstring_bpt2 w1_con_ccstring_bpt1 w1_con_cc_string_fp ///
  w1_con_cc_string_b_to_z w1_con_cc_string_p_to_z w1_con_woman_name w1_con_male_sterilized ///
  w1_con_ccstring_cc w1_con_pregnancy_status w1_con_completed_time w1_con_started_time ///
  w1_con_username w1_con_received_on w1_con_form_link w1_con_userid w1_con_deviceid ///
  w1_con_locationlatitudedegrees w1_con_locationlongitudedegrees ///
  w1_con_locationaltitudemeters w1_con_locationaccuracymeters w1_con_case_name ///
  w1_con_dup w1_wom_merge_w1_c w1_snd_number w1_snd_cc_disc_conf w1_snd_method7_6 ///
  w1_snd_method7 w1_snd_method6 w1_snd_method5 w1_snd_method4 w1_snd_ccstring_bpt2 ///
  w1_snd_method2 w1_snd_method1 w1_snd_ccstring_bpt1 w1_snd_method3_2 w1_snd_method9 ///
  w1_snd_method8 w1_snd_method12 w1_snd_method13 w1_snd_method10 w1_snd_method11 ///
  w1_snd_method14 w1_snd_current_use_fp w1_snd_ccstring_bpt w1_snd_method71 w1_snd_method5_4 ///
  w1_snd_method131 w1_snd_method121 w1_snd_method111 w1_snd_method101 w1_snd_method141 ///
  w1_snd_method3 w1_snd_current_method w1_snd_ccstring_cc w1_snd_ccstring_b_to_z ///
  w1_snd_ccstring_full w1_snd_method31 w1_snd_method21 w1_snd_method15 w1_snd_method72 ///
  w1_snd_method61 w1_snd_method51 w1_snd_method41 w1_snd_method91 w1_snd_method81 ///
  w1_snd_method11_10 w1_snd_method13_12 w1_snd_method2_1 w1_snd_youngest_birth_last_yr ///
  w1_snd_method82 w1_snd_method92 w1_snd_method16 w1_snd_method22 w1_snd_method32 ///
  w1_snd_method42 w1_snd_method52 w1_snd_method62 w1_snd_method14_13 w1_snd_method8_7 ///
  w1_snd_method10_9 w1_snd_method9_8 w1_snd_last_year_date w1_snd_ccstring_p_to_z ///
  w1_snd_woman_age w1_snd_method6_5 w1_snd_method142 w1_snd_method132 w1_snd_method122 ///
  w1_snd_method112 w1_snd_method102 w1_snd_method4_3 w1_snd_woman_name w1_snd_ccstring_fp ///
  w1_snd_method12_11 w1_snd_pregnancy_status w1_snd_ccstring_discont w1_snd_completed_time ///
  w1_snd_started_time w1_snd_username w1_snd_received_on w1_snd_form_link ///
  w1_snd_userid w1_snd_deviceid w1_snd_locationlatitudedegrees w1_snd_locationlongitudedegrees ///
  w1_snd_locationaltitudemeters w1_snd_locationaccuracymeters w1_snd_case_name ///
  w1_snd_explain12 w1_snd_explain14 w1_snd_explain15 w1_snd_explain16 w1_snd_explain17 ///
  w1_snd_explain18 w1_snd_explain22 w1_snd_explain24 w1_snd_explain25 w1_snd_explain26 ///
  w1_snd_explain27 w1_snd_explain28 w1_snd_explain32 w1_snd_explain34 w1_snd_explain35 ///
  w1_snd_explain36 w1_snd_explain3x w1_snd_explain3_o w1_snd_explain44 w1_snd_explain45 ///
  w1_snd_explain46 w1_snd_explain48 w1_snd_explain4x w1_snd_explain4_o w1_snd_explain52 ///
  w1_snd_explain53 w1_snd_explain54 w1_snd_explain55 w1_snd_explain56 w1_snd_explain57 ///
  w1_snd_explain58 w1_snd_explain5x w1_snd_explain5_o w1_snd_explain64 w1_snd_explain65 ///
  w1_snd_explain66 w1_snd_explain6x w1_snd_explain6_o w1_snd_explain70 w1_snd_explain72 ///
  w1_snd_explain74 w1_snd_explain75 w1_snd_explain76 w1_snd_explain77 w1_snd_explain7x ///
  w1_snd_explain7_o w1_snd_explain80 w1_snd_explain82 w1_snd_explain84 w1_snd_explain85 ///
  w1_snd_explain86 w1_snd_explain88 w1_snd_explain8x w1_snd_explain8_o w1_snd_explain93 ///
  w1_snd_explain94 w1_snd_explain95 w1_snd_explain96 w1_snd_explain97 w1_snd_explain98 ///
  w1_snd_explain9x w1_snd_explain9_o w1_snd_explain102 w1_snd_explain104 w1_snd_explain105 ///
  w1_snd_explain106 w1_snd_explain107 w1_snd_explain108 w1_snd_explain10x w1_snd_explain10_o ///
  w1_snd_explain110 w1_snd_explain114 w1_snd_explain115 w1_snd_explain116 w1_snd_explain117 ///
  w1_snd_explain118 w1_snd_explain11x w1_snd_explain11_o w1_snd_explain120 w1_snd_explain123 ///
  w1_snd_explain124 w1_snd_explain125 w1_snd_explain126 w1_snd_explain128 w1_snd_explain12x ///
  w1_snd_explain12_o w1_snd_explain130 w1_snd_explain132 w1_snd_explain133 w1_snd_explain134 ///
  w1_snd_explain135 w1_snd_explain136 w1_snd_explain137 w1_snd_explain138 w1_snd_explain13x ///
  w1_snd_explain13_o w1_snd_dup w1_wom_merge_w1_s
  
  *Section 4: w1_w04
  drop w1_w04_number w1_w04_w401 w1_w04_w405 w1_w04_w406 w1_w04_w407_m w1_w04_w407_a ///
  w1_w04_w407_dk w1_w04_w430 w1_w04_w447 w1_w04_w449 w1_w04_w451 w1_w04_w452 w1_w04_w453 ///
  w1_w04_w455_h w1_w04_w455_d w1_w04_w445_dk w1_w04_w456 w1_w04_w457a w1_w04_w457g ///
  w1_w04_w45796 w1_w04_w457_o w1_w04_w459 w1_w04_youngest_child_id ///
  w1_w04_youngest_child_age_yrs w1_w04_youngest_child_twin w1_w04_update_youngest_id ///
  w1_w04_youngest_child_alive w1_w04_pregnancy_status w1_w04_youngest_child_name ///
  w1_w04_woman_name w1_w04_youngest_child_age_days w1_w04_youngest_birth_last_yr ///
  w1_w04_youngest_child_sex w1_w04_update_youngest_name w1_w04_update_youngest_alive ///
  w1_w04_youngest_child_lineno w1_w04_completed_time w1_w04_started_time ///
  w1_w04_username w1_w04_received_on w1_w04_form_link w1_w04_userid w1_w04_deviceid ///
  w1_w04_locationlatitudedegrees w1_w04_locationlongitudedegrees ///
  w1_w04_locationaltitudemeters w1_w04_locationaccuracymeters w1_w04_case_name ///
  w1_w04_youngest_child_age_mths w1_w04_dup w1_wom_merge_w1_4

  *Section 6: w1_w06_*
  drop  w1_w06_number w1_w06_w604 w1_w06_w606 w1_w06_w607 w1_w06_w608 ///
  w1_w06_w611 w1_w06_w611_b w1_w06_w612_a w1_w06_w613 w1_w06_w615_q w1_w06_w615_u ///
  w1_w06_w621 w1_w06_w622 w1_w06_woman_age w1_w06_birth_year w1_w06_this_year ///
  w1_w06_wom_husb_id w1_w06_wom_husb_name w1_w06_woman_name ///
  w1_w06_marriage_date_one w1_w06_marriage_date_more w1_w06_marriage_date ///
  w1_w06_cohab_age w1_w06_woman_marital w1_w06_completed_time w1_w06_started_time ///
  w1_w06_username w1_w06_received_on w1_w06_form_link w1_w06_userid ///
  w1_w06_deviceid w1_w06_locationlatitudedegrees w1_w06_locationlongitudedegrees ///
  w1_w06_locationaltitudemeters w1_w06_locationaccuracymeters w1_w06_case_name ///
  w1_w06_w616 w1_w06_w6172 w1_w06_w6174 w1_w06_w6176 w1_w06_w6177 w1_w06_w618 ///
  w1_w06_w619 w1_w06_w620 w1_w06_w623 w1_w06_w624 w1_w06_w_625a w1_w06_w_625b ///
  w1_w06_w_625c w1_w06_w_625d w1_w06_ever_use_fp w1_w06_woman_birth_date ///
  w1_w06_rand_number w1_w06_w_626 w1_w06_w_627 w1_w06_w_630 w1_w06_w631 ///
  w1_w06_dup w1_wom_merge_w1_6
  
  *Section 7: w1_w07_*
  drop  w1_w07_number w1_w07_w704 w1_w07_w705_b_m w1_w07_w705_b_y w1_w07_w705_b_o ///
  w1_w07_w709a2 w1_w07_w709a3 w1_w07_w709a4 w1_w07_w709a6 w1_w07_w709a9 ///
  w1_w07_w709a10 w1_w07_w709a16 w1_w07_w709a18 w1_w07_w709a19 w1_w07_w709a20 ///
  w1_w07_w709a22 w1_w07_w709a24 w1_w07_w709a26 w1_w07_w709a27 w1_w07_w709a96 ///
  w1_w07_w709a_o w1_w07_w709b3 w1_w07_w709b4 w1_w07_w709b6 w1_w07_w709b9 ///
  w1_w07_w709b27 w1_w07_w711a w1_w07_w713_m ///
  w1_w07_w713_f w1_w07_w713_e w1_w07_w713b_m w1_w07_w713b_f w1_w07_w713b_e ///
  w1_w07_w714a_1 w1_w07_w714a_2 w1_w07_w714a_3 w1_w07_w714a_4 w1_w07_w714a_5 ///
  w1_w07_w714a_6 w1_w07_w714a_7 w1_w07_w714b_1 w1_w07_w714b_2 w1_w07_w714b_3 ///
  w1_w07_w714b_4 w1_w07_w714b_5 w1_w07_w714b_6 w1_w07_w714b_7 w1_w07_w714b_8 ///
  w1_w07_w718a w1_w07_w718b w1_w07_w718c w1_w07_w720 w1_w07_w721 w1_w07_w723 ///
  w1_w07_w724a w1_w07_w724b w1_w07_w725 ///
  w1_w07_spacing_not_pregnant w1_w07_spacing_2yrs_not_preg w1_w07_spacing_2_yrs ///
  w1_w07_male_sterilized w1_w07_total_children_alive w1_w07_current_method ///
  w1_w07_rand_no_ch w1_w07_ideal_no_children w1_w07_current_use_fp ///
  w1_w07_total_ideal_sex w1_w07_rand_no w1_w07_youngest_child_name w1_w07_woman_name ///
  w1_w07_pregnancy_status w1_w07_woman_marital w1_w07_completed_time ///
  w1_w07_started_time w1_w07_username w1_w07_received_on w1_w07_form_link ///
  w1_w07_userid w1_w07_deviceid w1_w07_locationlatitudedegrees ///
  w1_w07_locationlongitudedegrees w1_w07_locationaltitudemeters ///
  w1_w07_locationaccuracymeters w1_w07_case_name w1_w07_total_ideal_sex_child ///
  w1_w07_w711c9 w1_w07_w711c24 w1_w07_w725a w1_w07_w725b1 w1_w07_w725b5 ///
  w1_w07_w725b6 w1_w07_w725b96 w1_w07_w725b99 w1_w07_w725b0 w1_w07_w725b_o ///
  w1_w07_w725c1 w1_w07_w725c2 w1_w07_w725c3 w1_w07_w725c4 w1_w07_w725c5 ///
  w1_w07_w725c10 w1_w07_w725c11 w1_w07_w725c96 w1_w07_w725c88 w1_w07_w725c99 ///
  w1_w07_w725c0 w1_w07_w725c_o w1_w07_w725d1 w1_w07_w725d2 w1_w07_w725d3 ///
  w1_w07_w725d4 w1_w07_w725d5 w1_w07_w725d6 w1_w07_w725d7 w1_w07_w725d8 ///
  w1_w07_w725d9 w1_w07_w725d10 w1_w07_w725d11 w1_w07_w725d12 w1_w07_w725d13 ///
  w1_w07_w725d14 w1_w07_w725d96 w1_w07_w725d0 w1_w07_w725d_o w1_w07_ever_use_fp ///
  w1_w07_mths_yrs_entry_np w1_w07_w711b1 w1_w07_w711b5 w1_w07_w711b22 ///
  w1_w07_w711b26 w1_w07_w711b27 w1_w07_current_method_calc w1_w07_dup ///
  w1_wom_merge_w1_7 
  
  * Section 8: w1_w08_*
  drop  w1_w08_number w1_w08_w800 w1_w08_w806 w1_w08_w807 w1_w08_w808 ///
  w1_w08_w809 w1_w08_w810 w1_w08_new_husband_name w1_w08_husb_earn ///
  w1_w08_wom_husb_id w1_w08_wom_husb_name w1_w08_woman_name ///
  w1_w08_husb_work w1_w08_woman_marital w1_w08_completed_time ///
  w1_w08_started_time w1_w08_username w1_w08_received_on w1_w08_form_link ///
  w1_w08_userid w1_w08_deviceid w1_w08_locationlatitudedegrees ///
  w1_w08_locationlongitudedegrees w1_w08_locationaltitudemeters ///
  w1_w08_locationaccuracymeters w1_w08_case_name w1_w08_dup ///
  w1_wom_merge_w1_8
  
  * Section 9: w1_w09_*
  drop  w1_w09_number w1_w09_w900 w1_w09_w901 w1_w09_w901_o w1_w09_w902 ///
  w1_w09_w902_o w1_w09_w903 w1_w09_w904 w1_w09_w905 w1_w09_w906 w1_w09_w908 /// 
  w1_w09_w909 w1_w09_w910a w1_w09_w910b w1_w09_w911 w1_w09_w911a_1 ///
  w1_w09_w911a_2 w1_w09_w911a_3 w1_w09_w911a_4 w1_w09_w911a_5 w1_w09_w911a_6 ///
  w1_w09_w912d w1_w09_w912c w1_w09_w912b w1_w09_w912a w1_w09_w913a ///
  w1_w09_w913b w1_w09_w913c w1_w09_w913d w1_w09_w913e w1_w09_w914 ///
  w1_w09_w915 w1_w09_w916 w1_w09_w917 w1_w09_w918 w1_w09_husb_ideal_size_conf ///
  w1_w09_w9261 w1_w09_w9262 w1_w09_w9263 w1_w09_w9265 ///
  w1_w09_w9268 w1_w09_w9269 w1_w09_w92610 w1_w09_w92696 w1_w09_w926_o ///
  w1_w09_w9271 w1_w09_w9272 w1_w09_w9273 w1_w09_w9274 w1_w09_w9275 ///
  w1_w09_w92796 w1_w09_w927_o w1_w09_w930_1 w1_w09_w930_2 ///
  w1_w09_w930_3 w1_w09_w930_4 w1_w09_w930_5 w1_w09_w930_6 w1_w09_w930_7 ///
  w1_w09_w930_8 w1_w09_w930_9 w1_w09_w930_10 w1_w09_w930_11 w1_w09_w930_12 ///
  w1_w09_new_husband_name w1_w09_wom_earn w1_w09_total_children_alive ///
  w1_w09_husb_earn w1_w09_husb_ideal_size w1_w09_husb_work ///
  w1_w09_wom_husb_name w1_w09_woman_name w1_w09_woman_marital w1_w09_wom_husb_id ///
  w1_w09_completed_time w1_w09_started_time w1_w09_username w1_w09_received_on ///
  w1_w09_form_link w1_w09_userid w1_w09_deviceid w1_w09_locationlatitudedegrees ///
  w1_w09_locationlongitudedegrees w1_w09_locationaltitudemeters ///
  w1_w09_locationaccuracymeters w1_w09_case_name w1_w09_privacy w1_w09_w927a ///
  w1_w09_w914a w1_w09_w914b w1_w09_w914c w1_w09_w914d w1_w09_w914e w1_w09_w915b ///
  w1_w09_rand_no_2 w1_w09_dup w1_wom_merge_w1_9
  
  * Section 10: w1_w10_*
  drop  w1_w10_number w1_w10_w1008_1 w1_w10_w1008_2 w1_w10_w1008_3 w1_w10_w1008_4 ///
  w1_w10_w1008_5 w1_w10_w1008_6 w1_w10_w1008_7 w1_w10_w1009 w1_w10_w1010b ///
  w1_w10_w1010d w1_w10_w101096 w1_w10_w1010_o w1_w10_w1011_1 w1_w10_w1011_2 ///
  w1_w10_w1011_3 w1_w10_w1012_1 w1_w10_w1012_2 w1_w10_w1012_3 w1_w10_w1013 ///
  w1_w10_w1014 w1_w10_w1015 w1_w10_w1016_a w1_w10_w1016_b w1_w10_w1016_c ///
  w1_w10_w1016_d w1_w10_w1017 w1_w10_woman_name w1_w10_obstacles_total ///
  w1_w10_completed_time w1_w10_started_time w1_w10_username w1_w10_received_on ///
  w1_w10_form_link w1_w10_userid w1_w10_deviceid w1_w10_locationlatitudedegrees ///
  w1_w10_locationlongitudedegrees w1_w10_locationaltitudemeters ///
  w1_w10_locationaccuracymeters w1_w10_case_name w1_w10_dup w1_wom_merge_w1_10
  
  * Section 16 & 17
  drop  w1_w16_number w1_w16_fup_resp_1 w1_w16_fup_resp_2 w1_w16_fup_photo_resp_1 ///
  w1_w16_fup_photo_resp_2 w1_w16_fup_per1_1a w1_w16_fup_per1_1b w1_w16_fup_per1_1c ///
  w1_w16_fup_rel_per1 w1_w16_fup_add_per1_3 w1_w16_fup_add_per1_4 ///
  w1_w16_fup_add_per1_5 w1_w16_fup_ph1_per1 w1_w16_fup_ph2_per1 w1_w16_fup_em_per1 ///
  w1_w16_fup_per2_1a w1_w16_fup_per2_1b w1_w16_fup_per2_1c w1_w16_fup_rel_per2 ///
  w1_w16_fup_add_per2_3 w1_w16_fup_add_per2_4 w1_w16_fup_add_per2_5 w1_w16_fup_ph1_per2 ///
  w1_w16_fup_ph2_per2 w1_w16_fup_per3_1a w1_w16_fup_per3_1b w1_w16_fup_per3_1c ///
  w1_w16_fup_per3_phone w1_w16_fup_per3_rel w1_w16_fup_move_1 w1_w16_wfup_move_add_3 ///
  w1_w16_wfup_move_add_4 w1_w16_fup_move_add_5 w1_w16_fup_photo_house_1 ///
  w1_w16_fup_photo_house_2 w1_w16_wfup_intsig w1_w16_wfup_dt w1_w16_name_per3 ///
  w1_w16_case_area w1_w16_case_district w1_w16_case_surveyid w1_w16_area_move ///
  w1_w16_case_surveywave w1_w16_area_con1 w1_w16_name_per2 w1_w16_sector_con2 ///
  w1_w16_case_sector w1_w16_case_cluster_number w1_w16_address_move w1_w16_sector_move ///
  w1_w16_name_per1 w1_w16_sector_con1 w1_w16_area_con2 w1_w16_address_con2 ///
  w1_w16_address_con1 w1_w16_completed_time w1_w16_started_time w1_w16_username ///
  w1_w16_received_on w1_w16_form_link w1_w16_userid w1_w16_deviceid ///
  w1_w16_locationlatitudedegrees w1_w16_locationlongitudedegrees ///
  w1_w16_locationaltitudemeters w1_w16_locationaccuracymeters w1_w16_case_name ///
  w1_w16_dup w1_wom_merge_w1_16 w1_w17_number w1_w17_int_fup_1 w1_w17_int_obs_1 ///
  w1_w17_int_obs_1_o1 w1_w17_int_obs_1_o2 w1_w17_int_obs_22 w1_w17_int_obs_296 ///
  w1_w17_int_obs_2_o w1_w17_int_obs_31 w1_w17_int_obs_32 w1_w17_int_obs_33 ///
  w1_w17_int_obs_396 w1_w17_int_obs_3_o w1_w17_int_obs_4 w1_w17_int_fup_2 ///
  w1_w17_int_fup_3 w1_w17_int_fup_4 w1_w17_case_area w1_w17_case_district ///
  w1_w17_case_sector w1_w17_case_surveyid w1_w17_case_cluster_number ///
  w1_w17_case_surveywave w1_w17_completed_time w1_w17_started_time ///
  w1_w17_username w1_w17_received_on w1_w17_form_link w1_w17_userid ///
  w1_w17_deviceid w1_w17_locationlatitudedegrees w1_w17_locationlongitudedegrees ///
  w1_w17_locationaltitudemeters w1_w17_locationaccuracymeters w1_w17_case_name ///
  w1_w17_dup w1_wom_merge_w1_17 w1_reg_completed_date w1_hh1_completed_date ///
  w1_hh2_completed_date w1_w01_completed_date w1_w02_completed_date ///
  w1_w03_completed_date w1_con_completed_date w1_snd_completed_date ///
  w1_w04_completed_date w1_w06_completed_date w1_w07_completed_date ///
  w1_w08_completed_date w1_w09_completed_date w1_w10_completed_date ///
  w1_w16_completed_date w1_w17_completed_date w1_random_1 w1_random_2 ///
  w1_trt_obs_no w1_woman_pid w1_date_rand_fin w1_append
  
  *COUN
  drop  COUN__number COUN__FV_ID_1 COUN__FV_ID_2A COUN__FV_DATE ///
  COUN__FV_2A COUN__FV_3A_1 COUN__FV_3B COUN__FV_3B_NO COUN__FV_4_A COUN__FV_4_B ///
  COUN__FV_4_C COUN__FV_5_1 COUN__FV_5_2 COUN__FV_5_2A COUN__FV_5_2M COUN__FV_6 ///
  COUN__FV_6_2 COUN__FV_6_3 COUN__FV_6_4 COUN__FV_6_5latitudedegrees ///
  COUN__FV_6_5longitudedegrees COUN__FV_6_5altitudemeters ///
  COUN__FV_6_5accuracymeters COUN_101A COUN_101B COUN_104 COUN_115 ///
  COUN_115_NO COUN_116A COUN_122B_M COUN_122B_Y COUN_122_B_O ///
  COUN_122B_O_O COUN_122B_CHECK COUN_130_O ///
  COUN_133 COUN_1341 COUN_1342 COUN_1343 COUN_134extra COUN_134_1Q COUN_134_2Q ///
  COUN_134_3Q COUN__FINAL_ATTRIBUTE_RANKING COUN_202 COUN_209_0_2 ///
  COUN_301B COUN_302A COUN_302B COUN_302C COUN_302D COUN_302E ///
  COUN_302F COUN_304 COUN__Coun_305 COUN__VISIT_RESULT COUN__MOVED_1 ///
  COUN__HHID_3 COUN__HHID_4 COUN__HHID_5 COUN_INT_SIG COUN_COMMENT ///
  COUN__wom_prim_phone COUN__attribute_130 COUN_134_1_calc ///
  COUN__current_method COUN__new_attribute_2 COUN__new_attribute_3 ///
  COUN__number_of_visits COUN__new_attribute_1 COUN__ideal_cont_method_calc ///
  COUN__attribute_130_calc COUN__couns_name COUN__birth_year COUN_134_2_calc ///
  COUN__prog_end_date_calc COUN__new_sector COUN__G_FV_5new_gps ///
  COUN__taxi_driver_name COUN__current_method1 ///
  COUN__new_wom_prim_phone COUN__attribute_3 COUN__attribute_2 ///
  COUN__attribute_1 COUN__new_woman_name COUN__new_woman_age_years ///
  COUN__ideal_cont_method_pre_calc COUN__birth_month COUN__new_attribute_1_calc ///
  COUN__attribute_2_calc COUN__new_area COUN__at_most_36_yrs ///
  COUN__new_attribute_3_calc COUN__flipchart_color COUN__hhh_full_name ///
  COUN_ideal_method_post_calc COUN__current_method_calc COUN__fm_name_1 ///
  COUN__new_attribute_2_calc COUN__current_use_fp COUN__counselor_visit_no ///
  COUN__ideal_cont_method COUN__new_directions COUN__survey_id ///
  COUN__last_year_date COUN__attribute_1_calc COUN_134_3 COUN__spacing_not_pregnant ///
  COUN__wom_alt_phone COUN__prog_end_date COUN__at_least_18_yrs ///
  COUN__youngest_child_name COUN__attribute_post_couns_calc ///
  COUN__new_woman_birth_date COUN__wom_husb_name COUN__woman_id ///
  COUN__Coun_114_tot_births COUN__woman_name COUN__attribute_3_calc ///
  COUN__woman_pid COUN_134_3_calc COUN__address COUN__current_use_fp1 ///
  COUN_134_1 COUN__new_pregnancy_status COUN_134_2 COUN__pregnancy_status ///
  COUN__attribute_post_couns COUN__completed_time COUN__started_time ///
  COUN__username COUN__received_on COUN__form_link COUN__userID ///
  COUN__deviceID COUN__locationlatitudedegrees COUN__locationlongitudedegrees ///
  COUN__locationaltitudemeters COUN__locationaccuracymeters COUN__case_name ///
  COUN_104_NO COUN_116B00 COUN_116B01 COUN_116B11 COUN_116B12 COUN_116B13 ///
  COUN_116B14 COUN_116B15 COUN_116B16 COUN_116B17 COUN_116B21 COUN_116B22 ///
  COUN_116B23 COUN_116B24 COUN_116B31 COUN_116B32 COUN_116B33 COUN_116B34 ///
  COUN_116B35 COUN_116B36 COUN_116B41 COUN_116B51 COUN_116B61 COUN_116B71 ///
  COUN_116B81 COUN_116B82 COUN_116B83 COUN_116B96 COUN_116Bextra ///
  COUN_116B_O COUN_11711 COUN_11712 COUN_11713 COUN_11714 COUN_11715 ///
  COUN_11716 COUN_11717 COUN_11718 COUN_11719 COUN_11720 COUN_11799 ///
  COUN_11796 COUN_117extra COUN_117_O COUN_118B COUN_120 COUN_121 ///
  COUN_122_M COUN_122_Y COUN__Coun_122_O COUN__Coun_122_O_O COUN_122_CHECK ///
  COUN_124extra COUN_1251 COUN_1252 COUN_1253 COUN_1254 ///
  COUN_1255 COUN_1256 COUN_1257 COUN_1258 COUN_12515 COUN_1259 COUN_12510 ///
  COUN_12511 COUN_12512 COUN_12513 COUN_12514 COUN_12516 COUN_12517 ///
  COUN_12518 COUN_12519 COUN_12520 COUN_12521 COUN_12596 COUN_12588 ///
  COUN_12599 COUN_125extra COUN_125_O ///
  COUN_127extra COUN_1281 COUN_1282 COUN_1283 COUN_1284 COUN_1285 COUN_1286 ///
  COUN_1287 COUN_1288 COUN_12815 COUN_1289 COUN_12810 COUN_12811 COUN_12812 ///
  COUN_12813 COUN_12814 COUN_12816 COUN_12817 COUN_12818 COUN_12819 ///
  COUN_12820 COUN_12821 COUN_12896 COUN_12888 COUN_12899 COUN_128extra ///
  COUN_128_O COUN_128B0 COUN_128B1 COUN_128B2 COUN_128B3 COUN_128B4 ///
  COUN_128B5 COUN_128B6 COUN_128B7 COUN_128B8 COUN_128B15 COUN_128B9 ///
  COUN_128B10 COUN_128B11 COUN_128B12 COUN_128B13 COUN_128B14 COUN_128B16 ///
  COUN_128B17 COUN_128B18 COUN_128B19 COUN_128B20 COUN_128B21 COUN_128B22 ///
  COUN_128B23 COUN_128B24 COUN_128B25 COUN_128B96 COUN_128B88 COUN_128B99 ///
  COUN_128Bextra COUN_128B_O COUN_1320 COUN_1321 COUN_1322 COUN_1323 ///
  COUN_1324 COUN_1325 COUN_1326 COUN_1327 COUN_13296 COUN_13288 COUN_13299 ///
  COUN_132extra COUN_132_O COUN__husb_earn COUN__wom_earn COUN__alive_sons ///
  COUN__alive_daughters COUN__non_hom_sons COUN__non_hom_daughters ///
  COUN__dead_sons COUN__dead_daughters COUN__new_alive_sons ///
  COUN__new_alive_daughters COUN__new_non_hom_sons COUN__new_non_hom_daughters ///
  COUN__new_dead_sons COUN__new_dead_daughters COUN__husb_birth_year ///
  COUN__husb_birth_month COUN__new_husband_birth_date ///
  COUN__new_husband_age_years COUN__husb_work_H COUN__switch_method_preCoun ///
  COUN__switch_preCoun_calc COUN__spacing_pregnant COUN__WID_10 ///
  COUN__WID_11 COUN__WID_12 COUN__WID_13 COUN__WID_14 COUN__WID_15 ///
  COUN__WID_16 COUN__WID_1extra COUN__UPD_1 COUN__UPD_2 COUN__UPD_3 ///
  COUN__UPD_4 COUN__UPD_5 COUN__UPD_6 COUN_209 ///
  COUN__check_husb COUN_303A COUN_303B COUN_128C2 COUN_128C3 COUN_128C4 ///
  COUN_128C5 COUN_128C6 COUN_128C7 COUN_128C8 COUN_128C9 COUN_128C10 ///
  COUN_128C11 COUN_128C12 COUN_128C13 COUN_128C14 COUN_128C15 COUN_128C16 ///
  COUN_128C17 COUN_128C18 COUN_128C19 COUN_128C20 COUN_128C21 COUN_128C22 ///
  COUN_128C23 COUN_128C24 COUN_128C25 COUN_128C26 COUN_128C27 COUN_128C96 ///
  COUN_128C88 COUN_128C99 COUN_128Cextra COUN_128C_O COUN_128D ///
  COUN_Complete_CONF COUN_128E1 COUN_128E2 COUN_128E3 COUN_128E4 COUN_128E5 ///
  COUN_128E6 COUN_128E7 COUN_128E8 COUN_128E9 COUN_128E10 COUN_128E11 ///
  COUN_128E12 COUN_128E13 COUN_128E14 COUN_128E15 COUN_128E16 COUN_128E17 ///
  COUN_128E18 COUN_128E19 COUN_128E20 COUN_128E21 COUN_128E22 COUN_128E23 ///
  COUN_128E24 COUN_128E25 COUN_128E26 COUN_128E27 COUN_128E96 COUN_128E88 ///
  COUN_128E99 COUN_128Eextra COUN_128E_O COUN__HUSB_209N1 COUN__HUSB_209N2 ///
  COUN__HUSB_209N3 COUN__HUSB_209N99 COUN__HUSB_209N96 COUN__HUSB_209N4 ///
  COUN__HUSB_209Nextra COUN__HUSB_209N_O COUN_306A COUN_3060 COUN_3061 ///
  COUN_3062 COUN_3063 COUN_3064 COUN_3065 COUN_3066 COUN_3067 COUN_30696 ///
  COUN_30688 COUN_30699 COUN_306extra COUN_306_O COUN__CVF_close_condition ///
  COUN__husb_current_use COUN__husb_curr_method COUN__husb_curr_method_calc ///
  COUN__husb_switch_method COUN__husb_switch_method_calc COUN__RAND_NUMBER ///
  COUN__ideal_method_today_clinic COUN_ideal_method_from_coun ///
  COUN__joint_counseling COUN_209_CB_Q COUN_209_CB_D COUN_209_CB_T ///
  COUN_209_incomp COUN__individual_cons COUN__individual_cons_today ///
  COUN__individual_cons_N COUN_NH_CB_D COUN_NH_CB_T COUN_NH_INCOMP ///
  COUN__HUSB_102A ///
  COUN__HUSB_102B COUN__HUSB_102_Y COUN__HUSB_102_M COUN__HUSB_103 ///
  COUN__HUSB_104A COUN__HUSB_104B COUN__HUSB_105 COUN__HUSB_106 COUN__HUSB_107 ///
  COUN__HUSB_108A COUN__HUSB_108B COUN__HUSB_109 COUN__HUSB_110 COUN__HUSB_111 ///
  COUN__HUSB_11211 COUN__HUSB_11212 COUN__HUSB_11213 COUN__HUSB_11214 ///
  COUN__HUSB_11215 COUN__HUSB_11216 COUN__HUSB_11217 COUN__HUSB_11218 ///
  COUN__HUSB_11219 COUN__HUSB_11296 COUN__HUSB_11299 COUN__HUSB_112extra ///
  COUN__HUSB_112_O COUN__HUSB_113 COUN__HUSB_113A COUN__HUSB_113B ///
  COUN__HUSB_113C COUN__HUSB_113D COUN__HUSB_FERTILITY_ERR COUN__HUSB_113E ///
  COUN__HUSB_114 COUN__HUSB_1152 COUN__HUSB_1157 COUN__HUSB_11514 ///
  COUN__HUSB_11515 COUN__HUSB_11516 COUN__HUSB_115extra COUN__HUSB_1161 ///
  COUN__HUSB_1162 COUN__HUSB_1163 COUN__HUSB_1164 COUN__HUSB_1165 ///
  COUN__HUSB_1166 COUN__HUSB_1167 COUN__HUSB_1168 COUN__HUSB_1169 ///
  COUN__HUSB_11610 COUN__HUSB_11611 COUN__HUSB_11612 COUN__HUSB_11613 ///
  COUN__HUSB_11614 COUN__HUSB_11615 COUN__HUSB_11616 COUN__HUSB_11617 ///
  COUN__HUSB_11618 COUN__HUSB_11619 COUN__HUSB_11620 COUN__HUSB_11696 ///
  COUN__HUSB_11688 COUN__HUSB_11699 COUN__HUSB_116extra COUN__HUSB_116_O ///
  COUN__HUSB_117 COUN__HUSB_1182 COUN__HUSB_1187 COUN__HUSB_11814 ///
  COUN__HUSB_11815 COUN__HUSB_11816 COUN__HUSB_118extra COUN__HUSB_1191 ///
  COUN__HUSB_1192 COUN__HUSB_1193 COUN__HUSB_1194 COUN__HUSB_1195 ///
  COUN__HUSB_1196 COUN__HUSB_1197 COUN__HUSB_1198 COUN__HUSB_1199 ///
  COUN__HUSB_11910 COUN__HUSB_11911 COUN__HUSB_11912 COUN__HUSB_11913 ///
  COUN__HUSB_11914 COUN__HUSB_11915 COUN__HUSB_11916 COUN__HUSB_11917 ///
  COUN__HUSB_11919 COUN__HUSB_11920 COUN__HUSB_11921 COUN__HUSB_11996 ///
  COUN__HUSB_11988 COUN__HUSB_11999 COUN__HUSB_119extra COUN__HUSB_119_O ///
  COUN__HUSB_1202 COUN__HUSB_1203 COUN__HUSB_1204 COUN__HUSB_1205 ///
  COUN__HUSB_1206 COUN__HUSB_1207 COUN__HUSB_1208 COUN__HUSB_1209 ///
  COUN__HUSB_12010 COUN__HUSB_12011 COUN__HUSB_12012 COUN__HUSB_12014 ///
  COUN__HUSB_12015 COUN__HUSB_12016 COUN__HUSB_12017 COUN__HUSB_12018 ///
  COUN__HUSB_12019 COUN__HUSB_12020 COUN__HUSB_12021 COUN__HUSB_12022 ///
  COUN__HUSB_12023 COUN__HUSB_12024 COUN__HUSB_12025 COUN__HUSB_12026 ///
  COUN__HUSB_12027 COUN__HUSB_12096 COUN__HUSB_12088 COUN__HUSB_12099 ///
  COUN__HUSB_120extra COUN__HUSB_120_O COUN__HUSB_128C2 COUN__HUSB_128C3 ///
  COUN__HUSB_128C4 COUN__HUSB_128C5 COUN__HUSB_128C6 COUN__HUSB_128C7 ///
  COUN__HUSB_128C8 COUN__HUSB_128C9 COUN__HUSB_128C10 COUN__HUSB_128C11 ///
  COUN__HUSB_128C12 COUN__HUSB_128C13 COUN__HUSB_128C14 COUN__HUSB_128C15 ///
  COUN__HUSB_128C16 COUN__HUSB_128C17 COUN__HUSB_128C18 COUN__HUSB_128C19 ///
  COUN__HUSB_128C20 COUN__HUSB_128C21 COUN__HUSB_128C22 COUN__HUSB_128C23 ///
  COUN__HUSB_128C24 COUN__HUSB_128C25 COUN__HUSB_128C26 COUN__HUSB_128C27 ///
  COUN__HUSB_128C96 COUN__HUSB_128C88 COUN__HUSB_128C99 COUN__HUSB_128Cextra ///
  COUN__HUSB_128C_O COUN__HUSB_128D COUN__HUSB_128E1 COUN__HUSB_128E2 ///
  COUN__HUSB_128E3 COUN__HUSB_128E4 COUN__HUSB_128E5 COUN__HUSB_128E6 ///
  COUN__HUSB_128E7 COUN__HUSB_128E8 COUN__HUSB_128E9 COUN__HUSB_128E10 ///
  COUN__HUSB_128E11 COUN__HUSB_128E12 COUN__HUSB_128E13 COUN__HUSB_128E14 ///
  COUN__HUSB_128E15 COUN__HUSB_128E16 COUN__HUSB_128E17 COUN__HUSB_128E18 ///
  COUN__HUSB_128E19 COUN__HUSB_128E20 COUN__HUSB_128E21 COUN__HUSB_128E22 ///
  COUN__HUSB_128E23 COUN__HUSB_128E24 COUN__HUSB_128E25 COUN__HUSB_128E26 ///
  COUN__HUSB_128E27 COUN__HUSB_128E96 COUN__HUSB_128E88 COUN__HUSB_128E99 ///
  COUN__HUSB_128Eextra COUN__HUSB_128E_O COUN__HUSB_121extra ///
  COUN__HUSB_124 COUN__HUSB_1250 COUN__HUSB_1251 ///
  COUN__HUSB_1252 COUN__HUSB_1253 COUN__HUSB_1254 COUN__HUSB_1255 ///
  COUN__HUSB_1256 COUN__HUSB_1257 COUN__HUSB_1258 COUN__HUSB_1259 ///
  COUN__HUSB_12510 COUN__HUSB_12511 COUN__HUSB_12512 COUN__HUSB_12513 ///
  COUN__HUSB_12514 COUN__HUSB_12515 COUN__HUSB_12516 ///
  COUN__HUSB_125extra COUN__HUSB_126 COUN__HUSB_131A COUN__HUSB_131B ///
  COUN__HUSB_625A COUN__HUSB_625B COUN__HUSB_625C COUN__HUSB_625D ///
  COUN__HUSB_132 COUN__HUSB_133 COUN__HUSB_135A COUN__HUSB_135B COUN__HUSB_135C ///
  COUN__HUSB_136 COUN__HUSB_138 COUN__HUSB_139 COUN__HUSB_140 COUN__HUSB_141 ///
  COUN__W142_L COUN__HUSB_142A COUN__HUSB_142B COUN__HUSB_142C COUN__HUSB_142D ///
  COUN__HUSB_142E COUN__HUSB_148 COUN__HUSB_1491 COUN__HUSB_1492 ///
  COUN__HUSB_1493 COUN__HUSB_1494 COUN__HUSB_1495 COUN__HUSB_1496 ///
  COUN__HUSB_1497 COUN__HUSB_1498 COUN__HUSB_1499 COUN__HUSB_14910 ///
  COUN__HUSB_14911 COUN__HUSB_14912 COUN__HUSB_14913 COUN__HUSB_14914 ///
  COUN__HUSB_14915 COUN__HUSB_14996 COUN__HUSB_14988 COUN__HUSB_14999 ///
  COUN__HUSB_149extra COUN__HUSB_149_O COUN__HUSB_1501 COUN__HUSB_1502 ///
  COUN__HUSB_1503 COUN__HUSB_1504 COUN__HUSB_1505 COUN__HUSB_15096 ///
  COUN__HUSB_15088 COUN__HUSB_15099 COUN__HUSB_150extra COUN__HUSB_150_O ///
  COUN__HUSB_151 COUN__W930_L COUN__HUSB_152_1 COUN__HUSB_152_2 ///
  COUN__HUSB_152_3 COUN__HUSB_152_4 COUN__HUSB_152_5 COUN__HUSB_152_6 ///
  COUN__HUSB_152_7 COUN__HUSB_152_8 COUN__HUSB_152_9 COUN__HUSB_152_10 ///
  COUN__HUSB_152_11 COUN__HUSB_152_12 COUN_303C0 COUN_303C1 COUN_303C2 ///
  COUN_303C3 COUN_303C4 COUN_303C5 COUN_303C6 COUN_303C7 COUN_303C96 ///
  COUN_303C88 COUN_303C99 COUN_303Cextra COUN_303C_O COUN_129A COUN_129B0 ///
  COUN_129B1 COUN_129B2 COUN_129B3 COUN_129B4 COUN_129B5 COUN_129B6 ///
  COUN_129B7 COUN_129B96 COUN_129B88 COUN_129B99 COUN_129Bextra COUN_129B_O ///
  COUN_CONS COUN__HOME_REV_20 COUN__HOME_REV_20_HUSB COUN_CONS_RESP_1 ///
  COUN_THUMB_NAME COUN_THUMB_PIC COUN_THUMB_DT COUN_SIG_NAME COUN_SIG ///
  COUN_SIG_DT COUN__HUSB_CONS_RESP_1 COUN__HUSB_THUMB_NAME COUN__HUSB_THUMB_PIC ///
  COUN__HUSB_THUMB_DT COUN__HUSB_SIG_NAME COUN__HUSB_SIG COUN__HUSB_SIG_DT ///
  COUN_CONS_1 COUN__WOM_ONLY_CONS COUN_CONS_RESP_2 COUN_THUMB_NAME_2 ///
  COUN_THUMB_PIC_2 COUN_THUMB_DT_2 COUN_SIG_NAME_2 COUN_SIG_2 COUN_SIG_DT2 COUN_307 ///
  COUN_308B COUN_309 COUN_3101 COUN_3102 COUN_3103 COUN_3104 COUN_3105 ///
  COUN_3109 COUN_31096 COUN_310extra COUN_310_O COUN__HUSB_153_H_COUPLE ///
  COUN__HUSB_153_WOM_ONLY COUN__HUSB_RESCHE COUN__HUSB_womCheck ///
  COUN__WOM_COUN_RESCHE_D COUN__WOM_COUN_RESCHE_T COUN__WOM_COUN_RESCHE_incomp ///
  COUN__HUSB_COUN_cons COUN__couple_COUN_cons_today COUN__total_children_alive ///
  COUN__tot_births COUN__new_tot_children_alive COUN__FV_CONS_WOM_PART ///
  COUN__FV_CONS_WOM_PART_RESCHE COUN__WOM_CONS_RESCHE_D ///
  COUN__WOM_CONS_RESCHE_T COUN__WOM_CONS_RESCHE_incomp COUN__WOM_CONS_END ///
  COUN__coun_death_year COUN__coun_death_month COUN__woman_death_date_coun ///
  COUN__coun_area_hh COUN__coun_sector_hh COUN__coun_address ///
  COUN__New_Area1 COUN__New_Sector1 COUN__New_Address COUN__New_Phone_No ///
  COUN__area COUN__sector COUN_308 COUN_DEATH_1 COUN_MOVED_10 COUN_MOVED_11 ///
  COUN_DEATH_0 COUN_DEATH_2 COUN_DEATH_3A COUN_DEATH_3M COUN_DEATH_4 ///
  COUN_DEATH_51 COUN_DEATH_52 COUN_DEATH_53 COUN_DEATH_54 COUN_DEATH_596 ///
  COUN_DEATH_599 COUN_DEATH_588 COUN_DEATH_5extra COUN_DEATH_5_O ///
  COUN__N_REC_COUN_WOM_DIED COUN_MOVED_1 COUN_MOVED_2 COUN_MOVED_3 ///
  COUN_MOVED_4 COUN_MOVED_5 COUN_MOVED_6 COUN_MOVED_7 COUN_MOVED_8 ///
  COUN_MOVED_9
  
  * PHO
  drop  PHO_number PHO_FMID PHO_ENUMID_1 PHO_CONF_ID PHO_CONF_ID_NO ///
  PHO_REC_DATE PHO_REC_2A PHO_DEATH_0 PHO_DEATH_1 PHO_DEATH_2 ///
  PHO_DEATH_3A PHO_DEATH_3M PHO_DEATH_4 PHO_DEATH_51 PHO_DEATH_52 PHO_DEATH_53 ///
  PHO_DEATH_54 PHO_DEATH_596 PHO_DEATH_599 PHO_DEATH_588 PHO_DEATH_5extra ///
  PHO_DEATH_5_O PHO_MOVED_1 PHO_MOVED_2 PHO_MOVED_3 PHO_MOVED_4 PHO_MOVED_5 ///
  PHO_MOVED_6 PHO_TRACK_101A PHO_TRACK_101B ///
  PHO_1191 PHO_11911 PHO_11912 PHO_11913 PHO_11914 PHO_11915 PHO_11916 ///
  PHO_11917 PHO_11921 PHO_11922 PHO_11923 PHO_11924 PHO_11931 PHO_11932 ///
  PHO_11933 PHO_11934 PHO_11935 PHO_11936 PHO_11941 PHO_11951 PHO_11961 ///
  PHO_11971 PHO_11981 PHO_11982 PHO_11983 PHO_11996 PHO_119extra PHO_119_O ///
  PHO_121 PHO_122 PHO_1231 PHO_1232 PHO_1233 PHO_1234 PHO_1235 PHO_1236 ///
  PHO_12396 PHO_123extra PHO_123_O PHO_124 PHO_125 PHO_126 PHO_END_DT PHO_139extra ///
  PHO_CLIN_TRACK_INT_SIG PHO_CLIN_TRACK_COMMENT PHO_wom_prim_phone ///
  PHO_current_use_fp PHO_sector PHO_ideal_cont_method_calc PHO_enum_name ///
  PHO_current_use_fp1 PHO_death_month PHO_New_Phone_No PHO_sector_hh ///
  PHO_fp_routine_amt PHO_hhh_full_name PHO_directions PHO_current_method ///
  PHO_area PHO_con2_alt_phone PHO_woman_id PHO_con1_prim_phone PHO_visit_no ///
  PHO_area_hh PHO_def_fp_routine_amt PHO_New_Area PHO_con1_alt_phone ///
  PHO_New_Address PHO_gps PHO_woman_death_date PHO_new_pregnancy_status ///
  PHO_New_Sector PHO_enum_id PHO_con3_phone PHO_ideal_cont_method ///
  PHO_current_method1 PHO_current_method_calc PHO_survey_id PHO_name_con1 ///
  PHO_name_con2 PHO_name_con3 PHO_con2_prim_phone PHO_joint_counseling ///
  PHO_wom_alt_phone PHO_treatment PHO_death_year PHO_youngest_child_name ///
  PHO_wom_husb_name PHO_woman_name PHO_woman_pid PHO_address ///
  PHO_pregnancy_status PHO_address1 PHO_woman_alive PHO_couns_dir ///
  PHO_completed_time PHO_started_time PHO_username PHO_received_on ///
  PHO_form_link PHO_userID PHO_deviceID PHO_locationlatitudedegrees ///
  PHO_locationlongitudedegrees PHO_locationaltitudemeters ///
  PHO_locationaccuracymeters PHO_case_name PHO_MOVED_7 PHO_MOVED_8 PHO_MOVED_9 ///
  PHO_MOVED_10 PHO_MOVED_11 PHO_119A PHO_119B0 PHO_119B1 PHO_119B2 ///
  PHO_119B3 PHO_119B4 PHO_119B5 PHO_119B6 PHO_119B7 PHO_119B8 PHO_119B9 ///
  PHO_119B10 PHO_119B11 PHO_119B12 PHO_119B13 PHO_119B14 PHO_119B15 ///
  PHO_119B16 PHO_119B99 PHO_119Bextra PHO_111C PHO_1200 PHO_1201 PHO_1202 ///
  PHO_1203 PHO_1204 PHO_1205 PHO_1206 PHO_1207 PHO_1208 PHO_1209 ///
  PHO_12010 PHO_12011 PHO_12012 PHO_12013 PHO_12014 PHO_12015 PHO_12096 ///
  PHO_12099 PHO_12016 PHO_12017 PHO_12018 PHO_120extra PHO_120_O ///
  PHO_105extra PHO_105B PHO_105B_O PHO_105C PHO_105C_O PHO_105D PHO_105D_M ///
  PHO_105D_Y PHO_STER_DATE_ERR PHO_105E PHO_105E_Y PHO_CURR_DATE_ERR PHO_105F ///
  PHO_105G PHO_105G_O PHO_105H PHO_105I PHO_105J1 PHO_105J2 PHO_105J3 PHO_105J4 ///
  PHO_105J5 PHO_105J6 PHO_105J96 PHO_105J88 PHO_105J99 PHO_105Jextra PHO_105J_O ///
  PHO_105K PHO_105L PHO_105M1 PHO_105M2 PHO_105M3 PHO_105M4 PHO_105M5 PHO_105M6 ///
  PHO_105M7 PHO_105M8 PHO_105M15 PHO_105M9 PHO_105M10 PHO_105M11 PHO_105M12 ///
  PHO_105M13 PHO_105M14 PHO_105M16 PHO_105M17 PHO_105M18 PHO_105M19 PHO_105M20 ///
  PHO_105M21 PHO_105M96 PHO_105M88 PHO_105M99 PHO_105Mextra PHO_105M_O ///
  PHO_105N1extra PHO_105N21 PHO_105N22 ///
  PHO_105N23 PHO_105N24 PHO_105N25 PHO_105N26 PHO_105N27 PHO_105N28 PHO_105N215 ///
  PHO_105N29 PHO_105N210 PHO_105N211 PHO_105N212 PHO_105N213 PHO_105N214 ///
  PHO_105N216 PHO_105N217 PHO_105N218 PHO_105N219 PHO_105N220 PHO_105N221 ///
  PHO_105N296 PHO_105N288 PHO_105N299 PHO_105N2extra PHO_105N2_O PHO_105N30 ///
  PHO_105N31 PHO_105N32 PHO_105N33 PHO_105N34 PHO_105N35 PHO_105N36 ///
  PHO_105N37 PHO_105N38 PHO_105N315 PHO_105N39 PHO_105N310 PHO_105N311 ///
  PHO_105N312 PHO_105N313 PHO_105N314 PHO_105N316 PHO_105N317 PHO_105N318 ///
  PHO_105N319 PHO_105N320 PHO_105N321 PHO_105N322 PHO_105N323 PHO_105N324 ///
  PHO_105N325 PHO_105N396 PHO_105N388 PHO_105N399 PHO_105N3extra PHO_105N3_O ///
  PHO_105O2 PHO_105O3 PHO_105O4 PHO_105O5 PHO_105O6 PHO_105O7 PHO_105O8 ///
  PHO_105O9 PHO_105O10 PHO_105O11 PHO_105O12 PHO_105O13 PHO_105O14 PHO_105O15 ///
  PHO_105O16 PHO_105O17 PHO_105O18 PHO_105O19 PHO_105O20 PHO_105O21 ///
  PHO_105O22 PHO_105O23 PHO_105O24 PHO_105O25 PHO_105O26 PHO_105O27 PHO_105O96 ///
  PHO_105O88 PHO_105O99 PHO_105Oextra PHO_105O_O PHO_105P PHO_105Q1 ///
  PHO_105Q2 PHO_105Q3 PHO_105Q4 PHO_105Q5 PHO_105Q6 PHO_105Q7 PHO_105Q8 ///
  PHO_105Q9 PHO_105Q10 PHO_105Q11 PHO_105Q12 PHO_105Q13 PHO_105Q14 ///
  PHO_105Q15 PHO_105Q16 PHO_105Q17 PHO_105Q18 PHO_105Q19 PHO_105Q20 ///
  PHO_105Q21 PHO_105Q22 PHO_105Q23 PHO_105Q24 PHO_105Q25 PHO_105Q26 ///
  PHO_105Q27 PHO_105Q96 PHO_105Q88 PHO_105Q99 PHO_105Qextra PHO_105Q_O ///
  PHO_108A PHO_121A PHO_124A PHO_switch_method_PHO PHO_switch_PHO_calc ///
  PHO_pho_ideal_method_calc PHO_sterilization_date PHO_current_method_date ///
  PHO_male_sterilized PHO_female_sterilized PHO_111D0 PHO_111D1 PHO_111D2 ///
  PHO_111D3 PHO_111D4 PHO_111D5 PHO_111D6 PHO_111D7 PHO_111D8 PHO_111D15 ///
  PHO_111D9 PHO_111D10 PHO_111D11 PHO_111D12 PHO_111D13 PHO_111D14 ///
  PHO_111D16 PHO_111D17 PHO_111D18 PHO_111D19 PHO_111D20 PHO_111D21 ///
  PHO_111D96 PHO_111D88 PHO_111D99 PHO_111Dextra PHO_111D_O ///
  PHO_ideal_method_from_counseling PHO_105E_M PHO_124_0 PHO_127D PHO_127D1 ///
  PHO_127E PHO_127F PHO_127F1 PHO_127F2_FN PHO_127F2_LN PHO_127F2_ON ///
  PHO_127G PHO_127H PHO_127H1 PHO_127H2_FN PHO_127H2_LN PHO_127H2_ON ///
  PHO_127I PHO_127J PHO_127K PHO_127L PHO_127L1 PHO_127L2_FN PHO_127L2_LN ///
  PHO_127L2_ON PHO_127F_minus_1 PHO_127F2_fullname PHO_127H_minus_1 ///
  PHO_127H2_fullname PHO_127L_minus_1 PHO_127L2_fullname PHO_112A PHO_112B PHO_112C ///
  PHO_112D PHO_112E_1 PHO_112E_2 PHO_113A PHO_113B PHO_113C PHO_114A PHO_114B ///
  PHO_114C PHO_114D PHO_1151 PHO_1152 PHO_1153 PHO_1154 PHO_1155 PHO_1156 ///
  PHO_1157 PHO_11596 PHO_11588 PHO_11599 PHO_115extra PHO_115_O PHO_1161 ///
  PHO_1162 PHO_1163 PHO_1164 PHO_1165 PHO_1166 PHO_1167 PHO_1168 PHO_1169 ///
  PHO_11610 PHO_11611 PHO_11696 PHO_11688 PHO_11699 PHO_116extra PHO_116_O ///
  PHO_120_1 PHO_dup
  
  * HOM
  drop  HOM_number HOM_FMID HOM_ENUMID_1 HOM_REC_1B HOM_REC_1B_NO ///
  HOM_REC_1C HOM_REC_2A HOM_DEATH_0 HOM_DEATH_1 HOM_DEATH_2A HOM_DEATH_2 ///
  HOM_DEATH_3 HOM_DEATH_4 HOM_DEATH_51 HOM_DEATH_52 HOM_DEATH_53 HOM_DEATH_54 ///
  HOM_DEATH_596 HOM_DEATH_599 HOM_DEATH_588 HOM_DEATH_5extra HOM_DEATH_5_O ///
  HOM_MOVED_1 HOM_MOVED_2 HOM_MOVED_3 HOM_MOVED_4 HOM_MOVED_5 HOM_MOVED_6 ///
  HOME_CONS_1 HOME_CONS_SIG_NAME HOME_CONS_SIG HOME_CONS_INT_NAME ///
  HOME_CONS_INT_SIG HOME_CONS_SIG_DT HOME_CONS_THUMB_NAME HOME_CONS_THUMB ///
  HOME_CONS_THUMB_DT HOME_101A HOME_101B HOME_101C HOME_101D ///
  HOME_111B HOME_1191 HOME_11911 HOME_11912 HOME_11913 ///
  HOME_11914 HOME_11915 HOME_11916 HOME_11917 HOME_11921 HOME_11922 HOME_11923 ///
  HOME_11924 HOME_11931 HOME_11932 HOME_11933 HOME_11934 HOME_11935 HOME_11936 ///
  HOME_11941 HOME_11951 HOME_11961 HOME_11971 HOME_11981 HOME_11982 HOME_11983 ///
  HOME_11996 HOME_11988 HOME_11999 HOME_119extra HOME_119_O HOME_121 HOME_122 ///
  HOME_1231 HOME_1232 HOME_1233 HOME_1234 HOME_1235 HOME_1236 HOME_12396 ///
  HOME_123extra HOME_123_O HOME_124 HOME_125 HOME_126 HOME_END_DT ///
   HOME_1392 HOME_1393 HOME_1394 HOME_1395 HOME_13999 HOME_139extra ///
  HOM_CLIN_TRACK_INT_SIG HOM_CLIN_TRACK_COMMENT HOM_wom_prim_phone ///
  HOM_New_Phone_No HOM_current_use_fp HOM_sector HOM_ideal_cont_method_calc ///
  HOM_New_Area HOM_address HOM_fp_routine_amt HOM_death_month HOM_directions ///
  HOM_current_method HOM_male_sterilized HOM_treatment HOM_woman_id ///
  HOM_Woman_Alive HOM_visit_no HOM_new_wom_prim_phone HOM_def_fp_routine_amt ///
  HOM_enum_id HOM_enum_name HOM_female_sterilized HOM_area_hh ///
  HOM_current_use_fp1 HOM_ideal_cont_method HOM_survey_id ///
  HOM_joint_counseling HOM_wom_alt_phone HOM_area HOM_New_Sector ///
  HOM_youngest_child_name HOM_wom_husb_name HOM_death_year ///
  HOM_new_pregnancy_status HOM_woman_name HOM_woman_death_date ///
  HOM_woman_pid HOM_New_Address HOM_gps HOM_address1 HOM_current_method1 ///
  HOM_sector_hh HOM_pregnancy_status HOM_couns_dir HOM_current_method_calc ///
  HOM_completed_time HOM_started_time HOM_username HOM_received_on ///
  HOM_form_link HOM_userID HOM_deviceID HOM_locationlatitudedegrees ///
  HOM_locationlongitudedegrees HOM_locationaltitudemeters ///
  HOM_locationaccuracymeters HOM_case_name HOM_MOVED_7 HOM_MOVED_8 ///
  HOM_MOVED_9 HOM_MOVED_10 HOM_MOVED_11 HOME_119A HOME_119B1 HOME_119B2 ///
  HOME_119B3 HOME_119B4 HOME_119B5 HOME_119B6 HOME_119B7 HOME_119B8 ///
  HOME_119B9 HOME_119B10 HOME_119B11 HOME_119B12 HOME_119B13 HOME_119B14 ///
  HOME_119B15 HOME_119B16 HOME_119B88 HOME_119B99 HOME_119Bextra ///
  HOM_hhh_full_name HOME_128latitudedegrees HOME_128longitudedegrees ///
  HOME_128altitudemeters HOME_128accuracymeters HOME_1200 HOME_1201 ///
  HOME_1202 HOME_1203 HOME_1204 HOME_1205 HOME_1206 HOME_1207 HOME_1208 ///
  HOME_1209 HOME_12010 HOME_12011 HOME_12012 HOME_12014 HOME_12015 ///
  HOME_12096 HOME_12099 HOME_12016 HOME_12017 HOME_12018 HOME_120extra ///
  HOME_120_O HOME_105extra HOME_105B HOME_105B_O ///
  HOME_105C HOME_105C_O HOME_105D HOME_105D_M HOME_105D_Y HOM_STER_DATE_ERR ///
  HOM_N_HOME_105E HOME_105E_M HOME_105E_Y HOM_CURR_DATE_ERR HOME_105F ///
  HOME_105G HOME_105G_O HOME_105H HOME_105I HOME_105J1 HOME_105J2 ///
  HOME_105J3 HOME_105J4 HOME_105J5 HOME_105J6 HOME_105J96 HOME_105J88 ///
  HOME_105J99 HOME_105Jextra HOME_105J_O HOME_105K HOME_105L HOM_105M1 ///
  HOM_105M2 HOM_105M3 HOM_105M4 HOM_105M5 HOM_105M6 HOM_105M7 HOM_105M8 ///
  HOM_105M15 HOM_105M9 HOM_105M10 HOM_105M11 HOM_105M12 HOM_105M13 ///
  HOM_105M14 HOM_105M16 HOM_105M17 HOM_105M18 HOM_105M19 HOM_105M20 ///
  HOM_105M21 HOM_105M96 HOM_105M88 HOM_105M99 HOM_105Mextra HOM_105M_O ///
  HOM_105N1extra HOM_105N21 HOM_105N22 HOM_105N23 HOM_105N24 ///
  HOM_105N25 HOM_105N26 HOM_105N27 HOM_105N28 HOM_105N215 HOM_105N29 ///
  HOM_105N210 HOM_105N211 HOM_105N212 HOM_105N213 HOM_105N214 ///
  HOM_105N216 HOM_105N217 HOM_105N218 HOM_105N219 HOM_105N220 ///
  HOM_105N221 HOM_105N296 HOM_105N288 HOM_105N299 HOM_105N2extra ///
  HOM_105N2_O HOM_105N30 HOM_105N31 HOM_105N32 HOM_105N33 HOM_105N34 ///
  HOM_105N35 HOM_105N36 HOM_105N37 HOM_105N38 HOM_105N315 HOM_105N39 ///
  HOM_105N310 HOM_105N311 HOM_105N312 HOM_105N313 HOM_105N314 HOM_105N316 ///
  HOM_105N317 HOM_105N318 HOM_105N319 HOM_105N320 HOM_105N321 HOM_105N322 ///
  HOM_105N323 HOM_105N324 HOM_105N325 HOM_105N396 HOM_105N388 HOM_105N399 ///
  HOM_105N3extra HOM_105N3_O HOM_105O2 HOM_105O3 HOM_105O4 HOM_105O5 ///
  HOM_105O6 HOM_105O7 HOM_105O8 HOM_105O9 HOM_105O10 HOM_105O11 ///
  HOM_105O12 HOM_105O13 HOM_105O14 HOM_105O15 HOM_105O16 HOM_105O17 ///
  HOM_105O18 HOM_105O19 HOM_105O20 HOM_105O21 HOM_105O22 HOM_105O23 ///
  HOM_105O24 HOM_105O25 HOM_105O26 HOM_105O27 HOM_105O96 HOM_105O88 ///
  HOM_105O99 HOM_105Oextra HOM_105O_O HOM_105P HOM_105Q1 HOM_105Q2 ///
  HOM_105Q3 HOM_105Q4 HOM_105Q5 HOM_105Q6 HOM_105Q7 HOM_105Q8 HOM_105Q9 ///
  HOM_105Q10 HOM_105Q11 HOM_105Q12 HOM_105Q13 HOM_105Q14 HOM_105Q15 ///
  HOM_105Q16 HOM_105Q17 HOM_105Q18 HOM_105Q19 HOM_105Q20 HOM_105Q21 ///
  HOM_105Q22 HOM_105Q23 HOM_105Q24 HOM_105Q25 HOM_105Q26 HOM_105Q27 ///
  HOM_105Q96 HOM_105Q88 HOM_105Q99 HOM_105Qextra HOM_105Q_O HOM_108A ///
  HOME_111D0 HOME_111D1 HOME_111D2 HOME_111D3 HOME_111D4 HOME_111D5 ///
  HOME_111D6 HOME_111D7 HOME_111D8 HOME_111D15 HOME_111D9 HOME_111D10 ///
  HOME_111D11 HOME_111D12 HOME_111D13 HOME_111D14 HOME_111D16 HOME_111D17 ///
  HOME_111D18 HOME_111D19 HOME_111D20 HOME_111D21 HOME_111D96 HOME_111D88 ///
  HOME_111D99 HOME_111Dextra HOME_111D_O HOM_121A HOM_124A ///
  HOM_switch_method_HOM HOM_switch_HOM_calc HOM_ideal_method_calc_HOM ///
  HOM_sterilization_date HOM_current_method_date ///
  HOM_ideal_method_from_counseling HOM_124_0 HOM_127D HOM_127D1 HOM_127E ///
  HOM_127F HOM_127F1 HOM_127F2_FN HOM_127F2_LN HOM_127F2_ON HOM_127G ///
  HOM_127H HOM_127H1 HOM_127H2_FN HOM_127H2_LN HOM_127H2_ON HOM_127I ///
  HOM_127J HOM_127K HOM_127L HOM_127L1 HOM_127L2_FN HOM_127L2_LN ///
  HOM_127L2_ON HOM_127F_minus_1 HOM_127F2_fullname HOM_127H_minus_1 ///
  HOM_127H2_fullname HOM_127L_minus_1 HOM_127L2_fullname HOM_112A ///
  HOM_112B HOM_112C HOM_112D HOM_112E_1 HOM_112E_2 HOM_113A HOM_113B ///
  HOM_113C HOM_114A HOM_114B HOM_114C HOM_114D HOM_1151 HOM_1152 HOM_1153 ///
  HOM_1154 HOM_1155 HOM_1156 HOM_1157 HOM_11596 HOM_11588 HOM_11599 ///
  HOM_115extra HOM_115_O HOM_1161 HOM_1162 HOM_1163 HOM_1164 HOM_1165 ///
  HOM_1166 HOM_1167 HOM_1168 HOM_1169 HOM_11610 HOM_11611 HOM_11696 ///
  HOM_11688 HOM_11699 HOM_116extra HOM_116_O HOM_CONF_ID HOM_120_1 HOM_dup
  
  * CLI
  drop  CLIN_number CLIN_PASSWORD CLIN_2_ID CLIN_3_ID CLIN_3_IDA ///
  CLIN_3_IDB CLIN_3_IDC CLIN_4 CLIN_4_ID CLIN_5 CLIN_6 CLIN_7 CLIN_ID_67_NO ///
  CLIN_5CLIN_8 CLIN_8_ID_NO CLIN_102Alatitudedegrees CLIN_102Alongitudedegrees ///
  CLIN_102Aaltitudemeters CLIN_102Aaccuracymeters CLIN_103B CLIN_104A ///
  CLIN_104B CLIN_105extra CLIN_105B ///
  CLIN_105B_O CLIN_105C CLIN_105C_O CLIN_105F CLIN_105G CLIN_105G_O ///
  CLIN_105H CLIN_105I CLIN_105J1 CLIN_105J2 CLIN_105J3 CLIN_105J4 ///
  CLIN_105J5 CLIN_105J6 CLIN_105J96 CLIN_105J88 CLIN_105J99 CLIN_105Jextra ///
  CLIN_105K CLIN_105L CLIN_106B CLIN_106C1 CLIN_106C2 CLIN_106C3 ///
  CLIN_106C4 CLIN_106C5 CLIN_106C6 CLIN_106C7 CLIN_106C8 CLIN_106C9 ///
  CLIN_106C10 CLIN_106C11 CLIN_106C12 CLIN_106C13 CLIN_106C14 CLIN_106C15 ///
  CLIN_106C16 CLIN_106C17 CLIN_106C18 CLIN_106C19 CLIN_106C20 CLIN_106C21 ///
  CLIN_106C22 CLIN_106C23 CLIN_106C24 CLIN_106C25 CLIN_106CW709A_2626 ///
  CLIN_106C27 CLIN_106C28 CLIN_106C96 CLIN_106C88 CLIN_106C99 CLIN_106C0 ///
  CLIN_106Cextra CLIN_106C_O CLIN_107B CLIN_107C1 CLIN_107C2 ///
  CLIN_107C3 CLIN_107C4 CLIN_107C5 CLIN_107C6 CLIN_107C7 CLIN_107C8 ///
  CLIN_107C9 CLIN_107C10 CLIN_107C11 CLIN_107C12 CLIN_107C13 CLIN_107C14 ///
  CLIN_107C15 CLIN_107C16 CLIN_107C17 CLIN_107C18 CLIN_107C19 CLIN_107C20 ///
  CLIN_107C21 CLIN_107C22 CLIN_107C23 CLIN_107C24 CLIN_107C25 ///
  CLIN_107CW709A_2626 CLIN_107C27 CLIN_107C28 CLIN_107C96 CLIN_107C88 ///
  CLIN_107C99 CLIN_107C0 CLIN_107Cextra CLIN_107C_O CLIN_108B ///
  CLIN_108C1 CLIN_108C2 CLIN_108C3 CLIN_108C4 CLIN_108C5 CLIN_108C6 ///
  CLIN_108C7 CLIN_108C8 CLIN_108C9 CLIN_108C10 CLIN_108C11 CLIN_108C12 ///
  CLIN_108C13 CLIN_108C14 CLIN_108C15 CLIN_108C16 CLIN_108C17 CLIN_108C18 ///
  CLIN_108C19 CLIN_108C20 CLIN_108C21 CLIN_108C22 CLIN_108C23 CLIN_108C24 ///
  CLIN_108C25 CLIN_108CW709A_2626 CLIN_108C27 CLIN_108C28 CLIN_108C96 ///
  CLIN_108C88 CLIN_108C99 CLIN_108C0 CLIN_108Cextra CLIN_108C_O CLIN_1091 ///
  CLIN_1092 CLIN_1093 CLIN_1094 CLIN_1095 CLIN_1096 CLIN_1097 CLIN_1098 ///
  CLIN_1099 CLIN_10910 CLIN_10911 CLIN_10912 CLIN_10913 CLIN_10914 ///
  CLIN_10999 CLIN_109extra CLIN_109B CLIN_110 CLIN_112 CLIN_113 CLIN_1141 ///
  CLIN_1142 CLIN_1143 CLIN_1144 CLIN_1145 CLIN_1146 CLIN_11496 CLIN_114extra ///
  CLIN_114_O CLIN_115 CLIN_116 CLIN_117 CLIN_120latitudedegrees ///
  CLIN_120longitudedegrees CLIN_120altitudemeters CLIN_120accuracymeters ///
  CLIN_121 CLIN_201 CLIN_202 CLIN_20311 CLIN_20312 CLIN_20313 CLIN_20314 ///
  CLIN_20315 CLIN_20322 CLIN_207 CLIN_207A ///
  CLIN_209 CLIN_211 CLIN_2123 CLIN_2124 CLIN_2125 CLIN_212_O CLIN_213 ///
  CLIN_214 CLIN_2151 CLIN_2152 CLIN_2153 CLIN_2154 CLIN_21596 CLIN_215extra ///
  CLIN_215_O CLIN_216 CLIN_218 CLIN_219 CLIN_2201 CLIN_2202 CLIN_2203 ///
  CLIN_2204 CLIN_2205 CLIN_22099 CLIN_220extra CLIN_221 CLIN_TRACK_INT_SIG ///
  CLIN_TRACK_COMMENT CLIN_wom_prim_phone CLIN_start_method_calc ///
  CLIN_ideal_cont_method_calc CLIN_end_refill_method_calc ///
  CLIN_number_of_visits CLIN_end_start_method_calc CLIN_fp_routine_amt ///
  CLIN_new_pregnancy_status CLIN_male_sterilized CLIN_driver_name ///
  CLIN_hhh_full_name CLIN_directions CLIN_current_method CLIN_tot_visit_amt ///
  CLIN_treatment CLIN_woman_id CLIN_attribute_3 CLIN_attribute_2 ///
  CLIN_attribute_1 CLIN_female_sterilized CLIN_switch_method_calc ///
  CLIN_visit_no CLIN_current_method1 CLIN_current_method_calc ///
  CLIN_def_fp_routine_amt CLIN_attribute_2_calc CLIN_seffects_method_calc ///
  CLIN_visit_urgency CLIN_tot_routine_remainder CLIN_end_seffects_method_calc ///
  CLIN_attribute_post_couns CLIN_current_use_fp CLIN_current_use_fp1 ///
  CLIN_ideal_cont_method CLIN_refill_method_calc CLIN_survey_id ///
  CLIN_attribute_1_calc CLIN_tot_nonfp_visit_amt CLIN_joint_counseling ///
  CLIN_wom_alt_phone CLIN_current_method_calc1 CLIN_youngest_child_name ///
  CLIN_wom_husb_name CLIN_woman_name CLIN_tot_fp_visit_amt ///
  CLIN_attribute_3_calc CLIN_woman_pid CLIN_case_propertiesgps ///
  CLIN_end_switch_method_calc CLIN_address CLIN_attribute_post_couns_calc ///
  CLIN_pregnancy_status CLIN_couns_dir CLIN_completed_time CLIN_started_time ///
  CLIN_username CLIN_received_on CLIN_form_link CLIN_userID CLIN_deviceID ///
  CLIN_locationlatitudedegrees CLIN_locationlongitudedegrees ///
  CLIN_locationaltitudemeters CLIN_locationaccuracymeters ///
  CLIN_case_name CLIN_210 CLIN_105J_O CLIN_210_E CLIN_104A_O ///
  CLIN_105D CLIN_105D_M CLIN_105D_Y CLIN_N_CLIN_105E CLIN_105E_Y ///
  CLIN_105E_M CLIN_105M11 CLIN_105M12 CLIN_105M13 CLIN_105M14 CLIN_105M22 ///
  CLIN_111C0 CLIN_111C1 CLIN_111C2 CLIN_111C3 CLIN_111C4 CLIN_111C5 ///
  CLIN_111C6 CLIN_111C7 CLIN_111C8 CLIN_111C9 CLIN_111C10 CLIN_111C11 ///
  CLIN_111C12 CLIN_111C13 CLIN_111C14 CLIN_111C15 CLIN_111C16 CLIN_111C99 ///
  CLIN_111Cextra CLIN_119A CLIN_119B CLIN_119C CLIN_207B0 CLIN_207B1 ///
  CLIN_207B2 CLIN_207B3 CLIN_207B4 CLIN_207B5 CLIN_207B6 CLIN_207B7 CLIN_207B8 ///
  CLIN_207B15 CLIN_207B9 CLIN_207B10 CLIN_207B11 CLIN_207B12 CLIN_207B13 ///
  CLIN_207B14 CLIN_207B16 CLIN_207B17 CLIN_207B18 CLIN_207B19 CLIN_207B20 ///
  CLIN_207B21 CLIN_207B96 CLIN_207B88 CLIN_207B99 CLIN_207Bextra ///
  CLIN_CLIC_207B_O CLIN_2081 CLIN_2082 CLIN_2083 CLIN_2084 CLIN_2085 ///
  CLIN_2086 CLIN_2087 CLIN_2088 CLIN_20896 CLIN_208extra CLIN_208_O ///
  CLIN_sterilization_date CLIN_current_method_date CLIN_111A_O ///
  CLIN_111B CLIN_101A CLIN_101B CLIN_218Alatitudedegrees ///
  CLIN_218Alongitudedegrees CLIN_218Aaltitudemeters ///
  CLIN_218Aaccuracymeters CLIN_112A CLIN_115A CLIN_111D CLIN_111A ///
  CLIN_STER_DATE_ERR CLIN_CURR_DATE_ERR CLIN_SWITCH_ERR CLIN_115_0 ///
  CLIN_119F_minus_1 CLIN_119F2_fullname CLIN_119H_minus_1 ///
  CLIN_119H2_fullname CLIN_119L_minus_1 CLIN_119L2_fullname ///
  CLIN_119D CLIN_119D1 CLIN_119E CLIN_119F CLIN_119F1 CLIN_119F2_FN ///
  CLIN_119F2_LN CLIN_119F2_ON CLIN_119G CLIN_119H CLIN_119H1 ///
  CLIN_119H2_FN CLIN_119H2_LN CLIN_119H2_ON CLIN_119I CLIN_119J ///
  CLIN_119K CLIN_119L CLIN_119L1 CLIN_119L2_FN CLIN_119L2_LN ///
  CLIN_119L2_ON CLIN_122A CLIN_122B CLIN_122C CLIN_122D CLIN_122E ///
  CLIN_122E_2 CLIN_123A CLIN_123B CLIN_123C CLIN_123D CLIN_123E ///
  CLIN_123F CLIN_123G CLIN_123H1 CLIN_123H2 CLIN_123H3 CLIN_123H4 ///
  CLIN_123H5 CLIN_123H6 CLIN_123H7 CLIN_123H96 CLIN_123H88 CLIN_123H99 ///
  CLIN_123Hextra CLIN_123H_O CLIN_123J1 CLIN_123J2 CLIN_123J3 CLIN_123J4 ///
  CLIN_123J5 CLIN_123J6 CLIN_123J7 CLIN_123J8 CLIN_123J9 CLIN_123J10 ///
  CLIN_123J11 CLIN_123J96 CLIN_123J88 CLIN_123J99 CLIN_123Jextra ///
  CLIN_123J_O CLIN_couns_name CLIN_couns_date CLIN_base_enum_name ///
  CLIN_base_enumid CLIN_woman_baseline_date CLIN_fo_baseline_date ///
  CLIN_dup CLIN_no_visits
  
  * Miscellaneous variables
  drop  dateofinterview head_male head_birthdate head_age woman_birthdate /// 
  woman_birthdate_temp woman_age problem husband_birthdate husband_age ///
  wom_work_type wom_pay_method tot_child yng_birthdate yng_birthdate_temp ///
  yng_age start_method_date use_spell w1_w03_w320 w1_w03_w33428 ///
  w1_w03_w3364 w1_w03_w3365 w1_w03_w3366 ///
  w1_w03_w3367 attribute_1 attribute_1_wgt w1_w03_attribute_11 ///
  w1_w03_attribute_12 w1_w03_attribute_13 w1_w03_attribute_14 ///
  w1_w03_attribute_15 w1_w03_attribute_16 w1_w03_attribute_17 ///
  w1_w03_attribute_18 w1_w03_attribute_19 w1_w03_attribute_110 ///
  w1_w03_attribute_111 w1_w03_attribute_112 w1_w03_attribute_113 ///
  w1_w03_attribute_114 w1_w03_attribute_115 w1_w03_attribute_116 ///
  w1_w03_attribute_117 w1_w03_attribute_118 w1_w03_attribute_119 ///
  w1_w03_attribute_120 w1_w03_attribute_121 w1_w03_attribute_196 ///
  top_attribute_freq first_cohab_date cohab_age space_time boy_ratio ///
  girl_ratio any_gender_ratio husband_work wom_aut_901 wom_aut_902 ///
  wom_aut_903 wom_aut_905 wom_aut_906 wom_aut_908 wom_aut_909 ///
  wom_aut_904 woman_autonamy coun_start_date coun_start_time ///
  COUN_HUSB_209N5 coun_husb_start_date coun_husb_start_time ///
  coun_intro_time COUN__HUSB_128C28 COUN__HUSB_1221 COUN__HUSB_1222 ///
  COUN_flipchart_color_SHORT flipchart_color_freq ///
  HUSB_coun_start_date husb_counseling_start_dt ///
  counseling_time counseling_time2 ///
  counseling_time3 x y z COUN_3082 PHO_DATE ///
  PHO_start_date start_date_nostop PHO_spell PHO_105N326 ///
  PHO_105N327 PHO_105N328 HOME_start_date HOME_start_time ///
  start_date_nostop_hom HOME_spell HOM_105N326 HOM_105N327 ///
  HOM_105N328 home_end_time CLIN_start_date CLIN_start_time ///
  CLIN_request_time start_date_nostop_CLIN CLIN_spell ///
  reach_clinic_time finish_visit_time clinic_visit_time ///
  counseling_end_date counseling_start_date counseling_time_husb_sec CLIN_ideal_method_from_coun
  
  order COUN_3081, before(COUN_311)
  order counselor counseling_start_dt counseling_comp_dt, after(COUN__FV_1)
  order COUN_124*, after(COUN_123)
  
  label var HUSB_T "Partner Invitation"
  label var SHORT_T "Tailored Counseling"
  label var w1_hh1_r_hr_7b_h "How old is the household head?"

  * Labelling of variables
 label variable w1_hh1_birth_date "Woman birth date at HH Roster"
 label variable w1_hh1_birth_date1 "Household Head birth date at HH Roster"
 label variable w1_hh1_birth_date2 "Husband birth date at HH Roster"

  label var w1_hh1_woman_age "Women's age (asked in the HH section)"
  label var w1_w01_wom_work "Woman's work status"
  label var w1_w01_case_area "Woman's area of residence" 
  label var w1_w01_woman_birth_date  "Woman's birth date (asked in section 1)"
  label var w1_w01_new_woman_age  "Woman's age (new)"

  label var w1_w02_total_children_alive  "Woman's total number of alive children"
  label var counseling_start_dt "Counseling start time"
  label var counseling_comp_dt "Counseling end time"
label var w1_w03_total_num_attribute "Total number of chosen attributes"
label var w1_w03_attribute_2 "Second attribute from baseline"
label var w1_w03_attribute_3 "Third attribute from baseline"

foreach var of varlist  w1_w03_w3321 w1_w03_w3323 w1_w03_w3324 w1_w03_w3325 w1_w03_w3326 w1_w03_w3327 w1_w03_w33211 w1_w03_w33215 w1_w03_w33216{
	local u: var label `var'
	local m = "Method to switch to: " + "`u'"
	label var `var' "`m'"
}

foreach var of varlist  w1_w03_w3043 w1_w03_w3044 w1_w03_w3045 w1_w03_w3046 w1_w03_w3047 w1_w03_w30411 w1_w03_w30414 w1_w03_w30416{
	local u: var label `var'
	local u: subinstr local u "current: " "Woman's current method at BL: "
	label var `var' "`u'"
}

	capture label drop yesno1
	label define yesno1 1 "Yes" 2 "No"
label val  w1_hh1_ew_hhh_conf yesno1
	capture label drop yesno
	label define yesno 1 "Yes" 0 "No"
	
label var w1_w03_w336 "Most important attributes in chooseing a contracecptive method"
label var w1_w03_w336_o "Other, specify"
label var w1_w03_w338_1_1extra "First most important method attribute"
label var w1_w03_w338_2_1extra "Second most important method attribute"
label var w1_w03_w338_3_1extra "Third most important method attribute"
label var w1_hh1_ew_hhh_conf "Confirmation: Eligible woman is household head"
label var w1_w01_w_102_conf "Age confirmation: Age reported earlier is correct"

label var w1_w02_w202 "Do you have any sons or daughters to whom you have given birth who are now living with you?" 
label var w1_w02_w204 "Do you have any sons or daughters to whom you have given birth who are alive but do not live with you?" 
label var w1_w02_w205_m "How many sons are alive but do not live with you?"
label var w1_w02_w205_f "How many daughters are alive but do not live with you?"
label var w1_w02_w_203_m "How many sons live with you?"
label var w1_w02_w_203_f "How many daughters live with you?"

label var w1_w03_w313 "Have you ever used anything or tried in any way to delay or avoid getting pregnant?"
order w1_w03_w338b1 w1_w03_w338b3 w1_w03_w338b4 w1_w03_w338b5 w1_w03_w338b6 w1_w03_w338b7, before(w1_w03_w338b14)
label var w1_w03_w343 "Women's Knowledge about best spacing"
label var w1_treatment "Treatment Status (0=Control, 1=T1, 2=T2, 3=T3)"
label var COUN__treatment "Treatment Status at counseling (0=Control, 1=T1, 2=T2, 3=T3)"

label var w1_w06_w609 "Have you been married or lived with a man only once or more than once?" 
label var w1_w06_w610_a_m "In what month and year did you start living with your partner" 
label var w1_w06_w610_a_y "In what year did you start living with your partner?" 
label var w1_w06_w610_b_m "In what month and year did you start living with your first partner?" 
label var w1_w06_w610_b_y "In what year did you start living with your first partner?"

label var counselor "Counselor name"
order w1_w03_attribute_1 w1_w03_attribute_2 w1_w03_attribute_3, after(w1_w03_total_num_attribute)
label var mergeCLI "Merging with clinic visit data set (1=master only, 2=using only, 3=matched)"
label var mergeHOM "Merging with home visit data (1=master only, 2=using only, 3=matched)"
label var mergePHO "Merging with phone survey data (1=master only, 2=using only, 3=matched)"
label var mergeCVF "Merging with counseling data(1=master only, 2=using only, 3=matched)"
label var w1_mergeRand "Merging with randomization data set (1=master only, 2=using only, 3=matched)"
 
 label var COUN_129 "Stated ideal contraceptive method before counseling"
 label var COUN_303 "Stated ideal contraceptive method after counseling"
 label var PHO_111 "PHONE: Woman's ideal contraceptive method"
 label var HOM_111 "HOME: Woman's ideal contraceptive method"
 label var PHO_REC_1 "Woman is available for the phone survey"
 label var PHO_REC_4 "Woman consents to participate in the phone survey"
 label var PHO_104 "PHONE: Currently using a contraceptive method"
 label var PHO_118 "PHONE: Woman went to Kauma clinic or any other clinic to pick up FP services in the past month"
 label var PHO_138 "Anyone was present during the phone survey besides the woman?"

 label var PHO_13999 "OTHER"
 foreach var of varlist  PHO_1391 PHO_1392 PHO_1393 PHO_1394 PHO_1395 PHO_13999{
	local u: var label `var'
	local m = "People who were with the woman during the phone survey: " + substr("`u'", 1, 1) + lower(substr("`u'", 2, .))
	label var `var' "`m'"
 }

  foreach var of varlist w1_w03_w308b{
	local u: var label `var'
	local m = "`u'" + " (Record number of months)"
	label var `var' "`m'"
 }

 label var HOM_REC_1 "Woman is available for the home visit survey"
 label var HOME_REV_20 "Woman consents to participate in the home survey"
 label var HOME_104 "HOME: Currently using a contraceptive method"
 label var HOME_118 "HOME: Woman went to Kauma clinic or any other clinic to pick up FP services in the past month"
 label var HOME_138 "Anyone was present during the home survey besides the woman?"
 label var HOME_1391 "Partner was with woman during the home survey"
 label var HOM_105N "HOME: Woman would switch to another method given a chance"

 order COUN_126 COUN_127* COUN_129 COUN_130extra COUN_131 COUN_201A COUN_201B, before(COUN_207)
 order PHO_105* PHO_105N1*, after(PHO_104)
 order HOME_105* HOM_105N*, after(HOME_104)
 order HOM_111, before(HOME_118)
 
  *  w1_w03_w338b1 w1_w03_w338b3 w1_w03_w338b4 w1_w03_w338b5 w1_w03_w338b6 w1_w03_w338b7 w1_w03_w338b14
 		label var w1_w03_w338b1 "Want to use: FEMALE STERILIZATION"

		label var w1_w03_w338b3 "Want to use: IUD"

		label var w1_w03_w338b4 "Want to use: INJECTABLES"

		label var w1_w03_w338b5 "Want to use: IMPLANTS"

		label var w1_w03_w338b6 "Want to use: PILL"

		label var w1_w03_w338b7 "Want to use: CONDOM"

		label var w1_w03_w338b14 "Want to use: WITHDRAWAL"

 *  COUN_1241 COUN_1242 COUN_1243 COUN_1244 COUN_1245 COUN_1246 COUN_1247 COUN_1248 COUN_1249 COUN_12410 COUN_12411 COUN_12412 COUN_12413 COUN_12414 COUN_12415 COUN_12416
  		label var COUN_1241 "Current method at counseling: FEMALE STERILIZATION"

		label var COUN_1242 "Current method at counseling: MALE STERILIZATION"

		label var COUN_1243 "Current method at counseling: IUD"

		label var COUN_1244 "Current method at counseling: INJECTABLES"

		label var COUN_1245 "Current method at counseling: IMPLANTS"

		label var COUN_1246 "Current method at counseling: PILL"

		label var COUN_1247 "Current method at counseling: CONDOM"

		label var COUN_1248 "Current method at counseling: FEMALE CONDOM"

		label var COUN_1249 "Current method at counseling: DIAPHRAGM / FOAM / JELLY"

		label var COUN_12410 "Current method at counseling: TWO DAY METHOD"

		label var COUN_12411 "Current method at counseling: STANDARD DAYS METHOD"

		label var COUN_12412 "Current method at counseling: LACTATIONAL AMENORRHEA METHOD"

		label var COUN_12413 "Current method at counseling: RHYTHM METHOD"
		
		label var COUN_12414 "Current method at counseling: WITHDRAWAL"

		label var COUN_12415 "Current method at counseling: OTHER MODERN METHOD"

		label var COUN_12416 "Current method at counseling: OTHER TRADITIONAL METHOD"
 
 *  COUN_1271 COUN_1272 COUN_1273 COUN_1274 COUN_1275 COUN_1276 COUN_1277 COUN_1278 COUN_1279 COUN_12710 COUN_12711 COUN_12712 COUN_12713 COUN_12714 COUN_12715 COUN_12716
   		label var COUN_1271 "Method to switch to at counseling: FEMALE STERILIZATION"

		label var COUN_1272 "Method to switch to at counseling: MALE STERILIZATION"

		label var COUN_1273 "Method to switch to at counseling: IUD"

		label var COUN_1274 "Method to switch to at counseling: INJECTABLES"

		label var COUN_1275 "Method to switch to at counseling: IMPLANTS"

		label var COUN_1276 "Method to switch to at counseling: PILL"

		label var COUN_1277 "Method to switch to at counseling: CONDOM"

		label var COUN_1278 "Method to switch to at counseling: FEMALE CONDOM"

		label var COUN_1279 "Method to switch to at counseling: DIAPHRAGM / FOAM / JELLY"

		label var COUN_12710 "Method to switch to at counseling: TWO DAY METHOD"

		label var COUN_12711 "Method to switch to at counseling: STANDARD DAYS METHOD"

		label var COUN_12712 "Method to switch to at counseling: LACTATIONAL AMENORRHEA METHOD"

		label var COUN_12713 "Method to switch to at counseling: RHYTHM METHOD"
		
		label var COUN_12714 "Method to switch to at counseling: WITHDRAWAL"

		label var COUN_12715 "Method to switch to at counseling: OTHER MODERN METHOD"

		label var COUN_12716 "Method to switch to at counseling: OTHER TRADITIONAL METHOD"
 
 *  COUN__HUSB_1210 COUN__HUSB_1211 COUN__HUSB_1212 COUN__HUSB_1213 COUN__HUSB_1214 COUN__HUSB_1215 COUN__HUSB_1216 COUN__HUSB_1217 COUN__HUSB_1218 COUN__HUSB_1219 COUN__HUSB_12110 COUN__HUSB_12111 COUN__HUSB_12112 COUN__HUSB_12113 COUN__HUSB_12114 COUN__HUSB_12115 COUN__HUSB_12116
   		label var COUN__HUSB_1210 "Husband's ideal method at counseling: NONE"

		label var COUN__HUSB_1211 "Husband's ideal method at counseling: FEMALE STERILIZATION"

		label var COUN__HUSB_1212 "Husband's ideal method at counseling: MALE STERILIZATION"

		label var COUN__HUSB_1213 "Husband's ideal method at counseling: IUD"

		label var COUN__HUSB_1214 "Husband's ideal method at counseling: INJECTABLES"

		label var COUN__HUSB_1215 "Husband's ideal method at counseling: IMPLANTS"

		label var COUN__HUSB_1216 "Husband's ideal method at counseling: PILL"

		label var COUN__HUSB_1217 "Husband's ideal method at counseling: CONDOM"

		label var COUN__HUSB_1218 "Husband's ideal method at counseling: FEMALE CONDOM"

		label var COUN__HUSB_1219 "Husband's ideal method at counseling: DIAPHRAGM / FOAM / JELLY"

		label var COUN__HUSB_12110 "Husband's ideal method at counseling: TWO DAY METHOD"

		label var COUN__HUSB_12111 "Husband's ideal method at counseling: STANDARD DAYS METHOD"

		label var COUN__HUSB_12112 "Husband's ideal method at counseling: LACTATIONAL AMENORRHEA METHOD"

		label var COUN__HUSB_12113 "Husband's ideal method at counseling: RHYTHM METHOD"
		
		label var COUN__HUSB_12114 "Husband's ideal method at counseling: WITHDRAWAL"

		label var COUN__HUSB_12115 "Husband's ideal method at counseling: OTHER MODERN METHOD"

		label var COUN__HUSB_12116 "Husband's ideal method at counseling: OTHER TRADITIONAL METHOD"
 
		label var COUN__HUSB_122 "Husband's most valued method attribute in choosing a contraceptive method"
		
 *  PHO_1051 PHO_1052 PHO_1053 PHO_1054 PHO_1055 PHO_1056 PHO_1057 PHO_1058 PHO_1059 PHO_10510 PHO_10511 PHO_10512 PHO_10513 PHO_10514 PHO_10515 PHO_10516
    	label var PHO_1051 "Current method during phone surveys: FEMALE STERILIZATION"

		label var PHO_1052 "Current method during phone surveys: MALE STERILIZATION"

		label var PHO_1053 "Current method during phone surveys: IUD"

		label var PHO_1054 "Current method during phone surveys: INJECTABLES"

		label var PHO_1055 "Current method during phone surveys: IMPLANTS"

		label var PHO_1056 "Current method during phone surveys: PILL"

		label var PHO_1057 "Current method during phone surveys: CONDOM"

		label var PHO_1058 "Current method during phone surveys: FEMALE CONDOM"

		label var PHO_1059 "Current method during phone surveys: DIAPHRAGM / FOAM / JELLY"

		label var PHO_10510 "Current method during phone surveys: TWO DAY METHOD"

		label var PHO_10511 "Current method during phone surveys: STANDARD DAYS METHOD"

		label var PHO_10512 "Current method during phone surveys: LACTATIONAL AMENORRHEA METHOD"

		label var PHO_10513 "Current method during phone surveys: RHYTHM METHOD"
		
		label var PHO_10514 "Current method during phone surveys: WITHDRAWAL"

		label var PHO_10515 "Current method during phone surveys: OTHER MODERN METHOD"

		label var PHO_10516 "Current method during phone surveys: OTHER TRADITIONAL METHOD"
 
 label var PHO_105N "PHONE: Woman would like to switch to another contraceptive method if given the chance"
 *  PHO_105N PHO_105N11 PHO_105N12 PHO_105N13 PHO_105N14 PHO_105N15 PHO_105N16 PHO_105N17 PHO_105N18 PHO_105N19 PHO_105N110 PHO_105N111 PHO_105N112 PHO_105N113 PHO_105N114 PHO_105N115 PHO_105N116
     	label var PHO_105N11 "Method to switch to during phone surveys: FEMALE STERILIZATION"

		label var PHO_105N12 "Method to switch to during phone surveys: MALE STERILIZATION"

		label var PHO_105N13 "Method to switch to during phone surveys: IUD"

		label var PHO_105N14 "Method to switch to during phone surveys: INJECTABLES"

		label var PHO_105N15 "Method to switch to during phone surveys: IMPLANTS"

		label var PHO_105N16 "Method to switch to during phone surveys: PILL"

		label var PHO_105N17 "Method to switch to during phone surveys: CONDOM"

		label var PHO_105N18 "Method to switch to during phone surveys: FEMALE CONDOM"

		label var PHO_105N19 "Method to switch to during phone surveys: DIAPHRAGM / FOAM / JELLY"

		label var PHO_105N110 "Method to switch to during phone surveys: TWO DAY METHOD"

		label var PHO_105N111 "Method to switch to during phone surveys: STANDARD DAYS METHOD"

		label var PHO_105N112 "Method to switch to during phone surveys: LACTATIONAL AMENORRHEA METHOD"

		label var PHO_105N113 "Method to switch to during phone surveys: RHYTHM METHOD"
		
		label var PHO_105N114 "Method to switch to during phone surveys: WITHDRAWAL"

		label var PHO_105N115 "Method to switch to during phone surveys: OTHER MODERN METHOD"

		label var PHO_105N116 "Method to switch to during phone surveys: OTHER TRADITIONAL METHOD"
 
 * HOME_1051 HOME_1052 HOME_1053 HOME_1054 HOME_1055 HOME_1056 HOME_1057 HOME_1058 HOME_1059 HOME_10510 HOME_10511 HOME_10512 HOME_10513 HOME_10514 HOME_10515 HOME_10516
     	label var HOME_1051 "Current method during home surveys: FEMALE STERILIZATION"

		label var HOME_1052 "Current method during home surveys: MALE STERILIZATION"

		label var HOME_1053 "Current method during home surveys: IUD"

		label var HOME_1054 "Current method during home surveys: INJECTABLES"

		label var HOME_1055 "Current method during home surveys: IMPLANTS"

		label var HOME_1056 "Current method during home surveys: PILL"

		label var HOME_1057 "Current method during home surveys: CONDOM"

		label var HOME_1058 "Current method during home surveys: FEMALE CONDOM"

		label var HOME_1059 "Current method during home surveys: DIAPHRAGM / FOAM / JELLY"

		label var HOME_10510 "Current method during home surveys: TWO DAY METHOD"

		label var HOME_10511 "Current method during home surveys: STANDARD DAYS METHOD"

		label var HOME_10512 "Current method during home surveys: LACTATIONAL AMENORRHEA METHOD"

		label var HOME_10513 "Current method during home surveys: RHYTHM METHOD"
		
		label var HOME_10514 "Current method during home surveys: WITHDRAWAL"

		label var HOME_10515 "Current method during home surveys: OTHER MODERN METHOD"

		label var HOME_10516 "Current method during home surveys: OTHER TRADITIONAL METHOD"
 
 *  HOM_105N11 HOM_105N12 HOM_105N13 HOM_105N14 HOM_105N15 HOM_105N16 HOM_105N17 HOM_105N18 HOM_105N19 HOM_105N110 HOM_105N111 HOM_105N112 HOM_105N113 HOM_105N114 HOM_105N115 HOM_105N116
      	label var HOM_105N11 "Method to switch to during home surveys: FEMALE STERILIZATION"

		label var HOM_105N12 "Method to switch to during home surveys: MALE STERILIZATION"

		label var HOM_105N13 "Method to switch to during home surveys: IUD"

		label var HOM_105N14 "Method to switch to during home surveys: INJECTABLES"

		label var HOM_105N15 "Method to switch to during home surveys: IMPLANTS"

		label var HOM_105N16 "Method to switch to during home surveys: PILL"

		label var HOM_105N17 "Method to switch to during home surveys: CONDOM"

		label var HOM_105N18 "Method to switch to during home surveys: FEMALE CONDOM"

		label var HOM_105N19 "Method to switch to during home surveys: DIAPHRAGM / FOAM / JELLY"

		label var HOM_105N110 "Method to switch to during home surveys: TWO DAY METHOD"

		label var HOM_105N111 "Method to switch to during home surveys: STANDARD DAYS METHOD"

		label var HOM_105N112 "Method to switch to during home surveys: LACTATIONAL AMENORRHEA METHOD"

		label var HOM_105N113 "Method to switch to during home surveys: RHYTHM METHOD"
		
		label var HOM_105N114 "Method to switch to during home surveys: WITHDRAWAL"

		label var HOM_105N115 "Method to switch to during home surveys: OTHER MODERN METHOD"

		label var HOM_105N116 "Method to switch to during home surveys: OTHER TRADITIONAL METHOD"
 
 *  CLIN_1051 CLIN_1052 CLIN_1053 CLIN_1054 CLIN_1055 CLIN_1056 CLIN_1057 CLIN_1058 CLIN_1059 CLIN_10510 CLIN_10511 CLIN_10512 CLIN_10513 CLIN_10514 CLIN_10515 CLIN_10516
     	label var CLIN_1051 "Current method at time of clinic visit: FEMALE STERILIZATION"

		label var CLIN_1052 "Current method at time of clinic visit: MALE STERILIZATION"

		label var CLIN_1053 "Current method at time of clinic visit: IUD"

		label var CLIN_1054 "Current method at time of clinic visit: INJECTABLES"

		label var CLIN_1055 "Current method at time of clinic visit: IMPLANTS"

		label var CLIN_1056 "Current method at time of clinic visit: PILL"

		label var CLIN_1057 "Current method at time of clinic visit: CONDOM"

		label var CLIN_1058 "Current method at time of clinic visit: FEMALE CONDOM"

		label var CLIN_1059 "Current method at time of clinic visit: DIAPHRAGM / FOAM / JELLY"

		label var CLIN_10510 "Current method at time of clinic visit: TWO DAY METHOD"

		label var CLIN_10511 "Current method at time of clinic visit: STANDARD DAYS METHOD"

		label var CLIN_10512 "Current method at time of clinic visit: LACTATIONAL AMENORRHEA METHOD"

		label var CLIN_10513 "Current method at time of clinic visit: RHYTHM METHOD"
		
		label var CLIN_10514 "Current method at time of clinic visit: WITHDRAWAL"

		label var CLIN_10515 "Current method at time of clinic visit: OTHER MODERN METHOD"

		label var CLIN_10516 "Current method at time of clinic visit: OTHER TRADITIONAL METHOD"
		label var COUN__HUSB_101A "RECORD DATE: Before asking husband questions"
		label var COUN__HUSB_101B "RECORD TIME: Before asking husband questions"
 * Value labelling
 order caseid, before(district)
label val w1_w01_w_102_conf w1_w01_w104 yes

	capture label drop HUSB_T
	label define HUSB_T 1 "Husband Invitation" 0 "No Husband Invitation"
label val HUSB_T HUSB_T
	capture label drop SHORT_T
	label define SHORT_T 1 "Tailored counseling" 0 "Standard long counseling"
label val SHORT_T SHORT_T

foreach var of varlist HOM_105N11-HOM_105N116{
	ta `var'
}

	capture label drop month
label define month 1 "January" 2 "February" 3 "March" 4 "April" 5 "May" 6 "June" 7 "July" ///
	8 "August" 9 "September" 10 "October" 11 "November" 12 "December"
label val w1_w06_w610_a_m w1_w06_w610_b_m month

label val w1_w03_attribute_3 w1_w03_attribute_2 attributes
label val  w1_w03_w338_1_1extra w1_w03_w338_2_1extra w1_w03_w338_3_1extra attributes

	capture label drop work_status
	label define work_status 1 "Working" 0 "Not working"
label val w1_w01_wom_work work_status

* Create the required variables and only keep the used variables, drop the raw variables
* 1) Contraceptive use
tab w1_w03_w303
tab w1_w03_w313
label val w1_w03_w303 yesno

capture drop curr_use ever_use cont_use
gen curr_use = w1_w03_w303
gen ever_use = w1_w03_w313

gen cont_use = (curr_use==1 | ever_use==1) if !missing(curr_use) | !missing(ever_use)

label var ever_use "Ever used a contraceptive method"

* 2) Contraceptive use - 1
replace w1_w03_w303 = 97 if w1_w03_w303 ==.
	capture drop cont_use1
gen cont_use1 = w1_w03_w303 == 1 //used to randomize files
replace cont_use = 0 if w1_w03_w308b > 5 & w1_w03_w3044 == 1
replace cont_use1 = 0 if w1_w03_w308b > 5 & w1_w03_w3044 == 1
label val ever_use curr_use cont_use cont_use1 yesno
label var cont_use1 "Contraceptive use at the moment (updated)"

* 3) Effectiveness being the top attribute
gen eff_attribute = w1_w03_attribute_1==1
tab eff_attribute // 0 - 312, 1 - 353
	label var eff_attribute "Top method attribute being effectiveness (1=Yes, 0=No)"
	label val eff_attribute yesno

* 4) Age
gen age_binary = w1_hh1_woman_age <=26 
	label var age_binary "Woman's age not older than 26"
	label val age_binary yesno
	
* 5) top 1 attribute: effectiveness or not?
	capture drop top_attribute
gen top_attribute = (w1_w03_attribute_1 == 1) if !missing(w1_w03_attribute_1)
	label val top_attribute yesno
	
* 6) Woman's Age
rename w1_w01_new_woman_age age
label variable w1_hh1_birth_date "Woman birth date at HH Roster"
label variable w1_hh1_birth_date1 "Household Head birth date at HH Roster"
label variable w1_hh1_birth_date2 "Added - Husband birth date at HH Roster"
* fill out the age who did not reach Section 1 (Respondent Background), thus does not have woman_new_age
replace age = w1_hh1_woman_age if missing(age) & !missing(w1_hh1_woman_age)
* fill the age if woman is household head --> women's age is hhh age for the two women
tab age if w1_hh1_ew_hhh_conf == 1 //what is the age of the household head women?
tab w1_hh1_r_hr_7b_h if w1_hh1_ew_hhh_conf == 1 // what is the household head age for the women who reported themselves as hhh?

* 7) Area
rename w1_w01_case_area w1_area

* 8) Total Children Alive - 777 women reached section 2
rename w1_w02_total_children_alive w1_tot_child
tab w1_tot_child

* 8) Woman's Education
tab w1_w01_w105 //what is the highest level of education have you attained
tab w1_w01_w104 //10 no education, 730 have received education
	capture drop wom_educ
gen wom_educ = 0 if w1_w01_w104== 0
replace wom_educ = w1_w01_w105 if w1_w01_w104==1
tab wom_educ

	drop w1_w01_w104 w1_w01_w105
	capture label drop education
label define education 0 "No education" ///
					   1 "Primary" ///
					   2 "Secondary" ///
					   3 "Higher"
label val wom_educ education

* 9) Woman's Work
	capture drop wom_work
gen wom_work = w1_w01_wom_work
	drop w1_w01_wom_work
	label val wom_work yesno

* 10) Date of first cohabitation with man - 756 women reached section 6
	capture drop first_cohab_date
gen first_cohab_date = mdy(w1_w06_w610_a_m, 1, w1_w06_w610_a_y) if w1_w06_w610_a_y!=8888 & w1_w06_w610_a_y!= 9999 & w1_w06_w609==1
replace first_cohab_date = mdy(w1_w06_w610_b_m,1, w1_w06_w610_b_y) if w1_w06_w610_b_y!=8888 & w1_w06_w610_b_y != 9999 & w1_w06_w609==0
format first_cohab_date %td

***** correct women's birth date if their first reported dates were wrong
replace w1_hh1_birth_date=w1_w01_woman_birth_date if w1_w01_w_102_conf==2
***** correct women's birth date by replacing with HHH's birth date if they are HHH
replace w1_hh1_birth_date=w1_hh1_birth_date1 if missing(w1_hh1_birth_date) & !missing(w1_hh1_birth_date1)

	capture drop woman_birthdate
todate w1_hh1_birth_date, generate(woman_birthdate) p(yyyymmdd)
	capture drop dateofinterview
todate w1_w01_wid_3, generate(dateofinterview) p(yyyymmdd)
	drop w1_w01_wid_3 w1_hh1_birth_date w1_hh1_birth_date1 w1_w01_w_102_conf w1_w01_woman_birth_date
	
*ssc install personage
*drop cohab_age
	capture drop cohab_age
personage woman_birthdate first_cohab_date, gen(cohab_age)
	label var woman_birthdate "Woman's birth date"
	label var dateofinterview "Date of interview"
	
personage first_cohab_date dateofinterview, gen(cohab_time)
	gen cohab_longer8 = (cohab_time > 8) if !mi(cohab_time)
	drop first_cohab_date
	drop dateofinterview woman_birthdate
* 14) want to switch methods? - for 679 women currently using methods
tab w1_w03_w331
gen want_to_switch = w1_w03_w331
	label var want_to_switch "Wants to switch to another contraceptive method at BL (1=Yes)"
	label val want_to_switch yesno

* 15) Generate a measure for stickiness to an attribute (the more weight put into the first attribute, we say the more sticky 
* the woman's preference is)
gen top_attribute_wgt = 20 if w1_w03_total_num_attribute == 1 
*429
replace top_attribute_wgt = w1_w03_w338_1_2 if missing(top_attribute_wgt) & !missing(w1_w03_w338_1_2)
*307
tab top_attribute_wgt

* 16) Husband's supportiveness - 774/782 reached section 9
clonevar HUSB_supp = w1_w09_w928

	tab ethnicity
gen ethnicity_Chewa = (ethnicity == 1 & !missing(ethnicity)) 
	tab ethnicity_Chewa
	lab var ethnicity_Chewa "ethnicity=Chewa"
	drop ethnicity

* wom_des_fam_size
	capture drop wom_des_fam_size
gen wom_des_fam_size = w1_w07_w712a
replace wom_des_fam_size = w1_w07_w712b if missing(wom_des_fam_size) & !missing(w1_w07_w712b)
label variable wom_des_fam_size "Women's Desired Num of Children"
	drop w1_w07_w712a w1_w07_w712b

* 18) Husband's attitude towards FP at Baseline
tab w1_w09_w928
capture drop BASE_husb_FP
clonevar BASE_husb_FP = w1_w09_w928
replace BASE_husb_FP = 6 - BASE_husb_FP 
tab BASE_husb_FP
	drop w1_w09_w928

	* ===== correct for data issues ======
	replace w1_area = area - 100 if mi(w1_area) & !mi(area) //136 36
	replace w1_area = area - 100 if !mi(w1_area) & !mi(area) & !(area - 100 == w1_area) // 2 more
	assert w1_area == area - 100
		sum w1_area area
			
	capture drop tot_child
		
		gen tot_child = 0
		replace tot_child = w1_w02_w_203_m + w1_w02_w_203_f if w1_w02_w202 == 1 //724
		replace tot_child = tot_child + w1_w02_w205_m + w1_w02_w205_f if w1_w02_w204 == 1
		
*======================================== DEFINE METHODS ========================================================	

* Baseline want to switch:
		tab w1_w03_w331 //249 out of 679 yes (36.67%)
		
* ===== correct for data issues ======
replace w1_area = area - 100 if mi(w1_area) & !mi(area) //136 36
replace w1_area = area - 100 if !mi(w1_area) & !mi(area) & !(area - 100 == w1_area) // 2 more
assert w1_area == area - 100
	sum w1_area area
		
capture drop tot_child
	
	gen tot_child = 0
	replace tot_child = w1_w02_w_203_m + w1_w02_w_203_f if w1_w02_w202 == 1 //724
	replace tot_child = tot_child + w1_w02_w205_m + w1_w02_w205_f if w1_w02_w204 == 1
	drop w1_w02_w_203_m w1_w02_w_203_f w1_w02_w205_m w1_w02_w205_f w1_w02_w202 w1_w02_w204
	
gen preprimary = (wom_educ == 0) if !mi(wom_educ)
gen educ_primary = (wom_educ == 1) if !mi(wom_educ)
gen educ_second = (wom_educ == 2) if !mi(wom_educ)
gen educ_higher = (wom_educ == 3) if !mi(wom_educ) 

recode HUSB_supp (1 2 = 1)(3 4 5 = 0), gen(husband_support)
tab HUSB_supp husband_support
label var husband_support "Husband supports FP (1 = yes)"

***********************************************************************************
//Label all variables to be displayed in the table
**********************************************************************************
label variable age "Age (years)"
label variable cont_use "current or ever use of family planning (FP)"
label variable curr_use "Current use of FP (1 = yes)"
	label variable wom_educ "education"
label variable preprimary "Education: None"
label variable educ_primary "Education: Primary"
label variable educ_second "Education: Secondary"
label variable educ_higher "Education: Higher"
label variable wom_work "Currently working (1 = yes)"
label variable w1_w06_w609 "lived with men once or more"
label variable tot_child "Total no. of children"
label variable wom_des_fam_size "Desired no. of children"
label variable cohab_age "Age at first cohabitation (years)"
label variable top_attribute "Top attribute: Effectiveness (1 = yes)"
label variable top_attribute_wgt "Weight given to top attribute"
label variable want_to_switch "Wants to switch methods (1 = yes)"
label variable HUSB_supp "husband supports FP (1 = yes)"

label variable counselor "counselor"
label variable BASE_husb_FP "husband support at BL"

label variable COUN_126 "want to switch at counseling"
replace cont_use = 0 if w1_w03_w308b > 5 & w1_w03_w3044 == 1
replace curr_use = 0 if w1_w03_w308b > 5 & w1_w03_w3044 == 1
	
	* baseline using injectables
	gen baseline_inj = (w1_w03_w3044 == 1) if w1_w03_w303 == 1
	label var baseline_inj "Current FP method: Injectables (1 = yes)"
	
	gen baseline_implants = (w1_w03_w3045 == 1) if w1_w03_w303 == 1
	label var baseline_implants "Current FP method: Implants (1 = yes)"
	
global DESCVARS age tot_child wom_des_fam_size preprimary educ_primary educ_second educ_higher wom_work cohab_age curr_use baseline_inj baseline_implants top_attribute top_attribute_wgt want_to_switch husband_support

	capture drop BL_long_acting_method
gen BL_long_acting_method = (w1_w03_w3043 == 1 | w1_w03_w3044 == 1 | w1_w03_w3045 == 1)
	label var BL_long_acting_method "Using a Long-Acting Method at BL (1 = yes)"
	label var PHO_118 "In the past month, did you visit the GH clinic, or any pharmacy..."
	label var HOME_118 "In the past month, did you visit the GH clinic, or any pharmacy...?"

gen husb_satisfied = (w1_w07_w724d == 1 | w1_w07_w724d == 2) if w1_w07_w724d <88 //Dissatisfied husband
	label var husb_satisfied "\makecell[l]{Husband Satisfied with Woman's \\ Current Method (1 = yes)}"
	label val husb_satisfied yesno
	
	capture drop COUN_available
gen COUN_available = (COUN__FV_1 == 1) if !mi(COUN__FV_1)
	tab COUN_available
	label var COUN_available "Woman is available for counseling"
	label val COUN_available yesno

		capture drop anyClinic
	gen anyClinic = (mergeCLI == 3 | PHO_118 == 1 | HOME_118 == 1) if PHO_REC_1 == 1 | HOM_REC_1 == 1 | mergeCLI == 3 //731 finally reached women, 197 visited at least one of them
		label val anyClinic yesno
		
		label var anyClinic "Visited Any Clinic"
***********************************************************************************
*************** FOLLOW UP CURRENT METHOD **********************
***********************************************************************************

global pho_curr_methods  PHO_1051 PHO_1053 PHO_1054 PHO_1055 PHO_1056 PHO_1057 PHO_10511 PHO_10513 PHO_10514 PHO_10516

global home_curr_methods  HOME_1054 HOME_1055 HOME_1056 HOME_1057 HOME_10511 HOME_10513 HOME_10514 

global clin_curr_methods  CLIN_1053 CLIN_1054 CLIN_1055 CLIN_1056 CLIN_1057 

global baseline_curr_methods w1_w03_w3043 w1_w03_w3044 w1_w03_w3045 w1_w03_w3046 w1_w03_w3047 w1_w03_w30411 w1_w03_w30414 w1_w03_w30416

global coun_curr_method COUN_1243 COUN_1244 COUN_1245 COUN_1246 COUN_1247 COUN_12411 COUN_12412 COUN_12413 COUN_12414 COUN_12416

global baseline_switchto_methods w1_w03_w3321 w1_w03_w3323 w1_w03_w3324 w1_w03_w3325 w1_w03_w3326 w1_w03_w3327 w1_w03_w33211 w1_w03_w33215 w1_w03_w33216

****************** PHONE CURRENT METHOD **************************************
	sum $pho_curr_methods
	gen PHO_method=. 		
foreach x of numlist 1 3/7 11 13 14 16{
	replace PHO_method = `x' if mi(PHO_method) & PHO_105`x' == 1
}
		tab PHO_104
	replace PHO_method = 0 if PHO_104 == 0
	
	tab PHO_method
	br PHO_method $pho_curr_methods
label var PHO_method "Method use at the time of the phone survey"

******************* HOME CURRENT METHOD ********************************************
	sum $home_curr_methods
	gen HOM_method=.
foreach x of numlist 4/7 11 13 14{
	replace HOM_method = `x' if mi(HOM_method) & HOME_105`x' == 1
}

		tab HOME_104
	replace HOM_method = 0 if HOME_104 == 0

	tab HOM_method
	br HOM_method $home_curr_methods
	label var HOM_method "Method use at the time of the home survey"
******************** CLINIC CURRENT METHOD *******************************************
capture drop CLIN_method
	gen CLIN_method=.
foreach x of numlist 3/7{
	replace CLIN_method = `x' if mi(CLIN_method) & CLIN_105`x' == 1
}

	replace CLIN_method = 0 if CLIN_104C == 0
	tab CLIN_method
	br CLIN_method $clin_curr_methods
	label var CLIN_method "Method use at the time of the clinic visit survey"
******************** FUP CURRENT METHOD *****************************************
		capture drop FUP_curr_method
	gen FUP_curr_method = CLIN_method if !mi(CLIN_method) //63
	replace FUP_curr_method = HOM_method if !mi(HOM_method) & mi(FUP_curr_method) // 194 out of 202 - 8 people visited clinic
	replace FUP_curr_method = PHO_method if !mi(PHO_method) & mi(FUP_curr_method) //355 out of 368 -- 13 people either visited clinic or home visit
		tab FUP_curr_method //612
	label var FUP_curr_method "Method use at the follow-up"
		
********************* CLINIC IDEAL METHOD =======================================
	capture drop CLIN_ideal_method
gen CLIN_ideal_method = CLIN_204
replace CLIN_ideal_method = CLIN_205 if !mi(CLIN_205) & mi(CLIN_ideal_method)
replace CLIN_ideal_method = CLIN_206 if !mi(CLIN_206) & CLIN_206 != CLIN_ideal_method

	label var CLIN_ideal_method "Stated ideal method reported at the clinic visit"
	
******************** FUP IDEAL METHOD *****************************************
		capture drop FUP_ideal_method
	gen FUP_ideal_method = CLIN_ideal_method
	replace FUP_ideal_method = HOM_111 if mi(FUP_ideal_method) & !mi(HOM_111)
	replace FUP_ideal_method = PHO_111 if mi(FUP_ideal_method) & !mi(PHO_111)
	
	recode FUP_ideal_method (99=.)
	label var FUP_ideal_method "Stated ideal method at the follow-up"
	
******************** PHO SWITCH TO METHOD *************************************
	capture drop PHO_switchto_method
gen PHO_switchto_method =.

foreach x of numlist 1 3/7 11 16{	
replace PHO_switchto_method = `x' if PHO_105N1`x' == 1 & mi(PHO_switchto_method)
}

	label var PHO_switchto_method "Method after switching at the time of the phone survey"
	
******************** HOM SWITCH TO METHOD *************************************
capture drop HOM_switchto_method
gen HOM_switchto_method =.

foreach x of numlist 1 3/6{
	replace HOM_switchto_method = `x' if mi(HOM_switchto_method) & HOM_105N1`x' == 1
}

tab HOM_switchto_method // should be 64 women who want to switch
label var HOM_switchto_method "Method after switching at the time of the home survey"

******************** FUP SWITCH TO METHOD *************************************
	capture drop FUP_switchto_method
gen FUP_switchto_method= PHO_switchto_method if !mi(PHO_switchto_method)
replace FUP_switchto_method = HOM_switchto_method if mi(FUP_switchto_method) & !mi(HOM_switchto_method)

			tab FUP_switchto_method // 194 = 130 + 64
	label var FUP_switchto_method "Method after switching at the time of FUP (phone/home surveys)"	
******************** COUN SWITCH TO METHOD ************************************
capture drop COUN_switchto_method
gen COUN_switchto_method =.

foreach x of numlist 1 3/7 13 16{
	replace COUN_switchto_method = `x' if mi(COUN_switchto_method) &  COUN_127`x' == 1
}
tab COUN_switchto_method //256
	label var COUN_switchto_method "Method after switching at the time of counseling"

********************Baseline Switch to Methods *******************************************
tab w1_w03_w331
	gen switchto_method_b =.
foreach x of numlist 1 3/7 11 15 16{
	replace switchto_method_b = `x' if mi(switchto_method_b) & w1_w03_w332`x' == 1
}
	tab switchto_method_b //249 who wanted to switch at the baseline
		
******************** Compared to the no-counseling control group, with more information, more likely to be same? *******************************************
* Control group without counseling
count if COUN__FV_1 != 1 & mergeCVF == 1 & (mergeCLI == 3 | mergeHOM == 3 | mergePHO == 3) // only 5 observations who did not receive counseling were reached at the follow up session


******************** BASELINE CURRENT METHOD *******************************************
	capture drop baseline_curr_method
	gen baseline_curr_method =.
foreach x of numlist 3/7 11 14 16{
	replace baseline_curr_method = `x' if mi(baseline_curr_method) & w1_w03_w304`x' == 1
}

	replace baseline_curr_method = 0 if w1_w03_w303 == 0
	
	*if injectables renewed longer than 5 months ago, current method is 0
	replace baseline_curr_method = 0 if w1_w03_w308b > 5 & baseline_curr_method == 4 //17
	
	tab baseline_curr_method //679 + 98 = 777
	
	lab var baseline_curr_method "Baseline Current Method"

******************** COUNSELING CURRENT METHOD *******************************************
	capture drop coun_curr_method
	gen coun_curr_method =.
foreach x of numlist 3/7 11/14 16{
	replace coun_curr_method = `x' if mi(coun_curr_method) & COUN_124`x'==1
}

replace coun_curr_method = 0 if COUN_123 == 0

	tab coun_curr_method //684
	
	lab var coun_curr_method "Counseling Current Method"

* Realization of post-counseling ideal method 2, usng an earlier ideal method after the counseling
	lab var COUN_303 "If you could choose any contraceptive method that you want today, which method would you want to use? - 1 variable"
			capture label drop methods
	lab define methods 0 "NONE" 1 "FEMALE STERILIZATION" 2 "MALE STERILIZATION" 3 "IUD" 4 "INJECTABLES" 5 "IMPLANTS" 6 "PILL" 7 "CONDOM" 8 "FEMALE CONDOM" ///
		9 "DIAPHRAGM / FOAM / JELLY" 10 "TWO DAY METHOD" 11 "STANDARD DAYS METHOD" 12 "LACTATIONAL AMENORRHEA METHOD" 13 "RHYTHM METHOD" 14 "WITHDRAWAL" ///
		15 "OTHER MODERN METHOD" 16 "OTHER TRADITIONAL METHOD" 

	lab val COUN_303 methods
		tab COUN_303 //704

	* Define baseline ideal method -- after_switch method
	tab w1_w03_w331
		capture drop baseline_afterswitch_method
	gen baseline_afterswitch_method= baseline_curr_method if w1_w03_w331 == 0 //430 no switch
	replace baseline_afterswitch_method = switchto_method_b if w1_w03_w331 == 1 //249 switch

	tab baseline_afterswitch_method //679 - all current users
	
* Define baseline ideal method including non users
	gen baseline_ideal_method = baseline_afterswitch_method //679
	
	tab baseline_ideal_method
	foreach x of numlist 1 3/7 14{
	replace baseline_ideal_method =  w1_w03_w338b`x' if missing(baseline_ideal_method) & w1_w03_w338b`x' == 1
	}
	
	tab baseline_ideal_method

	* FIGURES
	*FIGURE A2
			capture drop w1_w03_w336extra?
	capture rename w1_w03_w336extra w1_w03_w336 
	split w1_w03_w336
	foreach x of numlist 1/7{
		lab var w1_w03_w336`x' "Attribute No - smallest to largest: `x'"
		count if !mi(w1_w03_w336`x')
	}
	
	destring w1_w03_w336?, replace
		des w1_w03_w336?

		lab val w1_w03_w336? attributes

		capture drop attribute_1_wgt
	gen attribute_1_wgt = w1_w03_w338_1_2 //329
	replace attribute_1_wgt = 20 if w1_w03_w3361 !=. & missing(w1_w03_w3362) //448
		tab attribute_1_wgt // 329 multiple choice top weight + 448 single choice top weight of 20 = 777
		drop w1_w03_w336
		label var attribute_1_wgt "Number of beans assigned to the top method attribute"
	
	gen attribute_2_wgt = w1_w03_w338_2_2
		ta attribute_1_wgt if mi(w1_w03_w338_2_2) //check: all 20
		ta w1_w03_w338_1_2 if mi(w1_w03_w338_2_2) //check: all missing
	
	replace attribute_2_wgt = 0 if mi(attribute_2_wgt)
		label var attribute_2_wgt "Number of beans assigned to the second method attribute"
	
	gen attribute_3_wgt = w1_w03_w338_3_2
		ta attribute_2_wgt if mi(w1_w03_w338_3_2)
	
	replace attribute_3_wgt = 0 if mi(attribute_3_wgt)
		label var attribute_3_wgt "Number of beans assigned to the third method attribute"
		
	gen x = attribute_1_wgt + attribute_2_wgt +attribute_3_wgt
		drop x
	
	gen attribute_wgt_variation = 0 if attribute_1_wgt == 20 & attribute_2_wgt == 0 & attribute_3_wgt == 0
	
	egen attribute_wgt_mean2 = rowmean(attribute_1_wgt attribute_2_wgt)
	replace attribute_wgt_variation = sqrt((attribute_1_wgt - attribute_wgt_mean2)^2 + (attribute_2_wgt - attribute_wgt_mean2)^2) if mi(attribute_wgt_variation) & attribute_1_wgt > 0 & attribute_2_wgt >0 & attribute_3_wgt == 0
	
	egen attribute_wgt_mean3 = rowmean(attribute_1_wgt attribute_2_wgt attribute_3_wgt)
	replace attribute_wgt_variation = sqrt((attribute_1_wgt - attribute_wgt_mean3)^2 + (attribute_2_wgt - attribute_wgt_mean3)^2 + (attribute_3_wgt - attribute_wgt_mean3)^2) if mi(attribute_wgt_variation) & attribute_1_wgt > 0 & attribute_2_wgt >0 & attribute_3_wgt > 0
	
	drop attribute_wgt_mean2 attribute_wgt_mean3
	
	gen attribute_wgt_var_bi = attribute_wgt_variation > 0 if !mi(attribute_wgt_variation)

	* Counselor FE into the number of reported attributes
	gen number_attributes = 1 if !mi(w1_w03_w3361) & mi(w1_w03_w3362)
	replace number_attributes = 2 if !mi(w1_w03_w3362) & mi(w1_w03_w3363)
	replace number_attributes = 3 if !mi(w1_w03_w3363) & mi(w1_w03_w3364)
	replace number_attributes = 4 if !mi(w1_w03_w3364) & mi(w1_w03_w3365)
	replace number_attributes = 5 if !mi(w1_w03_w3365) & mi(w1_w03_w3366)
	replace number_attributes = 6 if !mi(w1_w03_w3366) & mi(w1_w03_w3367)
	replace number_attributes = 7 if !mi(w1_w03_w3367) 
	label var number_attributes "Number of attributes"
	
	gen number_attributes_bi = number_attributes >1 
	label var number_attributes_bi "Number of attributes > 1"
	
	fvset base 1 w1_reg_enumid_1
	eststo number_coun_fe: reg number_attributes i.w1_reg_enumid_1, vce(robust)
	esttab number_coun_fe using "$output\regression.rtf", se ar2 note("Notes: Five enumerators were hired.") replace
	
	foreach x of numlist 1 3 8 11 12{
			ta number_attributes if w1_reg_enumid_1 == `x'
	}

	drop w1_reg_enumid_1
	bysort w1_w03_w3361: egen all20 = total(top_attribute_wgt == 20) if !mi(w1_w03_w3361)
	bysort w1_w03_w3361: egen attribute_total = total(!mi(w1_w03_w3361))
	gen ratio = all20/attribute_total
	bysort w1_w03_w3361: gen n=_n
	br w1_w03_w3361 all20 attribute_total ratio if n == 1
	
	* FIGURE A3
		label var w1_w03_w343 "For how long should a woman who just give birth to wait before getting pregnant to minimize health risks for next birth?"
		capture label drop spacing_time
	label define spacing_time  12 "Less than one year" ///
							13 "One to less than two years" ///
							14 "Two to less than three years" ///
							15 "Three years or more"
	label val w1_w03_w343 spacing_time
	recode w1_w03_w343 (88=.)(99=.)
		tab w1_w03_w343
		
	* FIGURE A7
*======================================================================================================
*=========================== HUSBAND COUNSELING ============================
*======================================================================================================
* Husband's ideal attributes
		capture label drop attributes
	lab define attributes   1 "EFFECTIVE AT PREVENTING PREGNANCY"  ///
							2 "CAN BE USED WITHOUT ANYONE ELSE KNOWING"  ///
							3 "PROTECTS AGAINST STI/HIV"  ///
							4 "DURATION OF EFFECT / LASTS LONG"   ///
							5 "NO RISK OF HARMING HEALTH"   ///
							6 "NO EFFECT ON REGULAR MONTHLY BLEEDING"   ///
							7 "NO UNPLEASANT SIDE EFFECTS"   ///
							8 "SHOULD NOT BE HORMONAL"  ///
							9 "LOW COST"  ///
							10 "EASILY AVAILABLE AT THE CLNIC"  ///
							11 "CAN BE USED FOR A LONG TIME WITHOUT NEED TO VISIT CLINIC OR RE-SUPPLY"   ///
							12 "WILL BE ABLE TO GET PREGNANT WHEN I WANT"  ///
							13 "NO NEED TO GO TO A CLINIC TO OBTAIN THE METHOD"  ///
							14 "NO RISK OF INFERTILITY"  ///
							15 "NO NEED TO REMEMBER USING THE METHOD"   ///
							16 "WANT TO TRY SOMETHING NEW / TIRED OF OLD METHOD"  ///
							17 "MY DOCTOR RECOMMENDED IT TO ME"  ///
							18 "MY HUSBAND WANTED ME TO USE THIS METHOD"  ///
							19 "OTHER WOMEN IN MY FAMILY HAVE USED THIS METHOD"  ///
							20 "FRIENDS HAVE USED THIS METHOD"  ///
							21 "DOES NOT INTERRUPT SEX"  ///
							96 "OTHER"

		* Identify who only chose one method, then weight is automatically 0, and is not asked the question above (three attributes)
		capture rename COUN__HUSB_122extra COUN__HUSB_122 
			capture drop COUN__HUSB_122?
		split COUN__HUSB_122
		destring COUN__HUSB_1221 COUN__HUSB_1222, ignore("---") replace
			sum COUN__HUSB_122?
			drop COUN__HUSB_1222
		
		lab var COUN__HUSB_1221 "Husband's most valued attribute" //121 of 122 husbands only chose 1 attribute, while 1 husband chose 2 of them
		
		lab val COUN__HUSB_1221 attributes
			drop COUN__HUSB_122
			
* TABLE A2, CULUMN 1: CURRENT METHOD
* Current using or not?
		tab w1_w03_w303
	label var w1_w03_w303 "Are you currently doing sth to delay or avoid getting pregnant?"
	recode w1_w03_w303 (1=1)(2=0)(0=0)(else=.)
		tab w1_w03_w303 //679
		
* Which method the woman is using? 8 methods out of 16 have entries

	capture drop w1_w03_w3040
gen w1_w03_w3040 = (w1_w03_w303 == 0) if !mi(w1_w03_w303)
	tab w1_w03_w3040 //98 units of 1
	
	foreach x of numlist 3/7 11 14 16{
		replace w1_w03_w304`x' = 0 if missing(w1_w03_w304`x') & !mi(w1_w03_w303) /*!missing(w1_w03_form_number)*/
	}
	
	foreach x of numlist 0 3/7 11 14 16{
		tab w1_w03_w304`x'
	}

		label var w1_w03_w3040 "None"
	
		label var w1_w03_w3043 "IUD"

		label var w1_w03_w3044 "Injectables"

		label var w1_w03_w3045 "Implants"

		label var w1_w03_w3046 "Pill"

		label var w1_w03_w3047 "Condom"

		label var w1_w03_w30411 "Standard Days Method"
		
		label var w1_w03_w30414 "Withdrawal"

		label var w1_w03_w30416 "Other Traditional Method"
		
		label val w1_w03_w304* yes 

gen modern_methods304 = (w1_w03_w3043 == 1 | w1_w03_w3046 == 1 | w1_w03_w3047 == 1) if !mi(w1_w03_w3047)
	label var modern_methods304 "Other Modern Methods"
gen traditional_methods304 = (w1_w03_w30411 == 1 | w1_w03_w30414 == 1 | w1_w03_w30416 == 1) if !mi(w1_w03_w30416)
	label var traditional_methods304 "Traditional methods"

* TABLE A2, COLUMN 2: BASELINE IDEAL METHOD
********************Baseline Switch to Methods *******************************************
tab w1_w03_w331
	capture drop switchto_method_b
	gen switchto_method_b =.
foreach x of numlist 1 3/7 11 15 16{
	replace switchto_method_b = `x' if mi(switchto_method_b) & w1_w03_w332`x' == 1
}
	tab switchto_method_b //249 who wanted to switch at the baseline
	label var switchto_method_b "Contraceptive method woman wants to switch to at BL"
	
******************** BASELINE CURRENT METHOD *******************************************
	capture drop baseline_curr_method
	gen baseline_curr_method =.
foreach x of numlist 3/7 11 14 16{
	replace baseline_curr_method = `x' if mi(baseline_curr_method) & w1_w03_w304`x' == 1
}

	replace baseline_curr_method = 0 if w1_w03_w303 == 0
	
	*if injectables renewed longer than 5 months ago, current method is 0
	replace baseline_curr_method = 0 if w1_w03_w308b > 5 & baseline_curr_method == 4 //17

	tab baseline_curr_method //679 + 98 = 777
	
	lab var baseline_curr_method "Baseline Current Method"

	* Define baseline ideal method -- after_switch method
	tab w1_w03_w331
		capture drop baseline_afterswitch_method
	gen baseline_afterswitch_method= baseline_curr_method if w1_w03_w331 == 0 //430 no switch
	replace baseline_afterswitch_method = switchto_method_b if w1_w03_w331 == 1 //249 switch

	tab baseline_afterswitch_method //679 - all current users
	label var baseline_afterswitch_method "Woman's method use after switching at baseline"

* Define baseline ideal method including non users
		capture drop baseline_ideal_method
	gen baseline_ideal_method = baseline_afterswitch_method //679
	
	replace baseline_ideal_method = 0 if w1_w03_w338a == 0
	
	tab baseline_ideal_method
	foreach x of numlist 1 3/7 14{
	replace baseline_ideal_method =  w1_w03_w338b`x' if missing(baseline_ideal_method) & w1_w03_w338b`x' == 1
	}
	
	tab baseline_ideal_method //773 = 679 + 6 + 88
	label var baseline_ideal_method "Stated ideal method at the baseline"

		capture label drop methods
	label define methods 0 "NONE" ///
		1 "FEMALE STERILIZATION" ///
		2 "MALE STERILIZATION" ///
		3 "IUD" ///
		4 "INJECTABLES" ///
		5 "IMPLANTS" ///
		6 "PILL"  ///
		7 "CONDOM" ///
		8 "FEMALE CONDOM"  ///
		9 "DIAPHRAGM / FOAM / JELLY" ///
		10 "TWO DAY METHOD" ///
		11 "STANDARD DAYS METHOD" ///
		12 "LACTATIONAL AMENORRHEA METHOD"  ///
		13 "RHYTHM METHOD" ///
		14 "WITHDRAWAL" ///
		15 "OTHER MODERN METHOD" ///
		16 "OTHER TRADITIONAL METHOD"
	label val baseline_ideal_method methods
		tab baseline_ideal_method
	
foreach x of numlist 0 1 3/7 11 14/16{
	gen BL_Ideal_Method`x' = 1 if baseline_ideal_method == `x'
	replace BL_Ideal_Method`x' = 0 if !mi(baseline_ideal_method) & mi(BL_Ideal_Method`x')
}

		label var BL_Ideal_Method0 "None"
		
		label var BL_Ideal_Method1 "Female Sterilization"
	
		label var BL_Ideal_Method3 "IUD"

		label var BL_Ideal_Method4 "Injectables"

		label var BL_Ideal_Method5 "Implants"

		label var BL_Ideal_Method6 "Pill"

		label var BL_Ideal_Method7 "Condom"

		label var BL_Ideal_Method11 "Standard Days Method"
		
		label var BL_Ideal_Method14 "Withdrawal"
		
		label var BL_Ideal_Method15 "Other Modern Method"

		label var BL_Ideal_Method16 "Other Traditional Method"

label val  BL_Ideal_Method0 BL_Ideal_Method1 BL_Ideal_Method3 BL_Ideal_Method4 ///
BL_Ideal_Method5 BL_Ideal_Method6 BL_Ideal_Method7 BL_Ideal_Method11 ///
BL_Ideal_Method14 BL_Ideal_Method15 BL_Ideal_Method16 yesno


gen modern_methods_BLideal = (BL_Ideal_Method1 ==1 | BL_Ideal_Method3 == 1 | BL_Ideal_Method6 == 1 | BL_Ideal_Method7 == 1) if !mi(BL_Ideal_Method3)
	label var modern_methods_BLideal "Other Modern Methods"

gen traditional_methods_BLideal = (BL_Ideal_Method11 ==1 | BL_Ideal_Method14 == 1 | BL_Ideal_Method15 ==1 | BL_Ideal_Method16 == 1) if !mi(BL_Ideal_Method11)
	label var traditional_methods_BLideal "Traditional methods"

* TABLE A2, COLUMN 3: HUSBAND IDEAL METHOD
	sum COUN__HUSB_1210 COUN__HUSB_1211 COUN__HUSB_1212 COUN__HUSB_1213 ///
		COUN__HUSB_1214 COUN__HUSB_1215 COUN__HUSB_1216 COUN__HUSB_1217 ///
		COUN__HUSB_12113 COUN__HUSB_12114 COUN__HUSB_12115 ///
		COUN__HUSB_12116
		
	gen husb_ideal_method  = .
	foreach x of numlist 0 1 2 3 4 5 6 7 13 14 15 16{
		replace husb_ideal_method = `x' if COUN__HUSB_121`x' == 1 & mi(husb_ideal_method)
	}
	label var husb_ideal_method "Husband's stated ideal method at counseling"
		capture label drop husb_ideal_method
	label define husb_ideal_method 0 "NONE" 1 "FEMALE STERILIZATION" 2 "MALE STERILIZATION" 3 "IUD" ///
		4 "INJECTABLES" 5 "IMPLANTS" 6 "PILL" 7 "CONDOM" 13 "RHYTHM METHOD" ///
		14 "WITHDRAWAL" 15 "OTHER MODERN METHOD" 16 "OTHER TRADITIONAL METHOD"

	label val husb_ideal_method husb_ideal_method
	
		label var COUN__HUSB_1210 "None"

		label var COUN__HUSB_1211 "Female Sterilization"

		label var COUN__HUSB_1212 "Male Sterilzation"		

		label var COUN__HUSB_1213 "IUD"

		label var COUN__HUSB_1214 "Injectables"

		label var COUN__HUSB_1215 "Implants"

		label var COUN__HUSB_1216 "Pill"

		label var COUN__HUSB_1217 "Condom"
		
		label var COUN__HUSB_12113 "Rhythm Method"

		label var COUN__HUSB_12114 "Withdrawal"

		label var COUN__HUSB_12115 "Other Modern Method"

		label var COUN__HUSB_12116 "Other Traditional Method"

		
gen husb_ideal_other_modern = (COUN__HUSB_1211 == 1 | COUN__HUSB_1212 == 1 | COUN__HUSB_1213 == 1 | COUN__HUSB_1216 == 1 | COUN__HUSB_1217 == 1 | COUN__HUSB_12115 == 1) if !mi(COUN__HUSB_1213)
	label var husb_ideal_other_modern "Other Modern Methods"
	
gen husb_ideal_traditional = (COUN__HUSB_12113 == 1 | COUN__HUSB_12114 == 1 | COUN__HUSB_12116 == 1) if !mi(COUN__HUSB_12116)
	label var husb_ideal_traditional "Traditional Methods"

*====================== Table A2 (for counseling) ====================
* Pre-counseling method
gen COUN_129_modern = (COUN_129 ==1 | COUN_129 == 2 | COUN_129 == 3 | COUN_129 == 6 | COUN_129 == 7 | COUN_129 == 8 | COUN_129 == 9 | COUN_129 == 15) if !mi(COUN_129)
label var COUN_129_modern "Other Modern Methods"

gen COUN_129_traditional = inrange(COUN_129, 10, 14) | COUN_129 == 16 if !mi(COUN_129)
label var COUN_129_traditional "Traditional Methods"

gen COUN_129_None = COUN_129 == 0 if !mi(COUN_129)
label var COUN_129_None "None"

gen COUN_129_inj = COUN_129 == 4 if !mi(COUN_129)
label var COUN_129_inj "Injectables"

gen COUN_129_implants = COUN_129 == 5 if !mi(COUN_129)
label var COUN_129_implants "Implants"

* Post-counseling method
gen COUN_303_modern = (COUN_303 ==1 | COUN_303 == 2 | COUN_303 == 3 | COUN_303 == 6 | COUN_303 == 7 | COUN_303 == 8 | COUN_303 == 9 | COUN_303 == 15) if !mi(COUN_303)
label var COUN_303_modern "Other Modern Methods"

gen COUN_303_traditional = inrange(COUN_303, 10, 14) | COUN_303 == 16 if !mi(COUN_303)
label var COUN_303_traditional "Traditional Methods"

gen COUN_303_None = COUN_303 == 0 if !mi(COUN_303)
label var COUN_303_None "None"

gen COUN_303_inj = COUN_303 == 4 if !mi(COUN_303)
label var COUN_303_inj "Injectables"

gen COUN_303_implants = COUN_303 == 5 if !mi(COUN_303)
label var COUN_303_implants "Implants"

* Counseling current method use
gen coun_curr_method_modern = (coun_curr_method ==1 | coun_curr_method == 2 | coun_curr_method == 3 | coun_curr_method == 6 | coun_curr_method == 7 | coun_curr_method == 8 | coun_curr_method == 9 | coun_curr_method == 15) if !mi(coun_curr_method)
label var coun_curr_method_modern "Other Modern Methods"

gen coun_curr_method_traditional = inrange(coun_curr_method, 10, 14) | coun_curr_method == 16 if !mi(coun_curr_method)
label var coun_curr_method_traditional "Traditional Methods"

gen coun_curr_method_None = coun_curr_method == 0 if !mi(coun_curr_method)
label var coun_curr_method_None "None"

gen coun_curr_method_inj = coun_curr_method == 4 if !mi(coun_curr_method)
label var coun_curr_method_inj "Injectables"

gen coun_curr_method_implants = coun_curr_method == 5 if !mi(coun_curr_method)
label var coun_curr_method_implants "Implants"
	
* TABLE A3: TOP METHOD ATTRIBUTE DISTRIBUTION
	label val w1_w03_attribute_1 attributes
	label var w1_w03_attribute_1 "Top attribute"
		tab w1_w03_attribute_1
		recode w1_w03_attribute_1 (88=.)
		
		capture drop w1_w03_attribute_1? w1_w03_attribute_1??
	foreach x of numlist 1/21 96{
		gen w1_w03_attribute_1`x' = (w1_w03_attribute_1 == `x') if !missing(w1_w03_attribute_1)
		tab w1_w03_attribute_1`x'
	}
	
		capture drop top_attribute_freq
	bysort w1_w03_attribute_1: gen top_attribute_freq =_N
	replace top_attribute_freq = 0.5 if w1_w03_attribute_1 == 96
		label var top_attribute_freq "Number of women that chose the attribute as the top attribute"
								
label var w1_w03_attribute_11 "Effective at preventing pregnancy"
label var w1_w03_attribute_12 "Can be used without anyone else knowing"
label var w1_w03_attribute_13 "Protects against STI/HIV"
label var w1_w03_attribute_14 "Duration of effect / lasts long"
label var w1_w03_attribute_15 "No risk of harming health"
label var w1_w03_attribute_16 "No effect on regular monthly bleeding"
label var w1_w03_attribute_17 "No unpleasant side effects"
label var w1_w03_attribute_18 "Should not be hormonal"
label var w1_w03_attribute_19 "Low cost"
label var w1_w03_attribute_110 "Easily available at the clnic"
label var w1_w03_attribute_111 "Can be used for a long time without need to visit clinic or re-supply"
label var w1_w03_attribute_112 "Will be able to get pregnant when I want"
label var w1_w03_attribute_113 "No need to go to a clinic to obtain the method"
label var w1_w03_attribute_114 "No risk of infertility"
label var w1_w03_attribute_115 "No need to remember using the method"
label var w1_w03_attribute_116 "Want to try something new / tired of old method"
label var w1_w03_attribute_117 "My doctor recommended it to me"
label var w1_w03_attribute_118 "My husband wanted me to use this method"
label var w1_w03_attribute_119 "Other women in my family have used this method"
label var w1_w03_attribute_120 "Friends have used this method"
label var w1_w03_attribute_121 "Does not interrupt sex"
label var w1_w03_attribute_196 "Other"

label val w1_w03_attribute_11 w1_w03_attribute_12 w1_w03_attribute_13 ///
w1_w03_attribute_14 w1_w03_attribute_15 w1_w03_attribute_16 w1_w03_attribute_17 ///
w1_w03_attribute_18 w1_w03_attribute_19 w1_w03_attribute_110 w1_w03_attribute_111 ///
w1_w03_attribute_112 w1_w03_attribute_113 w1_w03_attribute_114 w1_w03_attribute_115 ///
w1_w03_attribute_116 w1_w03_attribute_117 w1_w03_attribute_118 w1_w03_attribute_119 ///
w1_w03_attribute_120 w1_w03_attribute_121 w1_w03_attribute_196 yesno


global top_attribute  w1_w03_attribute_11 w1_w03_attribute_17 w1_w03_attribute_14 ///
w1_w03_attribute_15 w1_w03_attribute_16 w1_w03_attribute_115 ///
w1_w03_attribute_112 w1_w03_attribute_111 w1_w03_attribute_113 ///
w1_w03_attribute_13 w1_w03_attribute_114 w1_w03_attribute_120 ///
w1_w03_attribute_110 w1_w03_attribute_19 w1_w03_attribute_117 ///
w1_w03_attribute_18 w1_w03_attribute_121 w1_w03_attribute_119 ///
w1_w03_attribute_12 w1_w03_attribute_196

******************* PANEL A. pre-COUN ideal method and FUP ideal method**********************************************
	capture drop diff_method_r8
	capture drop diff_method_8
gen diff_method_r8 = FUP_ideal_method - COUN_129
gen diff_method_8 = (diff_method_r8 != 0) if !mi(diff_method_r8)
label var diff_method_8 "Pre-counseling ideal method differs from FUP ideal method"
	label val diff_method_8 yesno
	drop diff_method_r8
		
	capture drop diff_method_r20
	capture drop diff_method_20
gen diff_method_r20 = FUP_curr_method - coun_curr_method
gen diff_method_20 = (diff_method_r20 != 0 & FUP_curr_method ==0 & coun_curr_method != 0) if !mi(diff_method_r20)
label var diff_method_20 "FUP current method differs from counseling current method use"
	label val diff_method_20 yesno
	drop diff_method_r20

******************* Panel B: Counseling Current Method and FUP Current Method**********************************************
	capture drop diff_method_r3
	capture drop diff_method_3
gen diff_method_r3 = FUP_curr_method - coun_curr_method
gen diff_method_3 = (diff_method_r3 != 0) if !mi(diff_method_r3)
	tab diff_method_3 //576 = 248 different + 328 same
	label var diff_method_3 "Counseling current method differs from FUP current method"
	label val diff_method_3 yesno
	drop diff_method_r3

	capture drop diff_method_r17
	capture drop diff_method_17
gen diff_method_r17 = FUP_curr_method - coun_curr_method
gen diff_method_17 = (diff_method_r17 != 0 & FUP_curr_method !=0) if !mi(diff_method_r17)
	label var diff_method_17 "Counseling current method differs from FUP current method (FUP curr method non-missing)"
	label val diff_method_17 yesno
	drop diff_method_r17

	capture drop diff_method_r18
	capture drop diff_method_18
gen diff_method_r18 = FUP_curr_method - coun_curr_method
gen diff_method_18 = (diff_method_r18 != 0 & FUP_curr_method !=0 & coun_curr_method != 0) if !mi(diff_method_r18)
	label var diff_method_18 "Counseling current method differs from FUP current method (FUP curr method and counseling curr method non-missing"
	label val diff_method_18 yesno
	drop diff_method_r18

******************* post-COUN ideal method and FUP current method**********************************************
	capture drop diff_method_9_r
	capture drop diff_method_9
gen diff_method_9_r = FUP_curr_method - COUN_3081
gen diff_method_9 = (diff_method_9_r > 0 | diff_method_9_r < 0) if !mi(diff_method_9_r)
	label var diff_method_9 "Post-counseling ideal method differs from FUP current method"
	label val diff_method_9 yesno
	tab diff_method_9 //576 = 248 different + 328 same
	drop diff_method_9_r
	
	gen intertemperal_concordance = (FUP_curr_method == COUN_3081) if !mi(FUP_curr_method) & !mi(COUN_3081)
	label var intertemperal_concordance "Intertemporal Concordance"

******************* FUP Ideal Method and FUP Current Method**********************************************
	capture drop diff_method_r5
	capture drop diff_method_5
gen diff_method_r5 = FUP_ideal_method - FUP_curr_method
gen diff_method_5 = (diff_method_r5 != 0) if !mi(diff_method_r5)
	tab diff_method_5 //576 = 248 different + 328 same
	label var diff_method_5 "FUP ideal method differs from FUP current method use"
	label val diff_method_5 yesno
	drop diff_method_r5
	
	gen contemp_concordance = (FUP_ideal_method == FUP_curr_method) if !mi(FUP_ideal_method) & !mi(FUP_curr_method)
	label var contemp_concordance "Contemporaneous Concordance"

* TABLE A5-A6
* Panel A
* Column 1
	capture drop diff_method_r2
gen diff_method_r2 = COUN_3081 - COUN_129
gen diff_method_2 = (diff_method_r2 != 0) if !mi(diff_method_r2)
	label var diff_method_2 "End-of-counseling ideal method differs from pre-counseling ideal method"
	label val diff_method_2 yesno
	drop diff_method_r2
	
* Panel B
* Column 3
	capture drop diff_method_r16
	capture drop diff_method_16
gen diff_method_r16 = COUN_3081 - coun_curr_method
gen diff_method_16 = (diff_method_r16 != 0) if !mi(diff_method_r16)
	label var diff_method_16 "End-of-counseling ideal method differs from method use at counseling"
	label val diff_method_16 yesno
	drop diff_method_r16

* Column 4
	capture drop diff_method_r12
	capture drop diff_method_12
gen diff_method_r12 = FUP_ideal_method - coun_curr_method
gen diff_method_12 = (diff_method_r12 != 0) if !mi(diff_method_r12)
	label var diff_method_12 "FUP ideal method differs from method use at counseling"
	label val diff_method_12 yesno
	drop diff_method_r12
	
* TABLE A7-A8
* Column 3
	capture drop diff_method_r21
	capture drop diff_method_21
gen diff_method_r21 = FUP_curr_method - coun_curr_method
gen diff_method_21 = (diff_method_r21 != 0 & FUP_curr_method !=0 & coun_curr_method == 0) if !mi(diff_method_r21)
label var diff_method_21 "FUP method use differs from counseling method use"
	label val diff_method_21 yesno
	drop diff_method_r21
	
* TABLE A9
lab var SHORT_T "Tailored Counseling"
lab var HUSB_T "Partner Invitation"

	label var COUN_207 "Partner Invitation Uptake"
	replace COUN_207 = 0 if mi(COUN_207)

* LARCs & SARCs
***IDEAL METHOD
*CHANGED LARC
gen FUP_ideal_LARC = (FUP_ideal_method < 4 | FUP_ideal_method==5) & FUP_ideal_method!=0
gen COUN_ideal_LARC = (COUN_129 < 4 | COUN_129==5) & COUN_129!=0
gen diff_method_ideal_LARC_r = FUP_ideal_LARC - COUN_ideal_LARC
gen diff_method_ideal_LARC = (diff_method_ideal_LARC_r != 0) if !mi(diff_method_ideal_LARC_r) 

*CHANGED SARC
gen FUP_SARC_ideal = FUP_ideal_method == 4 | (FUP_ideal_method > 5 & FUP_ideal_method < 12)
gen COUN_SARC_ideal = COUN_129 == 4 | (COUN_129 > 5 & COUN_129 < 12)
gen diff_method_SARC_ideal_r = FUP_SARC_ideal - COUN_SARC_ideal
gen diff_method_SARC_ideal = (diff_method_SARC_ideal_r != 0) if !mi(diff_method_SARC_ideal_r)

********************************************************************************
***METHOD USE
*CHANGED LARC
gen FUP_LARC_use = (FUP_curr_method < 4 | FUP_curr_method==5) & FUP_curr_method!=0
gen COUN_LARC_use = (coun_curr_method < 4 | coun_curr_method==5) & coun_curr_method!=0
gen diff_method_LARC_use_r = FUP_LARC_use - COUN_LARC_use
gen diff_method_LARC_use = (diff_method_LARC_use_r != 0) if !mi(diff_method_LARC_use_r) 

*CHANGED SARC
gen FUP_SARC_use = FUP_curr_method == 4 | (FUP_curr_method > 5 & FUP_curr_method < 12)
gen COUN_SARC_use = coun_curr_method == 4 | (coun_curr_method > 5 & coun_curr_method < 12)
gen diff_method_SARC_use_r = FUP_SARC_use - COUN_SARC_use
gen diff_method_SARC_use = (diff_method_SARC_use_r != 0) if !mi(diff_method_SARC_use_r)

*** INTERTEMPORAL DISCORDANCE
* CHANGED LARC
gen POST_COUN_ideal_LARC = (COUN_3081 < 4 | COUN_3081 == 5) & COUN_3081 !=0
gen diff_LARC_ID_r = FUP_LARC_use - POST_COUN_ideal_LARC
gen diff_LARC_ID = (diff_LARC_ID_r > 0 | diff_LARC_ID_r < 0) if !mi(diff_LARC_ID_r)

* CHANGED SARC
gen POST_COUN_ideal_SARC = COUN_3081 == 4 | (COUN_3081 > 5 & COUN_3081 < 12)
gen diff_SARC_ID_r = FUP_SARC_use - POST_COUN_ideal_SARC
gen diff_SARC_ID = (diff_SARC_ID_r > 0 | diff_SARC_ID_r < 0) if !mi(diff_SARC_ID_r)

*** CONTEMPORANEOUS DISCORDANCE
* CHANGED LARC
gen diff_LARC_CD_r = FUP_LARC_use - FUP_ideal_LARC
gen diff_LARC_CD = (diff_LARC_CD_r > 0 | diff_LARC_CD_r < 0) if !mi(diff_LARC_CD_r)

* CHANGED SARC
gen diff_SARC_CD_r = FUP_SARC_use - FUP_SARC_ideal
gen diff_SARC_CD = (diff_SARC_CD_r > 0 | diff_SARC_CD_r < 0) if !mi(diff_SARC_CD_r)
	
* FIGURE E1-E2: Counseling Times
*******************************************************************************
***************** DATE AND TIME BEFORE HUSBAND PARTICIPATION**********************************
*******************************************************************************
	tab COUN_201A //date
	tab COUN_201B //time
	
	foreach var of varlist COUN_201A COUN_201B{
		capture replace `var' = "" if `var' == "---"
		destring `var', replace
	}
		capture drop coun_start_date
	capture replace COUN_201A = subinstr(COUN_201A, "-", "", .)
	destring COUN_201A, replace
	format COUN_201A %20.0f
	todate COUN_201A, p(yyyymmdd) gen(counseling_start_date)
	lab var counseling_start_date "The date before counseling starts - before husband participated"
	todate COUN_301A, p(yyyymmdd) gen(counseling_end_date)
	label var counseling_end_date "The date after counseling ends"
		
		capture drop coun_start_time
	gen double coun_start_time = clock(substr(COUN_201B, 1, 8), "hms") 
	lab var coun_start_time "The time before counseling starts - before husband participated"
	format coun_start_time %tc
		br COUN_201B coun_start_time
*******************************************************************************
*************************** TREATMENT STATUS ***************************************
*******************************************************************************
/*Counseling Time Bars*/
*******************************************************************************************************
************************************Counseling Time*************************************************** from 2020-02-20 analysis do file
*******************************************************************************************************
* note("Counseling time is defined as the time used from starting the counseling to the end of counseling, 
* which also includes the terms of service process at the beginning, and the husband pre-counseling part for the husband group.")
	count if COUN_301A != COUN_201A                                     							/*26 women: start counseling (TOS) and end counseling on two days*/
	count if (COUN_301A != COUN_201A) & (COUN_301A == COUN__HUSB_101A) & !missing(COUN__HUSB_101A)   /*15 out of 26 women where start date differs from end date, but husb start date == end date*/
	count if (COUN_301A != COUN_201A) & (COUN_301A != COUN__HUSB_101A) & !missing(COUN__HUSB_101A)   /*The 9 remaining women are missing husb_start_Date*/ 
	
todate COUN__HUSB_101A, gen(HUSB_coun_start_date) p(yyyymmdd)  														/*Convert COUN__HUSB_101A to HUSB_date*/ 
	label var HUSB_coun_start_date "Counseling start date of the partner counseling session"
	
capture drop husb_counseling_start_dt
		format COUN__HUSB_101B %20s  																						  /*Format husb start date*/ 
		gen double husb_counseling_start_dt = clock(substr(COUN__HUSB_101B, 1, 8), "hms") 									  /*Generate husb start date: 112 values*/
		format husb_counseling_start_dt %tc  /*Format time to time format*/
		label var husb_counseling_start_dt "Counseling start time of the partner counseling session"
	
capture drop counseling_time_husb_sec
		gen counseling_time_husb_sec = (counseling_comp_dt - husb_counseling_start_dt)/60000  								/*112- counseling time for husband section*/ 		
		label var counseling_time_husb_sec "Time of the partner counseling session"
		
* Variable 1: counseling_time: counseling time where start and end time of counseling were on the same day
gen counseling_time = counseling_comp_dt - counseling_start_dt if counseling_start_date == counseling_end_date

replace counseling_time = counseling_time/60000
	label var counseling_time "Counseling time if start and end are on the same day"

* Variable 2: counseling_time2: replace counseling_time with the husband_counseling_time if original was missing, and new time is positive
	capture drop counseling_time2
gen counseling_time2 = counseling_time
replace counseling_time2 = counseling_time_husb_sec if missing(counseling_time2) & !missing(counseling_time_husb_sec) & counseling_time_husb_sec >0 
	label variable counseling_time2 "Counseling time (replace missing with the husband counseling time)"

* Counseling_time3: replace counseling_time2 with the husband_counseling_time if original was non-missing, and longer than the new time, and that the new time is nonmissing
	capture drop counseling_time3
gen counseling_time3 = counseling_time2
	br counseling_time counseling_time_husb_sec if !missing(counseling_time_husb_sec) /*81*/
	br counseling_time2 counseling_time_husb_sec if !missing(counseling_time3) & !missing(counseling_time_husb_sec) & counseling_time3 > counseling_time_husb_sec & counseling_time_husb_sec > 0
	replace counseling_time3 = counseling_time_husb_sec if !missing(counseling_time3) & !missing(counseling_time_husb_sec) & counseling_time3 > counseling_time_husb_sec & counseling_time_husb_sec > 0
	label var counseling_time3 "Counseling time (replace counseling time is original is longer than the new time)"

* TABLE F1
gen diff_method111 = (COUN_129 != baseline_ideal_method) if !mi(baseline_ideal_method) & !mi(COUN_129)
label var diff_method111 "Changes to ideal method from baseline to pre-counseling"

gen diff_method112 = (COUN_303 != baseline_ideal_method) if !mi(baseline_ideal_method) & !mi(COUN_303)
label var diff_method112 "Changes to ideal method from baseline to post-counseling"

gen diff_method113 = (FUP_ideal_method != baseline_ideal_method) if !mi(baseline_ideal_method) & !mi(FUP_ideal_method)
label var diff_method113 "Changes to ideal method from baseline to Follow-up"	

gen diff_method114 = (COUN_303 != COUN_129) if !mi(COUN_303) & !mi(COUN_129)
label var diff_method114 "Changes to ideal method from pre-counseling to post-counseling"	

gen diff_method115 = (FUP_ideal_method != COUN_129) if !mi(COUN_129) & !mi(FUP_ideal_method)
label var diff_method115 "Changes to ideal method from pre-counseling to FUP"

gen diff_method116 = (FUP_ideal_method != COUN_303) if !mi(COUN_303) & !mi(FUP_ideal_method)
label var diff_method116 "Changes to ideal method from post-counseling to FUP" 

gen diff_method117 = (coun_curr_method != baseline_curr_method) if !mi(coun_curr_method) & !mi(baseline_curr_method)
label var diff_method117 "Changes to method use from baseline to counseling" 

gen diff_method118 = (FUP_curr_method != baseline_curr_method) if !mi(FUP_curr_method) & !mi(baseline_curr_method)
label var diff_method118 "Changes to method use from baseline to FUP" 

gen diff_method119 = (FUP_curr_method != coun_curr_method) if !mi(coun_curr_method) & !mi(FUP_curr_method)
label var diff_method119 "Changes to method use from counseling to FUP" 
	
	capture label drop method_change
label define method_change 1 "Changed" 0 "Did not change"
label val diff_method111-diff_method119 method_change
******************** FUP switching intention **********************************
gen want_to_switch_FUP = HOM_105N
replace want_to_switch_FUP = PHO_105N if mi(want_to_switch_FUP) & !mi(PHO_105N)

label var want_to_switch_FUP "Woman wants to switch to another contraceptive method at the FUP"
	label val want_to_switch_FUP yesno
* TABLE G5
gen attrited = (!(PHO_REC_4 == 1 | HOME_REV_20 == 1 | mergeCLI == 3) | COUN__FV_1 !=1)
label var attrited "Attritors (1 = Yes, 0 = No)"
label val attrited yesno

* TABLE H1, H2
******************** FUP IDEAL METHOD *****************************************
	gen FUP_ideal_method_NoClinic = .
	replace FUP_ideal_method_NoClinic = HOM_111 if mi(FUP_ideal_method_NoClinic) & !mi(HOM_111)
	replace FUP_ideal_method_NoClinic = PHO_111 if mi(FUP_ideal_method_NoClinic) & !mi(PHO_111)
	
	recode FUP_ideal_method_NoClinic (99=.)
	tab FUP_ideal_method_NoClinic //677
	label var FUP_ideal_method_NoClinic "FUP stated ideal method with no women who were reached at the Kauma clinic"

	capture drop diff_method_r8_noCLI
	capture drop diff_method_8_noCLI
gen diff_method_r8_noCLI = FUP_ideal_method_NoClinic - COUN_129
gen diff_method_8_noCLI = (diff_method_r8_noCLI != 0) if !mi(diff_method_r8_noCLI)
label var diff_method_8_noCLI "Pre-counseling ideal method differs from FUP ideal method"
	label val diff_method_8_noCLI yesno
	drop diff_method_r8_noCLI

	capture drop diff_method_r5_noCLI
	capture drop diff_method_5_noCLI
gen diff_method_r5_noCLI = FUP_ideal_method_NoClinic - FUP_curr_method
gen diff_method_5_noCLI = (diff_method_r5_noCLI != 0) if !mi(diff_method_r5_noCLI)
	label var diff_method_5_noCLI "FUP ideal method differs from FUP current method use (no women reached at the clinic)"
	label val diff_method_5_noCLI yesno
	drop diff_method_r5_noCLI
	
* TABLE K1
******************* 1. PANEL A: Husband Invitation on End-of-Counseling Ideal Method **********************************************
gen postIdeal_implants = (COUN_3081 == 5) if !mi(COUN_3081)
gen postIdeal_injectables = (COUN_3081 == 4) if !mi(COUN_3081)
gen postIdeal_pills = (COUN_3081 == 6) if !mi(COUN_3081)
gen postIdeal_Others = (COUN_3081 == 13 | COUN_3081 == 14 | COUN_3081 == 16) if !mi(COUN_3081)

label var postIdeal_implants "Post-counseling stated ideal method: Implants"
label var postIdeal_injectables "Post-counseling stated ideal method: Injectatbles"
label var postIdeal_pills "Post-counseling stated ideal method: Pills"
label var postIdeal_Others "Post-counseling stated ideal method: Others"

*========================= 2. Follow-up Method Use =======================================
gen FUPmethod_implants = (FUP_curr_method == 5) if !mi(FUP_curr_method)
gen FUPmethod_injectables = (FUP_curr_method == 4) if !mi(FUP_curr_method)
gen FUPmethod_pills = (FUP_curr_method == 6) if !mi(FUP_curr_method)
gen FUPmethod_Others = (FUP_curr_method == 13 | FUP_curr_method == 14 | FUP_curr_method == 16) if !mi(FUP_curr_method)

label var FUPmethod_implants "Follow-up method use: Implants"
label var FUPmethod_injectables "Follow-up method use: Injectables"
label var FUPmethod_pills "Follow-up method use: Pills"
label var FUPmethod_Others "Follow-up method use: Others"

* ============================== 3. End-of-Counseling and FUP Method Use both being Implants =====================================
gen uptake_injectables = ((FUP_curr_method == 4) ///
			& COUN_3081 == FUP_curr_method) if !mi(FUP_curr_method) & !mi(COUN_3081)
	tab uptake_injectables //576 = 248 different + 328 same

gen uptake_pills = ((FUP_curr_method == 6) ///
			& COUN_3081 == FUP_curr_method) if !mi(FUP_curr_method) & !mi(COUN_3081)
	tab uptake_pills //576 = 248 different + 328 same

gen uptake_implants = ((FUP_curr_method == 5) ///
			& COUN_3081 == FUP_curr_method) if !mi(FUP_curr_method) & !mi(COUN_3081)
	tab uptake_implants //576 = 248 different + 328 same

gen uptake_Others = ((FUP_curr_method == 13 | FUP_curr_method == 14 | FUP_curr_method == 16) ///
			& COUN_3081 == FUP_curr_method) if !mi(FUP_curr_method) & !mi(COUN_3081)
	tab uptake_Others //576 = 248 different + 328 same

label var uptake_implants "Post-counseling method is the same as FUP method use: Implants"
label var uptake_injectables "Post-counseling method is the same as FUP method use: Injectables"
label var uptake_pills "Post-counseling method is the same as FUP method use: Pills"
label var uptake_Others "Post-counseling method is the same as FUP method use: Others"

* ============================ 4. FUP ideal Method = injectables ========================================
gen FUPIdeal_implants = (FUP_ideal_method == 5) if !mi(FUP_ideal_method)
gen FUPIdeal_injectables = (FUP_ideal_method == 4) if !mi(FUP_ideal_method)
gen FUPIdeal_pills = (FUP_ideal_method == 6) if !mi(FUP_ideal_method)
gen FUPIdeal_Others = (FUP_ideal_method == 13 | FUP_ideal_method == 14 | FUP_ideal_method == 16) if !mi(FUP_ideal_method)

label var FUPIdeal_implants "Follow-up stated ideal method: Implants"
label var FUPIdeal_injectables "Follow-up stated ideal method: Injectables"
label var FUPIdeal_pills "Follow-up stated ideal method: Pills"
label var FUPIdeal_Others "Follow-up stated ideal method: Others"

* ====================== 5. Concordance at the FUP between ideal method and method use =========================================
gen concordance_injectables = ((FUP_curr_method == 4) ///
			& FUP_ideal_method == FUP_curr_method) if !mi(FUP_curr_method) & !mi(FUP_ideal_method)
gen concordance_pills = ((FUP_curr_method == 6) ///
			& FUP_ideal_method == FUP_curr_method) if !mi(FUP_curr_method) & !mi(FUP_ideal_method)
gen concordance_implants = ((FUP_curr_method == 5) ///
			& FUP_ideal_method == FUP_curr_method) if !mi(FUP_curr_method) & !mi(FUP_ideal_method)
gen concordance_Others = ((FUP_curr_method == 13 | FUP_curr_method == 14 | FUP_curr_method == 16) ///
			& FUP_ideal_method == FUP_curr_method) if !mi(FUP_curr_method) & !mi(FUP_ideal_method)

label var concordance_implants "FUP stated ideal method is the same as FUP method use: Implants"
label var concordance_injectables "FUP stated ideal method is the same as FUP method use: Injectables"
label var concordance_pills "FUP stated ideal method is the same as FUP method use: Pills"
label var concordance_Others "FUP stated ideal method is the same as FUP method use: Others"

	gen pre_Coun_short = (COUN_129 == 4 | COUN_129 == 6 | COUN_129 == 7) if !mi(COUN_129)
label var pre_Coun_short "Pre-counseling stated ideal method being pills or condoms"

label val want_to_switch_FUP attrited diff_method_8_noCLI diff_method_5_noCLI ///
postIdeal_implants postIdeal_injectables postIdeal_pills postIdeal_Others ///
FUPmethod_implants FUPmethod_injectables FUPmethod_pills FUPmethod_Others ///
uptake_injectables uptake_pills uptake_implants uptake_Others FUPIdeal_implants ///
FUPIdeal_injectables FUPIdeal_pills FUPIdeal_Others concordance_injectables ///
concordance_pills concordance_implants concordance_Others pre_Coun_short yesno

* TABLE M1-M2
* ============== Attributes =======================
	capture label drop attributes
lab define attributes   1 "EFFECTIVE AT PREVENTING PREGNANCY"  ///
						2 "CAN BE USED WITHOUT ANYONE ELSE KNOWING"  ///
						3 "PROTECTS AGAINST STI/HIV"  ///
						4 "DURATION OF EFFECT / LASTS LONG"   ///
						5 "NO RISK OF HARMING HEALTH"   ///
						6 "NO EFFECT ON REGULAR MONTHLY BLEEDING"   ///
						7 "NO UNPLEASANT SIDE EFFECTS"   ///
						8 "SHOULD NOT BE HORMONAL"  ///
						9 "LOW COST"  ///
						10 "EASILY AVAILABLE AT THE CLNIC"  ///
						11 "CAN BE USED FOR A LONG TIME WITHOUT NEED TO VISIT CLINIC OR RE-SUPPLY"   ///
						12 "WILL BE ABLE TO GET PREGNANT WHEN I WANT"  ///
						13 "NO NEED TO GO TO A CLINIC TO OBTAIN THE METHOD"  ///
						14 "NO RISK OF INFERTILITY"  ///
						15 "NO NEED TO REMEMBER USING THE METHOD"   ///
						16 "WANT TO TRY SOMETHING NEW / TIRED OF OLD METHOD"  ///
						17 "MY DOCTOR RECOMMENDED IT TO ME"  ///
						18 "MY HUSBAND WANTED ME TO USE THIS METHOD"  ///
						19 "OTHER WOMEN IN MY FAMILY HAVE USED THIS METHOD"  ///
						20 "FRIENDS HAVE USED THIS METHOD"  ///
						21 "DOES NOT INTERRUPT SEX"  ///
						96 "OTHER"
	
	lab val w1_w03_w336? attributes

gen attribute_1 = w1_w03_w338_1_1extra 
replace attribute_1 = w1_w03_w3361 if !missing(w1_w03_w3361) & missing(attribute_1)
	recode attribute_1 (88=.)
	label val attribute_1 attributes
	label var attribute_1 "Top method attribute"
	
	*CHECK
	count if attribute_1 != w1_w03_attribute_1 
* ==> can use w1_w03_attribute_1

assert w1_w03_attribute_1 == attribute_1 
assert w1_w03_attribute_2 == w1_w03_w338_2_1extra
assert w1_w03_attribute_3 == w1_w03_w338_3_1extra

sum w1_w03_attribute_1 if w1_w03_attribute_1 !=96
sum w1_w03_attribute_2 if w1_w03_attribute_2 !=96
sum w1_w03_attribute_3 if w1_w03_attribute_3 !=96
	label val w1_w03_attribute_2 attributes
	label val w1_w03_attribute_3 attributes
	
********************* Counseling Attribute ********************
replace w1_w03_attribute_1 = 12 if w1_w03_attribute_1 == 96 & w1_w03_w336_o == "will be able to stop whenever there is aproblem compared to other methods"
replace w1_w03_attribute_1 = 12 if w1_w03_attribute_1 == 96 & w1_w03_w336_o == "wanted the method which if they may be any side effects she can stop using anytime withoout any problem"
replace w1_w03_attribute_1 = 20 if w1_w03_attribute_1 == 96 & w1_w03_w336_o == "coz other members in church use this method"

gen COUN_attribute = w1_w03_attribute_1 if COUN__FV_1 == 1
replace COUN_attribute = COUN_130extra if COUN_131 == 1
	label val COUN_attribute attributes
	label var COUN_attribute "Top method attribute at counseling (updated from BL)"
	
 * COUN_attribute = 1 4
gen method1 = 1 if COUN_attribute == 1 | COUN_attribute == 4
gen method2 = 2 if COUN_attribute == 1 | COUN_attribute == 4
gen method3 = 3 if COUN_attribute == 1 | COUN_attribute == 4
gen method4 = 5 if COUN_attribute == 1 | COUN_attribute == 4
gen method5 = 4 if COUN_attribute == 1 | COUN_attribute == 4
gen method6 = 6 if COUN_attribute == 1 | COUN_attribute == 4

 * COUN_attribute = 5 6 7 8 9 13 14
replace method1 = 12 if inlist(COUN_attribute, 5, 6, 7, 8, 9, 13, 14)
replace method2 = 10 if inlist(COUN_attribute, 5, 6, 7, 8, 9, 13, 14)
replace method3 = 13 if inlist(COUN_attribute, 5, 6, 7, 8, 9, 13, 14)
replace method4 = 11 if inlist(COUN_attribute, 5, 6, 7, 8, 9, 13, 14)
replace method5 = 7 if inlist(COUN_attribute, 5, 6, 7, 8, 9, 13, 14)
replace method6 = 8 if inlist(COUN_attribute, 5, 6, 7, 8, 9, 13, 14)

* COUN_attribute = 12
replace method1 = 7 if COUN_attribute == 12
replace method2 = 8 if COUN_attribute == 12
replace method3 = 10 if COUN_attribute == 12
replace method4 = 13 if COUN_attribute == 12
replace method5 = 11 if COUN_attribute == 12
replace method6 = 3 if COUN_attribute == 12

* COUN_attribute == 3
replace method1 = 7 if COUN_attribute == 3
replace method2 = 8 if COUN_attribute == 3

* COUN_attribute == 10 16 17 18 19 20
replace method1 = 3 if inlist(COUN_attribute, 10, 16, 17, 18, 19, 20) 
replace method2 = 5 if inlist(COUN_attribute, 10, 16, 17, 18, 19, 20) 
replace method3 = 1 if inlist(COUN_attribute, 10, 16, 17, 18, 19, 20) 
replace method4 = 2 if inlist(COUN_attribute, 10, 16, 17, 18, 19, 20) 
replace method5 = 6 if inlist(COUN_attribute, 10, 16, 17, 18, 19, 20) 
replace method6 = 4 if inlist(COUN_attribute, 10, 16, 17, 18, 19, 20) 

* COUN_attribute == 15
replace method1 = 1 if COUN_attribute == 15
replace method2 = 2 if COUN_attribute == 15
replace method3 = 3 if COUN_attribute == 15
replace method4 = 5 if COUN_attribute == 15
replace method5 = 4 if COUN_attribute == 15

* COUN_attribute == 11
replace method1 = 10 if COUN_attribute == 11
replace method2 = 13 if COUN_attribute == 11
replace method3 = 11 if COUN_attribute == 11
replace method4 = 1 if COUN_attribute == 11
replace method5 = 2 if COUN_attribute == 11
replace method6 = 3 if COUN_attribute == 11
gen method7 = 5 if COUN_attribute == 11

* COUN_attribute == 2
replace method1 = 12 if COUN_attribute == 2
replace method2 = 10 if COUN_attribute == 2
replace method3 = 13 if COUN_attribute == 2
replace method4 = 11 if COUN_attribute == 2
replace method5 = 4 if COUN_attribute == 2

* COUN_attribute == 21
replace method1 = 1 if COUN_attribute == 21
replace method2 = 2 if COUN_attribute == 21
replace method3 = 3 if COUN_attribute == 21
replace method4 = 12 if COUN_attribute == 21
replace method5 = 5 if COUN_attribute == 21
replace method6 = 4 if COUN_attribute == 21
replace method7 = 6 if COUN_attribute == 21

clonevar tailored_method1 = method1
clonevar tailored_method2 = method2
clonevar tailored_method3 = method3
clonevar tailored_method4 = method4
clonevar tailored_method5 = method5
clonevar tailored_method6 = method6
clonevar tailored_method7 = method7

forvalues i = 8/12{
	gen method`i' = .
}
replace method1 = 3 if SHORT_T == 0
replace method2 = 5 if SHORT_T == 0
replace method3 = 1 if SHORT_T == 0
replace method4 = 2 if SHORT_T == 0
replace method5 = 6 if SHORT_T == 0
replace method6 = 4 if SHORT_T == 0
replace method7 = 7 if SHORT_T == 0
replace method8 = 8 if SHORT_T == 0
replace method9 = 12 if SHORT_T == 0
replace method10 = 10 if SHORT_T == 0
replace method11 = 13 if SHORT_T == 0
replace method12 = 11 if SHORT_T == 0

forvalues x = 1/12{
	label var method`x' "Method `x' corresponding to woman's top method attribute during counseling"
}

* CHECK
	capture label drop methods
label define methods 0 "NONE" /// 
					1 "FEMALE STERILIZATION" ///
					2 "MALE STERILIZATION" ///
					3 "IUD" ///
					4 "INJECTABLES" ///
					5 "IMPLANTS" ///
					6 "PILL" ///
					7 "CONDOM" ///
					8 "FEMALE CONDOM" ///
					9 "DIAPHRAGM / FOAM / JELLY" ///
					10 "TWO DAY METHOD" ///
					11 "STANDARD DAYS METHOD" ///
					12 "LACTATIONAL AMENORRHEA METHOD" ///
					13 "RHYTHM METHOD" ///
					14 "WITHDRAWAL" ///
					15 "OTHER MODERN METHOD" ///
					16 "OTHER TRADITIONAL METHOD"

foreach var of varlist method1-method7{
	label val `var' methods
}

label val FUP_ideal_method_NoClinic methods 
label val switchto_method_b baseline_curr_method baseline_afterswitch_method ///
	baseline_ideal_method coun_curr_method methods
label val PHO_method HOM_method CLIN_method FUP_curr_method CLIN_ideal_method ///
	FUP_ideal_method PHO_switchto_method HOM_switchto_method FUP_switchto_method ///
	COUN_switchto_method methods
* Method-attribute Concordance
// gen method_attribute_con = (inlist(baseline_curr_method, method1, method2, method3, method4, method5, method6, method7, method8, method9, method10, method11, method12))
//
// label var method_attribute_con "Baseline method use and method attribute are concordant"
// 	label val method_attribute_con yesno

* Counseling method use-attribute Concordance
gen method_attribute_con2 = (inlist(coun_curr_method, method1, method2, method3, method4, method5, method6, method7, method8, method9, method10, method11, method12))

label var method_attribute_con2 "Method use in list, pre-counseling stated preferred method not in list"

* Ideal-method-attribute Concordance
gen method_attribute_con1 = (inlist(COUN_129, method1, method2, method3, method4, method5, method6, method7, method8, method9, method10, method11, method12))

label var method_attribute_con1 "Pre-counseling stated preferred method in list, method use not in list"

* Concordance 3
gen method_attribute_con3 = (COUN_129 == coun_curr_method & inlist(COUN_129, method1, method2, method3, method4, method5, method6, method7, method8, method9, method10, method11, method12))  if !mi(COUN_129) & !mi(coun_curr_method)

label var method_attribute_con3 "Pre-counseling stated preferred method = method use, in list"

* Concordance 4
gen method_attribute_con4 = (COUN_129 == coun_curr_method)  if !mi(COUN_129) & !mi(coun_curr_method)

label var method_attribute_con4 "Pre-counseling stated preferred method = method use"

* Concordance 5
gen method_attribute_con5 = (inlist(COUN_129, method1, method2, method3, method4, method5, method6, method7, method8, method9, method10, method11, method12) & inlist(coun_curr_method, method1, method2, method3, method4, method5, method6, method7, method8, method9, method10, method11, method12) & COUN_129 != coun_curr_method)  if !mi(COUN_129) & !mi(coun_curr_method)

label var method_attribute_con5 "Pre-counseling stated preferred method != method use in list"

// gen method_attribute_con2 = (inlist(baseline_ideal_method, method1, method2, method3, method4, method5, method6, method7, method8, method9, method10, method11, method12))
//
// label var method_attribute_con2 "Baseline stated ideal method falls in the attribute-based method list"

	label val /*method_attribute_con*/ method_attribute_con1 /*method_attribute_con2*/ yesno

* New outcomes
gen method_inlist_95 = inlist(COUN_3081, tailored_method1, tailored_method2, tailored_method3, tailored_method4, tailored_method5, tailored_method6, tailored_method7) if !mi(COUN_3081)

label var method_inlist_95 "Post-counseling method in tailored list"

gen method_inlist_96 = inlist(FUP_curr_method, tailored_method1, tailored_method2, tailored_method3, tailored_method4, tailored_method5, tailored_method6, tailored_method7) if !mi(FUP_curr_method)

label var method_inlist_96 "Follow-up method use in tailored list"

gen method_inlist_97 = inlist(FUP_ideal_method, tailored_method1, tailored_method2, tailored_method3, tailored_method4, tailored_method5, tailored_method6, tailored_method7) if !mi(FUP_ideal_method)

label var method_inlist_97 "Follow-up ideal method in tailored list"
	
gen method_inlist_98 = inlist(COUN_3081, tailored_method1, tailored_method2, tailored_method3, tailored_method4, tailored_method5, tailored_method6, tailored_method7) & inlist(FUP_curr_method, tailored_method1, tailored_method2, tailored_method3, tailored_method4, tailored_method5, tailored_method6, tailored_method7) if !mi(COUN_3081) & !mi(FUP_curr_method)

label var method_inlist_98 "Both post-counseling preferred method and FUP method use in tailored list"

gen method_inlist_99 = inlist(FUP_ideal_method, tailored_method1, tailored_method2, tailored_method3, tailored_method4, tailored_method5, tailored_method6, tailored_method7) & inlist(FUP_curr_method, tailored_method1, tailored_method2, tailored_method3, tailored_method4, tailored_method5, tailored_method6, tailored_method7) if !mi(FUP_ideal_method) & !mi(FUP_curr_method)

label var method_inlist_99 "Both FUP stated preferred method and FUP method use in tailored list"

gen method_inlist_100 = inlist(COUN_3081, tailored_method1, tailored_method2, tailored_method3, tailored_method4, tailored_method5, tailored_method6, tailored_method7) & COUN_3081 == FUP_curr_method if !mi(COUN_3081) & !mi(FUP_curr_method)

label var method_inlist_100 "Post-counseling ideal method = FUP method use in tailored list"

gen method_inlist_101 = inlist(FUP_ideal_method, tailored_method1, tailored_method2, tailored_method3, tailored_method4, tailored_method5, tailored_method6, tailored_method7) & FUP_ideal_method == FUP_curr_method if !mi(COUN_3081) & !mi(FUP_curr_method)

label var method_inlist_101 "Follow-up stated preferred method = FUP method use in tailored list"

	capture drop same_method_9
gen same_method_9 = (FUP_curr_method == COUN_3081 & inlist(COUN_3081, tailored_method1, tailored_method2, tailored_method3, tailored_method4, tailored_method5, tailored_method6, tailored_method7)) if !mi(FUP_curr_method) & !mi(COUN_3081)
	label var same_method_9 "Post-counseling ideal method is the same as FUP current method in tailored list"
	label val same_method_9 yesno
	tab same_method_9 //576 = 248 different + 328 same
	
	capture drop same_method_5
gen same_method_5 = (FUP_ideal_method == FUP_curr_method & inlist(FUP_curr_method, tailored_method1, tailored_method2, tailored_method3, tailored_method4, tailored_method5, tailored_method6, tailored_method7)) if !mi(FUP_curr_method) & !mi(FUP_ideal_method)
	label var same_method_5 "FUP ideal method is the same as FUP current method use in tailored list"
	label val same_method_5 yesno

label val  ethnicity_Chewa preprimary educ_primary educ_second educ_higher husband_support ///
baseline_inj baseline_implants BL_long_acting_method husb_satisfied yesno

* Drop unused variables
drop w1_hh1_r_hr_7b_h w1_hh1_ew_hhh_conf w1_hh1_woman_age w1_hh1_birth_date2 ///
w1_w03_w338a w1_w06_w610_a_m w1_w06_w610_a_y w1_w06_w610_b_m w1_w06_w610_b_y

drop  w1_w03_w3321 w1_w03_w3323 w1_w03_w3324 w1_w03_w3325 w1_w03_w3326 ///
w1_w03_w3327 w1_w03_w33211 w1_w03_w33215 w1_w03_w33216

drop w1_w03_w338b1 w1_w03_w338b3 w1_w03_w338b4 w1_w03_w338b5 w1_w03_w338b6 ///
w1_w03_w338b7 w1_w03_w338b14

drop w1_w03_w338_2_1extra w1_w03_w338_3_1extra
drop w1_w03_attribute_2 w1_w03_attribute_3

drop COUN__HUSB_101A COUN__HUSB_101B

drop COUN_1241 COUN_1242 COUN_1243 COUN_1244 COUN_1245 COUN_1246 ///
COUN_1247 COUN_1248 COUN_1249 COUN_12410 COUN_12411 COUN_12412 ///
COUN_12413 COUN_12414 COUN_12415 COUN_12416

drop COUN_1271 COUN_1272 COUN_1273 COUN_1274 COUN_1275 COUN_1276 ///
COUN_1277 COUN_1278 COUN_1279 COUN_12710 COUN_12711 COUN_12712 ///
COUN_12713 COUN_12714 COUN_12715 COUN_12716

drop  PHO_1051 PHO_1052 PHO_1053 PHO_1054 PHO_1055 PHO_1056 PHO_1057 ///
PHO_1058 PHO_1059 PHO_10510 PHO_10511 PHO_10512 PHO_10513 PHO_10514 ///
PHO_10515 PHO_10516 

drop PHO_105N11 PHO_105N12 PHO_105N13 PHO_105N14 PHO_105N15 PHO_105N16 ///
PHO_105N17 PHO_105N18 PHO_105N19 PHO_105N110 PHO_105N111 PHO_105N112 ///
PHO_105N113 PHO_105N114 PHO_105N115 PHO_105N116

drop HOME_1051 HOME_1052 HOME_1053 HOME_1054 HOME_1055 HOME_1056 ///
HOME_1057 HOME_1058 HOME_1059 HOME_10510 HOME_10511 HOME_10512 ///
HOME_10513 HOME_10514 HOME_10515 HOME_10516

drop HOM_105N11 HOM_105N12 HOM_105N13 HOM_105N14 HOM_105N15 HOM_105N16 ///
HOM_105N17 HOM_105N18 HOM_105N19 HOM_105N110 HOM_105N111 HOM_105N112 ///
HOM_105N113 HOM_105N114 HOM_105N115 HOM_105N116

drop CLIN_1051 CLIN_1052 CLIN_1053 CLIN_1054 CLIN_1055 CLIN_1056 ///
CLIN_1057 CLIN_1058 CLIN_1059 CLIN_10510 CLIN_10511 CLIN_10512 CLIN_10513 ///
CLIN_10514 CLIN_10515 CLIN_10516

drop PHO_1392 PHO_1393 PHO_1394 PHO_1395 PHO_13999

drop COUN__treatment

drop  district area sector cluster

drop counseling_start_dt counseling_comp_dt COUN_130extra COUN_201A COUN_201B ///
COUN_301A counseling_start_date counseling_end_date coun_start_time ///
HUSB_coun_start_date husb_counseling_start_dt counseling_time_husb_sec

drop PHO_105N PHO_111 HOM_105N HOM_111 

drop w1_w03_w313 w1_w03_w336_o w1_w03_w338_1_1extra ///
w1_w03_total_num_attribute w1_w03_attribute_1 w1_w06_w609 

drop COUN_123 COUN_131 

drop PHO_104 PHO_118 PHO_138 PHO_1391 

drop HOME_104 HOME_118 HOME_138 HOME_1391 

drop CLIN_104C CLIN_106 CLIN_107 CLIN_108 CLIN_204 CLIN_205 CLIN_206 CLIN_118

* Some final changes
drop cont_use PHO_method HOM_method CLIN_method CLIN_ideal_method ///
FUP_ideal_method PHO_switchto_method HOM_switchto_method FUP_switchto_method ///
COUN_switchto_method switchto_method_b baseline_afterswitch_method

drop w1_w03_w3361 w1_w03_w3362 w1_w03_w3363 w1_w03_w3364 w1_w03_w3365 ///
w1_w03_w3366 w1_w03_w3367

order w1_w03_w3040, before(w1_w03_w3043)

assert top_attribute_wgt== attribute_1_wgt

drop attribute_1_wgt

drop _est_number_coun_fe all20 attribute_total ratio n

* Baseline hormonal methods
	gen baseline_hormonal = (baseline_inj == 1 | baseline_implants == 1) if !mi(w1_w03_w303)
	
* Treatment group indicators

forvalues i = 0/3{
    gen treatment`i' = w1_treatment == `i'
}

label var treatment0 "Control Group"
label var treatment1 "T1: Standard Counseling, Partner Invitations"
label var treatment2 "T2: Tailored Counseling, No Partner Invitations"
label var treatment3 "T3: Tailored Counseling, Partner Invitations"

save "$data\MBBS_Analysis_data.dta", replace
