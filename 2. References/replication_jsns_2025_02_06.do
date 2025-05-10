********************************************************************************
* Date: 05/09/2024														   	   *
* Replication Do-File for: 												       *
*						 "Bring a Friend: 							  	 	   *
* 	Strengthening Women's Social Networks and Reproductive Autonomy in India"  *
* 		By: S Anukriti, Catalina Herrera-Almanza, Mahesh Karra   			   *
********************************************************************************

* 		This do file replicates all tables presented in the JEEA paper		   *
*		With new covariates													   *


* It is organized in the following sections:

* I. 	Directories 
* II. 	Balance Tables (main body & appendix)
* III.	Descriptive Statistics
* IV. 	Result Tables of the main body
* V.	Result Tables of the appendix 

********************************************************************************
**# I. Directories 
********************************************************************************

*global repo "WRITE-YOUR-PATH-HERE"


* -----------------------------------
* Make sure to remove this part later.

if "`c(username)'"=="mvkarra" {
                global maindir "C:\Users\mvkarra\Dropbox\Social Networks - India"
				global path "C:\Users\mvkarra\Dropbox\Social Networks - India"
				}
else if "`c(username)'"=="cataher" {
                global maindir "C:\Users\cataher\Dropbox\Social Networks - India"
				global path "C:\Users\cataher\Dropbox\Social Networks - India"
}

else if "`c(username)'"=="WB340653" {
                global maindir "C:\Users\WB340653\Dropbox\Work\Social Networks - India"
				global path "C:\Users\WB340653\Dropbox\Work\Social Networks - India"
}

else if "`c(username)'"=="sh52" {
                global maindir "/Users/sh52/Dropbox"
				global path "/Users/sh52/Dropbox"
}

global repo "$path/RA UIUC_Shahadat/6BringAFriend-Repository/JDE_Revise_and_Resubmit"

* -------------------------------------

clear all


* Endline Data 
use "$repo/data/data_endline.dta", clear
drop if base_wants_child == . // Drop 4 obsrvations having missing values for this covariate


********************************************************************************
**# II. Balance Tables
********************************************************************************

************************************
**## Table 1: Balance Table
* By Treatment Assignment
************************************

* Create global for balance table 1:
global balance base_age base_school_yrs base_w_hindu base_scst base_obc 	///
			   base_ghunghat base_work base_livewMIL base_mobi 				///
			   base_asset_score base_num_friend base_outsider 			    ///
			   base_no_children base_wants_child base_current_fp 			///
			   base_mod_method base_ever_visit_fp base_costFP_MILopposed
 
eststo clear
est drop _all


* Mean . SD of each treatment arm:
eststo control:  estpost  summarize $balance  if treatment == 0
eststo own:  	 estpost  summarize $balance  if treatment == 1 
eststo baf:  	 estpost summarize  $balance  if treatment == 2 

* Pair-differences
eststo diffcontrolown:  estpost ttest $balance if treatment!=2, by(solo) unequal 
* Adding scalars of F-Test of join significance. 
reg solo $balance   if treatment!=2
estadd scalar F_Obs = `e(N)': diffcontrolown
testparm $balance
estadd scalar F_pvalue = r(p): diffcontrolown

eststo diffcontrolbaf:   estpost ttest $balance if treatment!=1, by(baf) unequal 
* Adding scalars of F-Test of join significance. 
reg baf $balance   if treatment!=1
estadd scalar F_Obs = `e(N)': diffcontrolbaf
testparm $balance
estadd scalar F_pvalue = r(p): diffcontrolbaf

eststo diffownbaf:   estpost ttest $balance if treatment!=0, by(baf) unequal 
* Adding scalars of F-Test of join significance. 
reg baf $balance  if treatment!=0
estadd scalar F_Obs = `e(N)': diffownbaf
testparm $balance
estadd scalar F_pvalue = r(p): diffownbaf

* Export Balance Table: 

esttab ///
control own baf  diffcontrolown diffcontrolbaf diffownbaf ///
using "$repo/tables/table1.tex"  , ///
cells("count(pattern(1 1 1 0 0 0 ) fmt(0)) mean(pattern(1 1 1 0 0 0) fmt(3)) b(star pattern(0 0 0 1 1 1) fmt(3))" ". sd(pattern(1 1 1 0 0 0) par fmt(3))" ) ///
label  collabels(none) nonum plain nomtitle noobs not tex starlevels(* 0.1 ** .05  *** .01) ///
stats( F_pvalue F_Obs, label("\midrule F-test of joint significance: p-value" "F-test: Number of observations" ) fmt(%9.3f  %9.0f )) ///
prehead("\begin{tabular}{lccccccccc} \toprule & \multicolumn{2}{c}{Control (C)}   & \multicolumn{2}{c}{Own}  &  \multicolumn{2}{c}{BAF}  & C - Own & C - BAF & Own - BAF \\ \cmidrule(lr){2-3} \cmidrule(lr){4-5} \cmidrule(lr){6-7} \cmidrule(lr){8-8} \cmidrule(lr){9-9} \cmidrule(lr){10-10}  & N & Mean/SD & N & Mean/SD & N & Mean/SD & Diff. & Diff. & Diff. \\ & (1) & (2) & (3) & (4) & (5) & (6) & (7) & (8) & (9) \\ \midrule& \multicolumn{2}{c}{\textbf{Control (C)}}   & \multicolumn{2}{c}{\textbf{Own}}  &  \multicolumn{2}{c}{\textbf{BAF}}  & \textbf{C - Own} & \textbf{C - BAF} & \textbf{Own - BAF} \\ \cmidrule(lr){2-3} \cmidrule(lr){4-5} \cmidrule(lr){6-7} \cmidrule(lr){8-8} \cmidrule(lr){9-9} \cmidrule(lr){10-10}  & N & Mean/SD & N & Mean/SD & N & Mean/SD & Diff. & Diff. & Diff. \\ \textbf{Woman's characteristics} & (1) & (2) & (3) & (4) & (5) & (6) & (7) & (8) & (9) \\ \midrule") ///
posthead("") ///
postfoot("\bottomrule  \\[-5ex] \end{tabular}") replace


************************************
**## Table A.1: Balance Table By Treatment Assignment
* Additional variables
************************************
eststo clear
est drop _all
 
global othervars base_poor base_durationmarriage base_at_least_1_son 		 ///
				 base_concealabilityFP base_costFP_embarrasing ///
				 base_nopeeruseFPvill base_went_hmil 

* Mean . SD of each treatment arm:
eststo control:  estpost summarize $othervars if treatment == 0
eststo own:  	 estpost summarize $othervars if treatment == 1 
eststo baf:  	 estpost summarize $othervars if treatment == 2 

* Pair-differences
eststo diffcontrolown:  estpost ttest $othervars if treatment!=2, by(solo) unequal 
* Adding scalars of F-Test of join significance. 
reg solo $othervars   if treatment!=2
estadd scalar F_Obs = `e(N)': diffcontrolown
testparm $othervars
estadd scalar F_pvalue = r(p): diffcontrolown

eststo diffcontrolbaf:   estpost ttest $othervars if treatment!=1, by(baf) unequal 
* Adding scalars of F-Test of join significance. 
reg baf $othervars   if treatment!=1
estadd scalar F_Obs = `e(N)': diffcontrolbaf
testparm $othervars
estadd scalar F_pvalue = r(p): diffcontrolbaf

eststo diffownbaf:   estpost ttest $othervars if treatment!=0, by(baf) unequal 
* Adding scalars of F-Test of join significance. 
reg baf $othervars  if treatment!=0
estadd scalar F_Obs = `e(N)': diffownbaf
testparm $othervars
estadd scalar F_pvalue = r(p): diffownbaf

la var base_went_hmil "Last visit to a FP clinic was with husband or MIL"

* Export Balance Table: 

esttab ///
control own baf  diffcontrolown diffcontrolbaf diffownbaf ///
using "$repo/tables/appendix_table1.tex"  , ///
cells("count(pattern(1 1 1 0 0 0 ) fmt(0)) mean(pattern(1 1 1 0 0 0) fmt(3)) b(star pattern(0 0 0 1 1 1) fmt(3))" ". sd(pattern(1 1 1 0 0 0) par fmt(3))" ) ///
label  varlabels(base_nopeeruseFPvill "Lack of close peers in village that use FP$^\text{a}$" ) collabels(none) nonum plain nomtitle noobs not tex starlevels(* 0.1 ** .05  *** .01) ///
stats(F_pvalue F_Obs, label("\midrule F-test of joint significance: p-value" "F-test: Number of observations" ) fmt( %9.3f  %9.0f )) ///
prehead("\begin{tabular}{lccccccccc} \toprule & \multicolumn{2}{c}{Control (C)}   & \multicolumn{2}{c}{Own}  &  \multicolumn{2}{c}{BAF}  & C - Own & C - BAF & Own - BAF \\ \cmidrule(lr){2-3} \cmidrule(lr){4-5} \cmidrule(lr){6-7} \cmidrule(lr){8-8} \cmidrule(lr){9-9} \cmidrule(lr){10-10}  & N & Mean/SD & N & Mean/SD & N & Mean/SD & Diff. & Diff. & Diff. \\ & (1) & (2) &(3)& (4) & (5) & (6) & (7) & (8) & (9) \\ \midrule") ///
posthead("") ///
postfoot("\bottomrule  \\[-5ex] \end{tabular}") replace


************************************
**## Table A.2: Balance Table By Attritors
************************************
preserve

* Baseline Data 
* Need baseline data for this table only (to have attrition_w2 == 1)

use "$repo/data/data_baseline.dta", clear
drop if base_wants_child == .

eststo clear
est drop _all

global balance solo baf $balance 

* Mean . SD of each group:
eststo nonatt:  estpost  summarize  $balance  if attrition_w2 == 0
eststo att:  	estpost  summarize  $balance  if attrition_w2 == 1 
* Pair-differences
eststo diff:  estpost ttest  $balance , by(attrition_w2) unequal 
* Adding scalars of F-Test of join significance. 
reg attrition_w2  $balance 
estadd scalar F_Obs = `e(N)': diff
testparm   $balance
estadd scalar F_pvalue = r(p): diff

* Export Balance Table: 
esttab ///
nonatt att diff ///
using "$repo/tables/appendix_table2.tex"  , ///
cells("count(pattern(1 1 0 ) fmt(0)) mean(pattern(1 1 0) fmt(3)) b(star pattern(0 0 1 ) fmt(3))" ". sd(pattern(1 1 0 ) par fmt(3))" ) ///
label  collabels(none) nonum plain nomtitle noobs not tex starlevels(* 0.1 ** .05  *** .01) ///
stats(F_pvalue F_Obs, label("\midrule F-test of joint significance: p-value" "F-test: number of observations" ) fmt( %9.3f  %9.0f )) ///
prehead("\begin{tabular}{lccccc} \toprule & \multicolumn{2}{c}{Non-attritor} & \multicolumn{2}{c}{Attritor} & Non-attritor -- Attritor       \\ \cmidrule(lr){2-3} \cmidrule(lr){4-5} \cmidrule(lr){6-6}	& N & Mean/SD & N   & Mean/SD          & Difference \\	& (1)   & (2)  & (3)  & (4)  & (5)        \\\midrule ") ///
posthead("") ///
postfoot("\bottomrule  \\[-5ex] \end{tabular}") replace

restore



********************************************************************************
**# III. Descriptive Statistics
********************************************************************************

************************************
* Table A.3: Descriptive Stats 
************************************
eststo clear
est drop _all
 
 * Globals:
global varstats_outcomes  num_peers_asked_adc ask_peer_adc asked_hmil  ///
						  asked_other asked_sil asked_nonfam outsider ///
						  afraid_being_seen  ///
						  visit_adc_fp_corr visit_any_fp_new_corr ///
						  visit_adc_alone visit_adc_w_hhmil visit_adc_w_nohmil ///
						  mod_method_el mod_method_since_bl preg_ever
global varstats_balancing  base_school_yrs base_current_fp ///
						   base_wants_child base_num_friend 
global varstats_othersvars  base_age base_w_hindu base_scst base_obc ///
							base_ghunghat base_work base_mobi ///
							base_ever_visit_fp base_asset_score
global vars_heteffect   base_costFP_MILopposed  base_concealabilityFP ///
						base_costFP_embarrasing  base_nopeeruseFPvill base_poor 

* Adding footnote symbols to variables that need it: 

*Phone survey footnote
la var asked_hmil "Sought company from husband or MIL to visit the ADC"
la var asked_other "Sought company from other than husband or MIL to visit the ADC"
la var asked_sil "Sought company from sister or SIL to visit the ADC"
la var asked_nonfam "Sought company from a non-relative to visit the ADC"
la var outsider "Number of close peers outside HH in village"
la var afraid_being_seen "Afraid of being seen at a health facility"
la var visit_adc_w_hhmil "Visited the ADC with Husband or MIL"
la var visit_adc_w_nohmil "Visited the ADC with other than husband or MIL"
* Other explanation footnote:
la var base_nopeeruseFPvill "No baseline close peers in village using FP"
* Another explanation footnote
la var mod_method_el "Currently using modern FP method"
la var mod_method_since_bl "Using modern FP method since baseline"
la var preg_ever "Ever pregnancy"
la var curr_fp_endline "Currently using FP method"

* Export table:
estpost summ $varstats_outcomes 
esttab using "$repo/tables/appendix_table4.tex" , ///
cells("count(fmt(0)) mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0))") ///
nomtitle noobs nonumber label collabels(none)  varwidth(25) ///
varlabels(ask_peer_adc "\emph{Sought company to visit the ADC from:} & & & & & \\ Someone" ///
asked_hmil "Husband or MIL" ///
asked_other "Someone other than husband or MIL" ///
asked_sil "Sister-in-law$" ///
asked_nonfam "Non-relative" ///
outsider  "Number of close peers outisde HH in village" ///
num_friend_2village "Number of close peers in village" ///
afraid_being_seen "Afraid of being seen at a health facility" ///
visit_adc_alone "\emph{Visited the ADC:} & & & & & \\ Alone" ///
visit_adc_w_hhmil "With husband or MIL" ///
visit_adc_w_nohmil "With someone other than husband or MIL") ///
prehead("\begin{tabular}{lccccc}\toprule & N & Mean & SD & Min & Max \\ & (1) & (2) & (3) & (4) & (5) \\  ") ///
posthead("\midrule \multicolumn{6}{l}{\textit{Endline variables}}\\ \midrule") ///
postfoot("") nogaps replace

estpost summ $varstats_balancing $varstats_othersvars $vars_heteffect 
esttab using "$repo/tables/appendix_table4.tex" , ///
cells("count(fmt(0)) mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0))") ///
nomtitle noobs nonumber label    mlabels(none) collabels(none) varwidth(25) ///
prehead("\midrule") ///
posthead(" \multicolumn{6}{l}{\textit{Baseline variables}}\\  \midrule") nogaps ///
postfoot("\bottomrule  \\[-5ex] \end{tabular}") append

********************************************************************************
**# IV. Results tables of the main body
********************************************************************************

* Globals for covariates and balancing covariates:

global covbal base_school_yrs base_current_fp base_wants_child base_num_friend
global cov  base_mobi base_work base_ever_visit_fp base_mod_method base_phone

************************************
**## Table 2: Sought company
************************************

eststo clear
est drop _all

global outcomes ask_peer_adc asked_hmil asked_other asked_sil asked_nonfam

 
foreach y of global outcomes{
eststo r`y'0: reg `y' solo baf $covbal $cov i.base_village_num  , r
test _b[solo]=_b[baf]
	estadd scalar pvalue = r(p)
	sum `y' if treatment == 0 
	estadd scalar controlmean = r(mean)		
}

esttab  rask_peer_adc0   rasked_hmil0  rasked_other0 rasked_sil0 rasked_nonfam0 ///
using "$repo/tables/table2.tex" , ///
keep(solo baf) ///
label mlabels(none) collabels(none)  se(%9.3f) b(%9.3f)  ///
brackets nonum  noobs nolines  nogaps starlevels( * 0.1 ** .05  *** .01) ///
stats(N  controlmean pvalue , label("\midrule Observations" "Endline control mean" "p-value: Own = BAF" ) fmt(%9.0f %9.3f %9.3f)) ///
prehead("\begin{tabular}{lccccc} \toprule") ///
posthead(" & \multicolumn{5}{c}{\textbf{Sought company to visit the ADC from:}}  \\ \cmidrule(lr){2-6} & Someone &  \shortstack{Husband/\\MIL} & \shortstack{Non-husband/\\MIL} & Sister-in-law & Non-relative \\  & (1) & (2) & (3) & (4) & (5) \\ \midrule") ///
postfoot("\bottomrule \\[-5ex] \end{tabular}") ///
 sfmt(%9.2f) varwidth(25)  replace

************************************
**## Table 3: clinic Visits
************************************

eststo clear
est drop _all

global visits  	visit_adc_fp_corr visit_any_fp_new_corr visit_adc_alone ///
				visit_adc_w_hhmil visit_adc_w_nohmil visit_adc_w_sil ///
				visit_adc_w_other

foreach y of global visits{
eststo r`y'0: reg `y' solo baf $covbal $cov i.base_village_num  , r

test _b[solo]=_b[baf]
	estadd scalar pvalue = r(p)
	sum `y' if treatment == 0 
	estadd scalar controlmean = r(mean)		
}



esttab  rvisit_adc_fp_corr0 rvisit_any_fp_new_corr0 rvisit_adc_alone0 /// 
		rvisit_adc_w_hhmil0 rvisit_adc_w_nohmil0 ///
		rvisit_adc_w_sil0 rvisit_adc_w_other0 ///
using "$repo/tables/table3.tex" , ///
keep(solo baf) ///
label mlabels(none) collabels(none)  se(%9.3f) b(%9.3f)  ///
brackets nonum  noobs nolines  nogaps starlevels( * 0.1 ** .05  *** .01) ///
stats(N  controlmean pvalue , label("\midrule Observations" "Endline control mean" "p-value: Own = BAF" ) fmt(%9.0f %9.3f %9.3f)) ///
prehead("\begin{tabular}{lccccccc} \toprule") ///
posthead(" & \multicolumn{2}{c}{} & \multicolumn{5}{c}{\textbf{Visited the ADC:}} \\ \cmidrule(lr){4-8} &  \textbf{\shortstack{Visited the\\ ADC}} &  \textbf{\shortstack{Visited any\\clinic}} &   Alone & \shortstack{with husband/\\MIL} & \shortstack{with non-husband/\\MIL} & with SIL & with non-relative\\  & (1) & (2) & (3) & (4) & (5) & (6) & (7) \\ \midrule") ///
postfoot("\bottomrule \\[-5ex] \end{tabular}") ///
 sfmt(%9.2f) varwidth(25)  replace
 
 
************************************
**## Table 4: het. effects by MIL opposition
************************************
eststo clear
est drop _all

global outcomes ask_peer_adc asked_hmil asked_other visit_adc_fp_corr ///
				visit_adc_w_hhmil visit_adc_w_nohmil visit_any_fp_new_corr

foreach y of global outcomes{
eststo reg`y': reg `y' i.solo##i.base_costFP_MILopposed  i.baf##i.base_costFP_MILopposed   ///
						c.base_school_yrs#i.base_costFP_MILopposed    ///
						c.base_num_friend#i.base_costFP_MILopposed    ///
						i.base_current_fp##i.base_costFP_MILopposed  ///
						i.base_wants_child##i.base_costFP_MILopposed  ///
						i.base_obc##i.base_costFP_MILopposed  ///
						c.base_mobi#i.base_costFP_MILopposed  ///
						i.base_work##i.base_costFP_MILopposed  ///
						i.base_ever_visit_fp##i.base_costFP_MILopposed   ///
						i.base_phone#i.base_costFP_MILopposed  ///
						i.base_mod_method#i.base_costFP_MILopposed ///
						i.base_village_num#i.base_costFP_MILopposed ,  r
						
test _b[1.solo] = _b[1.baf]
estadd scalar pvalue1 = r(p)

