use "C:\Users\XuQi\Desktop\simulation.dta", clear

*多元线性回归
reg lninc college
reg lninc college gender age age2 hukou feduy meduy sibling, robust

*假设高考时的运气可观测，可使用其作为工具变量来识别大学对收入的影响
corr luck1 luck2 luck3 college

*两阶段最小二乘法
ivregress 2sls lninc gender age age2 hukou feduy meduy sibling (college=luck1), vce(robust) first 
ivregress 2sls lninc gender age age2 hukou feduy meduy sibling (college=luck2), vce(robust) first
ivregress 2sls lninc gender age age2 hukou feduy meduy sibling (college=luck3), vce(robust) first 

*同时使用三个工具变量
ivregress 2sls lninc gender age age2 hukou feduy meduy sibling (college=luck1 luck2 luck3), vce(robust)

*使用广义矩估计法
ivregress gmm lninc gender age age2 hukou feduy meduy sibling (college=luck1 luck2 luck3), vce(robust)

*使用有限信息最大似然法
ivregress liml lninc gender age age2 hukou feduy meduy sibling (college=luck1 luck2 luck3), vce(robust)

*弱工具变量检验
qui ivregress 2sls lninc gender age age2 hukou feduy meduy sibling (college=luck1), vce(robust)
estat firststage, all forcenonrobust  

qui ivregress 2sls lninc gender age age2 hukou feduy meduy sibling (college=luck2), vce(robust)
estat firststage, all forcenonrobust  

qui ivregress 2sls lninc gender age age2 hukou feduy meduy sibling (college=luck3), vce(robust)
estat firststage, all forcenonrobust 

*过度识别检验
qui ivregress 2sls lninc gender age age2 hukou feduy meduy sibling (college=luck1 luck2 luck3), vce(robust)
estat overid  

qui ivregress 2sls lninc gender hukou feduy meduy sibling (college=luck1 luck2 luck3 age age2), robust first 
estat overid  

*豪斯曼检验
qui ivregress 2sls lninc gender age age2 hukou feduy meduy sibling (college=luck1 luck2 luck3), vce(robust)
estat endogenous  

*使用ivreg2
ivreg2 lninc gender age age2 hukou feduy meduy sibling (college=luck1 luck2 luck3), robust
ivreg2 lninc gender hukou feduy meduy sibling (college=luck1 luck2 luck3 age age2), robust orthog(age age2)
ivreg2 lninc gender age age2 hukou feduy meduy sibling (college=luck1 luck2 luck3), robust redundant(luck3)
ivreg2 lninc gender age age2 hukou feduy meduy sibling (college=luck1 luck2 luck3), robust endog(college)
