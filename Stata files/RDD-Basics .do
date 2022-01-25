clear
set obs 1000
set seed 1234
* optional plot scheme setting 
set scheme plottig

gen x = rnormal(50, 30)
replace x=0 if x<0
drop if x>100
sum x, det

gen d = 0
replace d = 1 if x > 30

* generating a y variable with discontinuity at 30
gen y = 25 + 40*d + 1.5*x + rnormal(0, 20) 
twoway (scatter y x if d==0)(scatter y x if d==1, sort)

* two fitted lines on either side of the discontinuity
twoway (scatter y x if d==0, mcolor(green))(scatter y x if d==1, sort) ///
(lfit y x if d==0, lwidth(thick) lcolor(black))(lfit y x if d==1, lwidth(thick) lcolor(black))

* simple regression with dummy variable 
reg y x d 

* using rdrobust 
rdrobust y x, c(30) p(1) masspoints(adjust)
rdplot y x, c(30) p(1) masspoints(check) 

* but what if slopes differ? 
gen a = rnormal(50, 30)
replace a=0 if a<0
drop if a>100
gen y1 = 25 + 1.5*a + rnormal(0, 20) if a<30
replace y1 = 30 + 3*a + rnormal(0, 20) if a>=30
gen d1 = 0
replace d1 = 1 if a > 30

* adding fitted lines 
twoway (scatter y1 a if d1==0, mcolor(green))(scatter y1 a if d1==1, sort) ///
(lfit y1 a if d1==0, lwidth(thick) lcolor(black))(lfit y1 a if d1==1, lwidth(thick) lcolor(black))

* using a simple regression 
reg y1 a d1

* now using differing slopes with rdrobust
rdrobust y1 a d1, c(30) p(1) masspoints(adjust)
* rdplot repeats what we found earlier
rdplot y1 a d1, c(30) p(1) masspoints(adjust)

* higher local polynomial
rdrobust y1 a d1, c(30) p(2) masspoints(adjust)
rdplot y1 a d1, c(30) p(2) masspoints(adjust)

* rdrobust defaults
rdrobust y1 a d1, c(30) masspoints(adjust)
rdplot y1 a d1, c(30) masspoints(adjust)
