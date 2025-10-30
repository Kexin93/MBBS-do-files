eststo Y1: reg diff_method_8 SHORT_T method_attribute_con2 deferral c.SHORT_T#c.method_attribute_con2 c.SHORT_T#c.deferral c.method_attribute_con2#c.deferral c.SHORT_T#c.method_attribute_con2#c.deferral $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_8 if SHORT_T == 0 & COUN__FV_1 == 1 
estadd scalar ymean = r(mean)

eststo Y2: reg diff_method_3 SHORT_T method_attribute_con2 deferral c.SHORT_T#c.method_attribute_con2 c.SHORT_T#c.deferral c.method_attribute_con2#c.deferral c.SHORT_T#c.method_attribute_con2#c.deferral $balance_covariates, vce(robust) 
summarize diff_method_3 if SHORT_T == 0 
estadd scalar ymean = r(mean)

eststo Y3: reg intertemperal_concordance SHORT_T method_attribute_con2 deferral c.SHORT_T#c.method_attribute_con2 c.SHORT_T#c.deferral c.method_attribute_con2#c.deferral c.SHORT_T#c.method_attribute_con2#c.deferral $balance_covariates, vce(robust) 
summarize intertemperal_concordance if SHORT_T == 0
estadd scalar ymean = r(mean)

eststo Y4: reg contemp_concordance SHORT_T method_attribute_con2 deferral c.SHORT_T#c.method_attribute_con2 c.SHORT_T#c.deferral c.method_attribute_con2#c.deferral c.SHORT_T#c.method_attribute_con2#c.deferral $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize contemp_concordance if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)

