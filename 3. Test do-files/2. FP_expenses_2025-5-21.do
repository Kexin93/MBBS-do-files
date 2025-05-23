***MALAWI Behavioral Biases Study
***DO FILE - DO RESPONSES DIFFER ACROSS SURVEY MODES?(R2-C6)

***KEXIN  ZHANG
***MAY 19, 2025

use "F:\5. Malawi Behavioral Biases Study\Archive\ANALYSIS_BASE_RAND_CVF_PHO_HOM_CLI_ANALYSIS.dta", replace

* Analytical sample of 638 observations
keep if w1_mergeRand == 3
keep if COUN__FV_1 == 1

* consent
	keep if PHO_REC_4 == 1 | HOME_REV_20 == 1 | mergeCLI == 3 //675

* Drop pregnant women at counseling
	drop if COUN_118 == 1

* Drop pregnant women at FUP
	drop if PHO_103 == 1 | HOME_103 == 1 //638

sum CLIN_213 CLIN_216

ta CLIN_213

hist CLIN_213