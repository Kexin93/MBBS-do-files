***NEW CODE FOR MBBS
***MAHESH KARRA
***5-10-25

********************************************************************************
**REPLACE METHOD USE = 0 FOR PREGNANT WOMEN
replace FUP_curr_method = 0 if CLIN_new_pregnancy_status==1 | PHO_new_pregnancy_status=="---" | HOM_new_pregnancy_status=="---"

*GENERATE BINARY FUP USE
gen FUP_use = FUP_curr_method > 0

********************************************************************************
*GENERATE START, STOP, SWITCH
gen FUP_start = FUP_use==1 & cont_use1==0
gen FUP_stop = FUP_use==0 & cont_use1==1

gen FUP_switch_r = FUP_curr_method - coun_curr_method
replace FUP_switch_r = . if FUP_use==0 | cont_use1==0
gen FUP_switch = (FUP_switch_r != 0) if !mi(FUP_switch_r)

***INJECTABLE USE IN THE PAST 3 MONTHS - HETEROGENEITY FOR SHORT COUNSELING BY SHORT
gen inj_3_months = w1_w03_w308b < 4

***WANT TO SWITCH (USERS) OR ADOPT (NON-USERS) AT BASELINE - HETEROGENEITY FOR SHORT
gen want_switch_adopt = w1_w03_w331==1 | w1_w03_w338a==1

***TOLD ABOUT SIDE EFFECTS - HETEROGENEITY FOR SHORT
gen told_side_effects = w1_w03_w317==1 | w1_w03_w318==1

***DEFERRAL: DO NOT FOLLOW THROUGH WITH ADVICE
gen deferral = w1_w10_w1012_1==1 | w1_w10_w1012_2==1 | w1_w10_w1012_3==1

***BASELINE ACCESS AND CHOICE: 325b-325d - MAJOR HETEROGENEITY HERE!!
gen access_choice = w1_w03_w325b==1 & w1_w03_w325c==1 & w1_w03_w325d==0

***BASELINE INFORMATION: 325a
gen enough_info = w1_w03_w325a==1


********************************************************************************
***HETEROGENEITY FOR TAILORED COUNSELING BY VARIABLES ABOVE
reg diff_method_8 SHORT_T $balance_covariates if inj_3_months==1, r
reg diff_method_3 SHORT_T $balance_covariates if inj_3_months==1, r
reg diff_method_5 SHORT_T $balance_covariates if inj_3_months==1, r
reg diff_method_9 SHORT_T $balance_covariates if inj_3_months==1, r
***EFFECTS ARE FROM WOMEN WHO HAD THEIR MOST RECENT INJECTABLE WITHIN PAST 3 MONTHS AND WANT TO SWITCH BUT CAN'T

reg diff_method_8 SHORT_T $balance_covariates if want_switch_adopt==0, r
reg diff_method_3 SHORT_T $balance_covariates if want_switch_adopt==0, r
reg diff_method_5 SHORT_T $balance_covariates if want_switch_adopt==0, r
reg diff_method_9 SHORT_T $balance_covariates if want_switch_adopt==0, r
***EFFECTS ARE FROM WOMEN WHO DID NOT INITIALLY WANT TO SWITCH OR ADOPT A METHOD BUT THEN RECEIVED COUNSELING. BUT THEY DID NOT FOLLOW THROUGH AND ARE DISCORDANT

reg diff_method_8 SHORT_T $balance_covariates if told_side_effects==1, r
reg diff_method_3 SHORT_T $balance_covariates if told_side_effects==1, r
reg diff_method_5 SHORT_T $balance_covariates if told_side_effects==1, r
reg diff_method_9 SHORT_T $balance_covariates if told_side_effects==1, r

reg diff_method_8 SHORT_T $balance_covariates if told_side_effects==0, r
reg diff_method_3 SHORT_T $balance_covariates if told_side_effects==0, r
reg diff_method_5 SHORT_T $balance_covariates if told_side_effects==0, r
reg diff_method_9 SHORT_T $balance_covariates if told_side_effects==0, r
***WOMEN WHO WERE TOLD ABOUT SIDE EFFECTS BEFORE COUNSELING REALLY CHANGE THEIR MINDS FROM SHORT COUNSELING BUT NOT USE, SIGNIFICANTLY DISCORDANT. SIGNALS THAT THEY
***SEEK TO CHANGE THEIR METHOD DUE TO SIDE EFFECTS BUT DO NOT FOLLOW THROUGH. NOT TRUE FOR WOMEN WHO WERE NOT INFORMED ABOUT SIDE EFFECTS.

reg diff_method_8 SHORT_T $balance_covariates if deferral==1, r
reg diff_method_3 SHORT_T $balance_covariates if deferral==1, r
reg diff_method_5 SHORT_T $balance_covariates if deferral==1, r
reg diff_method_9 SHORT_T $balance_covariates if deferral==1, r
***WOMEN WHO DEFER CARE (DO NOT TAKE ADVICE, DELAY RECEIVING CARE, ETC.) CHANGE THEIR MIND BUT ARE FAR LESS LIKELY TO CHANGE THEIR METHOD USE, THEREFORE BEING DISCORDANT.

