use "C:\Users\XuQi\Desktop\so2.dta", clear

tab year

*生成标识政策实施的时期变量
gen time=1 if year>2007
replace time=0 if year<=2007

*一重差分
reg lntfp treat if time==1 & so2==1, vce(cluster area)

*双重差分
*使用regress
reg lntfp treat##time if so2==1, vce(cluster area) 
reg lntfp treat##time zcsy lf age owner sczy lnaj lnlabor lnzlb if so2==1, vce(cluster area) 

*使用diff
diff lntfp if so2==1, t(treat) p(time) cluster(area) 
diff lntfp if so2==1, t(treat) p(time) cluster(area) cov(zcsy lf age owner sczy lnaj lnlabor lnzlb)
diff lntfp if so2==1, t(treat) p(time) cluster(area) cov(zcsy lf age owner sczy lnaj lnlabor lnzlb) test  

*PSM+双重差分
diff lntfp if so2==1, t(treat) p(time) cluster(area) cov(zcsy lf age owner sczy lnaj lnlabor lnzlb) kernel id(company) logit support
diff lntfp if so2==1, t(treat) p(time) cluster(area) cov(zcsy lf age owner sczy lnaj lnlabor lnzlb) kernel id(company) logit support test 

*三重差分
diff lntfp, t(treat) p(time) cluster(area) cov(zcsy lf age owner sczy lnaj lnlabor lnzlb) ddd(so2)
reg lntfp treat##time##so2 zcsy lf age owner sczy lnaj lnlabor lnzlb, vce(cluster area)

*多期双重差分
reg lntfp treat##i.year if so2==1, vce(cluster area) 
reg lntfp treat##i.year zcsy lf age owner sczy lnaj lnlabor lnzlb if so2==1, vce(cluster area) 

