***MALAWI Behavioral Biases Study
***DO FILE (NOT TO BE SUBMITTED): labelling do-file

***KEXIN ZHANG
***NOVEMBER 23, 2023

label var caseid "Identification number / Case ID"

* TABLE 1
order age tot_child wom_des_fam_size preprimary educ_primary educ_second educ_higher wom_work cohab_age curr_use baseline_inj baseline_implants top_attribute top_attribute_wgt want_to_switch husband_support prior_knowledge base_fup_span2, after(caseid)

label var age "Baseline: Woman's age (in years)"
label var tot_child "Baseline: Total number of children"
label var wom_des_fam_size "Baseline: Women's desired number of children"
label var preprimary "Education at baseline: None (1=yes)"
label var educ_primary "Education at baseline: Primary (1=yes)"
label var educ_second "Education at baseline: Secondary (1=yes)"
label var educ_higher "Education at baseline: Higher (1=yes)"
label var wom_work "Woman is currently working at baseline (1=yes)"
label var cohab_age "Baseline: Age at first cohabitation (1=yes)"
label var curr_use "Current use of FP at baseline (1=yes)"
label var baseline_inj "Baseline FP method: Injectables (1=yes)"
label var baseline_implants "Baseline FP method: Implants (1=yes)"
label var top_attribute "Top attribute in choosing a FP method at baseline: Effectiveness (1=yes)"
label var top_attribute_wgt "Weight given to top attribute at baseline"
label var want_to_switch "Wants to switch methods at baseline (1=yes)"
label var husband_support "Partner supports FP at baseline (1=yes)"
label var prior_knowledge "Women's prior knowledge about FP at baseline(number of FP methods women ever heard of)"
label var base_fup_span2 "Days between Baseline and Follow-up"

* TABLE 2
order age_binary cont_use1 eff_attribute w1_mergeRand COUN__FV_1 PHO_REC_4 HOME_REV_20 mergeCLI COUN_118 PHO_103 HOME_103 SHORT_T HUSB_T diff_method_8 diff_method_3 intertemperal_concordance contemp_concordance, after(base_fup_span2)

label var age_binary "Stratifying variable: Women's age not older than 26 at baseline (1=yes)"
label var cont_use1 "Stratifying variable: Contraceptive use at baseline (injectable use over 5 months is considered not using, 1=yes)"
label var eff_attribute "Stratifying variable: Top method attribute in choosing a FP method at baseline being effectiveness (1=yes)"
label var w1_mergeRand "Women were included for randomization (1= baseline only, 2 = randomization only, 3 = both)"
label var COUN__FV_1 "Women attended the counseling session (1=yes)"
label var PHO_REC_4 "Women consent to participate in the phone interview (1=yes)"
label var HOME_REV_20 "Women consent to participate in the home-based interview (1=yes)"
label var mergeCLI "Women went to the Good Health Kauma Clinic to pick up FP services during the one-month service period (3=yes, 1=no)"
label var COUN_118 "Women were pregnant at counseling (1=yes, 0=no, 88=don't know)"
label var PHO_103 "Women reached by phone were pregnant at the follow-up (1=yes, 0=no)"
label var HOME_103 "Women reached at home were pregnant at the follow-up (1=yes, 0=no)"
label var SHORT_T "Assignment to the tailored counseling intervention (1=yes)"
label var HUSB_T "Assignment to the partner invitation intervention (1=yes)"
	label val SHORT_T HUSB_T yes
label var diff_method_8 "Changes in stated preferred method (from pre-counseling to follow-up, 1=yes)"
label var diff_method_3 "Changes in method use (from counseling to follow-up, 1=yes)"
label var intertemperal_concordance "Intertemporal concordance (1=yes)"
	label val intertemperal_concordance yes
label var contemp_concordance "Contemporaneous concordance (1=yes)"
	label val contemp_concordance yes
* TABLE 3
order method_attribute_con2 method_attribute_con1 method_attribute_con3 method_attribute_con5, after(contemp_concordance)
label var method_attribute_con2 "Method use at counseling was included in the list of FP methods that were counseled on (1=yes)"
label var method_attribute_con1 "Stated preferred method at pre-counseling was included in the list of FP methods that were counseled on (1=yes)"
label var method_attribute_con3 "Pre-counseling stated preferred method = method use at counseling, and both were included in the list of methods that were counseled on (1=yes)"
label var method_attribute_con5 "Pre-counseling stated preferred method is DIFFERENT from method use at counseling, and both were included in the list of methods that were counseled on (1=yes)"
	label val method_attribute_con2 method_attribute_con1 method_attribute_con3 method_attribute_con5 yes