esttab Y1 Y2 Y3 Y4 using "$output\TC_decision_deferral.tex", replace fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) drop($balance_covariates _cons) ///
stats(N pvalue1, labels("N" "\makecell[l]{TC + TC $\times$ Decision deferral = 0}") fmt(%9.0f %9.3f))  ///
prehead("\begin{table}\begin{center}\caption{Heterogeneity in the Treatment Effect of Tailored Counseling}\label{tab: tailoredbygroup}\tabcolsep=0.3cm\scalebox{0.6}{\begin{tabular}{lcccc}\toprule") coeflabel(c.SHORT_T#c.deferral "TC $\times$ Decision deferral" method_attribute_con2 "Method use in list" c.SHORT_T#c.method_attribute_con2 "TC $\times$ Method use in list" c.method_attribute_con2#c.deferral "Method use in list $\times$ deferral" c.SHORT_T#c.method_attribute_con2#c.deferral "TC $\times$ Method use in list $\times$ deferral") collabels(none) nonumbers postfoot("\midrule") mtitles("\makecell{Change in \\ Stated Preferred Method}" "\makecell{Change in \\ Method Use}" "\makecell{Intertemporal \\ Concordance}" "\makecell{Contemporaneous \\ Concordance}") 

foreach var of varlist method_attribute_con1 method_attribute_con3 method_attribute_con5{
eststo `var'_Y1: reg diff_method_8 SHORT_T `var' deferral c.SHORT_T#c.`var' c.SHORT_T#c.deferral c.`var'#c.deferral c.SHORT_T#c.`var'#c.deferral $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize diff_method_8 if SHORT_T == 0 & COUN__FV_1 == 1 
estadd scalar ymean = r(mean)

eststo `var'_Y2: reg diff_method_3 SHORT_T `var' deferral c.SHORT_T#c.`var' c.SHORT_T#c.deferral c.`var'#c.deferral c.SHORT_T#c.`var'#c.deferral $balance_covariates, vce(robust) 
summarize diff_method_3 if SHORT_T == 0 
estadd scalar ymean = r(mean)

eststo `var'_Y3: reg intertemperal_concordance SHORT_T `var' deferral c.SHORT_T#c.`var' c.SHORT_T#c.deferral c.`var'#c.deferral c.SHORT_T#c.`var'#c.deferral $balance_covariates, vce(robust) 
summarize intertemperal_concordance if SHORT_T == 0
estadd scalar ymean = r(mean)

eststo `var'_Y4: reg contemp_concordance SHORT_T `var' deferral c.SHORT_T#c.`var' c.SHORT_T#c.deferral c.`var'#c.deferral c.SHORT_T#c.`var'#c.deferral $balance_covariates if COUN__FV_1 == 1, vce(robust) 
summarize contemp_concordance if SHORT_T == 0 & COUN__FV_1 == 1
estadd scalar ymean = r(mean)
}

esttab method_attribute_con1_Y1 method_attribute_con1_Y2 method_attribute_con1_Y3 method_attribute_con1_Y4 using "$output\TC_decision_deferral.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) drop($balance_covariates _cons) ///
stats(N pvalue1, labels("N" "\makecell[l]{TC + TC $\times$ Decision deferral = 0}") fmt(%9.0f %9.3f))  ///
coeflabel(c.SHORT_T#c.deferral "TC $\times$ Decision deferral" method_attribute_con1 "Stated preferred method in list" c.SHORT_T#c.method_attribute_con1 "TC $\times$ Stated preferred method in list" c.method_attribute_con1#c.deferral "Stated preferred method in list $\times$ deferral" c.SHORT_T#c.method_attribute_con1#c.deferral "TC $\times$ Stated preferred method in list $\times$ deferral") collabels(none) nonumbers postfoot("\midrule") nomtitles 

esttab method_attribute_con3_Y1 method_attribute_con3_Y2 method_attribute_con3_Y3 method_attribute_con3_Y4 using "$output\TC_decision_deferral.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) drop($balance_covariates _cons) ///
stats(N pvalue1, labels("N" "\makecell[l]{TC + TC $\times$ Decision deferral = 0}") fmt(%9.0f %9.3f))  ///
coeflabel(c.SHORT_T#c.deferral "TC $\times$ Decision deferral" method_attribute_con3 "Stated preferred method=method use in list" c.SHORT_T#c.method_attribute_con3 "TC $\times$ Stated preferred method=method use in list" c.method_attribute_con3#c.deferral "Stated preferred method=method use in list $\times$ deferral" c.SHORT_T#c.method_attribute_con3#c.deferral "TC $\times$ Stated preferred method=method use in list $\times$ deferral") collabels(none) nonumbers postfoot("\midrule") nomtitles 

esttab method_attribute_con5_Y1 method_attribute_con5_Y2 method_attribute_con5_Y3 method_attribute_con5_Y4 using "$output\TC_decision_deferral.tex", append fragment label nolines ///
cells(b(star fmt(%9.3f)) se(par( [ ] ) fmt(%9.3f))) starlevels(* 0.2 ** 0.1 *** 0.02) compress style(tab) drop($balance_covariates _cons) ///
stats(N pvalue1, labels("N" "\makecell[l]{TC + TC $\times$ Decision deferral = 0}") fmt(%9.0f %9.3f))  ///
coeflabel(c.SHORT_T#c.deferral "TC $\times$ Decision deferral" method_attribute_con5 "Stated preferred method!=method use in list" c.SHORT_T#c.method_attribute_con5 "TC $\times$ Stated preferred method!=method use in list" c.method_attribute_con5#c.deferral "Stated preferred method!=method use in list $\times$ deferral" c.SHORT_T#c.method_attribute_con5#c.deferral "TC $\times$ Stated preferred method!=method use in list $\times$ deferral") collabels(none) nonumbers nomtitles postfoot("\bottomrule \end{tabular}} \end{center}\footnotesize{Notes: Balancing control variables include a woman's age, her contraceptive use at baseline, and whether her most valued attribute was contraceptive effectiveness. Variable definitions are presented in Table \ref{tab: variable_descriptions}. Heteroskedastic-robust standard errors are presented in brackets. *** 1\%, ** 5\%, * 10\%.} \end{table}") nogaps 