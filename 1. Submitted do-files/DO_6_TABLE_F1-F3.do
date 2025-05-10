***MALAWI Behavioral Biases Study
***DO FILE 6: TABLE G1-G3
***SELECTION OF WOMEN

***KEXIN ZHANG
***NOVEMBER 15, 2023

version 13

clear all

use "$data\MBBS_Analysis_data.dta"

keep if w1_mergeRand == 3
	
global DESCVARS age tot_child wom_des_fam_size preprimary educ_primary educ_second educ_higher wom_work cohab_age curr_use baseline_inj baseline_implants top_attribute top_attribute_wgt want_to_switch husband_support

****** Selection between those who used long-lasting methods (IUD, Implants, Injectables) and those who were not
global DESCVARS1 $DESCVARS BL_long_acting_method husb_satisfied

* TABLE G1 - Selection between women who were reached for Counseling and those who were lost for counseling
************************************************************************************
eststo clear 
eststo all: quietly estpost summarize $DESCVARS1 if !mi(COUN_available)
eststo counselled: quietly estpost summarize $DESCVARS1 if COUN_available == 1 
eststo not_counselled: quietly estpost summarize $DESCVARS1 if COUN_available == 0
eststo counselled_diff: quietly estpost ttest $DESCVARS1 if !mi(COUN_available), by(COUN_available)

esttab all counselled not_counselled counselled_diff using "$output\counseling_reached.tex", booktabs fragment ///
label cells("mean(pattern(1 1 1 0) fmt(2)) b(star pattern(0 0 0 1) fmt(2))") ///
mtitles("All" "Counselled" "Not Counselled" "Difference") ///
nonumbers replace collabels(none) compress style(tab) ///
prehead("\begin{table}\begin{center}\caption{Who were Available for the Counseling Session?}\label{tab: counselingreached}\tabcolsep=0.2cm\scalebox{0.85}{\begin{tabular}{lcccc}\toprule") ///
postfoot("\bottomrule\end{tabular}}\end{center}\footnotesize{Notes: During the counseling session, 770 women who were interviewed at the baseline were asked if they were available for counseling, among whom 701 women were available for counseling and 69 women did not receive the counseling session. The variable currently working refers to women’s work status at the baseline. First cohabitation age is the age at which women started to live with her (first) husband. Current FP method: Injectables / Implants represents the proportion of women who were using injectables / Implants at baseline among all current users of contraception. Weight to top attribute refers to the number of counters (out of 20 counters) the woman assigned to their top method attribute. Intention to switch methods is woman’s answer to the question: if you had the choice to switch to another method, would you like to switch? Husband support FP is defined from the question: on a scale of 1 to 5, with 1 being strongly supportive and 5 being strongly opposed, how do you believe your husband feels towards using family planning methods? This variable takes 1 if her husband was strongly supportive or supportive of contraceptive use, and 0 otherwise. Using a Long-Acting Methods takes 1 if the woman was using IUDs/implants/injectables at the baseline. *** 1\%, ** 5\%, * 10\%.}\end{table}")

* TABLE G2 -Selection between women who invited husband and those who did not
************************************************************************************
// COMPARE between Compliers and non-compliers in the HUSB_T intervention group
************************************************************************************
replace COUN_207 = 0 if COUN__husb_cons == 0
eststo clear 
eststo husb_t: quietly estpost summarize $DESCVARS1 if HUSB_T ==1 & !mi(COUN_207) & COUN__FV_1 == 1
eststo husb_t_take: quietly estpost summarize $DESCVARS1 if HUSB_T == 1 & COUN_207 == 1 & COUN__FV_1 == 1
eststo husb_t_ntake: quietly estpost summarize $DESCVARS1 if HUSB_T == 1 & COUN_207 == 0 & COUN__FV_1 == 1
eststo husb_itt: quietly estpost ttest $DESCVARS1 if HUSB_T == 1 & COUN__FV_1 == 1, by(COUN_207)