test _b[1.solo#1.base_costFP_MILopposed ] = _b[1.baf#1.base_costFP_MILopposed ]
estadd scalar pvalue2 = r(p)

test _b[1.solo] + _b[1.solo#1.base_costFP_MILopposed ] = 0
estadd scalar pvalue3 = r(p)

test _b[1.baf] + _b[1.baf#1.base_costFP_MILopposed ] = 0
estadd scalar pvalue4 = r(p)

sum `y' if treatment == 0
estadd scalar controlmean = r(mean)	
}


esttab _all ///
using "$repo/tables/table4.tex" , ///
keep(1.solo  1.solo#1.base_costFP_MILopposed  1.baf 1.baf#1.base_costFP_MILopposed   ) ///
order(1.solo  1.baf  1.solo#1.base_costFP_MILopposed 1.baf#1.base_costFP_MILopposed  ) ///
varlabels(1.solo "Own Voucher" 1.baf "BAF Voucher" 1.solo#1.base_costFP_MILopposed "Own Voucher $\times$ MIL opposed to FP" 1.baf#1.base_costFP_MILopposed "BAF Voucher $\times$ MIL opposed to FP") ///
mlabels(none) se(%9.3f) b(%9.3f)  brackets nonum  noobs nolines collabels(none)   nogaps starlevels( * 0.1 ** .05  *** .01)  ///
stats(N  controlmean pvalue1 pvalue2 pvalue3 pvalue4 , label("\midrule Observations" "Endline control mean" "\shortstack[l]{p-values:\\Own = BAF}"   "Own $\times$ MIL opposed = BAF $\times$ MIL opposed" "Own + Own $\times$ MIL opposed = 0"  "BAF + BAF $\times$ MIL opposed = 0"  ) fmt(%9.0f %9.3f %9.3f  %9.3f %9.3f %9.3f)) ///
prehead("\begin{tabular}{lccccccc} \toprule") ///
posthead(" & \multicolumn{3}{c}{\textbf{Sought company to visit the ADC from:}} &  & \multicolumn{2}{c}{\textbf{Visited the ADC with:}} & \\  \cmidrule(lr){2-4} \cmidrule(lr){6-7}   &   Someone & \shortstack{Husband/\\MIL} & \shortstack{Non-husband/\\MIL} & \textbf{\shortstack{Visited\\the ADC}}  & \shortstack{Husband/\\MIL} & \shortstack{Non-husband/\\MIL}  & \textbf{\shortstack{Visited\\any clinic}}  \\  & (1) & (2) & (3) & (4) & (5) & (6) & (7) \\ \midrule") ///
postfoot("\bottomrule \\[-5ex] \end{tabular}") ///
sfmt(%9.2f) varwidth(25)  replace

************************************
**## Table 5 Modern contraceptive use
************************************

eststo clear
est drop _all

global outcomes mod_method_el mod_method_since_bl preg_ever

/*
foreach y of global outcomes{
	reg `y' i.solo i.baf $covbal $cov i.base_village_num , r
}
*/
 
foreach y of global outcomes{


eststo reg`y'0: reg `y' i.solo i.baf $covbal $cov i.base_village_num , r
	test _b[1.solo]=_b[1.baf]
	estadd scalar pvalue1 = r(p)
	sum `y' if treatment == 0 
	estadd scalar controlmean = r(mean)	

	
eststo reg`y'1: reg `y' i.solo##i.base_costFP_MILopposed i.baf##i.base_costFP_MILopposed   ///
						c.base_school_yrs#i.base_costFP_MILopposed    	///
						c.base_num_friend#i.base_costFP_MILopposed    	///
						i.base_current_fp##i.base_costFP_MILopposed   	///
						i.base_wants_child##i.base_costFP_MILopposed  	///
						i.base_obc##i.base_costFP_MILopposed  			///
						c.base_mobi#i.base_costFP_MILopposed  			///
						i.base_work##i.base_costFP_MILopposed  			///
						i.base_ever_visit_fp##i.base_costFP_MILopposed  ///
						i.base_phone#i.base_costFP_MILopposed  			///
						i.base_mod_method#i.base_costFP_MILopposed 		///
						i.base_village_num#i.base_costFP_MILopposed ,  r
						
test _b[1.solo] = _b[1.baf]
estadd scalar pvalue1 = r(p)

test _b[1.solo#1.base_costFP_MILopposed ] = _b[1.baf#1.base_costFP_MILopposed ]
estadd scalar pvalue2 = r(p)

test _b[1.solo] + _b[1.solo#1.base_costFP_MILopposed ] = 0
estadd scalar pvalue3 = r(p)

test _b[1.baf] + _b[1.baf#1.base_costFP_MILopposed ] = 0
estadd scalar pvalue4 = r(p)

sum `y' if treatment == 0 
estadd scalar controlmean = r(mean)	
 
	
eststo reg`y'3: reg `y' i.solo##i.base_costFP_embarrasing i.baf##i.base_costFP_embarrasing   ///
						c.base_school_yrs#i.base_costFP_embarrasing    	///
						c.base_num_friend#i.base_costFP_embarrasing    	///
						i.base_current_fp##i.base_costFP_embarrasing   	///
						i.base_wants_child##i.base_costFP_embarrasing  	///
						i.base_obc##i.base_costFP_embarrasing  			///
						c.base_mobi#i.base_costFP_embarrasing  			///
						i.base_work##i.base_costFP_embarrasing  			///
						i.base_ever_visit_fp##i.base_costFP_embarrasing  ///
						i.base_phone#i.base_costFP_embarrasing  			///
						i.base_mod_method#i.base_costFP_embarrasing 		///
						i.base_village_num#i.base_costFP_embarrasing ,  r
						
test _b[1.solo] = _b[1.baf]
estadd scalar pvalue1 = r(p)

test _b[1.solo#1.base_costFP_embarrasing ] = _b[1.baf#1.base_costFP_embarrasing ]
estadd scalar pvalue2 = r(p)

test _b[1.solo] + _b[1.solo#1.base_costFP_embarrasing ] = 0
estadd scalar pvalue3 = r(p)

test _b[1.baf] + _b[1.baf#1.base_costFP_embarrasing ] = 0
estadd scalar pvalue4 = r(p)

sum `y' if treatment == 0 
estadd scalar controlmean = r(mean)	
}

esttab 	regmod_method_el0 regmod_method_el1 regmod_method_el3 ///
		regmod_method_since_bl0 regpreg_ever0 ///
using "$repo/tables/table5.tex" , ///
rename(	1.base_costFP_embarrasing 1.base_costFP_MILopposed ///
		1.solo#1.base_costFP_embarrasing 1.solo#1.base_costFP_MILopposed ///
		1.baf#1.base_costFP_embarrasing 1.baf#1.base_costFP_MILopposed ) ///
keep(1.solo  1.solo#1.base_costFP_MILopposed  1.baf 1.baf#1.base_costFP_MILopposed  ) ///
order(1.solo  1.baf  1.solo#1.base_costFP_MILopposed 1.baf#1.base_costFP_MILopposed ) ///
varlabels(1.solo "Own Voucher" 1.baf "BAF Voucher" 1.solo#1.base_costFP_MILopposed "Own Voucher $\times$ Covariate" 1.baf#1.base_costFP_MILopposed "BAF Voucher $\times$ Covariate" ) ///
mlabels(none) se(%9.3f) b(%9.3f)  brackets nonum  noobs nolines collabels(none)   nogaps starlevels( * 0.1 ** .05  *** .01)  ///
stats(N  controlmean pvalue1 pvalue2 pvalue3 pvalue4 , label("\midrule Observations" "Endline control mean"  "\shortstack[l]{p-values:\\Own = BAF}"   "Own $\times$ Covariate = BAF $\times$ Covariate" "Own + Own $\times$ Covariate = 0"  "BAF + BAF $\times$ Covariate = 0" ) fmt(%9.0f %9.3f %9.3f  %9.3f %9.3f %9.3f)) ///
prehead("\begin{tabular}{lccccc} \toprule") ///
posthead(" & & \multicolumn{2}{c}{\textbf{\shortstack{Heterogeneity of\\Current Modern Method by}}} & & \\ \cmidrule(lr){3-4}  & \shortstack{Current Modern\\Method Use\\(all sample)} & \shortstack{MIL opposed\\to FP} &  \shortstack{Found FP\\embarrasing} &  \shortstack{Modern\\Method Use\\since baseline} &  \shortstack{Pregnancy since\\baseline}  \\  & (1) & (2) & (3) & (4) & (5) \\ \midrule") ///
postfoot("\bottomrule \\[-5ex] \end{tabular}") ///
sfmt(%9.2f) varwidth(25)  replace
 

************************************
**## Table 6: Social Connections
************************************

eststo clear
est drop _all	

global outcomes outsider  ///
				atleast1_visithf_VoutHH peer_advise_FP_VoHH  afraid_being_seen

foreach y of global outcomes{

eststo r`y': reg `y' solo baf $covbal $cov i.base_village_num  , r
	test _b[solo]=_b[baf]
	estadd scalar pvalue = r(p)
	sum `y' if treatment == 0 
	estadd scalar controlmean = r(mean)	

}

esttab  routsider ///
		ratleast1_visithf_VoutHH rpeer_advise_FP_VoHH rafraid_being_seen  ///
using "$repo/tables/table6.tex" , ///
booktabs fragment nogaps mlabels(none) nonum  nolines collabels(none) label se(%9.3f) b(%9.3f) brackets keep(solo baf) starlevels( * 0.1 ** .05  *** .01) ///
stats(N controlmean pvalue , label("\midrule Observations" "Endline control mean" "p-value: Own = BAF" ) fmt(%9.0f %9.3f  %9.3f)) ///
prehead("\begin{tabular}{lccccc}\toprule") ///
 posthead("  & \multicolumn{2}{c}{\textbf{No. of social}} & \multicolumn{2}{c}{\textbf{Peer engagement}} & \multicolumn{1}{c}{\textbf{Stigma}} \\  & \multicolumn{2}{c}{\textbf{connections}} &  \multicolumn{2}{c}{Has close peers outside HH in village that: } & \\ \cmidrule(lr){2-3}\cmidrule(lr){4-5}\cmidrule(lr){6-6} & \shortstack{Number of close peers\\in village} &  \shortstack{Number of close peers\\outside HH in village} &   \shortstack{Accompanied to\\health facility}  &  \shortstack{Advised woman\\to use FP} &  \shortstack{Afraid of\\being seen}  \\  & (1) & (2) & (3) & (4) & (5)  \\  \midrule") ///
 postfoot("\bottomrule \\[-5ex] \end{tabular}") ///
sfmt(%9.2f) varwidth(25)  replace


********************************************************************************
**# V. Results tables of the appendix section 
********************************************************************************

************************************
**## Table A.5 : Asking peers for 
* company to visit adc
************************************

eststo clear
est drop _all

global outcome 	ask_peer_adc num_peers_asked_adc  asked_hmil asked_other 		///
				asked_sil asked_nonfam visit_adc_fp_corr visit_any_fp_new_corr 	///
				num_visit_adc_corr num_fp_visit_new

foreach y of global outcome{
eststo reg`y'1: reg `y' solo baf , robust
	test _b[solo]=_b[baf]
	estadd scalar pvalue = r(p)
	sum `y' if treatment == 0 
	estadd scalar controlmean = r(mean)	
	
	estadd local Balance "No"
	estadd local Covariates "No"
	estadd local FE  "No"
	
eststo reg`y'2: reg `y' solo baf  $covbal  , robust 
	test _b[solo]=_b[baf]
	estadd scalar pvalue = r(p)
	sum `y' if treatment == 0 
	estadd scalar controlmean = r(mean)	

	estadd local Balance "Yes"
	estadd local Covariates "No"
	estadd local FE  "No"

	
eststo reg`y'3: reg `y' solo baf  $covbal $cov , robust 
	test _b[solo]=_b[baf]
	estadd scalar pvalue = r(p)
	sum `y' if treatment == 0 
	estadd scalar controlmean = r(mean)	

	estadd local Balance "Yes"
	estadd local Covariates "Yes"
	estadd local FE  "No"

	
eststo reg`y'4: reg `y' solo baf  $covbal $cov  i.base_village_num , robust 
	test _b[solo]=_b[baf]
	estadd scalar pvalue = r(p)
	sum `y' if treatment == 0 
	estadd scalar controlmean = r(mean)	

	estadd local Balance "Yes"
	estadd local Covariates "Yes"
	estadd local FE  "Yes"
	
}

esttab regask_peer_adc* ///
using "$repo/tables/appendix_table5.tex" , ///
keep(solo baf) ///
label mlabels(none) se(%9.3f) b(%9.3f)  ///
brackets nonum  noline collabels(none) noobs nogaps starlevels( * 0.1 ** .05  *** .01) ////
stats(N controlmean pvalue , label("\midrule Observations" "Endline control mean" "p-value: Own = BAF"  ) fmt(%9.0f %9.3f %9.3f)) ///
prehead("\begin{tabular}{lcccc}\toprule") ///
posthead(" & (1) & (2) & (3) & (4)  \\ \midrule  \multicolumn{5}{l}{\textbf{A: Sought company from someone}} \\ \midrule") nogaps ///
postfoot("\midrule") ///
sfmt(%9.2f) varwidth(25)  replace

esttab regasked_hmil* ///
using "$repo/tables/appendix_table5.tex" , ///
keep(solo baf) ///
label mlabels(none) se(%9.3f) b(%9.3f)  ///
brackets nonum  noline collabels(none) noobs nogaps starlevels( * 0.1 ** .05  *** .01) ////
stats(N  controlmean pvalue , label("\midrule Observations"  "Endline control mean"  "p-value: Own = BAF") fmt(%9.0f %9.3f %9.3f)) ///
prehead("") ///
posthead("\multicolumn{5}{l}{\textbf{B: Sought company from husband or mother-in-law}} \\ \midrule") nogaps ///
postfoot("\midrule") ///
sfmt(%9.2f) varwidth(30)  append

esttab regasked_other* ///
using "$repo/tables/appendix_table5.tex" , ///
keep(solo baf) ///
label mlabels(none) se(%9.3f) b(%9.3f)  ///
brackets nonum  noline collabels(none) noobs nogaps starlevels( * 0.1 ** .05  *** .01) ////
stats(N  pvalue controlmean Balance Covariates FE, label("\midrule Observations" "p-value: Own = BAF" "Endline control mean" "\midrule Balancing controls" "Other balancing covariates" "Village FE") fmt(%9.0f %9.3f %9.3f)) ///
prehead("") ///
posthead(" \multicolumn{5}{l}{\textbf{C: Sought company from someone other than husband or mother-in-law}} \\ \midrule") nogaps ///
postfoot("\bottomrule \\[-5ex] \end{tabular}") ///
 sfmt(%9.2f) varwidth(25)  append
 
 
************************************
**## Table A.6 :  number and composition
* of peers asked for companyto visit adc
************************************

esttab regnum_peers_asked_adc* ///
using "$repo/tables/appendix_table6.tex" , ///
keep(solo baf) ///
label mlabels(none) noline collabels(none) se(%9.3f) b(%9.3f)  ///
brackets nonum  noobs nogaps starlevels( * 0.1 ** .05  *** .01) ////
stats(N  controlmean pvalue , label("\midrule Observations" "Endline control mean" "p-value: Own=BAF"  ) fmt(%9.0f %9.3f %9.3f)) ///
prehead("\begin{tabular}{lcccc}\toprule") ///
posthead(" & (1) & (2) & (3) & (4)  \\ \midrule  \multicolumn{5}{l}{\textbf{A: Number of peers sought}} \\ \midrule") nogaps ///
postfoot("\midrule") ///
sfmt(%9.2f) varwidth(25)  replace

esttab regasked_sil* ///
using "$repo/tables/appendix_table6.tex" , ///
keep(solo baf) ///
label mlabels(none) noline collabels(none)  se(%9.3f) b(%9.3f)  ///
brackets nonum  noobs nogaps starlevels( * 0.1 ** .05  *** .01) ////
stats(N  controlmean pvalue , label("\midrule Observations" "Endline control mean"  "p-value: Own=BAF" ) fmt(%9.0f %9.3f %9.3f)) ///
prehead("") ///
posthead("\multicolumn{5}{l}{\textbf{B: Sought company from sister-in-law}} \\ \midrule") nogaps ///
postfoot("\midrule") ///
sfmt(%9.2f) varwidth(30)  append

esttab regasked_nonfam* ///
using "$repo/tables/appendix_table6.tex" , ///
keep(solo baf) ///
label mlabels(none) noline collabels(none) se(%9.3f) b(%9.3f)  ///
brackets nonum  noobs nogaps starlevels( * 0.1 ** .05  *** .01) ////
stats(N controlmean  pvalue  Balance Covariates FE, label("\midrule Observations" "Endline control mean"  "p-value: Own=BAF" "\midrule Balancing controls" "Other balancing covariates" "Village FE") fmt(%9.0f %9.3f %9.3f)) ///
prehead("") ///
posthead(" \multicolumn{5}{l}{\textbf{C: Sought company from a non-relative}} \\ \midrule") nogaps ///
postfoot("\bottomrule \\[-5ex] \end{tabular}") ///
 sfmt(%9.2f) varwidth(25)  append
 
************************************
**## Table A.7 : clinic visits for
* FP services
************************************


esttab regvisit_adc_fp_corr* ///
using "$repo/tables/appendix_table7.tex" , ///
keep(solo baf) ///
label mlabels(none) noline collabels(none) se(%9.3f) b(%9.3f)  ///
brackets nonum  noobs nogaps starlevels( * 0.1 ** .05  *** .01) ////
stats(N  controlmean pvalue , label("\midrule Observations" "Endline control mean" "p-value: Own = BAF"  ) fmt(%9.0f %9.3f %9.3f)) ///
prehead("\begin{tabular}{lcccc}\toprule") ///
posthead(" & (1) & (2) & (3) & (4)  \\ \midrule  \multicolumn{5}{l}{\textbf{A: Visited the ADC}} \\ \midrule") nogaps ///
postfoot("\midrule") ///
sfmt(%9.2f) varwidth(25)  replace

esttab regvisit_any_fp_new_corr* ///
using "$repo/tables/appendix_table7.tex" , ///
keep(solo baf) ///
label mlabels(none) noline collabels(none) se(%9.3f) b(%9.3f)  ///
brackets nonum  noobs nogaps starlevels( * 0.1 ** .05  *** .01) ////
stats(N  controlmean pvalue  Balance Covariates FE, label("\midrule Observations" "Endline control mean"  "p-value: Own = BAF" "\midrule Balancing controls" "Other balancing covariates" "Village FE") fmt(%9.0f %9.3f %9.3f)) ///
prehead("") ///
posthead(" \multicolumn{5}{l}{\textbf{B: Visited any clinic}} \\ \midrule") nogaps ///
postfoot("\bottomrule \\[-5ex] \end{tabular}") ///
 sfmt(%9.2f) varwidth(25)  append
 
 
************************************
**## Table A.8 :  Number of clinic
*  visits for FP services
************************************

 
esttab regnum_visit_adc_corr* ///
using "$repo/tables/appendix_table8.tex" , ///
keep(solo baf) ///
label mlabels(none) noline collabels(none) se(%9.3f) b(%9.3f)  ///
brackets nonum  noobs nogaps starlevels( * 0.1 ** .05  *** .01) ////
stats(N  controlmean pvalue , label("\midrule Observations" "Endline control mean"  "p-value: Own=BAF" ) fmt(%9.0f %9.3f %9.3f)) ///
prehead("\begin{tabular}{lcccc}\toprule") ///
posthead(" & (1) & (2) & (3) & (4)  \\ \midrule  \multicolumn{5}{l}{\textbf{A: Number of visits to the ADC}} \\ \midrule") nogaps ///
postfoot("\midrule") ///
sfmt(%9.2f) varwidth(25)  replace

esttab regnum_fp_visit_new* ///
using "$repo/tables/appendix_table8.tex" , ///
keep(solo baf) ///
label mlabels(none) noline collabels(none) se(%9.3f) b(%9.3f)  ///
brackets nonum  noobs nogaps starlevels( * 0.1 ** .05  *** .01) ////
stats(N  controlmean pvalue  Balance Covariates FE, label("\midrule Observations" "Endline control mean" "p-value: Own = BAF"  "\midrule Balancing controls" "Other balancing covariates" "Village FE") fmt(%9.0f %9.3f %9.3f)) ///
prehead("") ///
posthead(" \multicolumn{5}{l}{\textbf{B: Number of visits to any clinic}} \\ \midrule") nogaps ///
postfoot("\bottomrule \\[-5ex] \end{tabular}") ///
sfmt(%9.2f) varwidth(25)  append
 

************************************
**## Table A.9 :  Heterogeneous effects
* visit any by:
	* want another 
	* had one son
	* ever visited FP clinic
************************************

eststo clear
est drop _all

global outcome visit_any_fp_new_corr 
    
 foreach y of global outcome{
 
eststo reg`y'1: reg `y' i.solo##i.base_wants_child  i.baf##i.base_wants_child   ///
						c.base_school_yrs#i.base_wants_child    ///
						c.base_num_friend#i.base_wants_child    ///
						i.base_current_fp##i.base_wants_child  ///
						i.base_wants_child##i.base_wants_child  ///
						i.base_obc##i.base_wants_child  ///
						c.base_mobi#i.base_wants_child  ///
						i.base_work##i.base_wants_child  ///
						i.base_wants_child##i.base_wants_child   ///
						i.base_phone#i.base_wants_child  ///
						i.base_mod_method#i.base_wants_child ///
						i.base_village_num#i.base_wants_child ,  r
						

test _b[1.solo] = _b[1.baf]
estadd scalar pvalue1 = r(p)

test _b[1.solo#1.base_wants_child ] = _b[1.baf#1.base_wants_child ]
estadd scalar pvalue2 = r(p)

test _b[1.solo] + _b[1.solo#1.base_wants_child ] = 0
estadd scalar pvalue3 = r(p)

test _b[1.baf] + _b[1.baf#1.base_wants_child ] = 0
estadd scalar pvalue4 = r(p)

sum `y' if treatment == 0 
estadd scalar controlmean = r(mean)	
 	
	
eststo reg`y'2: reg `y' i.solo##i.base_at_least_1_son  i.baf##i.base_at_least_1_son   ///
						c.base_school_yrs#i.base_at_least_1_son    ///
						c.base_num_friend#i.base_at_least_1_son    ///
						i.base_current_fp##i.base_at_least_1_son  ///
						i.base_wants_child##i.base_at_least_1_son  ///
						i.base_obc##i.base_at_least_1_son  ///
						c.base_mobi#i.base_at_least_1_son  ///
						i.base_work##i.base_at_least_1_son  ///
						i.base_at_least_1_son##i.base_at_least_1_son   ///
						i.base_phone#i.base_at_least_1_son  ///
						i.base_mod_method#i.base_at_least_1_son ///
						i.base_village_num#i.base_at_least_1_son ,  r
						
test _b[1.solo] = _b[1.baf]
estadd scalar pvalue1 = r(p)

test _b[1.solo#1.base_at_least_1_son ] = _b[1.baf#1.base_at_least_1_son ]
estadd scalar pvalue2 = r(p)

test _b[1.solo] + _b[1.solo#1.base_at_least_1_son ] = 0
estadd scalar pvalue3 = r(p)

test _b[1.baf] + _b[1.baf#1.base_at_least_1_son ] = 0
estadd scalar pvalue4 = r(p)

sum `y' if treatment == 0 
estadd scalar controlmean = r(mean)	


*****	
	
eststo reg`y'3: reg `y' i.solo##i.base_ever_visit_fp i.baf##i.base_ever_visit_fp   ///
						c.base_school_yrs#i.base_ever_visit_fp    ///
						c.base_num_friend#i.base_ever_visit_fp    ///
						i.base_current_fp##i.base_ever_visit_fp  ///
						i.base_wants_child##i.base_ever_visit_fp  ///
						i.base_obc##i.base_ever_visit_fp  ///
						c.base_mobi#i.base_ever_visit_fp  ///
						i.base_work##i.base_ever_visit_fp  ///
						i.base_ever_visit_fp##i.base_ever_visit_fp   ///
						i.base_phone#i.base_ever_visit_fp  ///
						i.base_mod_method#i.base_ever_visit_fp ///
						i.base_village_num#i.base_ever_visit_fp ,  r
						
* reg 3 doesn't control for base_ever_visitFP, since we are using it to interact the model.
						
test _b[1.solo] = _b[1.baf]
estadd scalar pvalue1 = r(p)

test _b[1.solo#1.base_ever_visit_fp ] = _b[1.baf#1.base_ever_visit_fp ]
estadd scalar pvalue2 = r(p)

test _b[1.solo] + _b[1.solo#1.base_ever_visit_fp ] = 0
estadd scalar pvalue3 = r(p)

test _b[1.baf] + _b[1.baf#1.base_ever_visit_fp ] = 0
estadd scalar pvalue4 = r(p)

sum `y' if treatment == 0 
estadd scalar controlmean = r(mean)	
}
 
  
esttab regvisit_any_fp_new_corr1 regvisit_any_fp_new_corr2 regvisit_any_fp_new_corr3 ///
using "$repo/tables/appendix_table9.tex" , ///
rename(1.base_at_least_1_son 1.base_wants_child 1.base_ever_visit_fp 1.base_wants_child ///
1.solo#1.base_at_least_1_son 1.solo#1.base_wants_child ///
1.solo#1.base_ever_visit_fp 1.solo#1.base_wants_child ///
1.baf#1.base_at_least_1_son 1.baf#1.base_wants_child ///
1.baf#1.base_ever_visit_fp 1.baf#1.base_wants_child ) ///
keep(1.solo  1.solo#1.base_wants_child  1.baf 1.baf#1.base_wants_child   ) ///
order(1.solo  1.baf  1.solo#1.base_wants_child 1.baf#1.base_wants_child ) ///
varlabels(1.solo "Own Voucher" 1.baf "BAF Voucher" 1.solo#1.base_wants_child "Own Voucher $\times$ Covariate" 1.baf#1.base_wants_child "BAF Voucher $\times$ Covariate" ) ///
mlabels(none)  collabels(none) nolines se(%9.3f) b(%9.3f)  brackets nonum  noobs nogaps starlevels( * 0.1 ** .05  *** .01)  ///
stats(N  controlmean pvalue1 pvalue2 pvalue3 pvalue4 , label("\midrule Observations" "Endline control mean"  "\shortstack[l]{p-values:\\Own = BAF}"   "Own $\times$ Covariate = BAF $\times$ Covariate" "Own + Own $\times$ Covariate = 0"  "BAF + BAF $\times$ Covariate = 0" ) fmt(%9.0f %9.3f %9.3f  %9.3f %9.3f %9.3f)) ///
prehead("\begin{tabular}{lccc} \toprule") ///
posthead(" &  \multicolumn{3}{c}{Covariate at baseline:}  \\ \cmidrule(lr){2-4} \textbf{Outcome:}  &  \shortstack{Wanted another\\child} & \shortstack{Had at least\\one son} & \shortstack{Had ever visited\\a clinic for FP}  \\  \textbf{Visited any clinic} & (1) & (2) & (3) \\ \midrule") ///
postfoot("\bottomrule \\[-5ex] \end{tabular}") ///
sfmt(%9.2f) varwidth(25)  replace

*********************************************
**## Table A.10 : TOT table for 
* using IV
*********************************************

eststo clear
est drop _all

global mainoutcomes asked_other visit_adc_w_nohmil visit_adc_fp_corr visit_any_fp_new_corr ///
					mod_method_since_bl outsider atleast1_visithf_VoutHH peer_advise_FP_VoHH  afraid_being_seen  
 
foreach y of global mainoutcomes{
	
eststo reg_`y': ivreg2 `y' (treat_receive_solo treat_receive_baf=solo baf) $covbal $cov  i.base_village_num  , r

test _b[treat_receive_solo]=_b[treat_receive_baf]

	estadd scalar pvalue = r(p)
	sum `y' if treatment == 0 
	estadd scalar controlmean = r(mean)			
}


esttab   reg_asked_other reg_visit_adc_w_nohmil reg_visit_adc_fp_corr reg_visit_any_fp_new_corr ///
using "$repo/tables/appendix_table10.tex" , ///
keep(treat_receive_solo treat_receive_baf) ///
label mlabels(none) se(%9.3f) b(%9.3f)  ///
brackets nonum  noobs nogaps starlevels( * 0.1 ** .05  *** .01) ///
stats(N  pvalue controlmean, label("Observations" "p-value: Own=BAF" "Endline control mean") fmt(%9.0f %9.3f %9.3f)) ///
prehead("\begin{tabular}{lccccc} \toprule") ///
posthead("   & \textbf{\shortstack{Sought company\\to visit the ADC from\\non-husband/MIL}} & \textbf{\shortstack{Visited the\\ADC with \\non-husband/MIL}} & \textbf{\shortstack{Visited the\\ADC}}  & \textbf{\shortstack{Visited any\\clinic}} &   \textbf{\shortstack{Using modern\\FP method\\at endline}}  \\  \textbf{Panel A} & (1) & (2) & (3) & (4) & (5)  \\ \midrule")  ///
postfoot("\midrule") ///
sfmt(%9.2f) varwidth(30) replace
 
 
esttab  reg_mod_method_since_bl reg_outsider reg_atleast1_visithf_VoutHH reg_peer_advise_FP_VoHH reg_afraid_being_seen  ///  
using "$repo/tables/appendix_table10.tex" , ///
keep(treat_receive_solo treat_receive_baf) ///
label mlabels(none) se(%9.3f) b(%9.3f)  ///
brackets nonum  noobs nogaps starlevels( * 0.1 ** .05  *** .01) ///
stats(N  pvalue controlmean, label("Observations" "p-value: Own=BAF" "Endline control mean") fmt(%9.0f %9.3f %9.3f)) ///
prehead("") ///
 posthead(" & \textbf{\shortstack{Using modern\\FP method\\at baseline}} & \textbf{\shortstack{Number of close\\peers outside\\HH in village}}  &  \textbf{\shortstack{Has close peers outside\\HH that accompanied\\to health facility}} & \textbf{\shortstack{Has close peers\\outside HH that\\advised to use FP}} & \textbf{\shortstack{Afraid of\\being seen}} \\ \textbf{Panel B}  & (6) & (7) & (8) & (9) & (10) \\ \midrule")  ///
postfoot("\bottomrule \\[-5ex] \end{tabular}") sfmt(%9.2f) varwidth(30) append

 

************************************
**## Table A.11 :  Heterogeneous effects
* Asked sister in law, asked non-relative, visit ADC with SIL and non-relative
* by:
* 	Mil oppposed to FP
************************************

eststo clear
est drop _all

global outcomes  asked_sil asked_nonfam visit_adc_w_sil visit_adc_w_other

foreach y of global outcomes{
eststo reg`y': reg `y' i.solo##i.base_costFP_MILopposed   i.baf##i.base_costFP_MILopposed   ///
						c.base_school_yrs#i.base_costFP_MILopposed    ///
						c.base_num_friend#i.base_costFP_MILopposed    ///
						i.base_current_fp##i.base_costFP_MILopposed  ///
						i.base_wants_child##i.base_costFP_MILopposed  ///
						i.base_obc##i.base_costFP_MILopposed  ///
						c.base_mobi#i.base_costFP_MILopposed  ///
						i.base_work##i.base_costFP_MILopposed  ///
						i.base_ever_visit_fp##i.base_costFP_MILopposed   ///
						i.base_phone#i.base_costFP_MILopposed  ///
						i.base_mod_method#i.base_costFP_MILopposed ///
						i.base_village_num#i.base_costFP_MILopposed ,  r
						
test _b[1.solo] = _b[1.baf]
estadd scalar pvalue1 = r(p)

test _b[1.solo#1.base_costFP_MILopposed ] = _b[1.baf#1.base_costFP_MILopposed ]
estadd scalar pvalue2 = r(p)

test _b[1.solo] + _b[1.solo#1.base_costFP_MILopposed ] = 0
estadd scalar pvalue3 = r(p)

test _b[1.baf] + _b[1.baf#1.base_costFP_MILopposed ] = 0
estadd scalar pvalue4 = r(p)

sum `y' if treatment == 0 
estadd scalar controlmean = r(mean)	
}

esttab _all ///
using "$repo/tables/appendix_table11.tex" , ///
keep(1.solo  1.solo#1.base_costFP_MILopposed  1.baf 1.baf#1.base_costFP_MILopposed  ) ///
order(1.solo  1.baf  1.solo#1.base_costFP_MILopposed 1.baf#1.base_costFP_MILopposed ) ///
varlabels(1.solo "Own Voucher" 1.baf "BAF Voucher" 1.solo#1.base_costFP_MILopposed "Own Voucher $\times$ MIL opposed to FP" 1.baf#1.base_costFP_MILopposed "BAF Voucher $\times$ MIL opposed to FP" ) ///
mlabels(none) collabels(none) nolines se(%9.3f) b(%9.3f)  brackets nonum  noobs nogaps starlevels( * 0.1 ** .05  *** .01)  ///
stats(N  controlmean pvalue1 pvalue2 pvalue3 pvalue4 , label("\midrule Observations" "Endline control mean" "\shortstack[l]{p-values:\\Own = BAF}"   "Own $\times$ MIL opposed = BAF $\times$ MIL opposed" "Own + Own $\times$ MIL opposed = 0"  "BAF + BAF $\times$ MIL opposed = 0"  ) fmt(%9.0f %9.3f %9.3f  %9.3f %9.3f %9.3f)) ///
prehead("\begin{tabular}{lcccc}\toprule") ///
posthead(" & \multicolumn{2}{c}{\textbf{Sought company to visit the ADC from:}} & \multicolumn{2}{c}{\textbf{Visit ADC with:}} \\ \cmidrule(lr){2-3} \cmidrule(lr){4-5}  &   Sister-in-law & Non-relative &   Sister-in-law & Non-relative  \\  & (1) & (2) & (3) & (4) \\ \midrule") ///
postfoot("\bottomrule \\[-5ex] \end{tabular}") ///
sfmt(%9.2f) varwidth(25)  replace


************************************
**## Table A.12 : Using any FP
* and modern contraceptive
************************************
eststo clear
est drop _all

global outcomes curr_fp_endline mod_method_el

foreach y of global outcomes{

eststo reg`y'1: reg `y' solo baf , r
	test _b[solo]=_b[baf]
	estadd scalar pvalue = r(p)
	sum `y' if treatment == 0
	estadd scalar controlmean = r(mean)	
	estadd local Balance  "No"
	estadd local Covariates "No"
	estadd local FE  "No"
eststo reg`y'2: reg `y' solo baf $covbal  , r
	test _b[solo]=_b[baf]
	estadd scalar pvalue = r(p)
	sum `y' if treatment == 0
	estadd scalar controlmean = r(mean)	
	estadd local Balance  "Yes"
	estadd local Covariates "No"
	estadd local FE  "No"
eststo reg`y'3: reg `y' solo baf $covbal $cov , r
	test _b[solo]=_b[baf]
	estadd scalar pvalue = r(p)
	sum `y' if treatment == 0 
	estadd scalar controlmean = r(mean)	
	estadd local Balance "Yes"
	estadd local Covariates "Yes"
	estadd local FE  "No"
eststo reg`y'4: reg `y' solo baf $covbal $cov i.base_village_num , r
	test _b[solo]=_b[baf]
	estadd scalar pvalue = r(p)
	sum `y' if treatment == 0 
	estadd scalar controlmean = r(mean)	
	estadd local Balance "Yes"
	estadd local Covariates "Yes"
	estadd local FE  "Yes"
}

esttab  regcurr_fp_endline*  ///
using "$repo/tables/appendix_table12.tex" , ///
keep(solo baf) ///
label mlabels(none)  collabels(none) noline se(%9.3f) b(%9.3f)  ///
brackets nonum  noobs nogaps starlevels( * 0.1 ** .05  *** .01) ////
stats(N  pvalue controlmean, label("\midrule Observations" "p-value: Own=BAF" "Endline control mean" ) fmt(%9.0f %9.3f %9.3f)) ///
prehead("\begin{tabular}{lcccc} \toprule") ///
posthead(" & (1) & (2) & (3) & (4)  \\ \midrule   \multicolumn{5}{l}{\textbf{A: Using any FP method}} \\ \midrule") ///
postfoot("\midrule") ///
sfmt(%9.2f) varwidth(25)  replace


esttab  regmod_method_el1 regmod_method_el2 regmod_method_el3 regmod_method_el4  ///
using "$repo/tables/appendix_table12.tex" , ///
keep(solo baf) ///
label mlabels(none) se(%9.3f) b(%9.3f)  ///
brackets nonum  noobs nogaps starlevels( * 0.1 ** .05  *** .01) ////
stats(N  controlmean pvalue  Balance Covariates FE, label("Observations" "Endline control mean" "p-value: Own = BAF"  "\midrule Balancing controls" "Other balancing covariates" "Village FE") fmt(%9.0f %9.3f %9.3f)) ///
prehead("") ///
posthead("   \multicolumn{5}{l}{\textbf{B: Using modern FP method}} \\ \midrule ") ///
postfoot("\bottomrule \\[-5ex] \end{tabular}") ///
 sfmt(%9.2f) varwidth(25)  append


************************************
**## Table A.13 : Using any FP
* and modern contraceptive, and ever pregnancy
************************************
eststo clear
est drop _all

global outcomes curr_since_bl mod_method_since_bl preg_ever

foreach y of global outcomes{

eststo reg`y'1: reg `y' i.solo i.baf , r
	test _b[1.solo]=_b[1.baf]
	estadd scalar pvalue = r(p)
	sum `y' if treatment == 0
	estadd scalar controlmean = r(mean)	
	estadd local Balance  "No"
	estadd local Covariates "No"
	estadd local FE  "No"
eststo reg`y'2: reg `y' i.solo i.baf $covbal  , r
	test _b[1.solo]=_b[1.baf]
	estadd scalar pvalue = r(p)
	sum `y' if treatment == 0
	estadd scalar controlmean = r(mean)	
	estadd local Balance  "Yes"
	estadd local Covariates "No"
	estadd local FE  "No"
eststo reg`y'3: reg `y' i.solo i.baf $covbal $cov , r
	test _b[1.solo]=_b[1.baf]
	estadd scalar pvalue = r(p)
	sum `y' if treatment == 0 
	estadd scalar controlmean = r(mean)	
	estadd local Balance "Yes"
	estadd local Covariates "Yes"
	estadd local FE  "No"
eststo reg`y'4: reg `y' i.solo i.baf $covbal $cov i.base_village_num , r
	test _b[1.solo]=_b[1.baf]
	estadd scalar pvalue = r(p)
	sum `y' if treatment == 0 
	estadd scalar controlmean = r(mean)	
	estadd local Balance "Yes"
	estadd local Covariates "Yes"
	estadd local FE  "Yes"
	
}

esttab  regcurr_since_bl*  ///
using "$repo/tables/appendix_table13.tex" , ///
keep(1.solo 1.baf) ///
label mlabels(none)  collabels(none) noline se(%9.3f) b(%9.3f)  ///
brackets nonum  noobs nogaps starlevels( * 0.1 ** .05  *** .01) ////
stats(N  pvalue controlmean, label("\midrule Observations" "p-value: Own=BAF" "Endline control mean" ) fmt(%9.0f %9.3f %9.3f)) ///
prehead("\begin{tabular}{lcccc} \toprule") ///
posthead(" & (1) & (2) & (3) & (4)  \\ \midrule   \multicolumn{5}{l}{\textbf{A: Using FP since baseline}} \\ \midrule") ///
postfoot("\midrule") ///
sfmt(%9.2f) varwidth(25)  replace


esttab  regmod_method_since_bl* ///
using "$repo/tables/appendix_table13.tex" , ///
keep(1.solo 1.baf) ///
label mlabels(none) se(%9.3f) b(%9.3f)  ///
brackets nonum  noobs nogaps starlevels( * 0.1 ** .05  *** .01) ////
stats(N  controlmean pvalue  Balance Covariates FE, label("Observations" "Endline control mean" "p-value: Own = BAF"  "\midrule Balancing controls" "Other balancing covariates" "Village FE") fmt(%9.0f %9.3f %9.3f)) ///
prehead("") ///
posthead("   \multicolumn{5}{l}{\textbf{B: Using modern FP since baseline}} \\ \midrule ") ///
postfoot("\midrule") ///
 sfmt(%9.2f) varwidth(25) append

 
esttab  regpreg_ever* ///
using "$repo/tables/appendix_table13.tex" , ///
keep(1.solo 1.baf) ///
label mlabels(none) se(%9.3f) b(%9.3f)  ///
brackets nonum  noobs nogaps starlevels( * 0.1 ** .05  *** .01) ////
stats(N  controlmean pvalue  Balance Covariates FE, label("Observations" "Endline control mean" "p-value: Own = BAF"  "\midrule Balancing controls" "Other balancing covariates" "Village FE") fmt(%9.0f %9.3f %9.3f)) ///
prehead("") ///
posthead("   \multicolumn{5}{l}{\textbf{C: Ever pregnant}} \\ \midrule ") ///
postfoot("\bottomrule \\[-5ex] \end{tabular}") ///
 sfmt(%9.2f) varwidth(25)  append
 
 
************************************
**## Table A.14
* Socional Connections Het. Effects
************************************

eststo clear
est drop _all

global outcomes outsider atleast1_visithf_VoutHH

foreach y of global outcomes{
	
eststo r`y'0: reg `y' i.solo##i.base_nopeeruseFPvill   i.baf##i.base_nopeeruseFPvill   ///
						c.base_school_yrs#i.base_nopeeruseFPvill    ///
						c.base_num_friend#i.base_nopeeruseFPvill    ///
						i.base_current_fp##i.base_nopeeruseFPvill  ///
						i.base_wants_child##i.base_nopeeruseFPvill  ///
						i.base_obc##i.base_nopeeruseFPvill  ///
						c.base_mobi#i.base_nopeeruseFPvill  ///
						i.base_work##i.base_nopeeruseFPvill  ///
						i.base_ever_visit_fp##i.base_nopeeruseFPvill   ///
						i.base_phone#i.base_nopeeruseFPvill  ///
						i.base_mod_method#i.base_nopeeruseFPvill ///
						i.base_village_num#i.base_nopeeruseFPvill ,  r
						
test _b[1.solo] = _b[1.baf]
estadd scalar pvalue1 = r(p)

test _b[1.solo#1.base_nopeeruseFPvill] = _b[1.baf#1.base_nopeeruseFPvill]
estadd scalar pvalue2 = r(p)

test _b[1.solo] + _b[1.solo#1.base_nopeeruseFPvill ] = 0
estadd scalar pvalue3 = r(p)

test _b[1.baf] + _b[1.baf#1.base_nopeeruseFPvill ] = 0
estadd scalar pvalue4 = r(p)

sum `y' if treatment == 0 
estadd scalar controlmean = r(mean)	

}

esttab routsider0 ratleast1_visithf_VoutHH0  ///
using "$repo/tables/appendix_table14.tex" , ///
keep(1.solo  1.solo#1.base_nopeeruseFPvill  1.baf 1.baf#1.base_nopeeruseFPvill  ) ///
order(1.solo  1.baf  1.solo#1.base_nopeeruseFPvill 1.baf#1.base_nopeeruseFPvill  ) ///
varlabels(1.solo "Own Voucher" 1.baf "BAF Voucher" 1.solo#1.base_nopeeruseFPvill "Own Voucher $\times$ Covariate" 1.baf#1.base_nopeeruseFPvill "BAF  Voucher $\times$ Covariate" ) ///
mlabels(none) se(%9.3f) b(%9.3f)  brackets nonum  noobs nolines collabels(none)   nogaps starlevels( * 0.1 ** .05  *** .01)  ///
stats(N  controlmean pvalue1 pvalue2 pvalue3 pvalue4 , label("\midrule Observations" "Endline control mean" "\shortstack[l]{p-values:\\Own = BAF}"   "Own $\times$ Covariate = BAF $\times$ Covariate" "Own + Own $\times$ Covariate = 0"  "BAF + BAF $\times$ Covariate = 0"  ) fmt(%9.0f %9.3f %9.3f  %9.3f %9.3f %9.3f)) ///
prehead("\begin{tabular}{lcc} \toprule") ///
posthead(" &  \multicolumn{2}{c}{Covariate at baseline: Lack of close peers in village that use FP}  \\ \cmidrule(lr){2-3} \textbf{Outcomes:} &  \textbf{\shortstack{Number of close peers in\\village outside HH}} & \textbf{\shortstack{Has peers in village outside HH that\\accompanied to health facility}} \\  & (1) & (2)  \\ \midrule") ///
postfoot("\bottomrule \\[-5ex] \end{tabular}") ///
sfmt(%9.2f) varwidth(25)  replace


************************************
**## Table A.15 : Backlash effect
************************************
eststo clear
est drop _all

eststo reg1: reg neg_exp solo baf  $covbal $cov ib1.base_village_num , robust

	test _b[solo]=_b[baf]
	estadd scalar pvalue = r(p)
	sum neg_exp  if treatment == 0 
	estadd scalar controlmean = r(mean)
	
eststo reg2: reg sexlife_sat solo baf  $covbal $cov ib1.base_village_num if  sexlife_sat<88, robust
	test _b[solo]=_b[baf]
	estadd scalar pvalue = r(p)
	sum sexlife_sat if treatment == 0  & sexlife_sat<88
	estadd scalar controlmean = r(mean)
	
eststo reg3: reg marriage_sat solo baf  $covbal $cov ib1.base_village_num if  marriage_sat<88, robust
	test _b[solo]=_b[baf]
	estadd scalar pvalue = r(p)
	sum marriage_sat if treatment == 0  & marriage_sat<88
	estadd scalar controlmean = r(mean)
	
	
esttab reg1 reg2 reg3  ///
using "$repo/tables/appendix_table15.tex" , ///
keep(solo baf)  label mlabels(none) collabels(none) nolines se(%9.3f) b(%9.3f) starlevels( * 0.1 ** .05  *** .01)  brackets nonum  noobs nogaps ///
stats(N  controlmean pvalue , label("\midrule Observations" "Endline control mean" "p-value: Own = BAF" ) fmt(%9.0f %9.3f %9.3f)) ///
prehead("\begin{tabular}{lccc} \toprule") ///
 posthead("   &  \textbf{\shortstack{Negative experience\\with FP}} & \textbf{\shortstack{Satisfaction with\\sex life}}  & \textbf{\shortstack{Marital\\satisfaction}}  \\  & (1) & (2) & (3)  \\ \midrule") ///
 postfoot("\bottomrule \\[-5ex] \end{tabular}") ///
 sfmt(%9.2f) varwidth(30)  replace
 
 
************************************
**## Table A.16 : Heterogeneous Effects
* Financial Constraints
************************************
eststo clear
est drop _all

global outcomes  visit_adc_fp_corr visit_any_fp_new_corr mod_method_since_bl

foreach y of global outcomes{
eststo reg`y'0: reg `y' i.treat##i.base_poor  ///
						c.base_school_yrs#i.base_poor ///
						c.base_num_friend#i.base_poor   ///
						i.base_current_fp##i.base_poor ///
						i.base_wants_child##i.base_poor ///
						i.base_obc##i.base_poor ///
						c.base_mobi#i.base_poor ///
						i.base_work##i.base_poor ///
						i.base_ever_visit_fp##i.base_poor  ///
						i.base_phone##i.base_poor  ///
						i.base_mod_method##i.base_poor ///
						i.base_village_num##i.base_poor ,  r
						
sum `y' if treatment == 0 
estadd scalar controlmean = r(mean)	

test _b[1.treat] + _b[1.treat#1.base_poor ] = 0
estadd scalar pvalue = r(p)

}

esttab regvisit_adc_fp_corr0 regvisit_any_fp_new_corr0 regmod_method_since_bl0  ///
using "$repo/tables/appendix_table16.tex" , ///
keep(1.treat  1.treat#1.base_poor  ) ///
order(1.treat  1.treat#1.base_poor) ///
varlabels(1.treat "Any Voucher"  1.treat#1.base_poor "Any Voucher $\times$ Poor at baseline") ///
mlabels(none) collabels(none) nolines se(%9.3f) b(%9.3f)  brackets nonum  noobs nogaps starlevels( * 0.1 ** .05  *** .01) ///
stats(N  controlmean pvalue, label("\midrule Observations"  "Endline control mean" "\shortstack[l]{p-value:\\Any Voucher + Any Voucher $\times$ Poor = 0}") fmt(%9.0f %9.3f %9.3f)) ///
prehead("\begin{tabular}{lcccc} \toprule") ///
posthead(" &   \textbf{\shortstack{Visited the ADC\\clinic}} & \textbf{\shortstack{Visited any\\clinic}}  & \textbf{\shortstack{Using a modern\\method at endline}} & \textbf{\shortstack{Using a modern\\method since baseline}} \\  & (1) & (2) & (3) & (4)   \\ \midrule") ///
postfoot("\bottomrule \\[-5ex] \end{tabular}") ///
 sfmt(%9.2f) varwidth(25)  replace
 
/*
 
************************************
**## Table A.17 : Robustness Checks 
* MHT for main outcomes
************************************
 
set seed 123

eststo clear
est drop _all


global mainoutcomes ask_peer_adc visit_adc_fp_corr visit_any_fp_new_corr mod_method_since_bl outsider
            
foreach y of global mainoutcomes{

* robust
eststo reg_`y': reg `y' solo baf $covbal $cov i.base_village_num  , robust
test solo
estadd scalar solo_robust = r(p)
test baf 
estadd scalar baf_robust = r(p)

* cluster SE
reg `y' solo baf $covbal $cov i.base_village_num  , cluster(base_village_num)
test solo 
estadd scalar solo_cluster = r(p): reg_`y'
test baf
estadd scalar baf_cluster = r(p): reg_`y'

* Wild cluster bootstrapped SE
boottest {solo} {baf}, cluster(base_village_num) nograph  seed(123) 

estadd scalar solo_wild = r(p_1): reg_`y'
estadd scalar baf_wild = r(p_2): reg_`y'

}
 
* Computinig MHT using rwolf2 command (Romano-Wolf)

rwolf2 (reg ask_peer_adc		 		solo baf $covbal $cov i.base_village_num, r ) /// 
	   (reg visit_adc_fp_corr	 		solo baf $covbal $cov i.base_village_num, r ) /// 
       (reg visit_any_fp_new_corr 		solo baf $covbal $cov i.base_village_num, r ) ///  
	   (reg mod_method_since_bl			solo baf $covbal $cov i.base_village_num, r ) ///   
       (reg outsider					solo baf $covbal $cov i.base_village_num, r ),  ///  
indepvars(solo baf , solo baf, solo baf, solo baf, solo baf) reps(3000) holm seed(123)

matrix rw_all = e(RW)

* Ask peer
scalar solo_mht2 = rw_all[1,3]
scalar baf_mht2 = rw_all[2,3]
estadd scalar solo_mht2 = solo_mht2 : reg_ask_peer_adc
estadd scalar baf_mht2 = baf_mht2 : reg_ask_peer_adc

* Visit ADC 
scalar solo_mht2 = rw_all[3,3]
scalar baf_mht2	 = rw_all[4,3]
estadd scalar solo_mht2 = solo_mht2 : reg_visit_adc_fp_corr
estadd scalar baf_mht2 	= baf_mht2 : reg_visit_adc_fp_corr

* Visit Any
scalar solo_mht2 = rw_all[5,3]
scalar baf_mht2	 = rw_all[6,3]
estadd scalar solo_mht2 = solo_mht2 : reg_visit_any_fp_new_corr
estadd scalar baf_mht2  = baf_mht2 : reg_visit_any_fp_new_corr

* Mod method
scalar solo_mht2 = rw_all[7,3]
scalar baf_mht2	 = rw_all[8,3]
estadd scalar solo_mht2 = solo_mht2 : reg_mod_method_since_bl
estadd scalar baf_mht2	= baf_mht2 : reg_mod_method_since_bl

* Using outsider
scalar solo_mht2 = rw_all[9,3]
scalar baf_mht2	 = rw_all[10,3]
estadd scalar solo_mht2 = solo_mht2 : reg_outsider
estadd scalar baf_mht2  = baf_mht2  : reg_outsider


* Exportin Table in two panels:


esttab reg_ask_peer_adc reg_visit_adc_fp_corr reg_visit_any_fp_new_corr  ///  
using "$repo/tables/appendix_table17.tex" , ///
keep(solo) varlabels(solo "Own Voucher") ///
mlabels(none) b(%9.3f) not nostar nonum  noobs nogaps  eqlabel(none) collabels(none) nolines ///
stats(solo_robust solo_cluster solo_wild solo_mht2, layout(`"(@)"' `"(@)"' `"(@)"' `"(@)"' ) label("\emph{Robust (p-value)}" "\emph{Clustered (p-value)}" "\emph{WC Bootstrap (p-value)}" "\emph{\citet{romano_exact_2005,romano_stepwise_2005} MHT Correction (p-value)}")) ///
prehead("\begin{tabular}{lccc} \toprule") ///
posthead("   & \textbf{\shortstack{Sought company\\to visit the ADC}} & \textbf{\shortstack{Visited the\\ADC}}  & \textbf{\shortstack{Visited any\\clinic}} \\ \textbf{Panel A}  & (1) & (2) & (3) \\ \midrule")  ///
postfoot("\midrule") ///
 sfmt(%9.2f) varwidth(30) substitute(\_ _)  replace
 
esttab reg_ask_peer_adc reg_visit_adc_fp_corr reg_visit_any_fp_new_corr  ///  
using "$repo/tables/appendix_table17.tex" , ///
keep(baf) varlabels(baf "BAF Voucher") ///
mlabels(none) b(%9.3f) not nostar nonum  noobs nogaps  eqlabel(none) collabels(none) nolines ///
stats(baf_robust baf_cluster baf_wild baf_mht2, layout(`"(@)"' `"(@)"' `"(@)"' `"(@)"' ) label("\emph{Robust (p-value)}" "\emph{Clustered (p-value)}" "\emph{WC Bootstrap (p-value)}" "\emph{\citet{romano_exact_2005,romano_stepwise_2005} MHT Correction (p-value)}")) ///
prehead("") ///
posthead(" ")  ///
postfoot("\midrule") ///
sfmt(%9.2f) varwidth(30)  substitute(\_ _)  append
 
esttab reg_mod_method_since_bl reg_outsider  ///  
using "$repo/tables/appendix_table17.tex" , ///
keep(solo) varlabels(solo "Own Voucher") ///
mlabels(none) b(%9.3f) not nostar nonum  noobs nogaps  eqlabel(none) collabels(none) nolines ///
stats(solo_robust solo_cluster solo_wild solo_mht2, layout(`"(@)"' `"(@)"' `"(@)"' `"(@)"' ) label("\emph{Robust (p-value)}" "\emph{Clustered (p-value)}" "\emph{WC Bootstrap (p-value)}" "\emph{\citet{romano_exact_2005,romano_stepwise_2005} MHT Correction (p-value)}")) ///
prehead("") ///
posthead("   & \textbf{\shortstack{Using modern\\FP method\\since baseline}}  & \textbf{\shortstack{Number of close\\peers outside\\HH in village}} & \\ \textbf{Panel B}  & (4) & (5) &  \\ \midrule")  ///
postfoot("\midrule") ///
 sfmt(%9.2f) varwidth(30) substitute(\_ _)  append
 
esttab reg_mod_method_since_bl reg_outsider  ///   
using "$repo/tables/appendix_table17.tex" , ///
keep(baf) varlabels(baf "BAF Voucher") ///
mlabels(none) b(%9.3f) not nostar nonum  noobs nogaps  eqlabel(none) collabels(none) nolines ///
stats(baf_robust baf_cluster baf_wild baf_mht2, layout(`"(@)"' `"(@)"' `"(@)"' `"(@)"' ) label("\emph{Robust (p-value)}" "\emph{Clustered (p-value)}" "\emph{WC Bootstrap (p-value)}" "\emph{\citet{romano_exact_2005,romano_stepwise_2005} MHT Correction (p-value)}")) ///
prehead("") ///
posthead(" ")  ///
postfoot("\bottomrule \\[-5ex] \end{tabular}") ///
sfmt(%9.2f) varwidth(30)  substitute(\_ _)  append


*/










********************************************************************************
**# VI. R&R 1: From 2025-02-06
********************************************************************************

use "$repo/data/data_endline.dta", clear
drop if base_wants_child == . // Drop 4 obsrvations having missing values for this covariate

replace base_livewMI = . if  base_costFP_MILopposed == . //To keep the obs. in tables consistent


// The following tables have full table code; on the other hand above tables
// (for replication) starts from \begin{tabular}.

/*
. tab base_costFP_MILopposed base_livewMIL, cell

+-----------------+
| Key             |
|-----------------|
|    frequency    |
| cell percentage |
+-----------------+

       MIL |
opposed to | Co-residence with MIL
        FP |         0          1 |     Total
-----------+----------------------+----------
         0 |       162        354 |       516 
           |     26.26      57.37 |     83.63 
-----------+----------------------+----------
         1 |        33         68 |       101 
           |      5.35      11.02 |     16.37 
-----------+----------------------+----------
     Total |       195        422 |       617 
           |     31.60      68.40 |    100.00 

*/


* Globals for covariates and balancing covariates:

global covbal base_school_yrs base_current_fp base_wants_child base_num_friend
global cov  base_mobi base_work base_ever_visit_fp base_mod_method base_phone


************************************
**## Table 4x: het. effects by MIL co-residence
************************************
eststo clear
est drop _all

global outcomes ask_peer_adc asked_hmil asked_other visit_adc_fp_corr ///
				visit_adc_w_hhmil visit_adc_w_nohmil visit_any_fp_new_corr

foreach y of global outcomes{
eststo reg`y': reg `y' i.solo##i.base_livewMIL  i.baf##i.base_livewMIL   ///
						c.base_school_yrs#i.base_livewMIL    ///
						c.base_num_friend#i.base_livewMIL    ///
						i.base_current_fp##i.base_livewMIL  ///
						i.base_wants_child##i.base_livewMIL  ///
						i.base_obc##i.base_livewMIL  ///
						c.base_mobi#i.base_livewMIL  ///
						i.base_work##i.base_livewMIL  ///
						i.base_ever_visit_fp##i.base_livewMIL   ///
						i.base_phone#i.base_livewMIL  ///
						i.base_mod_method#i.base_livewMIL ///
						i.base_village_num#i.base_livewMIL ,  r
						
test _b[1.solo] = _b[1.baf]
estadd scalar pvalue1 = r(p)

test _b[1.solo#1.base_livewMIL ] = _b[1.baf#1.base_livewMIL ]
estadd scalar pvalue2 = r(p)

test _b[1.solo] + _b[1.solo#1.base_livewMIL ] = 0
estadd scalar pvalue3 = r(p)

test _b[1.baf] + _b[1.baf#1.base_livewMIL ] = 0
estadd scalar pvalue4 = r(p)

sum `y' if treatment == 0
estadd scalar controlmean = r(mean)	
}


esttab _all ///
using "$repo/RESULTS/tables/table4x.tex" , ///
keep(1.solo  1.solo#1.base_livewMIL  1.baf 1.baf#1.base_livewMIL   ) ///
order(1.solo  1.baf  1.solo#1.base_livewMIL 1.baf#1.base_livewMIL  ) ///
varlabels(1.solo "Own Voucher" 1.baf "BAF Voucher" 1.solo#1.base_livewMIL "Own Voucher $\times$ MIL Co-residence" 1.baf#1.base_livewMIL "BAF Voucher $\times$ MIL Co-residence") ///
mlabels(none) se(%9.3f) b(%9.3f)  brackets nonum  noobs nolines collabels(none)   nogaps starlevels( * 0.1 ** .05  *** .01)  ///
stats(N  controlmean pvalue1 pvalue2 pvalue3 pvalue4 , label("\midrule Observations" "Endline control mean" "\shortstack[l]{p-values:\\Own = BAF}"   "Own $\times$ MIL Co-residence = BAF $\times$ MIL Co-residence" "Own + Own $\times$ MIL Co-residence = 0"  "BAF + BAF $\times$ MIL Co-residence = 0"  ) fmt(%9.0f %9.3f %9.3f  %9.3f %9.3f %9.3f)) ///
prehead("\begin{table}[htpb]\begin{center}\caption{Heterogeneous treatment effects, by mother-in-law co-residence at baseline}\label{table:tab4x-interact-milopposed}\resizebox{\linewidth}{!}{\begin{tabular}{lccccccc} \toprule") ///
posthead(" & \multicolumn{3}{c}{\textbf{Sought company to visit the ADC from:}} &  & \multicolumn{2}{c}{\textbf{Visited the ADC with:}} & \\  \cmidrule(lr){2-4} \cmidrule(lr){6-7}   &   Someone & \shortstack{Husband/\\MIL} & \shortstack{Non-husband/\\MIL} & \textbf{\shortstack{Visited\\the ADC}}  & \shortstack{Husband/\\MIL} & \shortstack{Non-husband/\\MIL}  & \textbf{\shortstack{Visited\\any clinic}}  \\  & (1) & (2) & (3) & (4) & (5) & (6) & (7) \\ \midrule") ///
postfoot("\bottomrule \\[-5ex] \end{tabular}} \end{center} \begin{tablenotes} All specifications are fully-interacted regressions, where all covariates are interacted with an indicator for whether the MIL was co-residing at baseline. The main effect of MIL Co-residence at baseline is also included as control variable. All specifications include balancing controls (i.e., the baseline levels of whether a woman was using FP, her years of education, whether she wanted another child, and her number of general peers), other baseline covariates (i.e., whether the woman worked, whether she had ever visited a FP clinic, the woman's mobility score, and whether she was using a modern family planning method), whether the endline interview was conducted over the phone, and village fixed effects. MIL denotes mother-in-law, FP denotes family planning, and BAF denotes Bring-a-Friend. Variable definitions are presented in the Online Appendix. Robust standard errors are presented in brackets. \sym{*}\(p<0.1\),\sym{**}\(p<0.05\),\sym{***}\(p<0.01\). \end{tablenotes} \end{table}") ///
sfmt(%9.2f) varwidth(25)  replace


************************************
**## Table 5x Modern contraceptive use
************************************

eststo clear
est drop _all

global outcomes mod_method_el mod_method_since_bl preg_ever

 
foreach y of global outcomes{


eststo reg`y'0: reg `y' i.solo i.baf $covbal $cov i.base_village_num , r
	test _b[1.solo]=_b[1.baf]
	estadd scalar pvalue1 = r(p)
	sum `y' if treatment == 0 
	estadd scalar controlmean = r(mean)	



eststo reg`y'1: reg `y' i.solo##i.base_costFP_MILopposed i.baf##i.base_costFP_MILopposed   ///
						c.base_school_yrs#i.base_costFP_MILopposed    	///
						c.base_num_friend#i.base_costFP_MILopposed    	///
						i.base_current_fp##i.base_costFP_MILopposed   	///
						i.base_wants_child##i.base_costFP_MILopposed  	///
						i.base_obc##i.base_costFP_MILopposed  			///
						c.base_mobi#i.base_costFP_MILopposed  			///
						i.base_work##i.base_costFP_MILopposed  			///
						i.base_ever_visit_fp##i.base_costFP_MILopposed  ///
						i.base_phone#i.base_costFP_MILopposed  			///
						i.base_mod_method#i.base_costFP_MILopposed 		///
						i.base_village_num#i.base_costFP_MILopposed ,  r
						
test _b[1.solo] = _b[1.baf]
estadd scalar pvalue1 = r(p)

test _b[1.solo#1.base_costFP_MILopposed ] = _b[1.baf#1.base_costFP_MILopposed ]
estadd scalar pvalue2 = r(p)

test _b[1.solo] + _b[1.solo#1.base_costFP_MILopposed ] = 0
estadd scalar pvalue3 = r(p)

test _b[1.baf] + _b[1.baf#1.base_costFP_MILopposed ] = 0
estadd scalar pvalue4 = r(p)

sum `y' if treatment == 0 
estadd scalar controlmean = r(mean)	



eststo reg`y'2: reg `y' i.solo##i.base_livewMIL i.baf##i.base_livewMIL   ///
						c.base_school_yrs#i.base_livewMIL    	///
						c.base_num_friend#i.base_livewMIL    	///
						i.base_current_fp##i.base_livewMIL   	///
						i.base_wants_child##i.base_livewMIL  	///
						i.base_obc##i.base_livewMIL  			///
						c.base_mobi#i.base_livewMIL  			///
						i.base_work##i.base_livewMIL  			///
						i.base_ever_visit_fp##i.base_livewMIL  ///
						i.base_phone#i.base_livewMIL  			///
						i.base_mod_method#i.base_livewMIL 		///
						i.base_village_num#i.base_livewMIL ,  r
						
test _b[1.solo] = _b[1.baf]
estadd scalar pvalue1 = r(p)

test _b[1.solo#1.base_livewMIL ] = _b[1.baf#1.base_livewMIL ]
estadd scalar pvalue2 = r(p)

test _b[1.solo] + _b[1.solo#1.base_livewMIL ] = 0
estadd scalar pvalue3 = r(p)

test _b[1.baf] + _b[1.baf#1.base_livewMIL ] = 0
estadd scalar pvalue4 = r(p)

sum `y' if treatment == 0 
estadd scalar controlmean = r(mean)	
 
	
	
eststo reg`y'3: reg `y' i.solo##i.base_costFP_embarrasing i.baf##i.base_costFP_embarrasing   ///
						c.base_school_yrs#i.base_costFP_embarrasing    	///
						c.base_num_friend#i.base_costFP_embarrasing    	///
						i.base_current_fp##i.base_costFP_embarrasing   	///
						i.base_wants_child##i.base_costFP_embarrasing  	///
						i.base_obc##i.base_costFP_embarrasing  			///
						c.base_mobi#i.base_costFP_embarrasing  			///
						i.base_work##i.base_costFP_embarrasing  			///
						i.base_ever_visit_fp##i.base_costFP_embarrasing  ///
						i.base_phone#i.base_costFP_embarrasing  			///
						i.base_mod_method#i.base_costFP_embarrasing 		///
						i.base_village_num#i.base_costFP_embarrasing ,  r
						
test _b[1.solo] = _b[1.baf]
estadd scalar pvalue1 = r(p)

test _b[1.solo#1.base_costFP_embarrasing ] = _b[1.baf#1.base_costFP_embarrasing ]
estadd scalar pvalue2 = r(p)

test _b[1.solo] + _b[1.solo#1.base_costFP_embarrasing ] = 0
estadd scalar pvalue3 = r(p)

test _b[1.baf] + _b[1.baf#1.base_costFP_embarrasing ] = 0
estadd scalar pvalue4 = r(p)

sum `y' if treatment == 0 
estadd scalar controlmean = r(mean)	
}


esttab 	regmod_method_el0 regmod_method_el1 regmod_method_el2 regmod_method_el3 ///
		regmod_method_since_bl0 regpreg_ever0 ///
using "$repo/RESULTS/tables/table5x.tex" , ///
rename(	1.base_costFP_embarrasing 1.base_costFP_MILopposed ///
		1.solo#1.base_livewMIL 1.solo#1.base_costFP_MILopposed ///
		1.baf#1.base_livewMIL 1.baf#1.base_costFP_MILopposed ///
		1.solo#1.base_costFP_embarrasing 1.solo#1.base_costFP_MILopposed ///
		1.baf#1.base_costFP_embarrasing 1.baf#1.base_costFP_MILopposed ) ///
keep(1.solo  1.solo#1.base_costFP_MILopposed  1.baf 1.baf#1.base_costFP_MILopposed  ) ///
order(1.solo  1.baf  1.solo#1.base_costFP_MILopposed 1.baf#1.base_costFP_MILopposed ) ///
varlabels(1.solo "Own Voucher" 1.baf "BAF Voucher" 1.solo#1.base_costFP_MILopposed "Own Voucher $\times$ Covariate" 1.baf#1.base_costFP_MILopposed "BAF Voucher $\times$ Covariate" ) ///
mlabels(none) se(%9.3f) b(%9.3f)  brackets nonum  noobs nolines collabels(none)   nogaps starlevels( * 0.1 ** .05  *** .01)  ///
stats(N  controlmean pvalue1 pvalue2 pvalue3 pvalue4 , label("\midrule Observations" "Endline control mean"  "\shortstack[l]{p-values:\\Own = BAF}"   "Own $\times$ Covariate = BAF $\times$ Covariate" "Own + Own $\times$ Covariate = 0"  "BAF + BAF $\times$ Covariate = 0" ) fmt(%9.0f %9.3f %9.3f  %9.3f %9.3f %9.3f)) ///
prehead("\begin{table}[htpb]\begin{center}\caption{Modern contraceptive use and pregnancy at endline}\label{table:tab5x-modernuse-itt}\begin{tabular}{lcccccc} \toprule") ///
posthead(" & & \multicolumn{2}{c}{\textbf{\shortstack{Heterogeneity of\\Current Modern Method by}}} & & \\ \cmidrule(lr){3-5}  & \shortstack{Current Modern\\Method Use\\(all sample)} & \shortstack{MIL opposed\\to FP} & \shortstack{MIL\\Co-resident} &  \shortstack{Found FP\\embarrasing} &  \shortstack{Modern\\Method Use\\since baseline} &  \shortstack{Pregnancy since\\baseline}  \\  & (1) & (2) & (3) & (4) & (5) & (6) \\ \midrule") ///
postfoot("\bottomrule \\[-5ex] \end{tabular} \end{center} \begin{tablenotes} Each column represents a separate regression. Columns 2, 3, and 4 are fully-interacted regressions where all controls are interacted with the covariate used for estimating heterogeneous effects, with the main effect of that variable also included as a regressor. All specifications include balancing controls (i.e., the baseline levels of whether a woman was using FP, her years of education, whether she wanted another child, and her number of general peers), other baseline covariates (i.e., whether the woman worked, whether she had ever visited a FP clinic, the woman's mobility score, and whether she was using a modern FP method), whether the endline interview was conducted over the phone, and village fixed effects. MIL denotes mother-in-law, FP denotes family planning, and BAF denotes Bring-a-Friend. The number of observations is less than 621 a) in columns 1, 4, and 5 due to missing observations in the outcome variable and b) in columns 2 and 3 due to missing values in ``MIL opposed to FP''. Variable definitions are presented in the Online Appendix. Robust standard errors are presented in brackets. \sym{*}\(p<0.1\),\sym{**}\(p<0.05\),\sym{***}\(p<0.01\). \end{tablenotes} \end{table}") ///
sfmt(%9.2f) varwidth(25)  replace




************************************
**## Table 6x1: Social Connections: Het by MIL opposition
************************************

eststo clear
est drop _all	

global outcomes outsider  ///
				atleast1_visithf_VoutHH peer_advise_FP_VoHH ///
				afraid_being_seen

foreach y of global outcomes{

eststo reg`y'1: reg `y' i.solo##i.base_costFP_MILopposed i.baf##i.base_costFP_MILopposed   ///
						c.base_school_yrs#i.base_costFP_MILopposed    	///
						c.base_num_friend#i.base_costFP_MILopposed    	///
						i.base_current_fp##i.base_costFP_MILopposed   	///
						i.base_wants_child##i.base_costFP_MILopposed  	///
						i.base_obc##i.base_costFP_MILopposed  			///
						c.base_mobi#i.base_costFP_MILopposed  			///
						i.base_work##i.base_costFP_MILopposed  			///
						i.base_ever_visit_fp##i.base_costFP_MILopposed  ///
						i.base_phone#i.base_costFP_MILopposed  			///
						i.base_mod_method#i.base_costFP_MILopposed 		///
						i.base_village_num#i.base_costFP_MILopposed ,  r
						
test _b[1.solo] = _b[1.baf]
estadd scalar pvalue1 = r(p)

test _b[1.solo#1.base_costFP_MILopposed ] = _b[1.baf#1.base_costFP_MILopposed ]
estadd scalar pvalue2 = r(p)

test _b[1.solo] + _b[1.solo#1.base_costFP_MILopposed ] = 0
estadd scalar pvalue3 = r(p)

test _b[1.baf] + _b[1.baf#1.base_costFP_MILopposed ] = 0
estadd scalar pvalue4 = r(p)

sum `y' if treatment == 0 
estadd scalar controlmean = r(mean)	

}


esttab _all ///
using "$repo/RESULTS/tables/table6x1.tex" , ///
keep(1.solo  1.solo#1.base_costFP_MILopposed  1.baf 1.baf#1.base_costFP_MILopposed   ) ///
order(1.solo  1.baf  1.solo#1.base_costFP_MILopposed 1.baf#1.base_costFP_MILopposed  ) ///
varlabels(1.solo "Own Voucher" 1.baf "BAF Voucher" 1.solo#1.base_costFP_MILopposed "Own Voucher $\times$ MIL opposed to FP" 1.baf#1.base_costFP_MILopposed "BAF Voucher $\times$ MIL opposed to FP") ///
mlabels(none) se(%9.3f) b(%9.3f)  brackets nonum  noobs nolines collabels(none)   nogaps starlevels( * 0.1 ** .05  *** .01)  ///
stats(N  controlmean pvalue1 pvalue2 pvalue3 pvalue4 , label("\midrule Observations" "Endline control mean" "\shortstack[l]{p-values:\\Own = BAF}"   "Own $\times$ MIL opposed = BAF $\times$ MIL opposed" "Own + Own $\times$ MIL opposed = 0"  "BAF + BAF $\times$ MIL opposed = 0"  ) fmt(%9.0f %9.3f %9.3f  %9.3f %9.3f %9.3f)) ///
prehead("\begin{table}[htpb]\begin{center}\caption{Heterogeneous effect on Social connections at endline by MIL opposition to FP at baseline}\label{table:tab6-sn-itt-miloppose}\begin{tabular}{lcccc} \toprule") ///
 posthead(" & & \multicolumn{2}{c}{\textbf{Peer engagement}} & \multicolumn{1}{c}{\textbf{Stigma}} \\ \cmidrule(lr){3-4}  & &  \multicolumn{2}{c}{Has close peers outside HH in village that: } & \\ \cmidrule(lr){3-4} \cmidrule(lr){5-5} &  \shortstack{Number of close peers\\outside HH in village} &   \shortstack{Accompanied to\\health facility}  &  \shortstack{Advised woman\\to use FP} &  \shortstack{Afraid of\\being seen}  \\  & (1) & (2) & (3) & (4)  \\  \midrule") ///
postfoot("\bottomrule \\[-5ex] \end{tabular} \end{center} \begin{tablenotes} Each column represents a separate regression. All columns are fully-interacted regressions where all controls are interacted with the covariate used for estimating heterogeneous effects, with the main effect of that variable also included as a regressor. All specifications include balancing controls (i.e., the baseline levels of whether a woman was using FP, her years of education, whether she wanted another child, and her number of general peers), other baseline covariates (i.e., whether the woman worked, whether she had ever visited a FP clinic, the woman's mobility score, and whether she was using a modern FP method), whether the endline interview was conducted over the phone, and village fixed effects. MIL denotes mother-in-law, FP denotes family planning, and BAF denotes Bring-a-Friend. The number of observations is less than 621 a) in columns 1, 4, and 5 due to missing observations in the outcome variable and b) in columns 2 and 3 due to missing values in ``MIL opposed to FP''. Variable definitions are presented in the Online Appendix. Robust standard errors are presented in brackets. \sym{*}\(p<0.1\),\sym{**}\(p<0.05\),\sym{***}\(p<0.01\). \end{tablenotes} \end{table}") ///
sfmt(%9.2f) varwidth(25)  replace


************************************
**## Table 6x2: Social Connections: Het by MIL co-residence
************************************

eststo clear
est drop _all	

global outcomes outsider  ///
				atleast1_visithf_VoutHH peer_advise_FP_VoHH ///
				afraid_being_seen

foreach y of global outcomes{

eststo reg`y'2: reg `y' i.solo##i.base_livewMIL i.baf##i.base_livewMIL   ///
						c.base_school_yrs#i.base_livewMIL    	///
						c.base_num_friend#i.base_livewMIL    	///
						i.base_current_fp##i.base_livewMIL   	///
						i.base_wants_child##i.base_livewMIL  	///
						i.base_obc##i.base_livewMIL  			///
						c.base_mobi#i.base_livewMIL  			///
						i.base_work##i.base_livewMIL  			///
						i.base_ever_visit_fp##i.base_livewMIL  ///
						i.base_phone#i.base_livewMIL  			///
						i.base_mod_method#i.base_livewMIL 		///
						i.base_village_num#i.base_livewMIL ,  r
						
test _b[1.solo] = _b[1.baf]
estadd scalar pvalue1 = r(p)

test _b[1.solo#1.base_livewMIL ] = _b[1.baf#1.base_livewMIL ]
estadd scalar pvalue2 = r(p)

test _b[1.solo] + _b[1.solo#1.base_livewMIL ] = 0
estadd scalar pvalue3 = r(p)

test _b[1.baf] + _b[1.baf#1.base_livewMIL ] = 0
estadd scalar pvalue4 = r(p)

sum `y' if treatment == 0 
estadd scalar controlmean = r(mean)	

}


esttab _all ///
using "$repo/RESULTS/tables/table6x2.tex" , ///
keep(1.solo  1.solo#1.base_livewMIL  1.baf 1.baf#1.base_livewMIL   ) ///
order(1.solo  1.baf  1.solo#1.base_livewMIL 1.baf#1.base_livewMIL  ) ///
varlabels(1.solo "Own Voucher" 1.baf "BAF Voucher" 1.solo#1.base_livewMIL "Own Voucher $\times$ MIL Co-residence" 1.baf#1.base_livewMIL "BAF Voucher $\times$ MIL Co-residence") ///
mlabels(none) se(%9.3f) b(%9.3f)  brackets nonum  noobs nolines collabels(none)   nogaps starlevels( * 0.1 ** .05  *** .01)  ///
stats(N  controlmean pvalue1 pvalue2 pvalue3 pvalue4 , label("\midrule Observations" "Endline control mean" "\shortstack[l]{p-values:\\Own = BAF}"   "Own $\times$ MIL Co-residence = BAF $\times$ MIL Co-residence" "Own + Own $\times$ MIL Co-residence = 0"  "BAF + BAF $\times$ MIL Co-residence = 0"  ) fmt(%9.0f %9.3f %9.3f  %9.3f %9.3f %9.3f)) ///
prehead("\begin{table}[htpb]\begin{center}\caption{Heterogeneous effect on Social connections at endline by MIL Co-residence at baseline}\label{table:tab6-sn-itt-milcoreside}\begin{tabular}{lcccc} \toprule") ///
 posthead(" & & \multicolumn{2}{c}{\textbf{Peer engagement}} & \multicolumn{1}{c}{\textbf{Stigma}} \\ \cmidrule(lr){3-4}  & &  \multicolumn{2}{c}{Has close peers outside HH in village that: } & \\ \cmidrule(lr){3-4} \cmidrule(lr){5-5} &  \shortstack{Number of close peers\\outside HH in village} &   \shortstack{Accompanied to\\health facility}  &  \shortstack{Advised woman\\to use FP} &  \shortstack{Afraid of\\being seen}  \\  & (1) & (2) & (3) & (4)  \\  \midrule") ///
postfoot("\bottomrule \\[-5ex] \end{tabular} \end{center} \begin{tablenotes} Each column represents a separate regression. All columns are fully-interacted regressions where all controls are interacted with the covariate used for estimating heterogeneous effects, with the main effect of that variable also included as a regressor. All specifications include balancing controls (i.e., the baseline levels of whether a woman was using FP, her years of education, whether she wanted another child, and her number of general peers), other baseline covariates (i.e., whether the woman worked, whether she had ever visited a FP clinic, the woman's mobility score, and whether she was using a modern FP method), whether the endline interview was conducted over the phone, and village fixed effects. MIL denotes mother-in-law, FP denotes family planning, and BAF denotes Bring-a-Friend. The number of observations is less than 621 a) in columns 1, 4, and 5 due to missing observations in the outcome variable and b) in columns 2 and 3 due to missing values in ``MIL opposed to FP''. Variable definitions are presented in the Online Appendix. Robust standard errors are presented in brackets. \sym{*}\(p<0.1\),\sym{**}\(p<0.05\),\sym{***}\(p<0.01\). \end{tablenotes} \end{table}") ///
sfmt(%9.2f) varwidth(25)  replace


************************************
**## Table 1x: Balance Table
* By Treatment Assignment
************************************

* Create global for balance table 1:
global balance base_age base_school_yrs base_w_hindu base_scst base_obc 	///
			   base_ghunghat base_work base_livewMIL base_mobi 				///
			   base_asset_score base_num_friend base_outsider 			    ///
			   base_no_children base_wants_child base_current_fp 			///
			   base_mod_method base_ever_visit_fp base_costFP_MILopposed
 
eststo clear
est drop _all


* Mean . SD of each treatment arm:
eststo control:  estpost  summarize $balance  if treatment == 0
eststo own:  	 estpost  summarize $balance  if treatment == 1 
eststo baf:  	 estpost summarize  $balance  if treatment == 2 

* Pair-differences
eststo diffcontrolown:  estpost ttest $balance if treatment!=2, by(solo) unequal 

* Adding scalars of F-Test of join significance. 
reg solo $balance   if treatment!=2
estadd scalar F_Obs = `e(N)': diffcontrolown
testparm $balance
estadd scalar F_pvalue = r(p): diffcontrolown


eststo diffcontrolbaf:   estpost ttest $balance if treatment!=1, by(baf) unequal 
* Adding scalars of F-Test of join significance. 
reg baf $balance   if treatment!=1
estadd scalar F_Obs = `e(N)': diffcontrolbaf
testparm $balance
estadd scalar F_pvalue = r(p): diffcontrolbaf

eststo diffownbaf:   estpost ttest $balance if treatment!=0, by(baf) unequal 
* Adding scalars of F-Test of join significance. 
reg baf $balance  if treatment!=0
estadd scalar F_Obs = `e(N)': diffownbaf
testparm $balance
estadd scalar F_pvalue = r(p): diffownbaf

* Export Balance Table: 

esttab ///
control own baf  diffcontrolown diffcontrolbaf diffownbaf ///
using "$repo/RESULTS/tables/table1x.tex"  , ///
cells("count(pattern(1 1 1 0 0 0 ) fmt(0)) mean(pattern(1 1 1 0 0 0) fmt(3)) b(star pattern(0 0 0 1 1 1) fmt(3))" ". sd(pattern(1 1 1 0 0 0) par fmt(3))" ) ///
label  collabels(none) nonum plain nomtitle noobs not tex starlevels(* 0.1 ** .05  *** .01) ///
stats( F_pvalue F_Obs, label("\midrule F-test of joint significance: p-value" "F-test: Number of observations" ) fmt(%9.3f  %9.0f )) ///
prehead("\begin{table}[htpb]\begin{center} \caption{Balance at baseline: Individual characteristics }\label{table:tab1x-balancetable}\resizebox{1\linewidth}{!}{\begin{tabular}{lcccccccccccc} \toprule & \multicolumn{2}{c}{Control (C)}   & \multicolumn{2}{c}{Own}  &  \multicolumn{2}{c}{BAF}  & C - Own & C - BAF & Own - BAF & C - Own & C - BAF & Own - BAF \\ \cmidrule(lr){2-3} \cmidrule(lr){4-5} \cmidrule(lr){6-7} \cmidrule(lr){8-8} \cmidrule(lr){9-9} \cmidrule(lr){10-10} \cmidrule(lr){11-11} \cmidrule(lr){12-12} \cmidrule(lr){13-13}  & N & Mean/SD & N & Mean/SD & N & Mean/SD & Diff. & Diff. & Diff. & Norm. Diff. & Norm. Diff. Diff. & Norm. Diff. Diff. \\ & (1) & (2) & (3) & (4) & (5) & (6) & (7) & (8) & (9) & (10) & (11) & (12) \\ \midrule") ///
posthead("") ///
postfoot("\bottomrule  \\[-5ex] \end{tabular}} \end{center} \begin{tablenotes}  This table examines the baseline characteristics of our estimation sample (N = 621 women). Although we surveyed 625 women at endline, 4 women who had missing values at baseline for the variable ``wants another child'' are excluded from our estimation sample since we use this variable as a control in all our regressions. Standard deviations (SD) are presented in parentheses. BAF denotes Bring-a-Friend, FP denotes family planning, and MIL denotes mother-in-law. The variable ``MIL opposed to FP'' has 4 missing observations in our estimation sample. Variable definitions are presented in the Online Appendix. \sym{*}\(p<0.1\),\sym{**}\(p<0.05\),\sym{***}\(p<0.01\)  \end{tablenotes} \end{table}   ") replace




* Export Balance Table:  Part 2 - Normalized Differences

// Need to fix this (Added this column in latex table using R)

* Normalized Differences
qui stddiff $balance if treatment!=2, by(solo) coh
matrix ndif_cown = r(stddiff)
mat2txt, matrix(ndif_cown) saving("$repo/RESULTS/tables/table1_cown_ndiff.csv") replace


qui stddiff $balance if treatment!=1, by(baf) coh
matrix ndif_cbaf = r(stddiff)
mat2txt, matrix(ndif_cbaf) saving("$repo/RESULTS/tables/table1_ndif_cbaf_ndiff.csv") replace


qui stddiff $balance if treatment!=0, by(baf) coh
matrix ndif_ownbaf = r(stddiff)
mat2txt, matrix(ndif_ownbaf) saving("$repo/RESULTS/tables/table1_ndif_ownbaf_ndiff.csv") replace



**  Using Regression

eststo clear
est drop _all

eststo mod_1: qui reg solo $balance   if treatment!=2

test	base_age == base_school_yrs == base_w_hindu == base_scst == base_obc == ///
		base_ghunghat == base_work == base_livewMIL == base_mobi ==	 		 ///
		base_asset_score == base_num_friend == base_outsider ==  		     ///
		base_no_children == base_wants_child == base_current_fp ==   		 ///
		base_mod_method == base_ever_visit_fp == base_costFP_MILopposed
			
estadd scalar Obs = `e(N)'
estadd scalar F_pvalue = r(p)


eststo mod_2: qui reg baf $balance   if treatment!=1

test	base_age == base_school_yrs == base_w_hindu == base_scst == base_obc == ///
		base_ghunghat == base_work == base_livewMIL == base_mobi ==	 		 ///
		base_asset_score == base_num_friend == base_outsider ==  		     ///
		base_no_children == base_wants_child == base_current_fp ==   		 ///
		base_mod_method == base_ever_visit_fp == base_costFP_MILopposed
			
estadd scalar Obs = `e(N)'
estadd scalar F_pvalue = r(p)


eststo mod_3: qui reg baf $balance  if treatment!=0

test	base_age == base_school_yrs == base_w_hindu == base_scst == base_obc == ///
		base_ghunghat == base_work == base_livewMIL == base_mobi ==	 		 ///
		base_asset_score == base_num_friend == base_outsider ==  		     ///
		base_no_children == base_wants_child == base_current_fp ==   		 ///
		base_mod_method == base_ever_visit_fp == base_costFP_MILopposed
			
estadd scalar Obs = `e(N)'
estadd scalar F_pvalue = r(p)


esttab mod_* ///
using "$repo/RESULTS/tables/table1_ftest.tex"  , ///
keep($balance) ///
label mlabels(none) collabels(none)  cells(p(fmt(3))) ///
nonum  noobs nolines  nogaps starlevels( * 0.1 ** .05  *** .01) ///
stats(F_pvalue Obs , label("\midrule F-test of joint significance: p-value" "F-test: Number of observations") fmt(%9.3f  %9.0f )) ///
prehead("\begin{tabular}{lccc} \toprule") ///
posthead(" & (10) & (11) & (12)  \\ \midrule") ///
postfoot("\bottomrule \\[-1ex] \end{tabular}") ///
sfmt(%9.2f) varwidth(25)  replace

************************************
**## Table A.18: Balance Table By Phone Survey
* 
************************************

eststo clear
est drop _all

***GENERATE TREATMENT ARM DUMMIES

capture{
tab treatment, gen(treatment_)
}
la var treatment_1 "Control Arm"
la var treatment_2 "Own Voucher"
la var treatment_3 "BAF Voucher"

* Mean . SD of each group:
eststo person:  estpost  summarize $balance treatment_2 treatment_3 if base_phone==0
eststo phone:  	estpost  summarize $balance treatment_2 treatment_3 if base_phone==1 
* Pair-differences
eststo diff:  estpost ttest $balance treatment_2 treatment_3, by(base_phone) unequal 
* Adding scalars of F-Test of join significance. 
reg base_phone  $balance treatment_2 treatment_3
estadd scalar F_Obs = `e(N)': diff
testparm $balance i.treatment
estadd scalar F_pvalue = r(p): diff

* Export Balance Table: 
esttab ///
person phone diff ///
using "$repo/RESULTS/tables/appendix_table18.tex"  , ///
cells("count(pattern(1 1 0 ) fmt(0)) mean(pattern(1 1 0) fmt(3)) b(star pattern(0 0 1 ) fmt(3))" ". sd(pattern(1 1 0 ) par fmt(3))" ) ///
label  collabels(none) nonum plain nomtitle noobs not tex starlevels(* 0.1 ** .05  *** .01) ///
stats(F_pvalue F_Obs, label("\midrule F-test of joint significance: p-value" "F-test: number of observations" ) fmt( %9.3f  %9.0f )) ///
prehead("\begin{table}[htpb]\begin{center} \caption{Balance at baseline, by phone survey} \label{table:app-tab18-balancephone}\resizebox{0.85\linewidth}{!}{\begin{tabular}{lcccccc} \toprule & \multicolumn{2}{c}{In-person} & \multicolumn{2}{c}{Phone} &  \multicolumn{2}{c}{In-person -- Phone}       \\ \cmidrule(lr){2-3} \cmidrule(lr){4-5} \cmidrule(lr){6-7}	& N & Mean/SD & N   & Mean/SD          & Diff. & Norm. Diff. \\	& (1)   & (2)  & (3)  & (4)  & (5) & (6)        \\\midrule") ///
posthead("") ///
postfoot("\bottomrule  \\[-5ex] \end{tabular}} \end{center} \begin{tablenotes} Sample characteristics at baseline are compared between those 528 women who were successfully contacted at endline and completed an in-person survey and those 93 women who were successfully contacted at endline and completed a phone survey. Standard deviations (SD) are presented in parentheses. BAF denotes Bring-a-Friend, FP denotes family planning, and MIL denotes mother-in-law. \sym{*}\(p<0.1\),\sym{**}\(p<0.05\),\sym{***}\(p<0.01\) \end{tablenotes} \end{table}  ") replace


* Export Balance Table:  Part 2 - Normalized Differences

// Need to fix this (Added this column in latex table using R)

* Normalized Differences
qui stddiff $balance treatment_2 treatment_3, by(base_phone) coh
matrix ndif = r(stddiff)
mat2txt, matrix(ndif) saving("$repo/RESULTS/tables/appendix_table18_ndiff.csv") replace



**  Joint sign. using Regression

eststo clear
est drop _all

eststo mod_1: qui reg base_phone  $balance treatment_2 treatment_3

test	base_age == base_school_yrs == base_w_hindu == base_scst == base_obc == ///
		base_ghunghat == base_work == base_livewMIL == base_mobi ==	 		 ///
		base_asset_score == base_num_friend == base_outsider ==  		     ///
		base_no_children == base_wants_child == base_current_fp ==   		 ///
		base_mod_method == base_ever_visit_fp == base_costFP_MILopposed == ///
		treatment_2 == treatment_3
			
estadd scalar Obs = `e(N)'
estadd scalar F_pvalue = r(p)


esttab mod_* ///
using "$repo/RESULTS/tables/appendix_table18_ftest.tex"  , ///
keep($balance) ///
label mlabels(none) collabels(none)  cells(p(fmt(3))) ///
nonum  noobs nolines  nogaps starlevels( * 0.1 ** .05  *** .01) ///
stats(F_pvalue Obs , label("\midrule F-test of joint significance: p-value" "F-test: Number of observations") fmt(%9.3f  %9.0f )) ///
prehead("\begin{tabular}{lc} \toprule") ///
posthead(" & (6)  \\ \midrule") ///
postfoot("\bottomrule \\[-1ex] \end{tabular}") ///
sfmt(%9.2f) varwidth(25)  replace


************************************
**## Table A.2x: Balance Table By Attritors
************************************
preserve

* Baseline Data 
* Need baseline data for this table only (to have attrition_w2 == 1)

use "$repo/data/data_baseline.dta", clear
drop if base_wants_child == .

***GENERATE TREATMENT ARM DUMMIES

capture{
tab treatment, gen(treatment_)
}
la var treatment_1 "Control Arm"
la var treatment_2 "Own Voucher"
la var treatment_3 "BAF Voucher"

eststo clear
est drop _all

* Mean . SD of each group:
eststo nonatt:  estpost  summarize  $balance treatment_2 treatment_3  if attrition_w2 == 0
eststo att:  	estpost  summarize  $balance treatment_2 treatment_3  if attrition_w2 == 1 
* Pair-differences
eststo diff:  estpost ttest  $balance treatment_2 treatment_3 , by(attrition_w2) unequal 
* Adding scalars of F-Test of join significance. 
reg attrition_w2  $balance treatment_2 treatment_3
estadd scalar F_Obs = `e(N)': diff
testparm   $balance
estadd scalar F_pvalue = r(p): diff

* Export Balance Table: 
esttab ///
nonatt att diff ///
using "$repo/RESULTS/tables/appendix_table2x.tex"  , ///
cells("count(pattern(1 1 0 ) fmt(0)) mean(pattern(1 1 0) fmt(3)) b(star pattern(0 0 1 ) fmt(3))" ". sd(pattern(1 1 0 ) par fmt(3))" ) ///
label  collabels(none) nonum plain nomtitle noobs not tex starlevels(* 0.1 ** .05  *** .01) ///
stats(F_pvalue F_Obs, label("\midrule F-test of joint significance: p-value" "F-test: number of observations" ) fmt( %9.3f  %9.0f )) ///
prehead("\begin{table}[htpb]\begin{center} \caption{Balance at baseline, by attrition status at endline} \label{table:app-tab2x-balanceattritor}\resizebox{0.85\linewidth}{!}{\begin{tabular}{lcccccc} \toprule & \multicolumn{2}{c}{Non-attritor} & \multicolumn{2}{c}{Attritor} & \multicolumn{2}{c}{Non-attritor -- Attritor}  \\ \cmidrule(lr){2-3} \cmidrule(lr){4-5} \cmidrule(lr){6-7}	& N & Mean/SD & N & Mean/SD & Diff. & Norm. Diff. \\	& (1)   & (2)  & (3)  & (4)  & (5) & (6) \\ \midrule ") ///
posthead("") ///
postfoot("\bottomrule  \\[-5ex] \end{tabular}} \end{center} \begin{tablenotes} Sample characteristics at baseline are compared between those 621 women who were successfully contacted at endline and those 46 women who were lost to follow-up. Standard deviations (SD) are presented in parentheses. BAF denotes Bring-a-Friend, FP denotes family planning, and MIL denotes mother-in-law. \sym{*}\(p<0.1\),\sym{**}\(p<0.05\),\sym{***}\(p<0.01\) \end{tablenotes} \end{table}") replace


* Export Balance Table:  Part 2 - Normalized Differences

// Need to fix this (Added this column in latex table using R)

* Normalized Differences
qui stddiff $balance treatment_2 treatment_3 , by(attrition_w2) coh
matrix ndif = r(stddiff)
mat2txt, matrix(ndif) saving("$repo/RESULTS/tables/appendix_table2x_ndiff.csv") replace



**  Joint sign. using Regression

eststo clear
est drop _all

eststo mod_1: qui reg attrition_w2  $balance treatment_2 treatment_3

test	base_age == base_school_yrs == base_w_hindu == base_scst == base_obc == ///
		base_ghunghat == base_work == base_livewMIL == base_mobi ==	 		 ///
		base_asset_score == base_num_friend == base_outsider ==  		     ///
		base_no_children == base_wants_child == base_current_fp ==   		 ///
		base_mod_method == base_ever_visit_fp == base_costFP_MILopposed == ///
		treatment_2 == treatment_3
			
estadd scalar Obs = `e(N)'
estadd scalar F_pvalue = r(p)


esttab mod_* ///
using "$repo/RESULTS/tables/appendix_table2x_ftest.tex"  , ///
keep($balance) ///
label mlabels(none) collabels(none)  cells(p(fmt(3))) ///
nonum  noobs nolines  nogaps starlevels( * 0.1 ** .05  *** .01) ///
stats(F_pvalue Obs , label("\midrule F-test of joint significance: p-value" "F-test: Number of observations") fmt(%9.3f  %9.0f )) ///
prehead("\begin{tabular}{lc} \toprule") ///
posthead(" & (6)  \\ \midrule") ///
postfoot("\bottomrule \\[-1ex] \end{tabular}") ///
sfmt(%9.2f) varwidth(25)  replace


restore




************************************
**## Table A.19: Baseline Attritors WRT outcomes and treatments
************************************






preserve

* Baseline Data 
* Need baseline data for this table only (to have attrition_w2 == 1)

use "$repo/data/data_baseline.dta", clear
drop if base_wants_child == .

// to fit in 32 chars
rename base_atleast1_visithf_VoutHH b_1_visithf_VoutHH
rename base_peer_advise_FP_VoHH b_peer_adv_FP_VoHH



global covariate base_ever_visit_fp base_current_fp base_mod_method /// 
				 b_1_visithf_VoutHH b_peer_adv_FP_VoHH  //base_outsider


eststo clear
est drop _all

foreach y of global covariate{

eststo reg`y'0: reg attrition_w2 i.solo##i.`y' ///
					i.baf##i.`y' ///
					if base_phone == 0, r
					
eststo reg`y'1: reg attrition_w2 i.solo##i.`y' ///
					i.baf##i.`y', r
}

eststo regbase_outsider0: reg attrition_w2 	i.solo##c.base_outsider ///
					i.baf##c.base_outsider ///
					if base_phone == 0, r
					
eststo regbase_outsider1: reg attrition_w2 	i.solo##c.base_outsider ///
					i.baf##c.base_outsider, r

					
esttab 	regbase_ever_visit_fp0 regbase_current_fp0 ///
		regbase_mod_method0 regbase_outsider0 ///
		regb_1_visithf_VoutHH0 regb_peer_adv_FP_VoHH0 /// 
using "$repo/RESULTS/tables/table19a.tex" , ///
rename(	1.base_current_fp 	1.base_ever_visit_fp ///
		1.base_mod_method 	1.base_ever_visit_fp ///
		base_outsider 		1.base_ever_visit_fp ///
		1.b_1_visithf_VoutHH 		1.base_ever_visit_fp ///
		1.b_peer_adv_FP_VoHH 			1.base_ever_visit_fp ///
		1.solo#1.base_current_fp 1.solo#1.base_ever_visit_fp ///
		1.solo#1.base_mod_method 1.solo#1.base_ever_visit_fp ///
		1.solo#c.base_outsider 	 1.solo#1.base_ever_visit_fp ///
		1.solo#1.b_1_visithf_VoutHH 	 1.solo#1.base_ever_visit_fp ///
		1.solo#1.b_peer_adv_FP_VoHH 	 1.solo#1.base_ever_visit_fp ///
		1.baf#1.base_current_fp  1.baf#1.base_ever_visit_fp ///
		1.baf#1.base_mod_method  1.baf#1.base_ever_visit_fp ///
		1.baf#c.base_outsider 	 1.baf#1.base_ever_visit_fp ///
		1.baf#1.b_1_visithf_VoutHH 	 1.baf#1.base_ever_visit_fp ///
		1.baf#1.b_peer_adv_FP_VoHH 	 	1.baf#1.base_ever_visit_fp ///
		) ///
keep(1.solo 1.baf 1.base_ever_visit_fp 1.solo#1.base_ever_visit_fp   1.baf#1.base_ever_visit_fp  ) ///
order(1.solo 1.baf 1.base_ever_visit_fp 1.solo#1.base_ever_visit_fp   1.baf#1.base_ever_visit_fp ) ///
varlabels(1.solo "Own Voucher" 1.baf "BAF Voucher" 1.base_ever_visit_fp "Covariate" 1.solo#1.base_ever_visit_fp "Own Voucher $\times$ Covariate" 1.baf#1.base_ever_visit_fp "BAF Voucher $\times$ Covariate" ) ///
mlabels(none) se(%9.3f) b(%9.3f)  brackets nonum  noobs nolines collabels(none)   nogaps starlevels( * 0.1 ** .05  *** .01)  ///
stats(N , label("\midrule Observations" ) fmt(%9.0f)) ///
prehead("\begin{table}[htpb]\begin{center}\caption{Attrition WRT outcomes and treatments (in-person survey)}\label{table:tab19a-balanceattritor-itt}\begin{tabular}{lcccccc} \toprule") ///
posthead(" & \multicolumn{6}{c}{\textbf{Covariates}} \\ \cmidrule(lr){2-7} & & & & & \multicolumn{2}{c}{\textbf{Peer engagement}} \\ \cmidrule(lr){6-7}  & \shortstack{Ever visited a\\clinic for FP} & \shortstack{Currently\\using FP} & \shortstack{Using modern\\FP method} &  \shortstack{Close peer\\outside village} &   \shortstack{Accompanied to\\health facility}  &  \shortstack{Advised woman\\to use FP} \\  & (1) & (2) & (3) & (4) & (5) & (6) \\ \midrule") ///
postfoot("\bottomrule \\[-5ex] \end{tabular} \end{center} \begin{tablenotes} Each column represents a separate regression, and are fully-interacted regressions where all controls are interacted with the covariate used for estimating heterogeneous effects, with the main effect of that variable also included as a regressor. All specifications include balancing controls (i.e., the baseline levels of whether a woman was using FP, her years of education, whether she wanted another child, and her number of general peers), other baseline covariates (i.e., whether the woman worked, whether she had ever visited a FP clinic, the woman's mobility score, and whether she was using a modern FP method), whether the endline interview was conducted over the phone, and village fixed effects. MIL denotes mother-in-law, FP denotes family planning, and BAF denotes Bring-a-Friend. The sample size represents the baseline observations that are collected in-person at endline. It also includes the baseline observations that are attrited at endline. The sample size in Columns (2) and (3) lower because the outcomes are conditional on having a peer outside the household in the village Variable definitions are presented in the Online Appendix. Robust standard errors are presented in brackets. \sym{*}\(p<0.1\),\sym{**}\(p<0.05\),\sym{***}\(p<0.01\). \end{tablenotes} \end{table}") ///
sfmt(%9.2f) varwidth(25)  replace



					
esttab 	regbase_ever_visit_fp1 regbase_current_fp1 ///
		regbase_mod_method1 regbase_outsider0 ///
using "$repo/RESULTS/tables/table19b.tex" , ///
rename(	1.base_current_fp 	1.base_ever_visit_fp ///
		1.base_mod_method 	1.base_ever_visit_fp ///
		base_outsider 		1.base_ever_visit_fp ///
		1.solo#1.base_current_fp 1.solo#1.base_ever_visit_fp ///
		1.solo#1.base_mod_method 1.solo#1.base_ever_visit_fp ///
		1.solo#c.base_outsider 	 1.solo#1.base_ever_visit_fp ///
		1.baf#1.base_current_fp  1.baf#1.base_ever_visit_fp ///
		1.baf#1.base_mod_method  1.baf#1.base_ever_visit_fp ///
		1.baf#c.base_outsider 	 1.baf#1.base_ever_visit_fp ///
		) ///
keep(1.solo 1.baf 1.base_ever_visit_fp 1.solo#1.base_ever_visit_fp   1.baf#1.base_ever_visit_fp  ) ///
order(1.solo 1.baf 1.base_ever_visit_fp 1.solo#1.base_ever_visit_fp   1.baf#1.base_ever_visit_fp ) ///
varlabels(1.solo "Own Voucher" 1.baf "BAF Voucher" 1.base_ever_visit_fp "Covariate" 1.solo#1.base_ever_visit_fp "Own Voucher $\times$ Covariate" 1.baf#1.base_ever_visit_fp "BAF Voucher $\times$ Covariate" ) ///
mlabels(none) se(%9.3f) b(%9.3f)  brackets nonum  noobs nolines collabels(none)   nogaps starlevels( * 0.1 ** .05  *** .01)  ///
stats(N , label("\midrule Observations" ) fmt(%9.0f)) ///
prehead("\begin{table}[htpb]\begin{center}\caption{Attrition WRT outcomes and treatments (in-person and phone survey)}\label{table:tab19b-balanceattritor-itt}\begin{tabular}{lcccc} \toprule") ///
posthead(" & \multicolumn{4}{c}{\textbf{Covariates}} \\ \cmidrule(lr){2-5} & \shortstack{Ever visited a\\clinic for FP} & \shortstack{Currently\\using FP} & \shortstack{Using modern\\FP method} &  \shortstack{Close peer\\outside village}  \\  & (1) & (2) & (3) & (4) \\ \midrule") ///
postfoot("\bottomrule \\[-5ex] \end{tabular} \end{center} \begin{tablenotes} Each column represents a separate regression, and are fully-interacted regressions where all controls are interacted with the covariate used for estimating heterogeneous effects, with the main effect of that variable also included as a regressor. All specifications include balancing controls (i.e., the baseline levels of whether a woman was using FP, her years of education, whether she wanted another child, and her number of general peers), other baseline covariates (i.e., whether the woman worked, whether she had ever visited a FP clinic, the woman's mobility score, and whether she was using a modern FP method), whether the endline interview was conducted over the phone, and village fixed effects. MIL denotes mother-in-law, FP denotes family planning, and BAF denotes Bring-a-Friend. The sample size represents the baseline observations that are collected both in-person and over phone at endline. It also includes the baseline observations that are attrited at endline. The sample size in Columns (2) and (3) lower because the outcomes are conditional on having a peer outside the household in the village. Variable definitions are presented in the Online Appendix. Robust standard errors are presented in brackets. \sym{*}\(p<0.1\),\sym{**}\(p<0.05\),\sym{***}\(p<0.01\). \end{tablenotes} \end{table}") ///
sfmt(%9.2f) varwidth(25)  replace


restore		

/*
**## Crosstab of MIL's FP opposition and Co-residence	

tab base_livewMIL base_costFP_MILopposed, matcell(freq) matrow(names)

estout matrix(freq) using "$repo/RESULTS/tables/table20_freq.tex", replace ///
    style(tex) ///
    cells(freq) ///
    collabels(none) ///
    eqlabels(none) ///
    prehead("\begin{table}[h]\centering \caption{Cross-tab of MIL's FP opposition and Co-residence}\begin{tabular}{lccccc} \toprule") ///
	posthead(" & \multicolumn{2}{c}{\textbf{Covariates}} \\ \cmidrule(lr){2-3}  & 1 & 0 \\ \midrule") ///
    postfoot("\end{tabular}\end{table}")		
*/


************************************
**## Table A.21: FP knowledge and opinion
************************************


use "$repo/data/data_endline.dta", clear
drop if base_wants_child == . // Drop 4 obsrvations having missing values for this covariate


eststo clear
est drop _all

global outcomes heard_FP heard_mod_method heard_mod_method_org ///
				opinion_useFP opinion_FPeffect opinion_costFP opinion_benefitFP 

 
foreach y of global outcomes{
eststo r`y'0: reg `y' solo baf $covbal $cov i.base_village_num  , r
test _b[solo]=_b[baf]
	estadd scalar pvalue = r(p)
	sum `y' if treatment == 0 
	estadd scalar controlmean = r(mean)		
}

esttab  rheard_FP0   rheard_mod_method0 rheard_mod_method_org0  ropinion_useFP0 ropinion_FPeffect0 ///
		ropinion_costFP0 ropinion_benefitFP0 ///
using "$repo/RESULTS/tables/table21.tex" , ///
keep(solo baf) ///
label mlabels(none) collabels(none)  se(%9.3f) b(%9.3f)  ///
brackets nonum  noobs nolines  nogaps starlevels( * 0.1 ** .05  *** .01) ///
stats(N  controlmean pvalue , label("\midrule Observations" "Endline control mean" "p-value: Own = BAF" ) fmt(%9.0f %9.3f %9.3f)) ///
prehead("\begin{table}[htpb]\begin{center}\caption{FP knowledge and opinion about usage}\label{table:tab21-opinion-itt}\begin{tabular}{lccccccc} \toprule") ///
posthead(" & \multicolumn{3}{c}{\textbf{Number of}} & \multicolumn{4}{c}{\textbf{Opinion on FP usage}}  \\ \cmidrule(lr){2-4} \cmidrule(lr){5-8} & \shortstack{sources\\heard FP} & \shortstack{modern FP\\method(s)\\heard} & \shortstack{modern FP\\method(s)\\heard (org)} & \shortstack{Most women use\\FP in village} & \shortstack{Most women faced\\side effect of FP} & \shortstack{Number of costs/\\ disadvantage of FP} & \shortstack{Number of benefits\\ of FP} \\  & (1) & (2) & (3) & (4) & (5) & (6) & (7) \\ \midrule") ///
postfoot("\bottomrule \\[-5ex] \end{tabular} \end{center} \begin{tablenotes} All specifications include balancing controls (i.e., the baseline levels of whether a woman was using FP, her years of education, whether she wanted another child, and her number of general peers), other baseline covariates (i.e., whether the woman worked, whether she had ever visited a FP clinic, the woman's mobility score, and whether she was using a modern family planning method), whether the endline interview was conducted over the phone, and village fixed effects. MIL denotes mother-in-law and BAF denotes Bring-a-Friend. Variable definitions are presented in the Online Appendix. Robust standard errors are presented in brackets. \sym{*}\(p<0.1\),\sym{**}\(p<0.05\),\sym{***}\(p<0.01\). \end{tablenotes} \end{table}") ///
 sfmt(%9.2f) varwidth(25)  replace
 
 
************************************
**## Table A.22: FP attidudes
************************************


use "$repo/data/data_endline.dta", clear
drop if base_wants_child == . // Drop 4 obsrvations having missing values for this covariate


eststo clear
est drop _all



global outcomes duration_useFP duration_useModFP ///
				wants_child afraid_seen_FPclinic worried_seen_FPservice ///
				useFP_unfaithful embarrased_talkFP


foreach y of global outcomes{
eststo r`y'0: reg `y' solo baf $covbal $cov i.base_village_num  , r
test _b[solo]=_b[baf]
	estadd scalar pvalue = r(p)
	sum `y' if treatment == 0 
	estadd scalar controlmean = r(mean)		
}

esttab  rduration_useFP0 rduration_useModFP0 rwants_child0  ///
		rafraid_seen_FPclinic0  rworried_seen_FPservice0 ///
		ruseFP_unfaithful0 rembarrased_talkFP0 ///
using "$repo/RESULTS/tables/table22.tex" , ///
keep(solo baf) ///
label mlabels(none) collabels(none)  se(%9.3f) b(%9.3f)  ///
brackets nonum  noobs nolines  nogaps starlevels( * 0.1 ** .05  *** .01) ///
stats(N  controlmean pvalue , label("\midrule Observations" "Endline control mean" "p-value: Own = BAF" ) fmt(%9.0f %9.3f %9.3f)) ///
prehead("\begin{table}[htpb]\begin{center}\caption{FP knowledge and opinion about usage}\label{table:tab22-attidude-itt}\resizebox{\linewidth}{!}{\begin{tabular}{lccccccc} \toprule") ///
posthead(" & \multicolumn{2}{c}{\textbf{Duration (months)}} &  & \multicolumn{4}{c}{\textbf{Attitude towards FP}}  \\ \cmidrule(lr){2-3} \cmidrule(lr){5-8} & \shortstack{using FP\\non-stop} & \shortstack{using Mod. \\ FP non-stop} & \shortstack{Wants another\\child} & \shortstack{Afraid of being \\seen at FP clinic} & \shortstack{Worried about people if \\seen talking FP services} & \shortstack{FP usage makes\\unfaithful} & \shortstack{Embressing talking \\to provider about FP} \\  & (1) & (2) & (3) & (4) & (5) & (6) & (7) \\ \midrule") ///
postfoot("\bottomrule \\[-5ex] \end{tabular}} \end{center} \begin{tablenotes} All specifications include balancing controls (i.e., the baseline levels of whether a woman was using FP, her years of education, whether she wanted another child, and her number of general peers), other baseline covariates (i.e., whether the woman worked, whether she had ever visited a FP clinic, the woman's mobility score, and whether she was using a modern family planning method), whether the endline interview was conducted over the phone, and village fixed effects. MIL denotes mother-in-law and BAF denotes Bring-a-Friend. Variable definitions are presented in the Online Appendix. Robust standard errors are presented in brackets. \sym{*}\(p<0.1\),\sym{**}\(p<0.05\),\sym{***}\(p<0.01\). \end{tablenotes} \end{table}") ///
 sfmt(%9.2f) varwidth(25)  replace
 
 
 
************************************
**## Table A.22New: FP attidudes (Replace non-user to 0)
************************************


use "$repo/data/data_endline.dta", clear
drop if base_wants_child == . // Drop 4 obsrvations having missing values for this covariate


eststo clear
est drop _all



global outcomes duration_useFP duration_useModFP ///
				duration_useFP_all duration_useModFP_all


foreach y of global outcomes{
eststo r`y'0: reg `y' solo baf $covbal $cov i.base_village_num  , r
test _b[solo]=_b[baf]
	estadd scalar pvalue = r(p)
	sum `y' if treatment == 0 
	estadd scalar controlmean = r(mean)		
}

esttab  rduration_useFP0 rduration_useModFP0 ///
		rduration_useFP_all0 rduration_useModFP_all0 ///
using "$repo/RESULTS/tables/table22_new.tex" , ///
keep(solo baf) ///
label mlabels(none) collabels(none)  se(%9.3f) b(%9.3f)  ///
brackets nonum  noobs nolines  nogaps starlevels( * 0.1 ** .05  *** .01) ///
stats(N  controlmean pvalue , label("\midrule Observations" "Endline control mean" "p-value: Own = BAF" ) fmt(%9.0f %9.3f %9.3f)) ///
prehead("\begin{table}[htpb]\begin{center}\caption{Duration of non-stop FP usage}\label{table:tab22-new-duration}\begin{tabular}{lcccc} \toprule") ///
posthead(" & \multicolumn{4}{c}{\textbf{Duration (months)}} \\ \cmidrule(lr){2-5} & \shortstack{using FP\\non-stop} & \shortstack{using Mod. \\ FP non-stop} & \shortstack{using FP\\non-stop\\(all)} & \shortstack{using Mod. \\ FP non-stop\\(all)} \\  & (1) & (2) & (3) & (4) \\ \midrule") ///
postfoot("\bottomrule \\[-5ex] \end{tabular} \end{center} \begin{tablenotes} All specifications include balancing controls (i.e., the baseline levels of whether a woman was using FP, her years of education, whether she wanted another child, and her number of general peers), other baseline covariates (i.e., whether the woman worked, whether she had ever visited a FP clinic, the woman's mobility score, and whether she was using a modern family planning method), whether the endline interview was conducted over the phone, and village fixed effects. MIL denotes mother-in-law and BAF denotes Bring-a-Friend. Variable definitions are presented in the Online Appendix. Robust standard errors are presented in brackets. \sym{*}\(p<0.1\),\sym{**}\(p<0.05\),\sym{***}\(p<0.01\). \end{tablenotes} \end{table}") ///
 sfmt(%9.2f) varwidth(25)  replace
 
 
************************************
**## Table A.23: FP knowledge and opinion (Adding baseline as covariate)
************************************


use "$repo/data/data_endline.dta", clear
drop if base_wants_child == . // Drop 4 obsrvations having missing values for this covariate


eststo clear
est drop _all

global outcomes heard_FP heard_mod_method duration_useFP wants_child ///
				opinion_useFP opinion_costFP opinion_benefitFP 

 
foreach y of global outcomes{
eststo r`y'0: reg `y' solo baf $covbal $cov base_`y' i.base_village_num  , r
test _b[solo]=_b[baf]
	estadd scalar pvalue = r(p)
	sum `y' if treatment == 0 
	estadd scalar controlmean = r(mean)		
}

esttab  rheard_FP0   rheard_mod_method0  rduration_useFP0 rwants_child0 ///
		ropinion_useFP0 ropinion_costFP0 ropinion_benefitFP0 ///
using "$repo/RESULTS/tables/table23.tex" , ///
keep(solo baf) ///
label mlabels(none) collabels(none)  se(%9.3f) b(%9.3f)  ///
brackets nonum  noobs nolines  nogaps starlevels( * 0.1 ** .05  *** .01) ///
stats(N  controlmean pvalue , label(" Baseline & x & x & x & x & x & x & x \\ \midrule Observations" "Endline control mean" "p-value: Own = BAF" ) fmt(%9.0f %9.3f %9.3f)) ///
prehead("\begin{table}[htpb]\begin{center}\caption{FP knowledge and opinion about usage}\label{table:tab23-opinion-baseline-itt}\begin{tabular}{lccccccc} \toprule") ///
posthead(" & \multicolumn{2}{c}{\textbf{Number of}} & \textbf{Duration (months)} & & \multicolumn{3}{c}{\textbf{Opinion on FP usage}}  \\ \cmidrule(lr){2-3} \cmidrule(lr){4-4} \cmidrule(lr){6-8} & \shortstack{sources\\heard FP} & \shortstack{modern FP\\method(s) heard} & using FP non-stop & \shortstack{Wants another\\child} & \shortstack{Most women\\ use FP\\in village} & \shortstack{Number of\\costs/ disadvantage\\of using FP} & \shortstack{Number of\\benefits of\\using FP} \\  & (1) & (2) & (3) & (4) & (5) & (6) & (7) \\ \midrule") ///
postfoot("\bottomrule \\[-5ex] \end{tabular} \end{center} \begin{tablenotes} All specifications include balancing controls (i.e., the baseline levels of whether a woman was using FP, her years of education, whether she wanted another child, and her number of general peers), other baseline covariates (i.e., whether the woman worked, whether she had ever visited a FP clinic, the woman's mobility score, and whether she was using a modern family planning method), whether the endline interview was conducted over the phone, and village fixed effects. MIL denotes mother-in-law and BAF denotes Bring-a-Friend. Variable definitions are presented in the Online Appendix. Robust standard errors are presented in brackets. \sym{*}\(p<0.1\),\sym{**}\(p<0.05\),\sym{***}\(p<0.01\). \end{tablenotes} \end{table}") ///
 sfmt(%9.2f) varwidth(25)  replace

 
************************************
**## Table 24: Summary stat of the newly created variables
************************************


use "$repo/data/data_endline.dta", clear

global vars_end heard_FP heard_mod_method ///
				opinion_useFP opinion_FPeffect opinion_costFP opinion_benefitFP ///
				duration_useFP wants_child afraid_seen_FPclinic worried_seen_FPservice ///
				useFP_unfaithful embarrased_talkFP
				
global vars_bas base_heard_FP base_heard_mod_method ///
				base_opinion_useFP base_opinion_costFP ///
				base_opinion_benefitFP base_duration_useFP ///
				base_wants_child
 
eststo clear
est drop _all

la var worried_seen_FPservice "Worried about people if they found \\ out willingness of family planning servic"

estpost summ $vars_end
	esttab using "$repo/RESULTS/tables/table24.tex" , ///
	cells("count(fmt(0)) mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0))") ///
	nomtitle noobs nonumber label collabels(none)  varwidth(25) ///
	prehead("\begin{table}[htpb]\begin{center} \caption{Balance at baseline, by phone survey} \label{table:app-tab3-balancephone}\resizebox{0.85\linewidth}{!}{\begin{tabular}{lccccc}\toprule & N & Mean & SD & Min & Max \\ & (1) & (2) & (3) & (4) & (5) \\  ") ///
	posthead("\midrule \multicolumn{6}{l}{\textit{Panel A: Endline variables}}\\ \midrule") ///
	postfoot("") nogaps replace
	
estpost summ $vars_bas 
	esttab using "$repo/RESULTS/tables/table24.tex" , ///
	cells("count(fmt(0)) mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0))") ///
	nomtitle noobs nonumber label    mlabels(none) collabels(none) varwidth(25) ///
	prehead("\midrule") ///
	posthead(" \multicolumn{6}{l}{\textit{Panel B: Baseline variables}}\\  \midrule") nogaps ///
	postfoot("\bottomrule  \\[-5ex] \end{tabular}} \end{center} \begin{tablenotes} Sample characteristics at baseline are compared between those 528 women who were successfully contacted at endline and completed an in-person survey and those 93 women who were successfully contacted at endline and completed a phone survey. Standard deviations (SD) are presented in parentheses. BAF denotes Bring-a-Friend, FP denotes family planning, and MIL denotes mother-in-law. \sym{*}\(p<0.1\),\sym{**}\(p<0.05\),\sym{***}\(p<0.01\) \end{tablenotes} \end{table}  ") append
	
	
************************************
* Table 4xx: het. effects by with in-person sample
* MIL opposition
************************************

use "$repo/data/data_endline.dta", clear
drop if base_wants_child == . // Drop 4 obsrvations having missing values for this covariate


eststo clear
est drop _all

global outcomes ask_peer_adc asked_hmil asked_other visit_adc_fp_corr ///
				visit_adc_w_hhmil visit_adc_w_nohmil   visit_any_fp_new_corr

foreach y of global outcomes{
eststo reg`y': reg `y' i.solo##i.base_costFP_MILopposed   i.baf##i.base_costFP_MILopposed   ///
						c.base_school_yrs#i.base_costFP_MILopposed    ///
						c.base_num_friend#i.base_costFP_MILopposed    ///
						i.base_current_fp##i.base_costFP_MILopposed  ///
						i.base_wants_child##i.base_costFP_MILopposed  ///
						i.base_obc##i.base_costFP_MILopposed  ///
						c.base_mobi#i.base_costFP_MILopposed  ///
						i.base_work##i.base_costFP_MILopposed  ///
						i.base_ever_visit_fp##i.base_costFP_MILopposed   ///
						i.base_phone#i.base_costFP_MILopposed  ///
						i.base_mod_method#i.base_costFP_MILopposed ///
						i.base_village_num#i.base_costFP_MILopposed ///
						if phone != 1,  r
						
test _b[1.solo] = _b[1.baf]
estadd scalar pvalue1 = r(p)

test _b[1.solo#1.base_costFP_MILopposed ] = _b[1.baf#1.base_costFP_MILopposed ]
estadd scalar pvalue2 = r(p)

test _b[1.solo] + _b[1.solo#1.base_costFP_MILopposed ] = 0
estadd scalar pvalue3 = r(p)

test _b[1.baf] + _b[1.baf#1.base_costFP_MILopposed ] = 0
estadd scalar pvalue4 = r(p)

sum `y' if treatment == 0 & phone != 1
estadd scalar controlmean = r(mean)	
}


esttab _all ///
using "$repo/RESULTS/tables/table4xx.tex" , ///
keep(1.solo  1.solo#1.base_costFP_MILopposed  1.baf 1.baf#1.base_costFP_MILopposed   ) ///
order(1.solo  1.baf  1.solo#1.base_costFP_MILopposed 1.baf#1.base_costFP_MILopposed  ) ///
varlabels(1.solo "Own Voucher" 1.baf "BAF Voucher" 1.solo#1.base_costFP_MILopposed "Own Voucher $\times$ MIL opposed to FP" 1.baf#1.base_costFP_MILopposed "BAF Voucher $\times$ MIL opposed to FP") ///
mlabels(none) se(%9.3f) b(%9.3f)  brackets nonum  noobs nolines collabels(none)   nogaps starlevels( * 0.1 ** .05  *** .01)  ///
stats(N  controlmean pvalue1 pvalue2 pvalue3 pvalue4 , label("\midrule Observations" "Endline control mean" "\shortstack[l]{p-values:\\Own = BAF}"   "Own $\times$ MIL opposed = BAF $\times$ MIL opposed" "Own + Own $\times$ MIL opposed = 0"  "BAF + BAF $\times$ MIL opposed = 0"  ) fmt(%9.0f %9.3f %9.3f  %9.3f %9.3f %9.3f)) ///
prehead("\begin{table}[htpb]\begin{center}\caption{Heterogeneous treatment effects, by mother-in-law opposition to family planning at baseline (IN-PERSON SAMPLE)}\label{table:tab4xx-interact-milopposed}\resizebox{\linewidth}{!}{\begin{tabular}{lccccccc} \toprule") ///
posthead(" & \multicolumn{3}{c}{\textbf{Sought company to visit the ADC from:}} &  & \multicolumn{2}{c}{\textbf{Visited the ADC with:}} & \\  \cmidrule(lr){2-4} \cmidrule(lr){6-7}   &   Someone & \shortstack{Husband/\\MIL} & \shortstack{Non-husband/\\MIL} & \textbf{\shortstack{Visited\\the ADC}}  & \shortstack{Husband/\\MIL} & \shortstack{Non-husband/\\MIL}  & \textbf{\shortstack{Visited\\any clinic}}  \\  & (1) & (2) & (3) & (4) & (5) & (6) & (7) \\ \midrule") ///
postfoot("\bottomrule \\[-5ex] \end{tabular}} \end{center} \begin{tablenotes} All specifications are fully-interacted regressions, where all covariates are interacted with an indicator for whether the MIL was opposed to FP at baseline. The main effect of MIL opposition to FP at baseline is also included as control variable. All specifications include balancing controls (i.e., the baseline levels of whether a woman was using FP, her years of education, whether she wanted another child, and her number of general peers), other baseline covariates (i.e., whether the woman worked, whether she had ever visited a FP clinic, the woman's mobility score, and whether she was using a modern family planning method), whether the endline interview was conducted over the phone, and village fixed effects. MIL denotes mother-in-law, FP denotes family planning, and BAF denotes Bring-a-Friend. Variable definitions are presented in the Online Appendix. Robust standard errors are presented in brackets. \sym{*}\(p<0.1\),\sym{**}\(p<0.05\),\sym{***}\(p<0.01\). \end{tablenotes} \end{table}") ///
sfmt(%9.2f) varwidth(25)  replace





************************************
**## Table 5x_new Modern contraceptive use [Complete Mod FP list]
************************************

use "$repo/data/data_endline.dta", clear
drop if base_wants_child == . // Drop 4 obsrvations having missing values for this covariate



eststo clear
est drop _all

global outcomes mod_method_el_new mod_method_since_bl_new preg_ever

 
foreach y of global outcomes{


eststo reg`y'0: reg `y' i.solo i.baf $covbal $cov i.base_village_num , r
	test _b[1.solo]=_b[1.baf]
	estadd scalar pvalue1 = r(p)
	sum `y' if treatment == 0 
	estadd scalar controlmean = r(mean)	



eststo reg`y'1: reg `y' i.solo##i.base_costFP_MILopposed i.baf##i.base_costFP_MILopposed   ///
						c.base_school_yrs#i.base_costFP_MILopposed    	///
						c.base_num_friend#i.base_costFP_MILopposed    	///
						i.base_current_fp##i.base_costFP_MILopposed   	///
						i.base_wants_child##i.base_costFP_MILopposed  	///
						i.base_obc##i.base_costFP_MILopposed  			///
						c.base_mobi#i.base_costFP_MILopposed  			///
						i.base_work##i.base_costFP_MILopposed  			///
						i.base_ever_visit_fp##i.base_costFP_MILopposed  ///
						i.base_phone#i.base_costFP_MILopposed  			///
						i.base_mod_method#i.base_costFP_MILopposed 		///
						i.base_village_num#i.base_costFP_MILopposed ,  r
						
test _b[1.solo] = _b[1.baf]
estadd scalar pvalue1 = r(p)

test _b[1.solo#1.base_costFP_MILopposed ] = _b[1.baf#1.base_costFP_MILopposed ]
estadd scalar pvalue2 = r(p)

test _b[1.solo] + _b[1.solo#1.base_costFP_MILopposed ] = 0
estadd scalar pvalue3 = r(p)

test _b[1.baf] + _b[1.baf#1.base_costFP_MILopposed ] = 0
estadd scalar pvalue4 = r(p)

sum `y' if treatment == 0 
estadd scalar controlmean = r(mean)	



eststo reg`y'2: reg `y' i.solo##i.base_livewMIL i.baf##i.base_livewMIL   ///
						c.base_school_yrs#i.base_livewMIL    	///
						c.base_num_friend#i.base_livewMIL    	///
						i.base_current_fp##i.base_livewMIL   	///
						i.base_wants_child##i.base_livewMIL  	///
						i.base_obc##i.base_livewMIL  			///
						c.base_mobi#i.base_livewMIL  			///
						i.base_work##i.base_livewMIL  			///
						i.base_ever_visit_fp##i.base_livewMIL  ///
						i.base_phone#i.base_livewMIL  			///
						i.base_mod_method#i.base_livewMIL 		///
						i.base_village_num#i.base_livewMIL ,  r
						
test _b[1.solo] = _b[1.baf]
estadd scalar pvalue1 = r(p)

test _b[1.solo#1.base_livewMIL ] = _b[1.baf#1.base_livewMIL ]
estadd scalar pvalue2 = r(p)

test _b[1.solo] + _b[1.solo#1.base_livewMIL ] = 0
estadd scalar pvalue3 = r(p)

test _b[1.baf] + _b[1.baf#1.base_livewMIL ] = 0
estadd scalar pvalue4 = r(p)

sum `y' if treatment == 0 
estadd scalar controlmean = r(mean)	
 
	
	
eststo reg`y'3: reg `y' i.solo##i.base_costFP_embarrasing i.baf##i.base_costFP_embarrasing   ///
						c.base_school_yrs#i.base_costFP_embarrasing    	///
						c.base_num_friend#i.base_costFP_embarrasing    	///
						i.base_current_fp##i.base_costFP_embarrasing   	///
						i.base_wants_child##i.base_costFP_embarrasing  	///
						i.base_obc##i.base_costFP_embarrasing  			///
						c.base_mobi#i.base_costFP_embarrasing  			///
						i.base_work##i.base_costFP_embarrasing  			///
						i.base_ever_visit_fp##i.base_costFP_embarrasing  ///
						i.base_phone#i.base_costFP_embarrasing  			///
						i.base_mod_method#i.base_costFP_embarrasing 		///
						i.base_village_num#i.base_costFP_embarrasing ,  r
						
test _b[1.solo] = _b[1.baf]
estadd scalar pvalue1 = r(p)

test _b[1.solo#1.base_costFP_embarrasing ] = _b[1.baf#1.base_costFP_embarrasing ]
estadd scalar pvalue2 = r(p)

test _b[1.solo] + _b[1.solo#1.base_costFP_embarrasing ] = 0
estadd scalar pvalue3 = r(p)

test _b[1.baf] + _b[1.baf#1.base_costFP_embarrasing ] = 0
estadd scalar pvalue4 = r(p)

sum `y' if treatment == 0 
estadd scalar controlmean = r(mean)	
}


esttab 	regmod_method_el_new0 regmod_method_el_new1 regmod_method_el_new2 regmod_method_el_new3 ///
		regmod_method_since_bl_new0 regpreg_ever0 ///
using "$repo/RESULTS/tables/table5x_new.tex" , ///
rename(	1.base_costFP_embarrasing 1.base_costFP_MILopposed ///
		1.solo#1.base_livewMIL 1.solo#1.base_costFP_MILopposed ///
		1.baf#1.base_livewMIL 1.baf#1.base_costFP_MILopposed ///
		1.solo#1.base_costFP_embarrasing 1.solo#1.base_costFP_MILopposed ///
		1.baf#1.base_costFP_embarrasing 1.baf#1.base_costFP_MILopposed ) ///
keep(1.solo  1.solo#1.base_costFP_MILopposed  1.baf 1.baf#1.base_costFP_MILopposed  ) ///
order(1.solo  1.baf  1.solo#1.base_costFP_MILopposed 1.baf#1.base_costFP_MILopposed ) ///
varlabels(1.solo "Own Voucher" 1.baf "BAF Voucher" 1.solo#1.base_costFP_MILopposed "Own Voucher $\times$ Covariate" 1.baf#1.base_costFP_MILopposed "BAF Voucher $\times$ Covariate" ) ///
mlabels(none) se(%9.3f) b(%9.3f)  brackets nonum  noobs nolines collabels(none)   nogaps starlevels( * 0.1 ** .05  *** .01)  ///
stats(N  controlmean pvalue1 pvalue2 pvalue3 pvalue4 , label("\midrule Observations" "Endline control mean"  "\shortstack[l]{p-values:\\Own = BAF}"   "Own $\times$ Covariate = BAF $\times$ Covariate" "Own + Own $\times$ Covariate = 0"  "BAF + BAF $\times$ Covariate = 0" ) fmt(%9.0f %9.3f %9.3f  %9.3f %9.3f %9.3f)) ///
prehead("\begin{table}[htpb]\begin{center}\caption{Modern contraceptive use and pregnancy at endline (Complete Mod FP List)}\label{table:tab5x-new-modernuse-itt}\begin{tabular}{lcccccc} \toprule") ///
posthead(" & & \multicolumn{2}{c}{\textbf{\shortstack{Heterogeneity of\\Current Modern Method by}}} & & \\ \cmidrule(lr){3-5}  & \shortstack{Current Modern\\Method Use\\(all sample)} & \shortstack{MIL opposed\\to FP} & \shortstack{MIL\\Co-resident} &  \shortstack{Found FP\\embarrasing} &  \shortstack{Modern\\Method Use\\since baseline} &  \shortstack{Pregnancy since\\baseline}  \\  & (1) & (2) & (3) & (4) & (5) & (6) \\ \midrule") ///
postfoot("\bottomrule \\[-5ex] \end{tabular} \end{center} \begin{tablenotes} Each column represents a separate regression. Columns 2, 3, and 4 are fully-interacted regressions where all controls are interacted with the covariate used for estimating heterogeneous effects, with the main effect of that variable also included as a regressor. All specifications include balancing controls (i.e., the baseline levels of whether a woman was using FP, her years of education, whether she wanted another child, and her number of general peers), other baseline covariates (i.e., whether the woman worked, whether she had ever visited a FP clinic, the woman's mobility score, and whether she was using a modern FP method), whether the endline interview was conducted over the phone, and village fixed effects. MIL denotes mother-in-law, FP denotes family planning, and BAF denotes Bring-a-Friend. The number of observations is less than 621 a) in columns 1, 4, and 5 due to missing observations in the outcome variable and b) in columns 2 and 3 due to missing values in ``MIL opposed to FP''. Variable definitions are presented in the Online Appendix. Robust standard errors are presented in brackets. \sym{*}\(p<0.1\),\sym{**}\(p<0.05\),\sym{***}\(p<0.01\). \end{tablenotes} \end{table}") ///
sfmt(%9.2f) varwidth(25)  replace


************************************
**## Table A.14a: Socional Connections Het. Effects on ADC Visit
************************************

use "$repo/data/data_endline.dta", clear
drop if base_wants_child == . // Drop 4 obsrvations having missing values for this covariate


eststo clear
est drop _all

global outcomes visit_adc_fp_corr visit_any_fp_new_corr mod_method_since_bl

foreach y of global outcomes{
	
eststo r`y'0: reg `y' i.solo##i.base_nopeeruseFPvill   i.baf##i.base_nopeeruseFPvill   ///
						c.base_school_yrs#i.base_nopeeruseFPvill    ///
						c.base_num_friend#i.base_nopeeruseFPvill    ///
						i.base_current_fp##i.base_nopeeruseFPvill  ///
						i.base_wants_child##i.base_nopeeruseFPvill  ///
						i.base_obc##i.base_nopeeruseFPvill  ///
						c.base_mobi#i.base_nopeeruseFPvill  ///
						i.base_work##i.base_nopeeruseFPvill  ///
						i.base_ever_visit_fp##i.base_nopeeruseFPvill   ///
						i.base_phone#i.base_nopeeruseFPvill  ///
						i.base_mod_method#i.base_nopeeruseFPvill ///
						i.base_village_num#i.base_nopeeruseFPvill ,  r
						
test _b[1.solo] = _b[1.baf]
estadd scalar pvalue1 = r(p)

test _b[1.solo#1.base_nopeeruseFPvill] = _b[1.baf#1.base_nopeeruseFPvill]
estadd scalar pvalue2 = r(p)

test _b[1.solo] + _b[1.solo#1.base_nopeeruseFPvill ] = 0
estadd scalar pvalue3 = r(p)

test _b[1.baf] + _b[1.baf#1.base_nopeeruseFPvill ] = 0
estadd scalar pvalue4 = r(p)

sum `y' if treatment == 0 
estadd scalar controlmean = r(mean)	

}

esttab rvisit_adc_fp_corr0 rvisit_any_fp_new_corr0 rmod_method_since_bl0  ///
using "$repo/RESULTS/tables/appendix_table14a.tex" , ///
keep(1.solo  1.solo#1.base_nopeeruseFPvill  1.baf 1.baf#1.base_nopeeruseFPvill  ) ///
order(1.solo  1.baf  1.solo#1.base_nopeeruseFPvill 1.baf#1.base_nopeeruseFPvill  ) ///
varlabels(1.solo "Own Voucher" 1.baf "BAF Voucher" 1.solo#1.base_nopeeruseFPvill "Own Voucher $\times$ Covariate" 1.baf#1.base_nopeeruseFPvill "BAF  Voucher $\times$ Covariate" ) ///
mlabels(none) se(%9.3f) b(%9.3f)  brackets nonum  noobs nolines collabels(none)   nogaps starlevels( * 0.1 ** .05  *** .01)  ///
stats(N  controlmean pvalue1 pvalue2 pvalue3 pvalue4 , label("\midrule Observations" "Endline control mean" "\shortstack[l]{p-values:\\Own = BAF}"   "Own $\times$ Covariate = BAF $\times$ Covariate" "Own + Own $\times$ Covariate = 0"  "BAF + BAF $\times$ Covariate = 0"  ) fmt(%9.0f %9.3f %9.3f  %9.3f %9.3f %9.3f)) ///
prehead("\begin{table}[htpb]\begin{center}\caption{Heterogeneous treatment effects on ADC visit and Modern FP use at endline, by baseline social connections}\label{table:app-tab14a-sn-het}\resizebox{1\linewidth}{!}{\begin{tabular}{lccc} \toprule") ///
posthead(" &  \multicolumn{3}{c}{Covariate at baseline: Lack of close peers in village that use FP}  \\ \cmidrule(lr){2-4} \textbf{Outcomes:} &  \textbf{\shortstack{Visited the\\ADC}} & \textbf{\shortstack{Visited any\\clinic}} & \textbf{\shortstack{Has used a modern\\method since baseline}} \\  & (1) & (2) & (3)  \\ \midrule") ///
postfoot("\bottomrule \\[-5ex] \end{tabular}} \end{center} \begin{tablenotes} All specifications are fully-interacted regressions where all covariates are interacted with the covariate used for heterogeneous effects, the main effect of that variable is also included as a regressor. All specifications include balancing controls (i.e., the baseline levels of whether a woman was using FP, her years of education, whether she wanted another child, and her number of general peers), other baseline covariates (i.e., whether the woman worked, whether she had ever visited a FP clinic, the woman's mobility score, and whether she was using a modern family planning method), whether the endline interview was conducted over the phone, and village fixed effects. MIL denotes mother-in-law, FP denotes family planning, BAF denotes Bring-a-Friend, and HH denotes household. Variable definitions are presented in the Online Appendix. Robust standard errors are presented in brackets. \sym{*}\(p<0.1\),\sym{**}\(p<0.05\),\sym{***}\(p<0.01\). \end{tablenotes} \end{table}") ///
sfmt(%9.2f) varwidth(25)  replace
