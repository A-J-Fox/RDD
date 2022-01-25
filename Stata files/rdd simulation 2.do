clear
set obs 1000
set seed 1234567

gen x = rnormal(50, 25)
replace x=0 if x<0
drop if x>100
sum x, det

gen D = 0
replace D = 1 if x > 50

* generating y with no discontinuity
gen y1 = 25 + 0*D + 1.5*x + rnormal(0, 20)

* scatter plot showing no discontinuity
twoway (scatter y1 x if D==0, msize(vsmall) msymbol(circle_hollow)) (scatter y1 x if D==1, sort mcolor(blue) msize(vsmall) msymbol(circle_hollow)) ///
(lfit y1 x if D==0, lcolor(red) msize(small) lwidth(medthin) lpattern(solid)) (lfit y1 x if D==1, lcolor(dknavy) msize(small) lwidth(medthin) lpattern(solid))


* rdrobust predicts small gaps, but they not statistically significant. rdplot shows that this is really just the same line. 
* estimated bandwidth is around 14
rdrobust y1 x, c(50) p(1)
rdplot y1 x, c(50) p(1)

* generating a new y variable with discontinuity
gen y = 25 + 40*D + 1.5*x + rnormal(0, 20)

* scatter with discont
twoway (scatter y x if D==0, msize(vsmall) msymbol(circle_hollow)) (scatter y x if D==1, sort mcolor(blue) msize(vsmall) msymbol(circle_hollow)) ///
(lfit y x if D==0, lcolor(red) msize(small) lwidth(medthin) lpattern(solid)) (lfit y x if D==1, lcolor(dknavy) msize(small) lwidth(medthin) lpattern(solid))

* local linear robust RDD 
rdrobust y x, c(50) p(1)
* a smaller bin produces an estimate closer to the true one 
rdrobust y x, c(50) p(1) h(5)
rdplot y x, c(50) p(1)

* local quadratic robust RDD 
rdrobust y x, c(50) p(2)
rdplot y x, c(50) p(2)

* generating a treat dummy variable
gen treat = 1
replace treat =0 if x < 50

* simple regression with dummy, coefficient should be close to RD effect
reg y x treat, robust

* generating an interaction
gen xtreat = x*treat

* now with an interaction for differing slopes
reg y x treat xtreat, robust

* generating a centered x variable
gen x_c = x-50
* this estimate is the same as the one using only the dummy variable 
reg y x_c treat, robust

* again, the estimate of the treatment is the same with recentering 
gen x_ctreat = x_c*treat
reg y x_c treat xtreat, robust


* now lets create data with two different slopes
gen a = rnormal(50, 25)
replace a=0 if a<0
drop if a>100

gen y2 = 25 + 1.5*a + rnormal(0, 20) if a<50
replace y2 = 30 + 3*a + rnormal(0, 20) if a>=50 

* just checking with a linear rdplot
rdplot y2 a, c(50) p(1)
rdrobust y2 a, c(50) p(1)

gen a_c = a-50
gen treat2 = 1 
replace treat2 = 0 if a < 50

* a simple regression with a dummy still gets pretty close 
reg y2 a treat2, robust

gen a_ctreat = a_c*treat2
reg y2 a_c treat2 a_ctreat, robust





