***MALAWI Behavioral Biases Study
***MASTER DO FILE 

***KEXIN ZHANG
***May 10, 2025

***STEP 0: SETTING WORKING DIRECTORY
***To use the correct file directory, replace "C:\Users\kexin\Dropbox\MALAWI BEHAVIORAL BIASES STUDY\DATA\MBBS FINAL DATA FOR ANALYSIS\DATA ALL STAGES" with the appropriate file path under which your data is stored.
***Make sure that the Results subfolder is created to store the results from this analysis.
***Make sure that the dofile subfolder is created to store all do files that will be used.

version 13
clear all


if "`c(username)'"=="Kexin Zhang" {
global data "E:\5. Malawi Behavioral Biases Study"
global dofile "$data\GitHub\MBBS-do-files"
global output "$data\Results\2025-11-21"
}

else if "`c(username)'"=="mvkarra" {
global data ""
global dofile ""
global output ""
}

* TABLES IN THE MAIN TEXT (TABLE 1 - TABLE 4)
run "$dofile\DO_1_TABLE_1.do"
run "$dofile\DO_2_TABLE_2.do"
run "$dofile\DO_3_TABLE_3 (interaction).do"
run "$dofile\DO_4_TABLE_4 (interaction).do"

* TABLES IN APPENDIX A
run "$dofile\DO_5_TABLE_A2.do"
run "$dofile\DO_5_TABLE_A3.do"
run "$dofile\DO_5_TABLE_A4.do"
run "$dofile\DO_5_TABLE_A5.do"
run "$dofile\DO_5_TABLE_A6.do"

* TABLES IN APPENDIX D
run "$dofile\DO_6_TABLE_D1.do"

* TABLES IN APPENDIX E
run "$dofile\DO_7_TABLE_E1.do"
run "$dofile\DO_7_TABLE_E2.do"
run "$dofile\DO_7_TABLE_E3-E5.do"
run "$dofile\DO_7_TABLE_E6.do"

* TABLES IN APPENDIX F 
run "$dofile\DO_8_TABLE_F1.do"