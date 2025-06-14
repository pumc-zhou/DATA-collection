use "C:\Users\XuQi\Desktop\birthweight.dta", clear

*倾向值细分
pscore mbsmoke mage medu mrace nprenatal mmarried deadkids fbaby, pscore(ps) blockid(strata) logit comsup

*调整倾向值的估计方程
gen medu2=medu^2
gen mage2=mage^2
gen magemmarried=mage*mmarried
gen mage2mmarried=mage2*mmarried

drop strata comsup ps
pscore mbsmoke mage mage2 medu medu2 mrace nprenatal mmarried deadkids fbaby mage2mmarried magemmarried , pscore(ps) blockid(strata) logit comsup

*计算ATT
atts bweight mbsmoke, pscore(ps) blockid(strata) comsup

*干预效应的异质性
hte sm bweight mbsmoke mage mage2 medu medu2 mrace nprenatal mmarried deadkids fbaby mage2mmarried magemmarried, logit comsup
hte ms bweight mbsmoke mage mage2 medu medu2 mrace nprenatal mmarried deadkids fbaby mage2mmarried magemmarried, logit common noscatter lpolyci
hte sd bweight mbsmoke mage mage2 medu medu2 mrace nprenatal mmarried deadkids fbaby mage2mmarried magemmarried, logit comsup

*倾向值加权
teffects ipw (bweight) (mbsmoke c.mage##mmarried c.mage##c.mage##mmarried medu c.medu##c.medu mrace nprenatal deadkids fbaby)
teffects ipw (bweight) (mbsmoke c.mage##mmarried c.mage##c.mage##mmarried medu c.medu##c.medu mrace nprenatal deadkids fbaby), atet

*平衡性检验
qui teffects ipw (bweight) (mbsmoke c.mage##mmarried c.mage##c.mage##mmarried medu c.medu##c.medu mrace nprenatal deadkids fbaby)
tebalance summarize
tebalance overid, nolog 

*双重稳健估计
teffects ipwra (bweight mage medu mrace nprenatal mmarried deadkids fbaby) (mbsmoke c.mage##mmarried c.mage##c.mage##mmarried medu c.medu##c.medu mrace nprenatal deadkids fbaby)
teffects aipw (bweight mage medu mrace nprenatal mmarried deadkids fbaby) (mbsmoke c.mage##mmarried c.mage##c.mage##mmarried medu c.medu##c.medu mrace nprenatal deadkids fbaby)
