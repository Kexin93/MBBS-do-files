***MALAWI Behavioral Biases Study
***DO FILE 4: FIGURE E1-E2
***COUNSELING TIMES BY TREATMENT ARMS

***KEXIN ZHANG
***NOVEMBER 15, 2023

clear all

version 13

use "$data\MBBS_Analysis_data.dta"

dropmiss

* SHORT Intervention
			capture drop x y z
		sum counseling_time3 if (HUSB_T == 0 | COUN_207 == 0) & counseling_time !=0 & counseling_time < 40 
			gen x = r(mean)
		sum counseling_time3 if (HUSB_T == 0 | COUN_207 == 0) & counseling_time !=0 & counseling_time < 40 & SHORT_T == 1
			gen y = r(mean)
		sum counseling_time3 if (HUSB_T == 0 | COUN_207 == 0) & counseling_time !=0 & counseling_time < 40 & SHORT_T == 0
			gen z = r(mean)
graph bar x y z, graphregion(fcolor(white)) /*title("Counseling Time, by Short Counseling Intervention", size(small))*/ ysc(r(10(2)20)) ylabel(0(2)20) ///
bar(1, color(maroon) fintensity(inten60)) ///
bar(2, color(gray) fintensity(inten40))  bar(3, color(navy) fintensity(inten60)) ///
legend(order(1 "All" 2 "Short Counseling" 3 "Long Counseling")) blabel(bar, format(%4.1f))  

graph export "$output\counseling_time_short_bar.png", as(png) replace
		
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
legend(order(1 "All" 2 "Husband Invitation" 3 "No Husband Invitation")) blabel(bar, format(%4.1f))  

graph export "$output\counseling_time_husband_bar.png", as(png) replace

drop x y z
