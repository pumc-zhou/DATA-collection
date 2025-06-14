use "C:\Users\XuQi\Desktop\grade.dta", clear

*线性回归分析
reg avgmath classize, cluster(schlcode)   //一元线性回归
reg avgmath classize enrollment disadv, cluster(schlcode)   //纳入控制变量

*绘图
rdplot classize enrollment if enrollment>=20 & enrollment<=60, c(40.5) covs(disadv)
rdplot avgmath enrollment if enrollment>=20 & enrollment<=60, c(40.5) covs(disadv)

*计算最优带宽
rdbwselect avgmath enrollment if enrollment>=20 & enrollment<=60, c(40.5) fuzzy(classize) all covs(disadv)

*局部线性回归法
rdrobust avgmath enrollment if enrollment>=20 & enrollment<=60, c(40.5) fuzzy(classize) covs(disadv)

*将带宽设置为20
rdrobust avgmath enrollment if enrollment>=20 & enrollment<=60, c(40.5) fuzzy(classize) covs(disadv) h(20)

*将带宽设置为20，二次曲线
rdrobust avgmath enrollment if enrollment>=20 & enrollment<=60, c(40.5) fuzzy(classize) covs(disadv) h(20) p(2)

*disadv在断点处是否连续
rdrobust disadv enrollment if enrollment>=20 & enrollment<=60, c(40.5) fuzzy(classize) h(20) p(2)

*enrollment在断点处是否连续
rddensity enrollment if enrollment>=20 & enrollment<=60, c(40.5)

*使用全部样本
gen predclassize=enrollment/(int((enrollment-1)/40)+1)
gen enrollment2=enrollment^2

ivregress 2sls avgmath (classize=predclassize) enrollment enrollment2 disadv, robust cluster(schlcode)
