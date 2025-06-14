use "C:\Users\XuQi\Desktop\birthweight.dta", clear

*一元线性回归
reg bweight mbsmoke, vce(robust)

*控制mrace
reg bweight mbsmoke mrace, vce(robust)

*两步法计算偏回归系数
reg mbsmoke mrace, vce(robust)
predict e, residuals

reg bweight e, vce(robust)

*遗漏变量偏差公式
reg bweight mbsmoke mrace, vce(robust)
reg mrace mbsmoke, vce(robust)
dis -275.2519+263.1194
dis -.0387753*312.8912

*纳入更多控制变量
reg bweight mbsmoke mrace mage medu mhisp fage fedu fhisp frace nprenatal mmarried deadkids fbaby, vce(robust)

*因果影响的异质性
reg bweight mbsmoke if mrace==0, vce(robust)
reg bweight mbsmoke if mrace==1, vce(robust)

*回归系数加权结果
tab mbsmoke if mrace==0
tab mbsmoke if mrace==1
tab mrace

dis 15.94*77.70*22.30
dis 84.06*82.09*17.91

dis 27619.397/(27619.397+123587.69)
dis 123587.69/(27619.397+123587.69)
dis .18265941*-159.4308+.81734059*-286.2883

*回归调整估计量
teffects ra (bweight mrace mage medu mhisp fage fedu fhisp frace nprenatal mmarried deadkids fbaby) (mbsmoke), vce(robust)  //ATE
teffects ra (bweight mrace mage medu mhisp fage fedu fhisp frace nprenatal mmarried deadkids fbaby) (mbsmoke), vce(robust) atet  //ATT
teffects ra (bweight mrace mage medu mhisp fage fedu fhisp frace nprenatal mmarried deadkids fbaby) (mbsmoke), vce(robust) atet control(1) tlevel(0) //ATU

*手动实现
reg bweight mrace mage medu mhisp fage fedu fhisp frace nprenatal mmarried deadkids fbaby if mbsmoke==0, vce(robust)
predict y0hat if mbsmoke==1

reg bweight mrace mage medu mhisp fage fedu fhisp frace nprenatal mmarried deadkids fbaby if mbsmoke==1, vce(robust)
predict y1hat if mbsmoke==0

gen y0=bweight if mbsmoke==0
replace y0=y0hat if mbsmoke==1

gen y1=bweight if mbsmoke==1
replace y1=y1hat if mbsmoke==0

gen effect=y1-y0
tab mbsmoke, sum(effect)
