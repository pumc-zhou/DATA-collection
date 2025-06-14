use "C:\Users\XuQi\Desktop\cfps2010.dta", clear

*一元线性回归
reg lninc college, vce(cluster provcd)

*倾向值细分
tabulate fmedu, gen(fmedu)
pscore college hukou age gender race sibling fmedu2 fmedu3, pscore(ps) blockid(strata) logit comsup

drop ps strata comsup
gen hukouage=hukou*age
pscore college hukou hukouage age age2 gender race sibling fmedu2 fmedu3, pscore(ps) blockid(strata) logit comsup

atts lninc college, pscore(ps) blockid(strata) comsup

*干预效应的异质性
hte sm lninc college hukou hukouage age age2 gender race sibling fmedu2 fmedu3, logit comsup

hte ms lninc college hukou hukouage age age2 gender race sibling fmedu2 fmedu3, logit common noscatter lpolyci
hte sd lninc college hukou hukouage age age2 gender race sibling fmedu2 fmedu3, logit comsup

*倾向值加权（手动实现）
qui logit college hukou hukou##c.age c.age##c.age gender race sibling fmedu2 fmedu3
predict p

gen w_ate=1/p if college==1
replace w_ate=1/(1-p) if college==0

gen w_att=1 if college==1
replace w_att=p/(1-p) if college==0

gen w_atu=(1-p)/p if college==1
replace w_atu=1 if college==0

reg lninc college [pw=w_ate], vce(cluster provcd)
reg lninc college [pw=w_att], vce(cluster provcd)
reg lninc college [pw=w_atu], vce(cluster provcd)

*倾向值加权（teffects ipw）
teffects ipw (lninc) (college hukou hukou##c.age c.age##c.age gender race sibling fmedu2 fmedu3)
teffects ipw (lninc) (college hukou hukou##c.age c.age##c.age gender race sibling fmedu2 fmedu3), atet

*平衡性检验
reg age college [pw=w_ate], vce(cluster provcd)

qui teffects ipw (lninc) (college hukou hukou##c.age c.age##c.age gender race sibling fmedu2 fmedu3)
tebalance summarize
tebalance density age
tebalance overid, nolog 
tebalance overid, bconly nolog 

*双重稳健估计(ipwra)
teffects ipwra (lninc hukou age gender race sibling fmedu2 fmedu3) ///
               (college hukou hukou##c.age c.age##c.age gender race sibling fmedu2 fmedu3)
teffects aipw (lninc hukou age gender race sibling fmedu2 fmedu3) ///
              (college hukou hukou##c.age c.age##c.age gender race sibling fmedu2 fmedu3)

