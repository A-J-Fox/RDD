clear

set obs 1000
set seed 1234
set scheme plotplain

gen x = rnormal(50, 20)
replace x=0 if x<0
drop if x>100

* generating a dependent variable with non-linear relationship
gen y = 10 + 1.1*x + .1*x^2 + rnormal(0, 20)
twoway (scatter y x)

* what happens with a local linear regression with a "discontinuity" at 30?
rdrobust y x, c(30) p(1)
rdplot y x, c(30) p(1)

* of course, the problem occurs because of the non-linear relationship
* if we up the degree of the local polynomial, the discont. shrinks
rdrobust y x, c(30) p(2)
rdplot y x, c(30) p(2)

rdrobust y x, c(30) p(3)
rdplot y x, c(30) p(3)

* rdrobust defaults do not remove the problem!
rdrobust y x, c(30) 
rdplot y x, c(30) 



