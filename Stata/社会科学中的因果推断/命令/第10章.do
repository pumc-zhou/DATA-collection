***************************************************************************
*                             短面板模型                                  *
***************************************************************************

use "C:\Users\XuQi\Desktop\wagepan.dta", clear

*设置数据为追踪数据
xtset nr year

*描述数据缺失情况
xtdescribe

*描述变量的组内和组间方差
xtsum lwage black hisp educ year married exper exper2 union

*描述个体时间序列
xtline lwage if nr<100

*混合线性回归
xtreg lwage black hisp union married exper exper2 year educ, pa corr(independent) vce(robust)
regress lwage black hisp union married exper exper2 year educ, vce(cluster nr)

*固定效应模型
*LSDV法
qui regress lwage union married exper exper2 i.nr, vce(cluster nr)
estimates table, keep(union married exper exper2) b se

*均值差分法
xtreg lwage union married exper exper2, fe vce(robust)

*一阶差分法
regress D.(lwage union married exper exper2), vce(cluster nr) noconstant

*随机效应模型
*广义最小二乘估计
xtreg lwage black hisp union married exper exper2 year educ, re theta vce(robust)

*最大似然估计
xtreg lwage black hisp union married exper exper2 year educ, mle vce(bootstrap)

*组间估计量
xtreg lwage black hisp union married exper exper2 year educ, be vce(bootstrap)

*Hausman检验
qui xtreg lwage union married exper exper2, fe
est store fe

qui xtreg lwage black hisp union married exper exper2 year educ, re
est store re

hausman fe re, sigmamore

*稳健的Hausman检验
qui xtreg lwage black hisp union married exper exper2 year educ, re vce(robust)
xtoverid 


***************************************************************************
*                             长面板模型                                  *
***************************************************************************

use "C:\Users\XuQi\Desktop\mus08cigar.dta", clear

*设置为面板数据
xtset state year

*LSDV法拟合个体效应模型，将时间T作为连续变量纳入模型
reg lnc lnp lny lnpmin i.state year, vce(cluster state)

*检验组间异方差
qui xtreg lnc lnp lny lnpmin year, fe vce(robust)
xttest3

*检验组内自相关
xi:xtserial lnc lnp lny lnpmin year i.state

*检验组间同期相关
qui xtreg lnc lnp lny lnpmin year, fe vce(robust)
xttest2

*面板校正标准误
xtpcse lnc lnp lny lnpmin year i.state

*面板校正标准误+FGLS
xtpcse lnc lnp lny lnpmin year i.state, corr(ar1)
xtpcse lnc lnp lny lnpmin year i.state, corr(psar1)

*全面FGLS
xtgls lnc lnp lny lnpmin year i.state, panels(cor) corr(ar1)
xtgls lnc lnp lny lnpmin year i.state, panels(cor) corr(psar1)


***************************************************************************
*                            动态面板模型                                 *
***************************************************************************

use "C:\Users\XuQi\Desktop\wagepan.dta", clear

*设置为面板数据
xtset nr year

*固定效应模型
xtreg lwage L.lwage union married exper exper2, fe vce(robust)

*Arellano-Bond估计量
xtabond lwage union married exper exper2, lags(1) twostep vce(robust)

*设置前定变量和同期内生解释变量
xtabond lwage exper exper2, lags(1) pre(married) endogenous(union) twostep vce(robust)

*设置工具变量最多使用的滞后期数
xtabond lwage exper exper2, lags(1) pre(married) endogenous(union) maxldep(3) maxlags(3) twostep vce(robust)

*检验误差项是否存在自相关
qui xtabond lwage exper exper2, lags(1) pre(married) endogenous(union) maxldep(3) maxlags(3) twostep vce(robust) artests(3)
estat abond

*检验是否所有工具变量都有效
qui xtabond lwage exper exper2, lags(1) pre(married) endogenous(union) maxldep(3) maxlags(3) twostep
estat sargan

*使用xtdpdsys命令
xtdpdsys lwage exper exper2, lags(1) pre(married) endogenous(union) maxldep(3) maxlags(3) twostep vce(robust)

*纳入非时变变量
xtdpdsys lwage exper exper2 black hisp educ, lags(1) pre(married) endogenous(union) maxldep(3) maxlags(3) twostep vce(robust)

*检验误差项是否存在自相关
qui xtdpdsys lwage exper exper2, lags(1) pre(married) endogenous(union) maxldep(3) maxlags(3) twostep vce(robust) artests(3)
estat abond

*检验是否所有工具变量都有效
qui xtdpdsys lwage exper exper2, lags(1) pre(married) endogenous(union) maxldep(3) maxlags(3) twostep
estat sargan

*模型修正
qui xtdpdsys lwage exper exper2, lags(2) pre(married) endogenous(union) maxldep(3) maxlags(3) twostep vce(robust) artests(3)
estat abond

qui xtdpdsys lwage exper exper2, lags(2) pre(married) endogenous(union) maxldep(3) maxlags(3) twostep
estat sargan

xtdpdsys lwage exper exper2, lags(2) pre(married) endogenous(union) maxldep(3) maxlags(3) twostep