reg diff_method_8 SHORT_T $balance_covariates if access_choice==1, r
reg diff_method_3 SHORT_T $balance_covariates if access_choice==1, r
reg diff_method_5 SHORT_T $balance_covariates if access_choice==1, r
reg diff_method_9 SHORT_T $balance_covariates if access_choice==1, r
***WOMEN WHO HAD BASELINE ACCESS AND CHOICE ARE MORE LIKELY TO CHANGE PREFERENCES FOR METHODS BUT NOT BEHAVIOR, THEREFORE MORE DISCORDANCE

reg diff_method_8 SHORT_T $balance_covariates if enough_info==0, r
reg diff_method_3 SHORT_T $balance_covariates if enough_info==0, r
reg diff_method_5 SHORT_T $balance_covariates if enough_info==0, r
reg diff_method_9 SHORT_T $balance_covariates if enough_info==0, r
***WOMEN WHO HAD BASELINE INFORMATION ON METHODS ARE MORE LIKELY TO CHANGE IDEAL METHODS FROM COUNSELING BUT ARE MORE DISCORDANT.


********************************************************************************
***PARTNER INVITATION HETEROGENEITY

**DISCUSSED WITH HUSBAND HOW MANY MORE CHILDREN YOU WANT
gen discuss_kids_husb = w1_w09_w916

reg diff_method_8 HUSB_T $balance_covariates if discuss_kids_husb==0, r
reg diff_method_3 HUSB_T $balance_covariates if discuss_kids_husb==0, r
reg diff_method_5 HUSB_T $balance_covariates if discuss_kids_husb==0, r
reg diff_method_9 HUSB_T $balance_covariates if discuss_kids_husb==0, r
***WOMEN WHO HAVE NOT DISCUSSED KIDS ARE LESS LIKELY TO CHANGE STATED PREFERENCES, BUT MORE LIKELY TO CHANGE METHOD USE AFTER COUNSELING AND ARE LESS DISCORDANT AT FOLLOW-UP

**HUSBAND SUPPORTS FP
gen husb_supports_fp = w1_w09_w928==1

reg diff_method_8 HUSB_T $balance_covariates if husb_supports_fp==1, r
reg diff_method_3 HUSB_T $balance_covariates if husb_supports_fp==1, r
reg diff_method_5 HUSB_T $balance_covariates if husb_supports_fp==1, r
reg diff_method_9 HUSB_T $balance_covariates if husb_supports_fp==1, r
***WOMEN WHO HAVE SUPPORTIVE HUSBANDS ARE LESS LIKELY TO CHANGE METHOD PREFERENCES, LESS LIKELY TO CHANGE METHOD USE, AND ARE MORE CONCORDANT AT ENDLINE - NO SURPRISE

reg diff_method_8 HUSB_T $balance_covariates if husb_supports_fp==0, r
reg diff_method_3 HUSB_T $balance_covariates if husb_supports_fp==0, r
reg diff_method_5 HUSB_T $balance_covariates if husb_supports_fp==0, r
reg diff_method_9 HUSB_T $balance_covariates if husb_supports_fp==0, r
***WOMEN WHO DO NOT HAVE SUPPORTIVE HUSBANDS ARE NO MORE LIKELY TO CHANGE METHOD PREFERENCES, BUT ARE MORE LIKELY TO CHANGE METHOD USE. THEY ARE NO MORE CONCORDANT OR DISCORDANT
***AT FOLLOW-UP. WHAT ARE THEY CHANGING METHODS TO?

**WOMAN DECIDES CONTRACEPTIVE USE / NON-USE
gen cont_wom_decide = w1_w07_w718b < 3 | w1_w07_w718c < 3

reg diff_method_8 HUSB_T $balance_covariates if cont_wom_decide==0, r
reg diff_method_3 HUSB_T $balance_covariates if cont_wom_decide==0, r
reg diff_method_5 HUSB_T $balance_covariates if cont_wom_decide==0, r
reg diff_method_9 HUSB_T $balance_covariates if cont_wom_decide==0, r
***Since 98 percent of women say that husbands know of contraceptive use / non-use, women who say that husbands have some / all say in decision-making are no more likely to change
***method preferences, method use, but also less discordant at endline (choosing methods that husbands want?)

reg diff_method_8 HUSB_T $balance_covariates if cont_wom_decide==1, r
reg diff_method_3 HUSB_T $balance_covariates if cont_wom_decide==1, r
reg diff_method_5 HUSB_T $balance_covariates if cont_wom_decide==1, r
reg diff_method_9 HUSB_T $balance_covariates if cont_wom_decide==1, r

