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


* R3 - 3
ta CLIN_213

ta CLIN_216 // all missing (non family planning-related)