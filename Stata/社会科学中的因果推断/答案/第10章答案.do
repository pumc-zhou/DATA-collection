***************************************************************************
*                                练习5                                    *
***************************************************************************

use "C:\Users\XuQi\Desktop\antisocial.dta", clear

*将数据设置为面板数据
xtset id occ

*描述数据
xtsum anti-married  //时变变量为anti、pov，非时变变量为female、childage、hispanic、black、momage、momwork、married

*混合线性回归
xtreg anti female childage hispanic black pov momage momwork married, pa vce(robust) corr(independent)

*固定效应模型
xtreg anti female childage hispanic black pov momage momwork married, fe vce(robust) //female、childage、hispanic、black、momage、momwork、married被排除，因为它们都是非时变变量

*随机效应模型
xtreg anti female childage hispanic black pov momage momwork married, re vce(robust)

*组间估计量
xtreg anti female childage hispanic black pov momage momwork married, be vce(bootstrap)

*比较固定效应、随机效应和组间估计量，随机效应估计值介于固定效应和组间估计量之间，因为随机效应估计值是组内估计量（固定效应）和组间估计量的加权平均

*Hausman检验
xtreg anti female childage hispanic black pov momage momwork married, fe
est store fe

xtreg anti female childage hispanic black pov momage momwork married, re
est store re

hausman fe re, sigmamore  //检验结果显著，说明应使用固定效应模型

*传统的Hausman检验假定随机效应模型是最有效的估计量，使用稳健的Hausman检验可以放松该假定
*稳健的Hausman检验
xtreg anti female childage hispanic black pov momage momwork married, re vce(robust)
xtoverid  //检验结果依然显著，说明应使用固定效应模型


***************************************************************************
*                                练习6                                    *
***************************************************************************

use "C:\Users\XuQi\Desktop\grunfeld.dta", clear

*设置为面板数据
xtset company year

xtsum  //n=10, t=20, n<t, 因此是一个长面板

*双向固定效应模型
reg invest mvalue kstock i.company i.year, vce(cluster company)

*时间线性趋势
reg invest mvalue kstock i.company year, vce(cluster company)

*对误差项是否存在组内自相关、组间异方差和组间同期相关进行正式的统计检验
xtreg invest mvalue kstock year, fe vce(robust)
xttest3  //检验结果非常显著，说明存在组间异方差
xttest2  //检验结果非常显著，说明存在组间同期相关

xi:xtserial invest mvalue kstock year i.company  //检验结果非常显著，说明存在组内自相关

*面板校正标准误+FGLS
xtpcse invest mvalue kstock year i.company, corr(ar1)
xtpcse invest mvalue kstock year i.company, corr(psar1)

*全面FGLS
xtgls invest mvalue kstock year i.company, panels(cor) corr(ar1)
xtgls invest mvalue kstock year i.company, panels(cor) corr(psar1)

*模型比较，全面FGLS法得到的估计量对应的T值最大，因而效率最高，因为该方法对三种误差相关和异方差问题同时采用了FGLS估计


***************************************************************************
*                                练习7                                    *
***************************************************************************

use "C:\Users\XuQi\Desktop\returns.dta", clear

*设置为面板数据
xtset nr year

*固定效应模型
xtreg lwage exp exp2 wks occ ind south smsa ms fem union ed blk, fe vce(robust)  

*纳入因变量的一阶滞后
xtreg lwage L.lwage exp exp2 wks occ ind south smsa ms fem union ed blk, fe vce(robust)  //L.lwage的系数有偏，因为其均值差分后的结果一定与模型误差项相关

*Arellano-Bond估计量
xtabond lwage exp exp2 wks ind south smsa, lags(1) pre(ms) endogenous(union occ) maxldep(4) maxlags(4) twostep vce(robust) 

*检验误差项的自相关问题
xtabond lwage exp exp2 wks ind south smsa, lags(1) pre(ms) endogenous(union occ) maxldep(4) maxlags(4) twostep vce(robust) artests(3)
estat abond  //二阶以上自相关检验都不显著，因此可以认为原模型的误差项不存在自相关

xtabond lwage exp exp2 wks ind south smsa, lags(1) pre(ms) endogenous(union occ) maxldep(4) maxlags(4) twostep
estat sargan  //过度识别检验非常显著，因此所选取的工具变量不满足模型要求，上述Arellano-Bond估计量值得怀疑

*系统GMM
xtdpdsys lwage exp exp2 wks ind south smsa, lags(1) pre(ms) endogenous(union occ) maxldep(4) maxlags(4) twostep vce(robust) artests(3)
estat abond  //二阶自相关在0.05水平下统计显著，因此可以认为原模型的误差项存在自相关

xtdpdsys lwage exp exp2 wks ind south smsa, lags(1) pre(ms) endogenous(union occ) maxldep(4) maxlags(4) twostep
estat sargan  //过度识别检验非常显著，因此所选取的工具变量不满足模型要求，上述Arellano-Bond估计量值得怀疑
