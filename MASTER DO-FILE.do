***MALAWI Behavioral Biases Study
***MASTER DO FILE 

***KEXIN ZHANG
***NOVEMBER 15, 2023

***STEP 0: SETTING WORKING DIRECTORY
***To use the correct file directory, replace "C:\Users\kexin\Dropbox\MALAWI BEHAVIORAL BIASES STUDY\DATA\MBBS FINAL DATA FOR ANALYSIS\DATA ALL STAGES" with the appropriate file path under which your data is stored.
***Make sure that the Results subfolder is created to store the results from this analysis.
***Make sure that the dofile subfolder is created to store all do files that will be used.

version 13
clear all

global data "E:\5. Malawi Behavioral Biases Study"
global output "$data\Results"
global dofile "$data\GitHub\MBBS-do-files"

* TABLES IN THE MAIN TEXT (TABLE 1 - TABLE 7)
run "$dofile\DO_1_TABLE_1.do"
run "$dofile\DO_1_TABLE_2.do"
run "$dofile\DO_1_TABLE_3.do"
run "$dofile\DO_1_TABLE_4 and 5.do"
run "$dofile\DO_1_TABLE_6 and 7.do"

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
run "$dofile\DO_2_FIGURE_A2-A3.do"
run "$dofile\DO_2_FIGURE_A7.do"

* FIGURES IN APPENDIX D
run "$dofile\DO_3_FIGURE_D1.do"

* FIGURES IN APPENDIX E
run "$dofile\DO_4_FIGURE_E1-E2.do"

* TABLES IN APPENDIX F 
run "$dofile\DO_5_TABLE_F1.do"

* TABLES IN APPENDIX G
run "$dofile\DO_6_TABLE_G1-G3.do"
run "$dofile\DO_6_TABLE_G4.do"
run "$dofile\DO_6_TABLE_G5.do"
run "$dofile\DO_6_TABLE_G6.do"

* TABLES IN APPENDIX H
run "$dofile\DO_7_TABLE_H1.do"
run "$dofile\DO_7_TABLE_H2.do"

* TABLES IN APPENDIX I
run "$dofile\DO_8_TABLE_I1-I2.do"
run "$dofile\DO_8_TABLE_I3-I4.do"

* TABLES IN APPENDIX J
run "$dofile\DO_9_TABLE_J1-J2.do"
run "$dofile\DO_9_TABLE_J3-J4.do"

* TABLES IN APPENDIX K
run "$dofile\DO_10_TABLE_K1.do"
run "$dofile\DO_10_TABLE_K2.do"

* TABLES IN APPENDIX L
run "$dofile\DO_11_TABLE_L1.do"
run "$dofile\DO_11_TABLE_L2.do"
run "$dofile\DO_11_TABLE_L3.do"
run "$dofile\DO_11_TABLE_L4.do"

* TABLES IN APPENDIX M
run "$dofile\DO_12_TABLE_M1-M2.do"

