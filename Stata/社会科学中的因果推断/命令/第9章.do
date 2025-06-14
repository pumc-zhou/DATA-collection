****精确断点
use "C:\Users\XuQi\Desktop\rdrobust_senate.dta", clear

*图形分析
rdplot vote margin

*计算最优带宽
rdbwselect vote margin, all

*参数估计和统计推断
rdrobust vote margin

*稳健性检验
rdrobust vote margin, bwselect(cerrd)  //改变最优带宽的计算方法
rdrobust vote margin, kernel(uniform)  //使用矩形核

*矩形核条件下通过regress命令再现rdrobust的结果
gen d=1 if margin>=0 & margin<.
replace d=0 if margin<0

reg vote c.margin##d if margin<=11.597 & margin>=-11.597

tab class, gen(class)
rdrobust vote margin, covs(class2 class3 termshouse termssenate population)   //纳入协变量

rdrobust termshouse margin    //检验协变量在断点处是否连续
rdrobust vote margin, c(25)    //伪断点检验
rddensity margin  //检验配置变量是否连续


*多项式回归法
gen margin2=margin^2
gen margin3=margin^3
gen margin4=margin^4

qui reg vote c.margin##d if margin<=50 & margin>=-50
est store m1

qui reg vote (c.margin c.margin2)##d if margin<=50 & margin>=-50
est store m2

qui reg vote (c.margin c.margin2 c.margin3)##d if margin<=50 & margin>=-50
est store m3

qui reg vote (c.margin c.margin2 c.margin3 c.margin4)##d if margin<=50 & margin>=-50
est store m4

esttab m1 m2 m3 m4, aic bic keep(1.d)

rdrobust vote margin, h(50) p(2) kernel(uniform)   //通过rdrobust实现多项式回归法

****模糊断点
use "C:\Users\XuQi\Desktop\retirement.dta", clear

*图形分析
rdplot retire age, c(60)
rdplot health age, c(60)

*计算最优带宽
rdbwselect health age, all c(60) fuzzy(retire)

*参数估计和统计推断
rdrobust health age, c(60) fuzzy(retire) 

*换用矩形核
rdrobust health age, c(60) fuzzy(retire) kernel(uniform)  

*矩形核条件下通过ivregress命令再现rdrobust的结果
gen z=1 if age>=60 & age<.
replace z=0 if age<60

replace age=age-60    //配置变量对中

ivregress 2sls health (retire=z) age c.age#z if age>=-1.252 & age<=1.252

*多项式回归
gen age2=age^2
gen age3=age^3
gen age4=age^4

qui reg health c.age##z if age<=3 & age>=-3
est store m1

qui reg health (c.age c.age2)##z if age<=3 & age>=-3
est store m2

qui reg health (c.age c.age2 c.age3)##z if age<=3 & age>=-3
est store m3

qui reg health (c.age c.age2 c.age3 c.age4)##z if age<=3 & age>=-3
est store m4

esttab m1 m2 m3 m4, aic bic keep(1.z)

ivregress 2sls health (retire=z) age c.age#z if age<=3 & age>=-3