esttab husb_t husb_t_take husb_t_ntake husb_itt using "$output\husband_compliers639.tex", booktabs fragment ///
label cells("mean(pattern(1 1 1 0) fmt(2)) b(star pattern(0 0 0 1) fmt(2))") ///
mgroups("All" "Compliers" "Non-Compliers" "Difference", pattern(1 1 1 1)) ///
nonumbers replace collabels(none) compress style(tab) ///
prehead("\begin{table}\begin{center} \caption{Partner Invitation Compliers}\label{tab: husbandcompliers}\tabcolsep=0.02cm\begin{tabular}{lcccc}\toprule") ///
postfoot("\bottomrule\end{tabular}\end{center}\footnotesize{Notes: Among 701 women who received a counseling session, 401 women were assigned to the partner invitation group, among which 112 male partners participated. Currently working refers to women’s work status at the baseline. First cohabitation age is the age at which women started to live with her (first) husband. Current FP method: Injectables / Implants represents the proportion of women who were using injectables / Implants at baseline among all current users of contraception. Weight to top attribute refers to the number of counters (out of 20 counters) the woman assigned to their top method attribute. Intention to switch methods is woman’s answer to the question: if you had the choice to switch to another method, would you like to switch? Husband support FP is defined from the question: on a scale of 1 to 5, with 1 being strongly supportive and 5 being strongly opposed, how do you believe your husband feels towards using family planning methods? This variable takes 1 if her husband was strongly supportive or supportive of contraceptive use, and 0 otherwise. The variable Using a Long-Acting method at BL takes 1 if the woman was on injectables/implants/IUDs at the baseline. The variable husband satisfied with woman's current contraceptive method is constructed using a question from baseline that how satisfied women's male partner was with their current mthod. This variable takes 1 if her husband is very satisfied or somewhat satified with her current method use at baseline. *** 1\%, ** 5\%, * 10\%.}\end{table}")

* TABLE G3 -Selection between clinic visitors and non-clinic-visitors
************************************************************************************
eststo clear 
eststo all: quietly estpost summarize $DESCVARS1 if COUN__FV_1 == 1
eststo clinic_yes: quietly estpost summarize $DESCVARS1 if mergeCLI == 3 
eststo clinic_no: quietly estpost summarize $DESCVARS1 if mergeCLI != 3 & COUN__FV_1 == 1
eststo clinic_diff: quietly estpost ttest $DESCVARS1 if COUN__FV_1 == 1, by(mergeCLI)

esttab all clinic_yes clinic_no clinic_diff using "$output\visit_clinic639.tex", booktabs fragment ///
label cells("mean(pattern(1 1 1 0) fmt(2)) b(star pattern(0 0 0 1) fmt(2))") ///
mtitles("All" "Yes" "No" "Difference") ///
nonumbers replace collabels(none) compress style(tab) ///
prehead("\begin{table}\begin{center}\caption{Who Visited the Clinic?}\label{tab: visitclinic}\tabcolsep=0.2cm\scalebox{0.62}{\begin{tabular}{lcccc}\toprule") ///
posthead("\midrule\textbf{Visited the Good Health Kauma Clinic?} \\\\[-1ex]") nogaps postfoot("\midrule")

	*========================= Any Clinc ==========================================
	eststo clear 
	eststo all: quietly estpost summarize $DESCVARS1 if (PHO_REC_1 == 1 | HOM_REC_1 == 1 | mergeCLI == 3) &  COUN__FV_1 == 1
	eststo any_clinic: quietly estpost summarize $DESCVARS1 if (PHO_REC_1 == 1 | HOM_REC_1 == 1 | mergeCLI == 3) &  COUN__FV_1 == 1 & anyClinic == 1
	eststo no_clinic: quietly estpost summarize $DESCVARS1 if (PHO_REC_1 == 1 | HOM_REC_1 == 1 | mergeCLI == 3) &  COUN__FV_1 == 1 & anyClinic == 0 
	eststo any_clinic_diff: quietly estpost ttest $DESCVARS1 if (PHO_REC_1 == 1 | HOM_REC_1 == 1 | mergeCLI == 3) &  COUN__FV_1 == 1, by(anyClinic)

	esttab all any_clinic no_clinic any_clinic_diff using "$output\visit_clinic639.tex", booktabs fragment ///
	label cells("mean(pattern(1 1 1 0) fmt(2)) b(star pattern(0 0 0 1) fmt(2))") nomtitles ///
	nonumbers append collabels(none) compress style(tab) ///
	posthead("\textbf{Visited Any Clinic?} \\\\[-1ex]") nogaps ///
	postfoot("\bottomrule\end{tabular}}\end{center}\footnotesize{Notes: Among the 782 women who were interviewed at the baseline, 701 women attended a counseling session, among whom 682 women received a follow-up interview either through phone surveys, home visit surveys, or clinic visit surveys. Currently working refers to women’s work status at the baseline. First cohabitation age is the age at which women started to live with her (first) husband. Current FP method: Injectables / Implants represents the proportion of women who were using injectables / Implants at baseline among all current users of contraception. Weight to top attribute refers to the number of counters (out of 20 counters) the woman assigned to their top method attribute. Intention to switch methods is woman’s answer to the question: if you had the choice to switch to another method, would you like to switch? Husband support FP is defined from the question: on a scale of 1 to 5, with 1 being strongly supportive and 5 being strongly opposed, how do you believe your husband feels towards using family planning methods? This variable takes 1 if her husband was strongly supportive or supportive of contraceptive use, and 0 otherwise. Using a Long-Acting Methods takes 1 if the woman was using IUDs/implants/injectables at the baseline. *** 1\%, ** 5\%, * 10\%.}\end{table}") nogaps

