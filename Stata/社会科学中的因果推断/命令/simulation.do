use "C:\Users\XuQi\Desktop\raw.dta",clear


*设定随机数种子，以保证每次分析结果不变
set seed 12333

*生成y0，y0为gender、age、hukou、feduy、meduy、sibling、cognitive的函数（包含二次项和多个交互项），invnormal(runiform())为一个服从标准正态分布的随机误差
gen y0=3.051+0.711*gender+0.263*age-0.004*age2+0.232*hukou+0.023*feduy+0.012*meduy-0.065*sibling+0.026*cognitive+invnormal(runiform())

*生成干预效应，均值为0.6，考虑到异质性，增加了一个均值为0、标准差为0.2的正态分布随机项
gen delta=0.6+0.2*invnormal(runiform())

*生成y1，根据定义，y1=delta+y0
gen y1=y0+delta

*通过logit模型生成每个个案上大学的概率p
gen luck1=invnormal(runiform())  //假设luck1是高考时语文考试的运气
gen luck2=invnormal(runiform())  //假设luck2是高考时数学考试的运气
gen luck3=invnormal(runiform())  //假设luck3是高考时外语考试的运气

gen logodds=-21.8521-0.863*gender+0.545*age-0.008*age2+0.693*hukou+0.026*feduy+0.046*meduy-0.188*sibling+0.262*cognitive+luck1+luck2+0.1*luck3 
gen p=exp(logodds)/(1+exp(logodds))

*基于概率p进行伯努利实验，生成二分变量college
gen college=rbinomial(1, p)

*计算因变量y
gen y=y0*(1-college)+y1*college

rename y lninc
label var luck1 "语文考试运气"
label var luck2 "英语考试运气"
label var luck3 "数学考试运气"
label var college "是否上大学"
label var lninc "收入对数"

drop y0 delta y1 p logodds cognitive

replace college=0 if college==.
replace lninc=8.506025 if lninc==.

save "C:\Users\XuQi\Desktop\simulation.dta", replace
