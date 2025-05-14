***MALAWI Behavioral Biases Study
***DO FILE 4: FIGURE E1-E2
***COUNSELING TIMES BY TREATMENT ARMS

***KEXIN ZHANG
***NOVEMBER 15, 2023

clear all

version 13

use "$data\MBBS_Analysis_data.dta"

* Drop pregnant women at counseling
	drop if COUN_118 == 1

* Drop pregnant women at FUP
	drop if PHO_103 == 1 | HOME_103 == 1 //638
	
	keep if !mi(diff_method_3) & COUN__FV_1 == 1

* SHORT Intervention
			capture drop x y z
		sum counseling_time3 if /*(HUSB_T == 0 | COUN_207 == 0) &*/ counseling_time3 !=0 & counseling_time3 < 40 
			gen x = r(mean)
		sum counseling_time3 if /*(HUSB_T == 0 | COUN_207 == 0) &*/ counseling_time3 !=0 & counseling_time3 < 40 & SHORT_T == 1
			gen y = r(mean)
		sum counseling_time3 if /*(HUSB_T == 0 | COUN_207 == 0) &*/ counseling_time3 !=0 & counseling_time3 < 40 & SHORT_T == 0
			gen z = r(mean)
graph bar x y z, graphregion(fcolor(white)) /*title("Counseling Time, by Short Counseling Intervention", size(small))*/ ysc(r(10(2)20)) ylabel(0(2)20) ///
bar(1, color(maroon) fintensity(inten60)) ///
bar(2, color(gray) fintensity(inten40))  bar(3, color(navy) fintensity(inten60)) ///
legend(order(1 "All" 2 "Tailored Counseling" 3 "Standard Counseling")) blabel(bar, format(%4.1f))  

graph export "$output\counseling_time_short_bar.png", as(png) replace

* SHORT Intervention (among no-partner invitation group)
			capture drop x y z
		sum counseling_time3 if (HUSB_T == 0 | COUN_207 == 0) & counseling_time3 !=0 & counseling_time3 < 40 
			gen x = r(mean)
		sum counseling_time3 if (HUSB_T == 0 | COUN_207 == 0) & counseling_time3 !=0 & counseling_time3 < 40 & SHORT_T == 1
			gen y = r(mean)
		sum counseling_time3 if (HUSB_T == 0 | COUN_207 == 0) & counseling_time3 !=0 & counseling_time3 < 40 & SHORT_T == 0
			gen z = r(mean)
graph bar x y z, graphregion(fcolor(white)) /*title("Counseling Time, by Short Counseling Intervention", size(small))*/ ysc(r(10(2)20)) ylabel(0(2)20) ///
bar(1, color(maroon) fintensity(inten60)) ///
bar(2, color(gray) fintensity(inten40))  bar(3, color(navy) fintensity(inten60)) ///
legend(order(1 "All" 2 "Tailored Counseling" 3 "Standard Counseling")) blabel(bar, format(%4.1f))  

graph export "$output\counseling_time_short_bar_no_partner.png", as(png) replace

* HUSBAND Intervention
			capture drop x y z
		sum counseling_time3 if counseling_time3 !=0 & counseling_time3 < 40
			gen x = r(mean)
		sum counseling_time3 if counseling_time3 !=0 & counseling_time3 < 40 & HUSB_T == 1
			gen y = r(mean)
		sum counseling_time3 if counseling_time3 !=0 & counseling_time3 < 40 & HUSB_T == 0
			gen z = r(mean)

graph bar x y z, graphregion(fcolor(white)) /*title("Counseling Time, by Husband Invitation Intervention", size(small))*/ ysc(r(10(2)20)) ylabel(0(2)20) ///
bar(1, color(maroon) fintensity(inten60)) ///
bar(2, color(gray) fintensity(inten40))  bar(3, color(navy) fintensity(inten60)) ///
legend(order(1 "All" 2 "With Partner Invitation" 3 "No Partner Invitation")) blabel(bar, format(%4.1f))  

graph export "$output\counseling_time_husband_bar.png", as(png) replace

drop x y z
