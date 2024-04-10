***MALAWI Behavioral Biases Study
***DO FILE 10: TABLE K1
***TREATMENT EFFECTS OF PARTNER INVITATION BY METHOD TYPE

***KEXIN ZHANG
***NOVEMBER 15, 2023

version 13
clear all

use "$data\MBBS_Analysis_data.dta"

global balance_covariates "age_binary cont_use1 eff_attribute"

global covariates "age_binary cont_use1 eff_attribute i.w1_area"

global covariates1 "age_binary cont_use1 eff_attribute i.w1_area tot_child wom_work i.wom_educ ethnicity_Chewa pre_Coun_short"

keep if w1_mergeRand == 3

	keep if COUN__FV_1 == 1

* consent
	keep if PHO_REC_4 == 1 | HOME_REV_20 == 1 | mergeCLI == 3 //675

* Drop pregnant women at counseling
	drop if COUN_118 == 1

* Drop pregnant women at FUP
	drop if PHO_103 == 1 | HOME_103 == 1 //638

******************* 1. PANEL A: Husband Invitation on End-of-Counseling Ideal Method **********************************************
	eststo clear
	eststo: reg postIdeal_implants HUSB_T $covariates1 if /*!mi(FUP_curr_method) &*/ !mi(COUN_3081), vce(robust) 
	summarize postIdeal_implants if HUSB_T == 0 & /*!mi(FUP_curr_method) &*/ !mi(COUN_3081)
	estadd scalar ymean = r(mean)

	eststo: reg postIdeal_injectables HUSB_T $covariates1 if /*!mi(FUP_curr_method) &*/ !mi(COUN_3081), vce(robust) 
	summarize postIdeal_injectables if HUSB_T == 0 & /*!mi(FUP_curr_method) &*/ !mi(COUN_3081)
	estadd scalar ymean = r(mean)

	eststo: reg postIdeal_pills HUSB_T $covariates1 if /*!mi(FUP_curr_method) &*/ !mi(COUN_3081), vce(robust) 
	summarize postIdeal_pills if HUSB_T == 0 & /*!mi(FUP_curr_method) &*/ !mi(COUN_3081)
	estadd scalar ymean = r(mean)

	eststo: reg postIdeal_Others HUSB_T $covariates1 if /*!mi(FUP_curr_method) &*/ !mi(COUN_3081), vce(robust) 
	summarize postIdeal_Others if HUSB_T == 0 & /*!mi(FUP_curr_method) &*/ !mi(COUN_3081)
	estadd scalar ymean = r(mean)

esttab est1 est2 est3 est4 using "$output\allwomen_husband_toIV_implants_inj_pill_traditional_ITT.tex", replace fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean"))  ///
prehead("\begin{table}[h!]\begin{center}\caption{Treatment Effects of the Partner Invitation Intervention by Method Type}\label{tab: mechanisms4methodsITT}\tabcolsep=0.3cm\scalebox{0.68}{\begin{tabular}{lcccc}\toprule") ///
posthead("\midrule \multicolumn{5}{c}{\textbf{A. Post-Counseling Stated Ideal Method: Method Above}} \\\\[-1ex]") nogaps ///
collabels(none) nonumbers nomtitles  ///
mgroups("Implants" "Injectables" "Pills" "Rhythm/Withdrawal/Traditional", pattern(1 1 1 1 ))

*========================= 2. Follow-up Method Use =======================================
	eststo clear
eststo: reg FUPmethod_implants HUSB_T $covariates1 if !mi(FUP_curr_method) & !mi(COUN_3081), vce(robust) 
summarize FUPmethod_implants if HUSB_T == 0 & !mi(FUP_curr_method) & !mi(COUN_3081)
estadd scalar ymean = r(mean)

eststo: reg FUPmethod_injectables HUSB_T $covariates1 if !mi(FUP_curr_method) & !mi(COUN_3081), vce(robust) 
summarize FUPmethod_injectables if HUSB_T == 0 & !mi(FUP_curr_method) & !mi(COUN_3081)
estadd scalar ymean = r(mean)

eststo: reg FUPmethod_pills HUSB_T $covariates1 if !mi(FUP_curr_method) & !mi(COUN_3081), vce(robust) 
summarize FUPmethod_pills if HUSB_T == 0 & !mi(FUP_curr_method) & !mi(COUN_3081)
estadd scalar ymean = r(mean)

eststo: reg FUPmethod_Others HUSB_T $covariates1 if !mi(FUP_curr_method) & !mi(COUN_3081), vce(robust) 
summarize FUPmethod_Others if HUSB_T == 0 & !mi(FUP_curr_method) & !mi(COUN_3081)
estadd scalar ymean = r(mean)

esttab est1 est2 est3 est4 using "$output\allwomen_husband_toIV_implants_inj_pill_traditional_ITT.tex", append nomtitles nonumbers fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean"))  ///
posthead("\midrule \multicolumn{5}{c}{\textbf{B. Follow-up Method: Method Above}} \\\\[-1ex]") nogaps collabels(none) 

* ============================== 3. End-of-Counseling and FUP Method Use both being Implants =====================================
	eststo clear
eststo: reg uptake_implants HUSB_T $covariates1 if !mi(FUP_curr_method) & !mi(COUN_3081), vce(robust) 
summarize uptake_implants if HUSB_T == 0 & !mi(FUP_curr_method) & !mi(COUN_3081)
estadd scalar ymean = r(mean)

eststo: reg uptake_injectables HUSB_T $covariates1 if !mi(FUP_curr_method) & !mi(COUN_3081), vce(robust) 
summarize uptake_injectables if HUSB_T == 0 & !mi(FUP_curr_method) & !mi(COUN_3081)
estadd scalar ymean = r(mean)

