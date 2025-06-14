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

global data "F:\5. Malawi Behavioral Biases Study"
global output "$data\Results\2025-6-14"
global dofile "$data\GitHub\MBBS-do-files"

* TABLES IN THE MAIN TEXT (TABLE 1 - TABLE 7)
run "$dofile\DO_1_TABLE_1.do"
run "$dofile\DO_1_TABLE_2.do"
run "$dofile\DO_1_TABLE_3.do"
run "$dofile\DO_1_TABLE_4 and 5.do"
run "$dofile\DO_1_TABLE_6 and 7.do"
run "$dofile\DO_1_TABLE_8 and 9.do"
run "$dofile\DO_1_TABLE_10 and 11.do"


* FIGURES IN THE MAIN TEXT (NONE)

* TABLES IN APPENDIX A
run "$dofile\DO_2_TABLE_A2.do"
run "$dofile\DO_2_TABLE_A3.do"
run "$dofile\DO_2_TABLE_A4.do"
run "$dofile\DO_2_TABLE_A5-A6.do"
run "$dofile\DO_2_TABLE_A7-A8.do"
run "$dofile\DO_2_TABLE_A9.do"
run "$dofile\DO_2_TABLE_A10.do"
run "$dofile\DO_2_TABLE_A11.do"
run "$dofile\DO_2_TABLE_A12-A13.do"

* FIGURES IN APPENDIX A
run "$dofile\DO_2_FIGURE_A2.do"
run "$dofile\DO_2_FIGURE_A6.do"

* FIGURES IN APPENDIX D
run "$dofile\DO_4_FIGURE_D1-D2.do"

* TABLES IN APPENDIX E
run "$dofile\DO_5_TABLE_E1.do"

* TABLES IN APPENDIX F 
run "$dofile\DO_6_TABLE_F1-F3.do"
run "$dofile\DO_6_TABLE_F4.do"
run "$dofile\DO_6_TABLE_F5.do"
run "$dofile\DO_6_TABLE_F6.do"

* TABLES IN APPENDIX G
run "$dofile\DO_7_TABLE_G1.do"
run "$dofile\DO_7_TABLE_G2.do"

* TABLES IN APPENDIX H
run "$dofile\DO_8_TABLE_H1-H2.do"
run "$dofile\DO_8_TABLE_H3-H4.do"

* TABLES IN APPENDIX I
run "$dofile\DO_10_TABLE_I1.do"
run "$dofile\DO_10_TABLE_I2.do"

* TABLES IN APPENDIX J
run "$dofile\DO_11_TABLE_J1.do"
run "$dofile\DO_11_TABLE_J2.do"
run "$dofile\DO_11_TABLE_J3.do"
run "$dofile\DO_11_TABLE_J4.do"

* TABLES IN APPENDIX K
run "$dofile\DO_12_TABLE_K1-K2.do"

* TABLES IN APPENDIX M
run "$dofile\DO_14_TABLE_M1-M2.do"
