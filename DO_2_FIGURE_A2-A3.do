***MALAWI Behavioral Biases Study
***DO FILE 2: FIGURE A2-A3

***KEXIN ZHANG
***NOVEMBER 15, 2023

version 13
clear all

use "$data\MBBS_Analysis_data.dta"			
* ====================================================================================
* ======================= Fig A2: Number of beans assigned to top attribute ===============================
* ====================================================================================
	* top attribute weight
	hist top_attribute_wgt, color(navy) lcolor(white) start(6) width(1) graphregion(fcolor(white)) addlabels percent ///
		xlabel(6(1)20) xtitle("Number of Beans Assigned to the Top Attribute") addlabopts(yvarformat(%4.2f)) ylabel(0(20)60, angle(0))


	graph export "$output\fig3_beans_top_attribute.png", as(png) replace
	
* ====================================================================================
* ======================= Fig A3: Knowledge about Birth Spacing ===============================
* ====================================================================================
	catplot w1_w03_w343, asyvars percent legend(size(vsmall) title("For how long should a woman who has just given birth wait before trying to get pregnant to minimize health risks?", size(vsmall))) ///
	graphregion(fcolor(white)) ytitle() xtitle() title() bar(1, color(maroon) fintensity(inten80)) bar(2, color(maroon) fintensity(inten60)) ///
bar(3, color(gray) fintensity(inten40)) bar(4, color(navy) fintensity(inten60)) blabel(bar, format(%4.1f))  
		graph export "$output\fig5_birth_spacing_opinion.png", as(png) replace
