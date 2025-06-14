use "C:\Users\XuQi\Desktop\education.dta", clear

*多元线性回归
reg lninc ability gender age expr education city hukou, vce(robust)

*2SLS法
ivregress 2sls lninc gender age expr education city hukou (ability=moedu faedu), vce(robust) first

*GMM法
ivregress gmm lninc gender age expr education city hukou (ability=moedu faedu), vce(robust) first

*LIML法
ivregress liml lninc gender age expr education city hukou (ability=moedu faedu), vce(robust) first

*过度识别检验
ivregress 2sls lninc gender age expr education city hukou (ability=moedu faedu), vce(robust) first
estat overid

*弱工具变量检验
ivregress 2sls lninc gender age expr education city hukou (ability=moedu faedu), vce(robust) first
estat firststage, all forcenonrobust

*仅以moedu作为工具变量，同时进行弱工具变量检验
ivregress 2sls lninc gender age expr education city hukou (ability=moedu), vce(robust) first
estat firststage, all forcenonrobust

*豪斯曼检验
ivregress 2sls lninc gender age expr education city hukou (ability=moedu), vce(robust) first
estat endogenous

*使用ivreg2
ivreg2 lninc gender age expr education city hukou (ability=moedu), robust endog(ability)