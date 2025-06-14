use "C:\Users\XuQi\Desktop\cfps2010.dta", clear

*查看变量
describe

*一元线性回归
reg lninc college

reg lninc college, vce(robust)   // 异方差稳健标准误
reg lninc college, vce(cluster provcd)   //聚类稳健标准误


*多元线性回归
reg lninc college hukou, vce(cluster provcd)

*理解偏回归系数
reg college hukou, vce(cluster provcd)
predict e, residuals

reg lninc e, vce(cluster provcd)

*遗漏变量公式
dis .823612-.798281

reg hukou college, vce(cluster provcd)
dis .1175271*.2155333


*纳入更多控制变量
reg lninc college hukou##i.age, vce(cluster provcd)
estat ic

reg lninc college hukou##(c.age c.age2 c.age3), vce(cluster provcd)
estat ic

reg lninc college hukou age age2 age3, vce(cluster provcd)
estat ic

reg lninc college hukou age age2 age3 gender race sibling i.fmedu, vce(cluster provcd)

*分解回归系数
reg lninc college if hukou==0, vce(cluster provcd)
reg lninc college if hukou==1, vce(cluster provcd)

tab hukou
tab college if hukou==0
tab college if hukou==1


dis 34.97*65.03*59.25
dis 53.38*46.62*40.75

dis 134740.37/(134740.37+101409.46)
dis 101409.46/(134740.37+101409.46)
dis .57057153*.873513+.6983452*.42942847

*回归调整估计量
teffects ra (lninc hukou age age2 age3 gender race sibling i.fmedu) (college), vce(robust)
teffects ra (lninc hukou age age2 age3 gender race sibling i.fmedu) (college), vce(robust) atet
teffects ra (lninc hukou age age2 age3 gender race sibling i.fmedu) (college), vce(robust) control(1) tlevel(0) atet

*手动实现
reg lninc hukou age age2 age3 gender race sibling i.fmedu if college==0
predict y0hat if college==1

reg lninc hukou age age2 age3 gender race sibling i.fmedu if college==1
predict y1hat if college==0

gen y0=lninc if college==0
replace y0=y0hat if college==1

gen y1=lninc if college==1
replace y1=y1hat if college==0

gen effect=y1-y0
tab college, sum(effect)