eststo: reg uptake_pills HUSB_T $covariates1 if !mi(FUP_curr_method) & !mi(COUN_3081), vce(robust) 
summarize uptake_pills if HUSB_T == 0 & !mi(FUP_curr_method) & !mi(COUN_3081)
estadd scalar ymean = r(mean)

eststo: reg uptake_Others HUSB_T $covariates1 if !mi(FUP_curr_method) & !mi(COUN_3081), vce(robust) 
summarize uptake_Others if HUSB_T == 0 & !mi(FUP_curr_method) & !mi(COUN_3081)
estadd scalar ymean = r(mean)

*Panel C: Counseling current method and Follow-up current method
esttab est1 est2 est3 est4 using "$output\allwomen_husband_toIV_implants_inj_pill_traditional_ITT.tex", append fragment nomtitles label nonumbers nolines cells(b(star fmt(%9.3f)) ///
se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean"))  ///
posthead("\midrule \multicolumn{5}{c}{\textbf{C. FUP method = Post-Counseling Stated Ideal Method: Method Above}} \\\\[-1ex]") nogaps

* ============================ 4. FUP ideal Method = injectables ========================================
	eststo clear
eststo: reg FUPIdeal_implants HUSB_T $covariates1 if /*!mi(FUP_curr_method) &*/ !mi(COUN_3081), vce(robust) 
summarize FUPIdeal_implants if HUSB_T == 0 & /*!mi(FUP_curr_method) &*/ !mi(COUN_3081)
estadd scalar ymean = r(mean)

eststo: reg FUPIdeal_injectables HUSB_T $covariates1 if /*!mi(FUP_curr_method) &*/ !mi(COUN_3081), vce(robust) 
summarize FUPIdeal_injectables if HUSB_T == 0 & /*!mi(FUP_curr_method) &*/ !mi(COUN_3081)
estadd scalar ymean = r(mean)

eststo: reg FUPIdeal_pills HUSB_T $covariates1 if /*!mi(FUP_curr_method) &*/ !mi(COUN_3081), vce(robust) 
summarize FUPIdeal_pills if HUSB_T == 0 & /*!mi(FUP_curr_method) &*/ !mi(COUN_3081)
estadd scalar ymean = r(mean)

eststo: reg FUPIdeal_Others HUSB_T $covariates1 if /*!mi(FUP_curr_method) &*/ !mi(COUN_3081), vce(robust) 
summarize FUPIdeal_Others if HUSB_T == 0 & /*!mi(FUP_curr_method) &*/ !mi(COUN_3081)
estadd scalar ymean = r(mean)

esttab est1 est2 est3 est4 using "$output\allwomen_husband_toIV_implants_inj_pill_traditional_ITT.tex", append nomtitles nonumbers fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean"))  ///
posthead("\midrule \multicolumn{5}{c}{\textbf{D. Follow-up Stated Ideal Method: Method Above}} \\\\[-1ex]") nogaps collabels(none) 

* ====================== 5. Concordance at the FUP between ideal method and method use =========================================
	eststo clear
eststo: reg concordance_implants HUSB_T $covariates1 if !mi(FUP_curr_method) & !mi(COUN_3081), vce(robust) 
summarize concordance_implants if HUSB_T == 0 & !mi(FUP_curr_method) & !mi(COUN_3081)
estadd scalar ymean = r(mean)

eststo: reg concordance_injectables HUSB_T $covariates1 if !mi(FUP_curr_method) & !mi(COUN_3081), vce(robust) 
summarize concordance_injectables if HUSB_T == 0 & !mi(FUP_curr_method) & !mi(COUN_3081)
estadd scalar ymean = r(mean)

eststo: reg concordance_pills HUSB_T $covariates1 if !mi(FUP_curr_method) & !mi(COUN_3081), vce(robust) 
summarize concordance_pills if HUSB_T == 0 & !mi(FUP_curr_method) & !mi(COUN_3081)
estadd scalar ymean = r(mean)

eststo: reg concordance_Others HUSB_T $covariates1 if !mi(FUP_curr_method) & !mi(COUN_3081), vce(robust) 
summarize concordance_Others if HUSB_T == 0 & !mi(FUP_curr_method) & !mi(COUN_3081)
estadd scalar ymean = r(mean)

*Panel E: Counseling current method and Follow-up current method
esttab est1 est2 est3 est4 using "$output\allwomen_husband_toIV_implants_inj_pill_traditional_ITT.tex", append fragment label nomtitles nonumbers nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) keep(HUSB_T) ///
stats(N ymean, fmt(0 2) labels("N" "Control mean"))  ///
posthead("\midrule \multicolumn{5}{c}{\textbf{E. FUP Method = FUP Stated Ideal Method: Method Above}} \\\\[-1ex]") nogaps ///
postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: The dependent variable in Panel A indicates whether a woman's stated ideal method at the post-counseling stage is the method specified above. The dependent variable in Panel B indicates whether her method use at the follow-up is the method specified above. The dependent variable in Panel C takes 1 if both the post-counseling stated ideal method and the follow-up method use are the method specified above. The dependent variable in Panel D takes 1 if the follow-up stated ideal method is the method specified above. The dependent variable in Panel E takes 1 if both her stated ideal method and her method use at follow-up are the method specified above. Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Other baseline covariates include: her total number of children, educational attainment (primary, secondary, higher), work status (1 = working), ethnicity (1 = Chewa), and pre-counseling method being injectables, pills, or condoms (1 = yes). Area fixed effects are included in all specifications. Heteroskedasticity-robust standard errors are in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps

 