* TABLE 4
order women_own_house_a women_earn_more women_decide_her_m women_child_edu husb_supports_fp husb_want_more, after(method_attribute_con5)
label var women_own_house_a "Baseline: Women own at least one house alone (1=yes)"
label var women_earn_more "Baseline: Women earn no less than male partner (1=yes)"
label var women_decide_her_m "Baseline: Women decide how her earnings should be used (1=yes)"
label var women_child_edu "Baseline: Women deide over children's education (1=yes)"
label var husb_supports_fp "Baseline: Male partners strongly support family planning (1=yes)"
label var husb_want_more "Baseline: Male partners want more children than their wives (1=yes)"
	label val women_own_house_a women_earn_more women_decide_her_m women_child_edu husb_supports_fp husb_want_more yes

* TABLE A2
order w1_w03_attribute_11 w1_w03_attribute_12 w1_w03_attribute_13 w1_w03_attribute_14 w1_w03_attribute_15 w1_w03_attribute_16 w1_w03_attribute_17 w1_w03_attribute_18 w1_w03_attribute_19  w1_w03_attribute_110 w1_w03_attribute_111 w1_w03_attribute_112 w1_w03_attribute_113  w1_w03_attribute_114 w1_w03_attribute_115 w1_w03_attribute_117  w1_w03_attribute_119 w1_w03_attribute_120   w1_w03_attribute_121   w1_w03_attribute_196, after(husb_want_more)

global top_attributes  w1_w03_attribute_11 w1_w03_attribute_12 w1_w03_attribute_13 w1_w03_attribute_14 w1_w03_attribute_15 w1_w03_attribute_16 w1_w03_attribute_17 w1_w03_attribute_19  w1_w03_attribute_110 w1_w03_attribute_111 w1_w03_attribute_112 w1_w03_attribute_113 w1_w03_attribute_114 w1_w03_attribute_115 w1_w03_attribute_117 w1_w03_attribute_18 w1_w03_attribute_119 w1_w03_attribute_120 w1_w03_attribute_121 w1_w03_attribute_196

foreach var of varlist $top_attributes{
    local u : var label `var' 
	local m = "Top attribute in choosing a FP method at BL: "+ "`u'"
	label var `var' "`m'"
}

* TABLE A3
order treatment0 treatment1 treatment2 treatment3, after(w1_w03_attribute_196)

label var treatment0 "Treatment arm T0: Standard Counseling, No Partner Invitations"
label var treatment1 "Treatment arm T1: Standard Counseling, Partner Invitations"
label var treatment2 "Treatment arm T2: Tailored Counseling, No Partner Invitations"
label var treatment3 "Treatment arm T3: Tailored Counseling, Partner Invitations"
	label val treatment0 treatment1 treatment2 treatment3 yes

* TABLE A4
order COUN_207, after(treatment3)
label var COUN_207 "Women chose to invite their male partner to counseling (1=yes)"

* TABLE A5
order BL_Ideal_Method0 BL_Ideal_Method4 BL_Ideal_Method5 modern_methods_BLideal traditional_methods_BLideal COUN_303_None COUN_303_inj COUN_303_implants COUN_303_modern COUN_303_traditional COUN__HUSB_1210 COUN__HUSB_1214 COUN__HUSB_1215 husb_ideal_other_modern husb_ideal_traditional HUSB_T_comp, after(COUN_207)

label var BL_Ideal_Method0 "Stated preferred method at BL: None (1=yes)"
label var BL_Ideal_Method4 "Stated preferred method at BL: Injectables (1=yes)" 
label var BL_Ideal_Method5 "Stated preferred method at BL: Implants (1=yes)"
label var modern_methods_BLideal "Stated preferred method at BL: Other modern methods (sterilization/IUD/pills/condoms, 1=yes)"
label var traditional_methods_BLideal "Stated preferred method at BL: Other traditional methods (standard days method/withdrawal, 1=yes)" 
label var COUN_303_None "Stated preferred method at Post-counseling: None (1=yes)"
label var COUN_303_inj "Stated preferred method at Post-counseling: Injectables (1=yes)"
label var COUN_303_implants "Stated preferred method at Post-counseling: Implants (1=yes)"
label var COUN_303_modern "Stated preferred method at Post-counseling: Other modern methods (sterilization/IUD/pills/condoms, 1=yes)"
label var COUN_303_traditional "Stated preferred method at Post-counseling: Other traditional methods (Two-day method/withdrawal, 1=yes)"
label var COUN__HUSB_1210 "Male partner's stated preferred method at pre-counseling: None (1=yes)"
label var COUN__HUSB_1214 "Male partner's stated preferred method at pre-counseling: Injectables (1=yes)"
label var COUN__HUSB_1215 "Male partner's stated preferred method at pre-counseling: Implants (1=yes)"
label var husb_ideal_other_modern "Male partner's stated preferred method at pre-counseling: Other modern methods (sterilization/IUD/pills/condoms/other modern methods, 1=yes)"
label var husb_ideal_traditional "Male partner's stated preferred method at pre-counseling: Other traditional methods (rhythm method/withdrawal/other traditional methods, 1=yes)"
label var HUSB_T_comp "Male partner consent to attend counseling (1=yes)"
	label val modern_methods_BLideal traditional_methods_BLideal COUN_303_None COUN_303_inj COUN_303_implants COUN_303_modern COUN_303_traditional COUN__HUSB_1210 COUN__HUSB_1214 COUN__HUSB_1215 husb_ideal_other_modern husb_ideal_traditional HUSB_T_comp yes
	
* Table A6
order diff_method_2 diff_method_22 /*diff_method_8*/, after(HUSB_T_comp)
label var diff_method_2 "Changes in stated preferred method between pre-counseling and post-counseling (1=yes)"
label var diff_method_22 "Changes in stated preferred method between post-counseling and follow-up (1=yes)"

* Table D1
order baseline_ideal_method COUN_129 COUN_303 FUP_ideal_method baseline_curr_method coun_curr_method FUP_curr_method diff_method111 diff_method112 diff_method113 diff_method114 diff_method115 diff_method116 diff_method117 diff_method118 diff_method119 w1_w03_w331 COUN_126 want_to_switch_FUP, after(diff_method_22)

label var baseline_ideal_method "Stated preferred method at baseline" 
label var COUN_129 "Stated preferred method at pre-counseling"
label var COUN_303 "Stated preferred method at post-counseling"
label var FUP_ideal_method "Stated preferred method at follow-up"
label var baseline_curr_method "Method use at baseline"
label var coun_curr_method "Method use at counseling"
label var FUP_curr_method "Method use at follow-up"
label var diff_method111 "Changes in stated preferred method from baseline to pre-counseling (1=yes)"
label var diff_method112 "Changes in stated preferrd method from baseline to post-counseling (1=yes)"
label var diff_method113 "Changes in stated preferred method from baseline to follow-up (1=yes)"
label var diff_method114 "Changes in stated preferred method from pre-counseling to post-counseling (1=yes)"
label var diff_method115 "Changes in stated preferred method from pre-counseling to follow-up (1=yes)"
label var diff_method116 "Changes in stated preferred method from post-counseling to follow-up (1=yes)"
label var diff_method117 "Changes in method use from baseline to counseling (1=yes)"
label var diff_method118 "Changes in method use from baseline to follow-up (1=yes)"
label var diff_method119 "Changes in method use from counseling to follow-up (1=yes)"
label var w1_w03_w331 "Women want to switch to another FP method at baseline (1=yes)"
label var COUN_126 "Women want to switch to another FP method at counseling (1=yes)"
label var want_to_switch_FUP "Women want to switch to another FP method at follow-up (1=yes)"

* TABLE E1: same as Table 1

* TABLE E2
order attrited, after(want_to_switch_FUP)
label var attrited "Women who attrited from the sample at the counseling or follow-up (1=yes)"

* TABLE E3-E5
order COUN_available COUN__husb_cons PHO_REC_1 HOM_REC_1 anyClinic, after(attrited)
label var COUN_available "Woman is available for counseling (1=yes)"
label var COUN__husb_cons "Male partners consent to participate in counseling (1=yes)"
label var PHO_REC_1 "Woman is available for the phone-based interview (1=yes)"
label var HOM_REC_1 "Woman is available for the home-based interview (1=yes)"
label var anyClinic "In the past month, woman visited the Good Health (Kauma clinic), a pharmacy, or hospital to receive any family planning services (1=yes)"

* TABLE E6: same as Table 1
order BL_long_acting_method husb_satisfied, after(anyClinic)

label var BL_long_acting_method "Method use at baseline is a long-acting method (IUD/injectables/implants (1=yes))"
label var husb_satisfied "Baseline: Male partners were very satisfied or somewhat satisfied with their wives' current contraceptive method (1=yes)"
	label val BL_long_acting_method husb_satisfied yes

* TABLE F1
