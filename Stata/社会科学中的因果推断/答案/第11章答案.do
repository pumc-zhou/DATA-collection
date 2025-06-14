use "C:\Users\XuQi\Desktop\ada.dta", clear

*生成标识ADA法案生效前后的虚拟变量
gen post=1 if year>1992
replace post=0 if year<=1992

*两期双重差分
reg wkswork i.disabled##i.post

*纳入协变量
reg wkswork i.disabled##i.post i.age_G i.edu_G i.race_G i.region

*使用diff命令
diff wkswork, treat(disabled) period(post)
xi : diff wkswork, treat(disabled) period(post) cov(i.age_G i.edu_G i.race_G i.region)

*检验协变量在残疾人与非残疾人之间是否存在显著差异
xi : diff wkswork, treat(disabled) period(post) cov(i.age_G i.edu_G i.race_G i.region) test

*多期双重差分
reg wkswork disabled##i.year i.age_G i.edu_G i.race_G i.region  