**HUSBAND SATISFIED WITH METHOD - DONE THIS BEFORE
gen husb_sat = w1_w07_w724d==1

reg diff_method_8 HUSB_T $balance_covariates if husb_sat==1, r
reg diff_method_3 HUSB_T $balance_covariates if husb_sat==1, r
reg diff_method_5 HUSB_T $balance_covariates if husb_sat==1, r
reg diff_method_9 HUSB_T $balance_covariates if husb_sat==1, r
**Women whose husbands are satisfied are far less likely to change their method choice or use and are far more concordant - no surprise.


********************************************************************************
***IDEAL METHOD
*CHANGED LARC
gen FUP_LARC = (FUP_ideal_method < 4 | FUP_ideal_method==5) & FUP_ideal_method!=0
gen COUN_LARC = (COUN_129 < 4 | COUN_129==5) & COUN_129!=0
gen diff_method_LARC = FUP_LARC - COUN_LARC
gen diff_method_LARC_r = (diff_method_LARC != 0) if !mi(diff_method_LARC) 

*CHANGED SARC
gen FUP_SARC = (FUP_ideal_method >= 4 & FUP_ideal_method!=5) & FUP_ideal_method < 12
gen COUN_SARC = COUN_129 >= 4 & COUN_129!=5 & COUN_129 < 12
gen diff_method_SARC = FUP_SARC - COUN_SARC
gen diff_method_SARC_r = (diff_method_SARC != 0) if !mi(diff_method_SARC)

*CHANGED MODERN
gen FUP_modern = FUP_ideal_method < 12 & FUP_ideal_method!=0
gen COUN_modern = COUN_129 < 12 & FUP_ideal_method!=0
gen diff_method_modern = FUP_modern - COUN_modern
gen diff_method_modern_r = (diff_method_modern != 0) if !mi(diff_method_modern)

gen diff_any_modern = diff_method_LARC_r==1 | diff_method_SARC_r==1

*CHANGED TRADITIONAL
gen FUP_trad = FUP_ideal_method >= 12 & !mi(FUP_ideal_method)
gen COUN_trad = COUN_129 >= 12 & !mi(COUN_129)
gen diff_method_trad = FUP_trad - COUN_trad
gen diff_method_trad_r = (diff_method_trad != 0) if !mi(diff_method_trad)

*CHANGED NO METHOD
gen FUP_none = FUP_ideal_method==0 & FUP_ideal_method!=.
gen COUN_none = COUN_129==0 & COUN_129!=.
gen diff_method_none = FUP_none - COUN_none
gen diff_method_none_r = (diff_method_none != 0) if !mi(diff_method_none) 

********************************************************************************
***METHOD USE
*CHANGED LARC
gen FUP_LARC_use = (FUP_curr_method < 4 | FUP_curr_method==5) & FUP_curr_method!=0
gen COUN_LARC_use = (coun_curr_method < 4 | coun_curr_method==5) & coun_curr_method!=0
gen diff_method_LARC_use = FUP_LARC_use - COUN_LARC_use
gen diff_method_LARC_use_r = (diff_method_LARC_use != 0) if !mi(diff_method_LARC_use) 

*CHANGED SARC
gen FUP_SARC_use = FUP_curr_method >= 4 & FUP_curr_method!=5 & FUP_curr_method < 12
gen COUN_SARC_use = coun_curr_method >= 4 & coun_curr_method!=5 & coun_curr_method < 12
gen diff_method_SARC_use = FUP_SARC_use - COUN_SARC_use
gen diff_method_SARC_use_r = (diff_method_SARC_use != 0) if !mi(diff_method_SARC_use)

*CHANGED MODERN
gen FUP_modern_use = FUP_curr_method < 12 & FUP_curr_method!=0
gen COUN_modern_use = coun_curr_method < 12 & coun_curr_method!=0
gen diff_method_modern_use = FUP_modern_use - COUN_modern_use
gen diff_method_modern_use_r = (diff_method_modern_use != 0) if !mi(diff_method_modern_use)

gen diff_any_modern_use = diff_method_LARC_use_r==1 | diff_method_SARC_use_r==1

*CHANGED TRADITIONAL
gen FUP_trad_use = FUP_curr_method >= 12 & !mi(FUP_curr_method)
gen COUN_trad_use = coun_curr_method >= 12 & !mi(coun_curr_method)
gen diff_method_trad_use = FUP_trad_use - COUN_trad_use
gen diff_method_trad_use_r = (diff_method_trad_use != 0) if !mi(diff_method_trad_use)

*CHANGED NO METHOD
gen FUP_none_use = FUP_curr_method==0 & FUP_curr_method!=.
gen COUN_none_use = coun_curr_method==0 & coun_curr_method!=.
gen diff_method_none_use = FUP_none_use - COUN_none_use
gen diff_method_none_use_r = (diff_method_none_use != 0) if !mi(diff_method_none_use) 


	
