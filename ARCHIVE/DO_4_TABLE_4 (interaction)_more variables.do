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
foreach var of varlist cohab_longer8 husb_want_more discussed_FP women_decide_husb_m women_decide_health women_decide_daily women_decide_visits women_own_money women_own_house_a women_own_land_a{
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

/*esttab women_big_purchase_Y1 women_big_purchase_Y2 women_big_purchase_Y3 women_big_purchase_Y4 using "$output\partner_subgroups_interaction_power.tex", replace fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T c.HUSB_T#c.women_big_purchase) ///
prehead("\begin{table}\begin{center}\caption{Heterogeneity in the Treatment Effect of Partner Invitation}\label{tab: partnerbygroup}\tabcolsep=0.3cm\scalebox{0.8}{\begin{tabular}{lcccc}\toprule") coeflabel(women_big_purchase "\makecell[l]{Women decide big \\ purchases}" c.HUSB_T#c.women_big_purchase "PI $\times$ Women decide big puchases") posthead("\midrule" ) ///
stats(N pvalue1, fmt(%9.0f %9.3f) labels("N" "\makecell[l]{PI + PI $\times$ Women \\ decide big purchases = 0}"))  ///
mtitles("\makecell{Change in \\ Stated Preferred Method}" "\makecell{Change in \\ Method Use}" "\makecell{Intertemporal \\ Concordance}" "\makecell{Contemporaneous \\ Concordance}") collabels(none) postfoot("\cdashline{1-5}")
*/

esttab women_decide_husb_m_Y1 women_decide_husb_m_Y2 women_decide_husb_m_Y3 women_decide_husb_m_Y4 using "$output\partner_subgroups_interaction_power.tex", replace fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T c.HUSB_T#c.women_decide_husb_m) ///
prehead("\begin{table}\begin{center}\caption{Heterogeneity in the Treatment Effect of Partner Invitation}\label{tab: partnerbygroup}\tabcolsep=0.3cm\scalebox{0.8}{\begin{tabular}{lcccc}\toprule") ///
stats(N pvalue1, fmt(%9.0f %9.3f) labels("N" "\makecell[l]{PI + PI $\times$ Women \\ decide husband's earnings = 0}"))  ///
coeflabel(women_decide_husb_m "\makecell[l]{Woman decide \\ husband's earnings}" c.HUSB_T#c.women_decide_husb_m "PI $\times$ Women decide husband's earnings") collabels(none) nonumbers posthead("\midrule" ) ///
mtitles("\makecell{Change in \\ Stated Preferred Method}" "\makecell{Change in \\ Method Use}" "\makecell{Intertemporal \\ Concordance}" "\makecell{Contemporaneous \\ Concordance}") postfoot("\cdashline{1-5}")

// esttab women_decide_health_Y1 women_decide_health_Y2 women_decide_health_Y3 women_decide_health_Y4 using "$output\partner_subgroups_interaction_power.tex", append fragment label nolines ///
// cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T c.HUSB_T#c.women_decide_health) ///
// stats(N pvalue1, fmt(%9.0f %9.3f) labels("N" "\makecell[l]{PI + PI $\times$ Women \\ decide health care = 0}"))  ///
// coeflabel(women_decide_health "\makecell[l]{Woman decide \\ health care}" c.HUSB_T#c.women_decide_health "PI $\times$ Women decide health care") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab husb_want_more_Y1 husb_want_more_Y2 husb_want_more_Y3 husb_want_more_Y4 using "$output\partner_subgroups_interaction_power.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T c.HUSB_T#c.husb_want_more) ///
stats(N pvalue1, fmt(%9.0f %9.3f) labels("N" "\makecell[l]{PI + PI $\times$ Husband \\ wants more children  = 0}"))  ///
coeflabel(husb_want_more "\makecell[l]{Husband wants \\ more children}" c.HUSB_T#c.husb_want_more "PI $\times$ Husband wants more children") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab women_decide_daily_Y1 women_decide_daily_Y2 women_decide_daily_Y3 women_decide_daily_Y4 using "$output\partner_subgroups_interaction_power.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T c.HUSB_T#c.women_decide_daily) ///
stats(N pvalue1, fmt(%9.0f %9.3f) labels("N" "\makecell[l]{PI + PI $\times$ Women \\ decide daily purchases = 0}"))  ///
coeflabel(women_decide_daily "\makecell[l]{Woman decide daily purchases'}" c.HUSB_T#c.women_decide_daily "PI $\times$ Women decide daily purchases") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab discussed_FP_Y1 discussed_FP_Y2 discussed_FP_Y3 discussed_FP_Y4 using "$output\partner_subgroups_interaction_power.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T c.HUSB_T#c.discussed_FP) ///
stats(N pvalue1, fmt(%9.0f %9.3f) labels("N" "\makecell[l]{PI + PI $\times$ Discussed \\ FP with husband = 0}"))  ///
coeflabel(discussed_FP "\makecell[l]{Discussed FP with Husband}" c.HUSB_T#c.discussed_FP "PI $\times$ Discussed FP with Husband") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab cohab_longer8_Y1 cohab_longer8_Y2 cohab_longer8_Y3 cohab_longer8_Y4 using "$output\partner_subgroups_interaction_power.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T c.HUSB_T#c.cohab_longer8) ///
stats(N pvalue1, fmt(%9.0f %9.3f) labels("N" "\makecell[l]{PI + PI $\times$ Women lived \\ with husband for 8+ yrs = 0}"))  ///
coeflabel(cohab_longer8 "Women lived with husband for 8+ yrs" c.HUSB_T#c.cohab_longer8 "\makecell[l]{PI $\times$ Women lived \\ with husband for 8+ yrs}") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

// esttab women_decide_visits_Y1 women_decide_visits_Y2 women_decide_visits_Y3 women_decide_visits_Y4 using "$output\partner_subgroups_interaction_power.tex", append fragment label nolines ///
// cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T c.HUSB_T#c.women_decide_visits) ///
// stats(N pvalue1, fmt(%9.0f %9.3f) labels("N" "\makecell[l]{PI + PI $\times$ Women \\ decide visits = 0}"))  ///
// coeflabel(women_decide_visits "Women decide visits" c.HUSB_T#c.women_decide_visits "PI $\times$ Women decide visits") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab women_own_money_Y1 women_own_money_Y2 women_own_money_Y3 women_own_money_Y4 using "$output\partner_subgroups_interaction_power.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T c.HUSB_T#c.women_own_money) ///
stats(N pvalue1, fmt(%9.0f %9.3f) labels("N" "\makecell[l]{PI + PI $\times$ Women \\ own money alone = 0}"))  ///
coeflabel(women_own_money "\makecell[l]{Woman own money alone}" c.HUSB_T#c.women_own_money "PI $\times$ Women own money alone") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab women_own_house_a_Y1 women_own_house_a_Y2 women_own_house_a_Y3 women_own_house_a_Y4 using "$output\partner_subgroups_interaction_power.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T c.HUSB_T#c.women_own_house_a) ///
stats(N pvalue1, fmt(%9.0f %9.3f) labels("N" "\makecell[l]{PI + PI $\times$ Women \\ own house alone = 0}"))  ///
coeflabel(women_own_house_a "Women own house alone" c.HUSB_T#c.women_own_house_a "PI $\times$ Women own house alone") nomtitles collabels(none) nonumbers postfoot("\cdashline{1-5}")

esttab women_own_land_a_Y1 women_own_land_a_Y2 women_own_land_a_Y3 women_own_land_a_Y4 using "$output\partner_subgroups_interaction_power.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T c.HUSB_T#c.women_own_land_a) ///
stats(N pvalue1, fmt(%9.0f %9.3f) labels("N" "\makecell[l]{PI + PI $\times$ Women \\ own land alone  = 0}"))  ///
coeflabel(women_own_land_a "\makecell[l]{Women own \\ land alone}" c.HUSB_T#c.women_own_land_a "\makecell[l]{PI $\times$ Women own land alone}") nomtitles collabels(none) nonumbers postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Variable definitions are presented in Table \ref{tab: variable_descriptions}. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps


