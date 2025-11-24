***MALAWI Behavioral Biases Study
***TABLE D1
***CHANGES IN STATED IDEAL METHODS AND METHOD USE ACROSS STAGES

***KEXIN ZHANG
***NOVEMBER 21, 2025

version 13

clear all
timer on 10
use "$data\MBBS_Analysis_data.dta"

keep if w1_mergeRand == 3 //782
*========= Ideal Method ============
* Baseline
tab baseline_ideal_method //767

* Pre-counseling
tab COUN_129 //704

* Post-counseling
tab COUN_303 //704

* FUP_ideal_method
tab FUP_ideal_method //719

*========= Current Method Use ===========
*Baseline
tab baseline_curr_method //777

*Counseling
tab coun_curr_method //684 - 20 pregnancies

*Follow-up Method Use
tab FUP_curr_method //682

	tab diff_method111
	
	tab diff_method112
	
	tab diff_method113
	
	tab diff_method114

	tab diff_method115
	
	tab diff_method116

	tab diff_method117

	tab diff_method118
	
	tab diff_method119
	
* Baseline
tab w1_w03_w331

* Counseling
tab COUN_126

* Follow-up
tab want_to_switch_FUP
timer off 10
timer list