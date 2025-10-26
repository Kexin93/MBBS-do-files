***MALAWI Behavioral Biases Study
***DO FILE 4: TABLE 4 (Heterogeity analyses for Partner Invitation)

***KEXIN ZHANG
***June 3, 2025

version 13
clear all

use "$data\MBBS_Analysis_data.dta"

global balance_covariates "age_binary cont_use1 eff_attribute"
		
********************************************************************************************************************
******************** Changing Ideal Methods from Counseling to Fup: which group is more likely afterwards? ***********************************
****************************************************************************************************************
keep if w1_mergeRand == 3
keep if COUN__FV_1 == 1

* consent
	keep if PHO_REC_4 == 1 | HOME_REV_20 == 1 | mergeCLI == 3 //675

* Drop pregnant women at counseling
	drop if COUN_118 == 1

* Drop pregnant women at FUP
	drop if PHO_103 == 1 | HOME_103 == 1 //638

	eststo clear
foreach var of varlist /*discuss_kids_husb*/ /*women_own_house_a*/ women_earn_more /*women_decide_her_m women_child_edu women_big_purchase*/ husb_supports_fp husb_want_more husb_sat{
preserve
eststo `var'_Y1: reg diff_method_8 HUSB_T `var' c.HUSB_T#c.`var' $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_8 if HUSB_T == 0 & COUN__FV_1 == 1 
estadd scalar ymean = r(mean)
test _b[HUSB_T] + _b[c.HUSB_T#c.`var'] = 0
estadd scalar pvalue1 = r(p)

eststo `var'_Y2: reg diff_method_3 HUSB_T `var' c.HUSB_T#c.`var' $balance_covariates, vce(robust) 
summarize diff_method_3 if HUSB_T == 0 
estadd scalar ymean = r(mean)
test _b[HUSB_T] + _b[c.HUSB_T#c.`var'] = 0
estadd scalar pvalue1 = r(p)

eststo `var'_Y3: reg intertemperal_concordance HUSB_T `var' c.HUSB_T#c.`var' $balance_covariates, vce(robust) 
summarize intertemperal_concordance if HUSB_T == 0
estadd scalar ymean = r(mean)
test _b[HUSB_T] + _b[c.HUSB_T#c.`var'] = 0
estadd scalar pvalue1 = r(p)

eststo `var'_Y4: reg contemp_concordance HUSB_T `var' c.HUSB_T#c.`var' $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize contemp_concordance if HUSB_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
test _b[HUSB_T] + _b[c.HUSB_T#c.`var'] = 0
estadd scalar pvalue1 = r(p)
restore
}

label var HUSB_T "Partner invitation (PI)"

/*esttab women_big_purchase_Y1 women_big_purchase_Y2 women_big_purchase_Y3 women_big_purchase_Y4 using "$output\partner_subgroups_interaction.tex", replace fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T c.HUSB_T#c.women_big_purchase) ///
prehead("\begin{table}\begin{center}\caption{Heterogeneity in the Treatment Effect of Partner Invitation}\label{tab: partnerbygroup}\tabcolsep=0.3cm\scalebox{0.8}{\begin{tabular}{lcccc}\toprule") coeflabel(women_big_purchase "\makecell[l]{Women decide big \\ purchases}" c.HUSB_T#c.women_big_purchase "PI $\times$ Women decide big puchases") posthead("\midrule" ) ///
stats(N pvalue1, fmt(%9.0f %9.3f) labels("N" "\makecell[l]{PI + PI $\times$ Women \\ decide big purchases = 0}"))  ///
mtitles("\makecell{Change in \\ Stated Preferred Method}" "\makecell{Change in \\ Method Use}" "\makecell{Intertemporal \\ Concordance}" "\makecell{Contemporaneous \\ Concordance}") collabels(none) postfoot("\cdashline{1-5}")
*/

// esttab women_child_edu_Y1 women_child_edu_Y2 women_child_edu_Y3 women_child_edu_Y4 using "$output\partner_subgroups_interaction.tex", replace fragment label nolines ///
// cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T c.HUSB_T#c.women_child_edu) ///
// prehead("\begin{table}\begin{center}\caption{Heterogeneity in the Treatment Effect of Partner Invitation}\label{tab: partnerbygroup}\tabcolsep=0.3cm\scalebox{0.8}{\begin{tabular}{lcccc}\toprule") ///
// stats(N pvalue1, fmt(%9.0f %9.3f) labels("N" "\makecell[l]{PI + PI $\times$ Women \\ decide child's education}"))  ///
// coeflabel(women_child_edu "\makecell[l]{Woman decide \\ child's education}" c.HUSB_T#c.women_child_edu "PI $\times$ Women decide child's education") collabels(none) nonumbers posthead("\midrule" ) ///
// mtitles("\makecell{Change in \\ Stated Preferred Method}" "\makecell{Change in \\ Method Use}" "\makecell{Intertemporal \\ Concordance}" "\makecell{Contemporaneous \\ Concordance}") postfoot("\cdashline{1-5}")

// esttab women_decide_her_m_Y1 women_decide_her_m_Y2 women_decide_her_m_Y3 women_decide_her_m_Y4 using "$output\partner_subgroups_interaction.tex", append fragment label nolines ///
// cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T c.HUSB_T#c.women_decide_her_m) ///
// stats(N pvalue1, fmt(%9.0f %9.3f) labels("N" "\makecell[l]{PI + PI $\times$ Women \\ decide her earnings}"))  ///
// coeflabel(women_decide_her_m "\makecell[l]{Woman decide \\ her earnings}" c.HUSB_T#c.women_decide_her_m "PI $\times$ Women decide her earnings") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab women_earn_more_Y1 women_earn_more_Y2 women_earn_more_Y3 women_earn_more_Y4 using "$output\partner_subgroups_interaction.tex", replace fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T c.HUSB_T#c.women_earn_more) ///
prehead("\begin{table}\begin{center}\caption{Heterogeneity in the Treatment Effect of Partner Invitation}\label{tab: partnerbygroup}\tabcolsep=0.3cm\scalebox{0.8}{\begin{tabular}{lcccc}\toprule") ///
stats(N pvalue1, fmt(%9.0f %9.3f) labels("N" "\makecell[l]{PI + PI $\times$ Women \\ earn more}"))  ///
coeflabel(c.HUSB_T#c.women_earn_more "PI $\times$  Women earn more") collabels(none) nonumbers posthead("\midrule" ) ///
mtitles("\makecell{Change in \\ Stated Preferred Method}" "\makecell{Change in \\ Method Use}" "\makecell{Intertemporal \\ Concordance}" "\makecell{Contemporaneous \\ Concordance}") postfoot("\cdashline{1-5}")

// esttab women_own_house_a_Y1 women_own_house_a_Y2 women_own_house_a_Y3 women_own_house_a_Y4 using "$output\partner_subgroups_interaction.tex", append fragment label nolines ///
// cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T c.HUSB_T#c.women_own_house_a) ///
// stats(N pvalue1, fmt(%9.0f %9.3f) labels("N" "\makecell[l]{PI + PI $\times$ Women \\ own a house alone = 0}"))  ///
// coeflabel(women_own_house_a "\makecell[l]{own a house alone}" c.HUSB_T#c.women_own_house_a "PI $\times$ Women own a house alone") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab husb_want_more_Y1 husb_want_more_Y2 husb_want_more_Y3 husb_want_more_Y4 using "$output\partner_subgroups_interaction.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T c.HUSB_T#c.husb_want_more) ///
stats(N pvalue1, fmt(%9.0f %9.3f) labels("N" "\makecell[l]{PI + PI $\times$ Husband \\ wants more children = 0}"))  ///
coeflabel(husb_want_more "Husband wants more children" c.HUSB_T#c.husb_want_more "PI $\times$ Husband wants more children") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

// esttab husb_supports_fp_Y1 husb_supports_fp_Y2 husb_supports_fp_Y3 husb_supports_fp_Y4 using "$output\partner_subgroups_interaction.tex", append fragment label nolines ///
// cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T c.HUSB_T#c.husb_supports_fp) ///
// stats(N pvalue1, fmt(%9.0f %9.3f) labels("N" "\makecell[l]{PI + PI $\times$ Husband \\ supports FP = 0}"))  ///
// coeflabel(husb_supports_fp "Husband supports FP" c.HUSB_T#c.husb_supports_fp "PI $\times$ Husband supports FP") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab husb_sat_Y1 husb_sat_Y2 husb_sat_Y3 husb_sat_Y4 using "$output\partner_subgroups_interaction.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T c.HUSB_T#c.husb_sat) ///
stats(N pvalue1, fmt(%9.0f %9.3f) labels("N" "\makecell[l]{PI + PI $\times$ Husband \\ satisfied with women's FP use  = 0}"))  ///
coeflabel(c.HUSB_T#c.husb_sat "\makecell[l]{PI $\times$ Husband satisfied with \\ women's FP use}") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab husb_supports_fp_Y1 husb_supports_fp_Y2 husb_supports_fp_Y3 husb_supports_fp_Y4 using "$output\partner_subgroups_interaction.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T c.HUSB_T#c.husb_supports_fp) ///
stats(N pvalue1, fmt(%9.0f %9.3f) labels("N" "\makecell[l]{PI + PI $\times$ Husband \\ supports FP = 0}"))  ///
coeflabel(c.HUSB_T#c.husb_supports_fp "\makecell[l]{PI $\times$ Husband supports FP}") nomtitles collabels(none) nonumbers postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Variable definitions are presented in Table \ref{tab: variable_descriptions}. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps
